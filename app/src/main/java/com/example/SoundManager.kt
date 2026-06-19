package com.example

import android.content.Context
import android.media.AudioAttributes
import android.media.AudioFormat
import android.media.AudioTrack
import android.util.Log
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.Job
import kotlinx.coroutines.delay
import kotlinx.coroutines.isActive
import kotlinx.coroutines.launch
import kotlin.math.sin
import kotlin.math.PI
import kotlin.math.abs

class SoundManager(private val context: Context) {
    var isSoundEnabled: Boolean = true
    var isMusicEnabled: Boolean = true
        set(value) {
            field = value
            if (value) {
                resumeMusic()
            } else {
                pauseMusic()
            }
        }

    private val scope = CoroutineScope(Dispatchers.Default)
    private var musicJob: Job? = null
    private val sampleRate = 22050

    // Short SFX generator using AudioTrack
    fun playSound(type: sfxType) {
        if (!isSoundEnabled) return
        scope.launch {
            try {
                val samples = when (type) {
                    sfxType.CLICK -> generateClickSamples()
                    sfxType.CORRECT -> generateCorrectSamples()
                    sfxType.INCORRECT -> generateIncorrectSamples()
                    sfxType.VICTORY -> generateVictorySamples()
                    sfxType.TICK -> generateTickSamples()
                }
                playPcmStream(samples)
            } catch (e: Exception) {
                Log.e("SoundManager", "Error playing SFX", e)
            }
        }
    }

    enum class sfxType {
        CLICK, CORRECT, INCORRECT, VICTORY, TICK
    }

    private fun playPcmStream(samples: ShortArray) {
        var track: AudioTrack? = null
        try {
            val minBufSize = AudioTrack.getMinBufferSize(
                sampleRate,
                AudioFormat.CHANNEL_OUT_MONO,
                AudioFormat.ENCODING_PCM_16BIT
            )
            val bufferSize = maxOf(minBufSize, samples.size * 2)

            track = AudioTrack.Builder()
                .setAudioAttributes(
                    AudioAttributes.Builder()
                        .setUsage(AudioAttributes.USAGE_GAME)
                        .setContentType(AudioAttributes.CONTENT_TYPE_SONIFICATION)
                        .build()
                )
                .setAudioFormat(
                    AudioFormat.Builder()
                        .setEncoding(AudioFormat.ENCODING_PCM_16BIT)
                        .setSampleRate(sampleRate)
                        .setChannelMask(AudioFormat.CHANNEL_OUT_MONO)
                        .build()
                )
                .setBufferSizeInBytes(bufferSize)
                .setTransferMode(AudioTrack.MODE_STATIC)
                .build()

            track.write(samples, 0, samples.size)
            track.play()
            
            // Static track needs time to play
            val durationMs = (samples.size * 1000L) / sampleRate
            Thread.sleep(durationMs + 100)
        } catch (e: Exception) {
            Log.e("SoundManager", "AudioTrack static play failed", e)
        } finally {
            try {
                track?.stop()
                track?.release()
            } catch (e: Exception) {}
        }
    }

    private var bgmPlayer: android.media.MediaPlayer? = null

