package com.example

import app.cash.sqldelight.coroutines.asFlow
import app.cash.sqldelight.coroutines.mapToList
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.first
import kotlinx.coroutines.withContext

class QuizRepository(private val queries: StageProgressQueries) {

    val allProgress: Flow<List<StageProgress>> = queries.getAllProgress()
        .asFlow()
        .mapToList(Dispatchers.Default)

    suspend fun initializeDefaultDataIfEmpty() {
        val currentList = allProgress.first()
        if (currentList.isEmpty()) resetAllProgress()
    }

    suspend fun resetAllProgress() = withContext(Dispatchers.Default) {
        queries.clearProgress()
        for (lvl in 1..3) {
            for (stg in 1..10) {
                queries.insertProgress(
                    levelId = lvl, stageId = stg,
                    starsCount = 0, timeSpentMs = 0L,
                    isCompleted = false, isUnlocked = (lvl == 1 && stg == 1)
                )
            }
        }
    }

    suspend fun unlockAllProgress() = withContext(Dispatchers.Default) {
        queries.clearProgress()
        for (lvl in 1..3) {
            for (stg in 1..10) {
                queries.insertProgress(
                    levelId = lvl, stageId = stg,
                    starsCount = 3, timeSpentMs = 1200L,
                    isCompleted = true, isUnlocked = true
                )
            }
        }
    }

    suspend fun saveProgress(levelId: Int, stageId: Int, stars: Int, elapsedMs: Long) = withContext(Dispatchers.Default) {
        val current = queries.getProgressForStage(levelId, stageId).executeAsOneOrNull()
        val newStars = current?.let { maxOf(it.starsCount, stars) } ?: stars
        val newTime = current?.let {
            if (it.timeSpentMs <= 0L) elapsedMs else minOf(it.timeSpentMs, elapsedMs)
        } ?: elapsedMs
        queries.insertProgress(
            levelId = levelId, stageId = stageId,
            starsCount = newStars, timeSpentMs = newTime,
            isCompleted = true, isUnlocked = true
        )
        unlockNextStage(levelId, stageId)
    }

    private fun unlockNextStage(currentLvl: Int, currentStg: Int) {
        val (nextLvl, nextStg) = when {
            currentStg < 10 -> currentLvl to (currentStg + 1)
            currentLvl < 3 -> (currentLvl + 1) to 1
            else -> return
        }
        val next = queries.getProgressForStage(nextLvl, nextStg).executeAsOneOrNull()
        queries.insertProgress(
            levelId = nextLvl, stageId = nextStg,
            starsCount = next?.starsCount ?: 0,
            timeSpentMs = next?.timeSpentMs ?: 0L,
            isCompleted = next?.isCompleted ?: false,
            isUnlocked = true
        )
    }
}
