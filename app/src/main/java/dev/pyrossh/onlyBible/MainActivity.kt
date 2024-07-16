package dev.pyrossh.onlyBible

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.activity.enableEdgeToEdge
import androidx.activity.viewModels
import androidx.compose.runtime.CompositionLocalProvider
import androidx.core.splashscreen.SplashScreen.Companion.installSplashScreen

class MainActivity : ComponentActivity() {

    private val model: AppViewModel by viewModels()

    override fun onCreate(savedInstanceState: Bundle?) {
        val splashScreen = installSplashScreen()
        super.onCreate(savedInstanceState)
        enableEdgeToEdge()
        model.loadBible(applicationContext)
        splashScreen.setKeepOnScreenCondition{model.uiState.value.isLoading}
        setContent {
            CompositionLocalProvider(LocalSettings provides model) {
                AppTheme {
                    AppHost()
                    if (model.showBottomSheet) {
                        TextSettingsBottomSheet()
                    }
                }
            }
        }
    }
}

