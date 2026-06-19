package com.example

import android.app.Application
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.setValue
import androidx.lifecycle.AndroidViewModel
import androidx.lifecycle.viewModelScope
import kotlinx.coroutines.Job
import kotlinx.coroutines.delay
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.SharingStarted
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.flow.stateIn
import kotlinx.coroutines.launch

sealed interface Screen {
    object Splash : Screen
    object LevelSelect : Screen
    data class StageSelect(val levelId: Int) : Screen
    data class Gameplay(val levelId: Int, val stageId: Int) : Screen
    data class Summary(val levelId: Int, val stageId: Int, val isSuccess: Boolean, val stars: Int, val timeSpentMs: Long) : Screen
}

class QuizViewModel(application: Application) : AndroidViewModel(application) {

    private val database = androidx.room.Room.databaseBuilder(
        application,
        QuizDatabase::class.java, "quiz_db"
    ).build()

    private val repository = QuizRepository(database.stageProgressDao())
    val soundManager = SoundManager(application)

    // Screen navigation state
    var currentScreen by mutableStateOf<Screen>(Screen.Splash)
        private set

    // All stage progress flows from Room db
    val progressList: StateFlow<List<StageProgress>> = repository.allProgress
        .stateIn(
            scope = viewModelScope,
            started = SharingStarted.WhileSubscribed(5000),
            initialValue = emptyList()
        )

    // Current quiz active question
    var currentQuestion by mutableStateOf<Question?>(null)
        private set

    // Observation phase state
    var isObservationPhase by mutableStateOf(false)
        private set
    var observationTimer by mutableStateOf(0)
        private set
    private var observationJob: Job? = null

    // Answer phase state
    var isAnswerPhase by mutableStateOf(false)
        private set
    var answerTimeElapsedMs by mutableStateOf(0L)
        private set
    private var answerJob: Job? = null

    // Selected option during quiz
    var selectedOptionIndex by mutableStateOf<Int?>(null)
        private set

    init {
        viewModelScope.launch {
            repository.initializeDefaultDataIfEmpty()
        }
        // Auto-run background chiptune arpeggio
        soundManager.startBgmLoop()
    }

    fun navigateTo(screen: Screen) {
        soundManager.playSound(SoundManager.sfxType.CLICK)
        currentScreen = screen

        // Handle entering gameplay screen
        if (screen is Screen.Gameplay) {
            setupGameplay(screen.levelId, screen.stageId)
        }
    }

    private fun setupGameplay(levelId: Int, stageId: Int) {
        val questions = QuizQuestions.getQuestions()
        val q = questions.firstOrNull { it.levelId == levelId && it.stageId == stageId }
        currentQuestion = q
        selectedOptionIndex = null

        if (q != null) {
            if (q.observationTimeSecs > 0) {
                // Start Observation Phase
                isObservationPhase = true
                isAnswerPhase = false
                observationTimer = q.observationTimeSecs
                startObservationTimer()
            } else {
                // No observation, jump straight to quiz answering
                isObservationPhase = false
                isAnswerPhase = true
                startAnswerTiming()
            }
        }
    }

    fun skipObservation() {
        soundManager.playSound(SoundManager.sfxType.CLICK)
        observationJob?.cancel()
        enterAnswerPhase()
    }

    private fun startObservationTimer() {
        observationJob?.cancel()
        observationJob = viewModelScope.launch {
            while (observationTimer > 0) {
                delay(1000)
                observationTimer -= 1
                if (observationTimer > 0 && observationTimer <= 4) {
                    // Soft ticking sound warning time limit
                    soundManager.playSound(SoundManager.sfxType.TICK)
                }
                if (observationTimer == 0) {
                    enterAnswerPhase()
                }
            }
        }
    }

    private fun enterAnswerPhase() {
        isObservationPhase = false
        isAnswerPhase = true
        startAnswerTiming()
    }

    private fun startAnswerTiming() {
        answerJob?.cancel()
        answerTimeElapsedMs = 0L
        answerJob = viewModelScope.launch {
            val startTime = System.currentTimeMillis()
            while (isAnswerPhase) {
                delay(30)
                answerTimeElapsedMs = System.currentTimeMillis() - startTime
            }
        }
    }

    fun submitAnswer(optionIndex: Int) {
        if (selectedOptionIndex != null || currentQuestion == null) return
        selectedOptionIndex = optionIndex
        
        // Stop timer
        isAnswerPhase = false
        answerJob?.cancel()

        val q = currentQuestion!!
        val isCorrect = optionIndex == q.correctAnswerIndex

        viewModelScope.launch {
            if (isCorrect) {
                // Calculate stars based on speed
                val stars = when {
                    answerTimeElapsedMs < 3000L -> 3
                    answerTimeElapsedMs < 7000L -> 2
                    else -> 1
                }
                
                soundManager.playSound(SoundManager.sfxType.CORRECT)
                repository.saveProgress(q.levelId, q.stageId, stars, answerTimeElapsedMs)
                
                // Show winning screen/modal with 250ms delayed transition
                delay(350)
                navigateTo(Screen.Summary(q.levelId, q.stageId, isSuccess = true, stars = stars, timeSpentMs = answerTimeElapsedMs))
            } else {
                soundManager.playSound(SoundManager.sfxType.INCORRECT)
                delay(350)
                navigateTo(Screen.Summary(q.levelId, q.stageId, isSuccess = false, stars = 0, timeSpentMs = answerTimeElapsedMs))
            }
        }
    }

    fun resetGame() {
        soundManager.playSound(SoundManager.sfxType.CLICK)
        viewModelScope.launch {
            repository.resetAllProgress()
        }
    }

    fun unlockAll() {
        soundManager.playSound(SoundManager.sfxType.CLICK)
        viewModelScope.launch {
            repository.unlockAllProgress()
        }
    }

    // Toggle background music
    fun toggleMusic() {
        soundManager.playSound(SoundManager.sfxType.CLICK)
        soundManager.isMusicEnabled = !soundManager.isMusicEnabled
    }

    // Toggle sound effects
    fun toggleSound() {
        soundManager.isSoundEnabled = !soundManager.isSoundEnabled
        soundManager.playSound(SoundManager.sfxType.CLICK)
    }

    override fun onCleared() {
        soundManager.pauseMusic()
        super.onCleared()
    }
}
