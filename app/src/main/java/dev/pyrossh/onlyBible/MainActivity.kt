package dev.pyrossh.onlyBible

import android.animation.ObjectAnimator
import android.content.res.Configuration
import android.os.Bundle
import android.view.View
import android.view.animation.AccelerateInterpolator
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.activity.enableEdgeToEdge
import androidx.activity.viewModels
import androidx.core.animation.doOnEnd
import androidx.core.splashscreen.SplashScreen.Companion.installSplashScreen
import androidx.datastore.preferences.core.edit
import androidx.datastore.preferences.core.intPreferencesKey
import androidx.lifecycle.lifecycleScope
import kotlinx.coroutines.flow.first
import kotlinx.coroutines.launch

class MainActivity : ComponentActivity() {

    private val model by viewModels<AppViewModel>()

    override fun onCreate(savedInstanceState: Bundle?) {
        val isSystemDark = applicationContext.resources.configuration.uiMode  and Configuration.UI_MODE_NIGHT_MASK == Configuration.UI_MODE_NIGHT_YES
//        if (isSystemDark) {
//            setTheme(R.style.Theme_BibleAppSplashDark)
//        } else {
//            setTheme(R.style.Theme_BibleAppSplashLight)
//        }
        val splashScreen = installSplashScreen()
        super.onCreate(savedInstanceState)
        enableEdgeToEdge()
        lifecycleScope.launch {
            val data = applicationContext.dataStore.data.first()
            model.initData(data)
            model.loadBible(applicationContext)
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
        setContent {
            AppTheme {
                AppHost()
                if (model.showBottomSheet) {
                    TextSettingsBottomSheet(model = model)
                }
            }
        }
    }

    override fun onSaveInstanceState(outState: Bundle) {
        super.onSaveInstanceState(outState)
        lifecycleScope.launch {
            applicationContext.dataStore.edit {
                println("saveData ${model.scrollState.firstVisibleItemIndex}")
                it[intPreferencesKey("scrollIndex")] = model.scrollState.firstVisibleItemIndex
                it[intPreferencesKey("scrollOffset")] = model.scrollState.firstVisibleItemScrollOffset
            }
        }
    }
}

