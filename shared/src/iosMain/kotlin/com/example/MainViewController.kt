package com.example

import androidx.compose.runtime.remember
import androidx.compose.ui.window.ComposeUIViewController

fun MainViewController() = ComposeUIViewController {
    val vm = remember { QuizViewModel() }
    App(vm)
}
