package dev.pyrossh.onlyBible

import android.content.res.Configuration.UI_MODE_NIGHT_MASK
import android.content.res.Configuration.UI_MODE_NIGHT_NO
import android.content.res.Configuration.UI_MODE_NIGHT_UNDEFINED
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

fun isLightTheme(uiMode: Int, isSystemDark: Boolean): Boolean {
    val maskedMode = uiMode and UI_MODE_NIGHT_MASK
    return maskedMode == UI_MODE_NIGHT_NO || (maskedMode == UI_MODE_NIGHT_UNDEFINED && !isSystemDark)
}

@Composable
fun AppTheme(
    model: AppViewModel = viewModel(),
    content: @Composable() () -> Unit
) {
    val context = LocalContext.current
    val systemUiController = rememberSystemUiController()
    val colorScheme = if (isLightTheme(model.uiMode, isSystemInDarkTheme()))
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
    println("AppTheme ${model.uiMode}")
    LaunchedEffect(key1 = model.uiMode) {
        systemUiController.setSystemBarsColor(
            color = colorScheme.background
        )
    }
    MaterialTheme(
        colorScheme = colorScheme,
        content = content
    )
}

