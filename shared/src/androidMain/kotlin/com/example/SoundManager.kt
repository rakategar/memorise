package com.example

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
import kotlin.math.PI
import kotlin.math.sin

actual class SoundManager actual constructor() {
    actual var isSoundEnabled: Boolean = true
    actual var isMusicEnabled: Boolean = true
        set(value) {
            field = value
            if (value) resumeMusic() else pauseMusic()
        }

    private val context get() = AppContextHolder.applicationContext
    private val scope = CoroutineScope(Dispatchers.Default)
    private var musicJob: Job? = null
    private val sampleRate = 22050

    actual fun playSound(type: SfxType) {
        if (!isSoundEnabled) return
        scope.launch {
            try {
                val samples = when (type) {
                    SfxType.CLICK -> generateClickSamples()
                    SfxType.CORRECT -> generateCorrectSamples()
                    SfxType.INCORRECT -> generateIncorrectSamples()
                    SfxType.VICTORY -> generateVictorySamples()
                    SfxType.TICK -> generateTickSamples()
                }
                playPcmStream(samples)
            } catch (e: Exception) {
                Log.e("SoundManager", "Error playing SFX", e)
            }
        }
    }

    private fun playPcmStream(samples: ShortArray) {
        var track: AudioTrack? = null
        try {
            val minBufSize = AudioTrack.getMinBufferSize(
                sampleRate, AudioFormat.CHANNEL_OUT_MONO, AudioFormat.ENCODING_PCM_16BIT
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
            val durationMs = (samples.size * 1000L) / sampleRate
            Thread.sleep(durationMs + 100)
        } catch (e: Exception) {
            Log.e("SoundManager", "AudioTrack play failed", e)
        } finally {
            try { track?.stop(); track?.release() } catch (e: Exception) {}
        }
    }

    private var bgmPlayer: android.media.MediaPlayer? = null

    actual fun startBgmLoop() {
        if (!isMusicEnabled) return
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
        if (bgmPlayer != null) { bgmPlayer?.start(); return }
        if (musicJob != null) return
        musicJob = scope.launch {
            val melody1 = doubleArrayOf(523.25, 659.25, 783.99, 659.25, 523.25, 659.25, 783.99, 1046.50)
            val melody2 = doubleArrayOf(698.46, 880.00, 1046.50, 880.00, 698.46, 880.00, 1046.50, 1396.91)
            val melody3 = doubleArrayOf(783.99, 987.77, 1174.66, 987.77, 783.99, 987.77, 1174.66, 1567.98)
            val melody4 = doubleArrayOf(1046.50, 783.99, 659.25, 783.99, 523.25, 659.25, 783.99, 1046.50)
            val sections = listOf(melody1, melody2, melody3, melody4)
            var sectionIdx = 0
            while (isActive) {
                if (!isMusicEnabled) { delay(500); continue }
                val chord = sections[sectionIdx]
                for (noteFreq in chord) {
                    if (!isActive || !isMusicEnabled) break
                    val noteDurationSecs = 0.18f
                    val sampleCount = (sampleRate * noteDurationSecs).toInt()
                    val noteSamples = ShortArray(sampleCount)
                    for (i in 0 until sampleCount) {
                        val t = i.toDouble() / sampleRate
                        val wave = bellWave(noteFreq, t)
                        val envelope = 1.0 - i.toDouble() / sampleCount
                        noteSamples[i] = (wave * 1400.0 * envelope).toInt().toShort()
                    }
                    playPcmShortNoteAsync(noteSamples)
                    delay(180)
                }
                sectionIdx = (sectionIdx + 1) % sections.size
                delay(80)
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
                // Ignore transient errors
            } finally {
                try { track?.stop(); track?.release() } catch (e: Exception) {}
            }
        }
    }

    actual fun pauseMusic() {
        bgmPlayer?.pause()
        musicJob?.cancel()
        musicJob = null
    }

    actual fun resumeMusic() { startBgmLoop() }

    private fun sineWave(freq: Double, t: Double) = sin(2.0 * PI * freq * t)
    private fun bellWave(freq: Double, t: Double): Double {
        val attack = if (t < 0.02) t / 0.02 else 1.0
        return attack * (0.65 * sineWave(freq, t) + 0.25 * sineWave(freq * 2.0, t) + 0.10 * sineWave(freq * 3.0, t))
    }

    private fun generateClickSamples(): ShortArray {
        val duration = 0.06f
        val len = (sampleRate * duration).toInt()
        return ShortArray(len) { i ->
            val t = i.toDouble() / sampleRate
            val freq = 1200.0 - (t / duration) * 600.0
            val vol = (1.0 - i.toDouble() / len) * 8000.0
            (sineWave(freq, t) * vol).toInt().toShort()
        }
    }

    private fun generateCorrectSamples(): ShortArray {
        val notes = doubleArrayOf(523.25, 659.25, 783.99, 1046.50)
        val len1 = (sampleRate * 0.08f).toInt()
        val s = ShortArray(len1 * notes.size)
        for (n in notes.indices) {
            val freq = notes[n]; val offset = n * len1
            for (i in 0 until len1) {
                val t = i.toDouble() / sampleRate
                val vol = (1.0 - i.toDouble() / len1) * 11000.0
                s[offset + i] = (bellWave(freq, t) * vol).toInt().toShort()
            }
        }
        return s
    }

    private fun generateIncorrectSamples(): ShortArray {
        val notes = doubleArrayOf(466.16, 349.23)
        val len1 = (sampleRate * 0.18f).toInt()
        val s = ShortArray(len1 * notes.size)
        for (n in notes.indices) {
            val freq = notes[n]; val offset = n * len1
            for (i in 0 until len1) {
                val t = i.toDouble() / sampleRate
                val vol = (1.0 - i.toDouble() / len1) * 8000.0
                s[offset + i] = (bellWave(freq, t) * vol).toInt().toShort()
            }
        }
        return s
    }

    private fun generateTickSamples(): ShortArray {
        val len = (sampleRate * 0.02f).toInt()
        return ShortArray(len) { i ->
            val t = i.toDouble() / sampleRate
            val vol = (1.0 - i.toDouble() / len) * 8000.0
            (sineWave(1200.0, t) * vol).toInt().toShort()
        }
    }

    private fun generateVictorySamples(): ShortArray {
        val notes = doubleArrayOf(523.25, 659.25, 783.99, 1046.50, 1318.51, 1567.98)
        val noteLen = (sampleRate * 0.10f).toInt()
        val s = ShortArray(noteLen * notes.size)
        for (n in notes.indices) {
            val freq = notes[n]; val offset = n * noteLen
            for (i in 0 until noteLen) {
                val t = i.toDouble() / sampleRate
                val vol = (1.0 - i.toDouble() / noteLen) * 10000.0
                s[offset + i] = (bellWave(freq, t) * vol).toInt().toShort()
            }
        }
        return s
    }
}
