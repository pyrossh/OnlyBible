package example.one

import androidx.compose.runtime.Composable
import androidx.lifecycle.viewmodel.compose.viewModel

@Composable
fun App(model: AppViewModel = viewModel { AppViewModel() }) {
    AppTheme(themeType = model.themeType) {
        AppHost(model = model)
    }
}