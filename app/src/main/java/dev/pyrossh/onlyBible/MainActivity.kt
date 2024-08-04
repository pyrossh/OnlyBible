package dev.pyrossh.onlyBible

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.activity.enableEdgeToEdge
import androidx.activity.viewModels
import androidx.compose.runtime.CompositionLocalProvider
import androidx.lifecycle.lifecycleScope
import androidx.navigation.compose.rememberNavController
import dev.pyrossh.onlyBible.composables.TextSettingsBottomSheet
import dev.pyrossh.onlyBible.utils.LocalNavController
import kotlinx.coroutines.launch

class MainActivity : ComponentActivity() {

    private val model by viewModels<AppViewModel>()

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        enableEdgeToEdge()
        if (savedInstanceState == null) {
            lifecycleScope.launch {
                model.loadData(applicationContext)
            }
        }
        setContent {
            AppTheme(
                nightMode = model.nightMode
            ) {
                val navController = rememberNavController()
                CompositionLocalProvider(LocalNavController provides navController) {
                    AppHost(navController = navController, model = model)
                }
                if (model.showBottomSheet) {
                    TextSettingsBottomSheet()
                }
            }
        }
    }

    override fun onSaveInstanceState(outState: Bundle) {
        super.onSaveInstanceState(outState)
        lifecycleScope.launch {
            model.saveData(applicationContext)
        }
    }
}

