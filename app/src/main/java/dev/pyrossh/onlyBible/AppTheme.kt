package dev.pyrossh.onlyBible

import androidx.compose.foundation.background
import androidx.compose.foundation.isSystemInDarkTheme
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.padding
import androidx.compose.material3.Icon
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.material3.dynamicDarkColorScheme
import androidx.compose.material3.dynamicLightColorScheme
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.text.TextStyle
import androidx.compose.ui.text.font.FontFamily
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.font.GenericFontFamily
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
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

    private fun background(isDark: Boolean): Color {
        return when {
            this == Light || (this == Auto && !isDark) -> Color.White
            else -> if (isDark) Color.Unspecified else Color(0xFF3E4042)
        }
    }

    private fun tint(isDark: Boolean): Color {
        return when {
            this == Light || (this == Auto && !isDark) -> Color(0xFF424547)
            else -> Color(0xFFd3d7da)
        }
    }

    @Composable
    fun ThemeIcon(currentTheme: ThemeType) {
        val name = this.name;
        val darkTheme = isSystemInDarkTheme()
        when (this) {
            Light -> Icon(
                painter = painterResource(id = R.drawable.text_theme),
                contentDescription = "Light",
                tint = this.tint(darkTheme),
                modifier = Modifier
                    .background(Color.White)
                    .padding(4.dp)
            )

            Dark -> Icon(
                painter = painterResource(id = R.drawable.text_theme),
                contentDescription = "Dark",
                tint = this.tint(darkTheme),
                modifier = Modifier
                    .background(
                        if (darkTheme && currentTheme == Dark) MaterialTheme.colorScheme.background
                        else Color(0xFF3E4042)
                    )
                    .padding(4.dp)
            )

            Auto -> Column(
                modifier = Modifier.background(
                    color = MaterialTheme.colorScheme.background,
                ),
                verticalArrangement = Arrangement.Center,
                horizontalAlignment = Alignment.CenterHorizontally
            ) {
                Text(
                    text = name,
                    style = TextStyle(
                        fontSize = 18.sp,
                        fontWeight = FontWeight.Medium,
                    ),
                )
            }
        }
    }
}

@Composable
fun AppTheme(
    content: @Composable() () -> Unit
) {
    val context = LocalContext.current
    val state = LocalSettings.current!!
    val darkTheme = isSystemInDarkTheme()
    val systemUiController = rememberSystemUiController()
    val colorScheme = when {
        state.themeType == ThemeType.Light || (state.themeType == ThemeType.Auto && !darkTheme) ->
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
    systemUiController.setSystemBarsColor(
        color = colorScheme.background
    )
    MaterialTheme(
        colorScheme = colorScheme,
        content = content
    )
}

