package com.example

import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.Job
import kotlinx.coroutines.delay
import kotlinx.coroutines.isActive
import kotlinx.coroutines.launch
import platform.AVFAudio.*

actual class SoundManager actual constructor() {
    actual var isSoundEnabled: Boolean = true
    actual var isMusicEnabled: Boolean = true
        set(value) {
            field = value
            if (value) resumeMusic() else pauseMusic()
        }

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
                playPcmBuffer(samples)
            } catch (e: Exception) {
                // Ignore sound errors on iOS
            }
        }
    }

    private fun playPcmBuffer(samples: ShortArray) {
        val format = AVAudioFormat(standardFormatWithSampleRate = sampleRate.toDouble(), channels = 1u)
            ?: return
        val engine = AVAudioEngine()
        val playerNode = AVAudioPlayerNode()
        engine.attachNode(playerNode)
        engine.connect(playerNode, engine.mainMixerNode, format)
        try {
            engine.startAndReturnError(null)
            val frameCount = samples.size.toUInt()
            val buffer = AVAudioPCMBuffer(pCMFormat = format, frameCapacity = frameCount) ?: return
            buffer.frameLength = frameCount
            val channelData = buffer.int16ChannelData ?: return
            val ptr = channelData[0] ?: return
            for (i in samples.indices) {
                ptr[i] = samples[i]
            }
            playerNode.scheduleBuffer(buffer, completionHandler = null)
            playerNode.play()
            val durationMs = (samples.size * 1000L) / sampleRate
            Thread.sleep(durationMs + 100)
        } catch (e: Exception) {
            // Ignore
        } finally {
            playerNode.stop()
            engine.stop()
        }
    }

    actual fun startBgmLoop() {
        if (!isMusicEnabled || musicJob != null) return
        musicJob = scope.launch {
            val melody1 = doubleArrayOf(523.25, 659.25, 783.99, 659.25, 523.25, 659.25, 783.99, 1046.50)
            val melody2 = doubleArrayOf(698.46, 880.00, 1046.50, 880.00, 698.46, 880.00, 1046.50, 1396.91)
            val sections = listOf(melody1, melody2)
            var sectionIdx = 0
            while (isActive) {
                if (!isMusicEnabled) { delay(500); continue }
                val chord = sections[sectionIdx]
                for (noteFreq in chord) {
                    if (!isActive || !isMusicEnabled) break
                    val sampleCount = (sampleRate * 0.18f).toInt()
                    val noteSamples = ShortArray(sampleCount) { i ->
                        val t = i.toDouble() / sampleRate
                        val envelope = 1.0 - i.toDouble() / sampleCount
                        (bellWave(noteFreq, t) * 1400.0 * envelope).toInt().toShort()
                    }
                    playPcmBuffer(noteSamples)
                    delay(180)
                }
                sectionIdx = (sectionIdx + 1) % sections.size
                delay(80)
            }
        }
    }

    actual fun pauseMusic() {
        musicJob?.cancel()
        musicJob = null
    }

    actual fun resumeMusic() { startBgmLoop() }

    private fun sineWave(freq: Double, t: Double) = kotlin.math.sin(2.0 * kotlin.math.PI * freq * t)
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
                s[offset + i] = (bellWave(freq, t) * (1.0 - i.toDouble() / len1) * 11000.0).toInt().toShort()
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
                s[offset + i] = (bellWave(freq, t) * (1.0 - i.toDouble() / len1) * 8000.0).toInt().toShort()
            }
        }
        return s
    }

    private fun generateTickSamples(): ShortArray {
        val len = (sampleRate * 0.02f).toInt()
        return ShortArray(len) { i ->
            val t = i.toDouble() / sampleRate
            (sineWave(1200.0, t) * (1.0 - i.toDouble() / len) * 8000.0).toInt().toShort()
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
                s[offset + i] = (bellWave(freq, t) * (1.0 - i.toDouble() / noteLen) * 10000.0).toInt().toShort()
            }
        }
        return s
    }
}
