package com.example

import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.first

class QuizRepository(private val dao: StageProgressDao) {

    val allProgress: Flow<List<StageProgress>> = dao.getAllProgress()

    suspend fun initializeDefaultDataIfEmpty() {
        // Collect once to see if populated
        val currentList = allProgress.first()
        if (currentList.isEmpty()) {
            resetAllProgress()
        }
    }

    suspend fun resetAllProgress() {
        dao.clearProgress()
        // Prepopulate 3 levels, each has 10 stages
        for (lvl in 1..3) {
            for (stg in 1..10) {
                // First stage of Level 1 is unlocked by default
                val unlocked = (lvl == 1 && stg == 1)
                dao.insertProgress(
                    StageProgress(
                        levelId = lvl,
                        stageId = stg,
                        starsCount = 0,
                        timeSpentMs = 0L,
                        isCompleted = false,
                        isUnlocked = unlocked
                    )
                )
            }
        }
    }

    suspend fun unlockAllProgress() {
        dao.clearProgress()
        for (lvl in 1..3) {
            for (stg in 1..10) {
                dao.insertProgress(
                    StageProgress(
                        levelId = lvl,
                        stageId = stg,
                        starsCount = 3, // For a nice initialized state in debugging
                        timeSpentMs = 1200L,
                        isCompleted = true,
                        isUnlocked = true
                    )
                )
            }
        }
    }

    suspend fun saveProgress(levelId: Int, stageId: Int, stars: Int, elapsedMs: Long) {
        val currentProgress = dao.getProgressForStage(levelId, stageId)
        
        // Calculate new values, preserving best stars and fastest time
        val newStars = currentProgress?.let { maxOf(it.starsCount, stars) } ?: stars
        
        val newTime = currentProgress?.let {
            if (it.timeSpentMs <= 0L) elapsedMs
            else minOf(it.timeSpentMs, elapsedMs)
        } ?: elapsedMs

        dao.insertProgress(
            StageProgress(
                levelId = levelId,
                stageId = stageId,
                starsCount = newStars,
                timeSpentMs = newTime,
                isCompleted = true,
                isUnlocked = true
            )
        )

        // Unlock next stage
        unlockNextStage(levelId, stageId)
    }

    private suspend fun unlockNextStage(currentLvl: Int, currentStg: Int) {
        val nextLvl: Int
        val nextStg: Int

        if (currentStg < 10) {
            nextLvl = currentLvl
            nextStg = currentStg + 1
        } else if (currentLvl < 3) {
            nextLvl = currentLvl + 1
            nextStg = 1
        } else {
            // Already at last stage of last level
            return
        }

        val nextProgress = dao.getProgressForStage(nextLvl, nextStg)
        dao.insertProgress(
            StageProgress(
                levelId = nextLvl,
                stageId = nextStg,
                starsCount = nextProgress?.starsCount ?: 0,
                timeSpentMs = nextProgress?.timeSpentMs ?: 0L,
                isCompleted = nextProgress?.isCompleted ?: false,
                isUnlocked = true
            )
        )
    }
}
