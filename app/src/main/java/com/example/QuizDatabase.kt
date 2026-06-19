package com.example

import androidx.room.*
import kotlinx.coroutines.flow.Flow

@Entity(tableName = "stage_progress", primaryKeys = ["levelId", "stageId"])
data class StageProgress(
    val levelId: Int,
    val stageId: Int,
    val starsCount: Int,
    val timeSpentMs: Long,
    val isCompleted: Boolean,
    val isUnlocked: Boolean
)

@Dao
interface StageProgressDao {
    @Query("SELECT * FROM stage_progress ORDER BY levelId ASC, stageId ASC")
    fun getAllProgress(): Flow<List<StageProgress>>

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun insertProgress(progress: StageProgress)

    @Query("SELECT * FROM stage_progress WHERE levelId = :levelId AND stageId = :stageId LIMIT 1")
    suspend fun getProgressForStage(levelId: Int, stageId: Int): StageProgress?

    @Query("UPDATE stage_progress SET isUnlocked = 1 WHERE levelId = :levelId AND stageId = :stageId")
    suspend fun unlockStage(levelId: Int, stageId: Int)

    @Query("DELETE FROM stage_progress")
    suspend fun clearProgress()
}

@Database(entities = [StageProgress::class], version = 1, exportSchema = false)
abstract class QuizDatabase : RoomDatabase() {
    abstract fun stageProgressDao(): StageProgressDao
}
