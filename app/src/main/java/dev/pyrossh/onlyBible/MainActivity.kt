package dev.pyrossh.onlyBible

import android.animation.ObjectAnimator
import android.content.Context
import android.os.Bundle
import android.view.View
import android.view.animation.AccelerateInterpolator
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.activity.enableEdgeToEdge
import androidx.activity.viewModels
import androidx.core.animation.doOnEnd
import androidx.core.splashscreen.SplashScreen.Companion.installSplashScreen
import androidx.lifecycle.lifecycleScope
import kotlinx.coroutines.launch
import java.util.Locale

fun Context.getCurrentLocale(): Locale {
    return resources.configuration.locales.get(0)
}

class MainActivity : ComponentActivity() {

    private val model by viewModels<AppViewModel>()

    override fun onCreate(savedInstanceState: Bundle?) {
        val splashScreen = installSplashScreen()
        super.onCreate(savedInstanceState)
        enableEdgeToEdge()
        lifecycleScope.launch {
            model.loadData()
        }
        splashScreen.setKeepOnScreenCondition { model.isLoading }
        splashScreen.setOnExitAnimationListener { viewProvider ->
            ObjectAnimator.ofFloat(
                viewProvider.view,
                View.TRANSLATION_Y,
                0f,
                -viewProvider.view.height.toFloat()
            ).apply {
                interpolator = AccelerateInterpolator()
                duration = 200L
                doOnEnd {
                    enableEdgeToEdge()
                    viewProvider.remove()
                    enableEdgeToEdge()
                }
                start()
            }
        }

        addOnConfigurationChangedListener {
            model.uiMode = it.uiMode
        }
        setContent {
            AppTheme {
                AppHost(model = model)
                if (model.showBottomSheet) {
                    TextSettingsBottomSheet(model = model)
                }
            }
        }
    }

    override fun onSaveInstanceState(outState: Bundle) {
        super.onSaveInstanceState(outState)
        lifecycleScope.launch {
            model.saveData()
        }
    }
}