    // Play happy background music on a light background thread loop
    fun startBgmLoop() {
        if (!isMusicEnabled) return
        
        // Try to load user attached BGM
        if (bgmPlayer == null) {
            val resId = context.resources.getIdentifier("bgm", "raw", context.packageName)
            if (resId != 0) {
                try {
                    bgmPlayer = android.media.MediaPlayer().apply {
                        val attrs = android.media.AudioAttributes.Builder()
                            .setContentType(android.media.AudioAttributes.CONTENT_TYPE_MUSIC)
                            .setUsage(android.media.AudioAttributes.USAGE_MEDIA)
                            .build()
                        setAudioAttributes(attrs)
                        val afd = context.resources.openRawResourceFd(resId)
                        setDataSource(afd.fileDescriptor, afd.startOffset, afd.length)
                        afd.close()
                        prepare()
                        isLooping = true
                        setVolume(0.4f, 0.4f)
                    }
                } catch (e: Exception) {
                    Log.e("SoundManager", "Error init BGM", e)
                }
            }
        }
        
        if (bgmPlayer != null) {
            bgmPlayer?.start()
            return
        }
        
        if (musicJob != null) return
        musicJob = scope.launch {
            // Cheerful, bouncy toy-glockenspiel/music box melodies in child-friendly C major scale
            val melody1 = doubleArrayOf(523.25, 659.25, 783.99, 659.25, 523.25, 659.25, 783.99, 1046.50) // C5 -> E5 -> G5 -> C6
            val melody2 = doubleArrayOf(698.46, 880.00, 1046.50, 880.00, 698.46, 880.00, 1046.50, 1396.91) // F5 -> A5 -> C6 -> F6
            val melody3 = doubleArrayOf(783.99, 987.77, 1174.66, 987.77, 783.99, 987.77, 1174.66, 1567.98) // G5 -> B5 -> D6 -> G6
            val melody4 = doubleArrayOf(1046.50, 783.99, 659.25, 783.99, 523.25, 659.25, 783.99, 1046.50) // Sweet C5 resolve

            val sections = listOf(melody1, melody2, melody3, melody4)
            var sectionIdx = 0

            while (isActive) {
                if (!isMusicEnabled) {
                    delay(500)
                    continue
                }

                val chord = sections[sectionIdx]
                for (noteFreq in chord) {
                    if (!isActive || !isMusicEnabled) break
                    
                    // Synthesize a brief cozy note using a sweet chime wave
                    val noteDurationSecs = 0.18f
                    val sampleCount = (sampleRate * noteDurationSecs).toInt()
                    val noteSamples = ShortArray(sampleCount)
                    
                    for (i in 0 until sampleCount) {
                        val t = i.toDouble() / sampleRate
                        // Sweet bell wave with exponential fade envelope
                        val wave = bellWave(noteFreq, t)
                        val fraction = i.toDouble() / sampleCount
                        val envelope = 1.0 - fraction
                        
                        // Keep bgm smooth and non-blocking, modern mix
                        val amplitude = 1400.0 * envelope
                        noteSamples[i] = (wave * amplitude).toInt().toShort()
                    }

                    // Write note using passive lightweight transient AudioTrack
                    playPcmShortNoteAsync(noteSamples)
                    
                    // Upbeat tempo delay
                    delay(180)
                }
                sectionIdx = (sectionIdx + 1) % sections.size
                delay(80) // short breath between chord measures
            }
        }
    }

    private fun playPcmShortNoteAsync(samples: ShortArray) {
        if (!isMusicEnabled) return
        scope.launch {
            var track: AudioTrack? = null
            try {
                track = AudioTrack.Builder()
                    .setAudioAttributes(
                        AudioAttributes.Builder()
                            .setUsage(AudioAttributes.USAGE_MEDIA)
                            .setContentType(AudioAttributes.CONTENT_TYPE_MUSIC)
                            .build()
                    )
                    .setAudioFormat(
                        AudioFormat.Builder()
                            .setEncoding(AudioFormat.ENCODING_PCM_16BIT)
                            .setSampleRate(sampleRate)
                            .setChannelMask(AudioFormat.CHANNEL_OUT_MONO)
                            .build()
                    )
                    .setBufferSizeInBytes(samples.size * 2)
                    .setTransferMode(AudioTrack.MODE_STATIC)
                    .build()

                track.write(samples, 0, samples.size)
                track.play()
                
                val durationMs = (samples.size * 1000L) / sampleRate
                delay(durationMs)
            } catch (e: Exception) {
                // Ignore transient write errors
            } finally {
                try {
                    track?.stop()
                    track?.release()
                } catch (e: Exception) {}
            }
        }
    }

    fun pauseMusic() {
        bgmPlayer?.pause()
        musicJob?.cancel()
        musicJob = null
    }

    fun resumeMusic() {
        startBgmLoop()
    }

    // Synthesis helper functions
    private fun sineWave(freq: Double, t: Double) = sin(2.0 * PI * freq * t)
    
    private fun squareWave(freq: Double, t: Double) = if (sin(2.0 * PI * freq * t) >= 0) 1.0 else -1.0
    
