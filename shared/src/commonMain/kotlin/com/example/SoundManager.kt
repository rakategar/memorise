package com.example

enum class SfxType { CLICK, CORRECT, INCORRECT, VICTORY, TICK }

expect class SoundManager() {
    var isSoundEnabled: Boolean
    var isMusicEnabled: Boolean
    fun playSound(type: SfxType)
    fun startBgmLoop()
    fun pauseMusic()
    fun resumeMusic()
}
