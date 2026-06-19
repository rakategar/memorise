@file:JvmName("DatabaseDriverFactoryAndroid")

package com.example

import app.cash.sqldelight.db.SqlDriver
import app.cash.sqldelight.driver.android.AndroidSqliteDriver

actual fun createSqlDriver(): SqlDriver =
    AndroidSqliteDriver(QuizDatabase.Schema, AppContextHolder.applicationContext, "quiz_db.db")
