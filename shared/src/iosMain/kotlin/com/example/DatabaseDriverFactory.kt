package com.example

import app.cash.sqldelight.db.SqlDriver
import app.cash.sqldelight.driver.native.NativeSqliteDriver

actual fun createSqlDriver(): SqlDriver =
    NativeSqliteDriver(QuizDatabase.Schema, "quiz_db.db")
