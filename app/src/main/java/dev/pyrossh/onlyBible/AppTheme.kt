package dev.pyrossh.onlyBible

import android.app.UiModeManager
import androidx.compose.foundation.isSystemInDarkTheme
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.dynamicDarkColorScheme
import androidx.compose.material3.dynamicLightColorScheme
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.text.font.FontFamily
import androidx.compose.ui.text.font.GenericFontFamily
import androidx.lifecycle.viewmodel.compose.viewModel
import com.google.accompanist.systemuicontroller.rememberSystemUiController

enum class FontType {
    Sans,
    Serif,
    Mono;

    fun family(): GenericFontFamily {
        return when (this) {
            Sans -> FontFamily.SansSerif
            Serif -> FontFamily.Serif
            Mono -> FontFamily.Monospace
        }
    }
}

val lightHighlights = listOf(
    Color(0xFFDAEFFE),
    Color(0xFFFFFCB2),
    Color(0xFFFFDDF3),
)

val darkHighlights = listOf(
    Color(0xFF69A9FC),
    Color(0xFFFFEB66),
    Color(0xFFFF66B3),
)


fun isLightTheme(uiMode: Int, isSystemDark: Boolean): Boolean {
    return uiMode == UiModeManager.MODE_NIGHT_NO || (uiMode == UiModeManager.MODE_NIGHT_AUTO && !isSystemDark)
}

@Composable
fun AppTheme(
    model: AppViewModel = viewModel(),
    content: @Composable() () -> Unit
) {
    val context = LocalContext.current
    val systemUiController = rememberSystemUiController()
    val colorScheme = if (isLightTheme(model.nightMode, isSystemInDarkTheme()))
        dynamicLightColorScheme(context).copy(
            onSurface = Color.Black,
            outline = Color.LightGray,
        )
    else
        dynamicDarkColorScheme(context).copy(
            background = Color(0xFF090F12),
            surface = Color(0xFF090F12),
            outline = Color(0xAA5D4979),
        )
    LaunchedEffect(key1 = model.nightMode) {
        systemUiController.setSystemBarsColor(
            color = colorScheme.background
        )
    }
    MaterialTheme(
        colorScheme = colorScheme,
        content = content
    )
}

