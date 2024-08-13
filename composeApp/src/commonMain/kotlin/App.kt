import androidx.compose.runtime.Composable

@Composable
fun App(model: AppViewModel) {
    AppTheme(themeType = model.themeType) {
        AppHost(model = model)
    }
}