package com.example

import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.setValue
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import kotlinx.coroutines.Job
import kotlinx.coroutines.delay
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.SharingStarted
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.stateIn
import kotlinx.coroutines.launch

sealed interface Screen {
    object Splash : Screen
    object LevelSelect : Screen
    data class StageSelect(val levelId: Int) : Screen
    data class Gameplay(val levelId: Int, val stageId: Int) : Screen
    data class Summary(val levelId: Int, val stageId: Int, val isSuccess: Boolean, val stars: Int, val timeSpentMs: Long) : Screen
}

class QuizViewModel : ViewModel() {

    private val database = createQuizDatabase()
    private val repository = QuizRepository(database.stageProgressQueries)
    val soundManager = SoundManager()

    var currentScreen by mutableStateOf<Screen>(Screen.Splash)
        private set

    val progressList: StateFlow<List<StageProgress>> = repository.allProgress
        .stateIn(
            scope = viewModelScope,
            started = SharingStarted.WhileSubscribed(5000),
            initialValue = emptyList()
        )

    var currentQuestion by mutableStateOf<Question?>(null)
        private set

    var isObservationPhase by mutableStateOf(false)
        private set
    var observationTimer by mutableStateOf(0)
        private set
    private var observationJob: Job? = null

    var isAnswerPhase by mutableStateOf(false)
        private set
    var answerTimeElapsedMs by mutableStateOf(0L)
        private set
    private var answerJob: Job? = null

    var selectedOptionIndex by mutableStateOf<Int?>(null)
        private set

    init {
        viewModelScope.launch {
            repository.initializeDefaultDataIfEmpty()
        }
        soundManager.startBgmLoop()
    }

    fun navigateTo(screen: Screen) {
        soundManager.playSound(SfxType.CLICK)
        currentScreen = screen
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
                isObservationPhase = true
                isAnswerPhase = false
                observationTimer = q.observationTimeSecs
                startObservationTimer()
            } else {
                isObservationPhase = false
                isAnswerPhase = true
                startAnswerTiming()
            }
        }
    }

    fun skipObservation() {
        soundManager.playSound(SfxType.CLICK)
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
                    soundManager.playSound(SfxType.TICK)
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
            val startTime = currentTimeMillis()
            while (isAnswerPhase) {
                delay(30)
                answerTimeElapsedMs = currentTimeMillis() - startTime
            }
        }
    }

    fun submitAnswer(optionIndex: Int) {
        if (selectedOptionIndex != null || currentQuestion == null) return
        selectedOptionIndex = optionIndex

        isAnswerPhase = false
        answerJob?.cancel()

        val q = currentQuestion!!
        val isCorrect = optionIndex == q.correctAnswerIndex

        viewModelScope.launch {
            if (isCorrect) {
                val stars = when {
                    answerTimeElapsedMs < 3000L -> 3
                    answerTimeElapsedMs < 7000L -> 2
                    else -> 1
                }
                soundManager.playSound(SfxType.CORRECT)
                repository.saveProgress(q.levelId, q.stageId, stars, answerTimeElapsedMs)
                delay(350)
                navigateTo(Screen.Summary(q.levelId, q.stageId, isSuccess = true, stars = stars, timeSpentMs = answerTimeElapsedMs))
            } else {
                soundManager.playSound(SfxType.INCORRECT)
                delay(350)
                navigateTo(Screen.Summary(q.levelId, q.stageId, isSuccess = false, stars = 0, timeSpentMs = answerTimeElapsedMs))
            }
        }
    }

    fun resetGame() {
        soundManager.playSound(SfxType.CLICK)
        viewModelScope.launch { repository.resetAllProgress() }
    }

    fun unlockAll() {
        soundManager.playSound(SfxType.CLICK)
        viewModelScope.launch { repository.unlockAllProgress() }
    }

    fun toggleMusic() {
        soundManager.playSound(SfxType.CLICK)
        soundManager.isMusicEnabled = !soundManager.isMusicEnabled
    }

    fun toggleSound() {
        soundManager.isSoundEnabled = !soundManager.isSoundEnabled
        soundManager.playSound(SfxType.CLICK)
    }

    override fun onCleared() {
        soundManager.pauseMusic()
        super.onCleared()
    }
}

expect fun currentTimeMillis(): Long
