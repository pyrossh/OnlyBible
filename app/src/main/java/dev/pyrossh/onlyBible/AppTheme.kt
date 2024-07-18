package dev.pyrossh.onlyBible

import android.content.Context
import androidx.compose.foundation.isSystemInDarkTheme
import androidx.compose.material3.ColorScheme
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

enum class ThemeType {
    Light,
    Dark,
    Auto;
}

fun getColorScheme(context: Context, themeType: ThemeType, darkTheme: Boolean): ColorScheme {
    return when {
        themeType == ThemeType.Light || (themeType == ThemeType.Auto && !darkTheme) ->
            dynamicLightColorScheme(context).copy(
                outline = Color.LightGray,
            )

        else ->
            dynamicDarkColorScheme(context).copy(
                background = Color(0xFF090F12),
                surface = Color(0xFF090F12),
                outline = Color(0xAA5D4979),
            )
    }
}

@Composable
fun AppTheme(
    model: AppViewModel = viewModel(),
    content: @Composable() () -> Unit
) {
    val context = LocalContext.current
    val darkTheme = isSystemInDarkTheme()
    val systemUiController = rememberSystemUiController()
    val themeType = ThemeType.valueOf(model.themeType)
    val colorScheme = getColorScheme(context, themeType, darkTheme)
    LaunchedEffect(key1 = model.themeType) {
//        val view = LocalView.current
//        val window = (view.context as Activity).window
//        window.statusBarColor = colorScheme.primary.toArgb()
//        WindowCompat.getInsetsController(window, view).isAppearanceLightStatusBars = darkTheme
        systemUiController.setSystemBarsColor(
            color = colorScheme.background
        )
    }
    MaterialTheme(
        colorScheme = colorScheme,
        content = content
    )
}

