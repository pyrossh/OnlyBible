package dev.pyrossh.only_bible_app

import androidx.compose.runtime.Composable
import androidx.lifecycle.viewmodel.compose.viewModel

@Composable
fun App(model: AppViewModel = viewModel { AppViewModel() }) {
    AppTheme(themeType = model.themeType) {
        AppHost(model = model)
    }
}