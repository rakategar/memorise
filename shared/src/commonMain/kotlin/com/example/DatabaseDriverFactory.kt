package com.example

import app.cash.sqldelight.ColumnAdapter
import app.cash.sqldelight.db.SqlDriver

expect fun createSqlDriver(): SqlDriver

private val IntColumnAdapter = object : ColumnAdapter<Int, Long> {
    override fun decode(databaseValue: Long) = databaseValue.toInt()
    override fun encode(value: Int) = value.toLong()
}

fun createQuizDatabase(): QuizDatabase {
    val driver = createSqlDriver()
    return QuizDatabase(
        driver = driver,
        StageProgressAdapter = StageProgress.Adapter(
            levelIdAdapter = IntColumnAdapter,
            stageIdAdapter = IntColumnAdapter,
            starsCountAdapter = IntColumnAdapter
        )
    )
}