    private fun triangleWave(freq: Double, t: Double): Double {
        val x = (t * freq) % 1.0
        return if (x < 0.25) {
            x * 4.0
        } else if (x < 0.75) {
            2.0 - x * 4.0
        } else {
            x * 4.0 - 4.0
        }
    }

    // Timbre helper for modern snappy glockenspiel
    private fun bellWave(freq: Double, t: Double): Double {
        // fundamental sine + clear 2nd harmonic (octave) + minor 3rd harmonic for brightness
        val attack = if (t < 0.02) t / 0.02 else 1.0 // very brief attack to avoid clicks
        return attack * (0.65 * sineWave(freq, t) + 0.25 * sineWave(freq * 2.0, t) + 0.10 * sineWave(freq * 3.0, t))
    }

    // SFX Spec: Modern soft bubble pop
    private fun generateClickSamples(): ShortArray {
        val duration = 0.06f
        val len = (sampleRate * duration).toInt()
        val s = ShortArray(len)
        for (i in 0 until len) {
            val t = i.toDouble() / sampleRate
            // snappy sweep 1200hz to 600hz
            val freq = 1200.0 - (t / duration) * 600.0
            val vol = (1.0 - (i.toDouble() / len)) * 8000.0
            s[i] = (sineWave(freq, t) * vol).toInt().toShort()
        }
        return s
    }

    // SFX Spec: Modern correct playful glockenspiel chime (major triad)
    private fun generateCorrectSamples(): ShortArray {
        val notes = doubleArrayOf(523.25, 659.25, 783.99, 1046.50) // C5, E5, G5, C6
        val durationNote = 0.08f
        val len1 = (sampleRate * durationNote).toInt()
        val s = ShortArray(len1 * notes.size)
        
        for (n in notes.indices) {
            val freq = notes[n]
            val offset = n * len1
            for (i in 0 until len1) {
                val t = i.toDouble() / sampleRate
                val vol = (1.0 - (i.toDouble() / len1)) * 11000.0
                s[offset + i] = (bellWave(freq, t) * vol).toInt().toShort()
            }
        }
        return s
    }

    // SFX Spec: Modern incorrect playful descend (no retro boings), soft marimba tone
    private fun generateIncorrectSamples(): ShortArray {
        val notes = doubleArrayOf(466.16, 349.23) // Bb4, F4 - gentle descend
        val durationNote = 0.18f
        val len1 = (sampleRate * durationNote).toInt()
        val s = ShortArray(len1 * notes.size)
        for (n in notes.indices) {
            val freq = notes[n]
            val offset = n * len1
            for (i in 0 until len1) {
                val t = i.toDouble() / sampleRate
                val vol = (1.0 - i.toDouble() / len1) * 8000.0
                s[offset + i] = (bellWave(freq, t) * vol).toInt().toShort()
            }
        }
        return s
    }

    // SFX Spec: Tick (soft bubble knock timer)
    private fun generateTickSamples(): ShortArray {
        val duration = 0.02f
        val len = (sampleRate * duration).toInt()
        val s = ShortArray(len)
        for (i in 0 until len) {
            val t = i.toDouble() / sampleRate
            val freq = 1200.0
            val vol = (1.0 - (i.toDouble() / len)) * 8000.0
            s[i] = (sineWave(freq, t) * vol).toInt().toShort()
        }
        return s
    }

    // SFX Spec: Grand luxury children fanfare victory march!
    private fun generateVictorySamples(): ShortArray {
        val notes = doubleArrayOf(523.25, 659.25, 783.99, 1046.50, 1318.51, 1567.98) // C5 -> E5 -> G5 -> C6 -> E6 -> G6
        val dur = 0.10f
        val noteLen = (sampleRate * dur).toInt()
        val s = ShortArray(noteLen * notes.size)
        for (n in notes.indices) {
            val freq = notes[n]
            val offset = n * noteLen
            for (i in 0 until noteLen) {
                val t = i.toDouble() / sampleRate
                val decayFraction = i.toDouble() / noteLen
                val vol = if (n == notes.size - 1) {
                    (1.0 - (decayFraction * 0.3)) * 11000.0
                } else {
                    (1.0 - decayFraction) * 10000.0
                }
                s[offset + i] = (bellWave(freq, t) * vol).toInt().toShort()
            }
        }
        return s
    }
}
