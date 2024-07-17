package dev.pyrossh.onlyBible

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.activity.enableEdgeToEdge
import androidx.activity.viewModels
import androidx.core.splashscreen.SplashScreen.Companion.installSplashScreen
import androidx.lifecycle.lifecycleScope
import kotlinx.coroutines.flow.collectLatest
import kotlinx.coroutines.launch

class MainActivity : ComponentActivity() {

    private val model by viewModels<AppViewModel>()

    override fun onCreate(savedInstanceState: Bundle?) {
        val splashScreen = installSplashScreen()
        super.onCreate(savedInstanceState)
        enableEdgeToEdge()
        lifecycleScope.launch {
            applicationContext.dataStore.data.collectLatest {
                model.initData(it)
                model.loadBible(applicationContext)
            }
        }
        splashScreen.setKeepOnScreenCondition { model.isLoading }
        setContent {
            AppTheme {
                AppHost()
                if (model.showBottomSheet) {
                    TextSettingsBottomSheet()
                }
            }
        }
    }
}

