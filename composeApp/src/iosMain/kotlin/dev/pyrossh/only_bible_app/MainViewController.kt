package dev.pyrossh.only_bible_app

import androidx.compose.ui.window.ComposeUIViewController

fun MainViewController(): ComposeUIViewController {
    val model = AppViewModel()
    return ComposeUIViewController {
        AppTheme(themeType = model.themeType) {
            AppHost(model = model)
        }
    }
}