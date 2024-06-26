package dev.pyrossh.onlyBible.ui.theme

import androidx.compose.foundation.background
import androidx.compose.foundation.isSystemInDarkTheme
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.padding
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
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.google.accompanist.systemuicontroller.rememberSystemUiController
import dev.pyrossh.onlyBible.LocalState
import dev.pyrossh.onlyBible.R


enum class ThemeType {
    Light,
    Dark,
    Auto;

    private fun background(isDark: Boolean): Color {
        return when {
            this == Light || (this == Auto && !isDark) -> Color.White
            else -> Color(0xFF2c2e30)
        }
    }

    private fun tint(isDark: Boolean): Color {
        return when {
            this == Light || (this == Auto && !isDark) -> Color(0xFF424547)
            else -> Color(0xFFd3d7da)
        }
    }

    @Composable
    fun Icon() {
        val name = this.name;
        val darkTheme = isSystemInDarkTheme()
        when (this) {
            Light, Dark -> androidx.compose.material3.Icon(
                painter = painterResource(id = R.drawable.text_theme),
                contentDescription = "Light",
                tint = this.tint(darkTheme),
                modifier = Modifier
                    .background(this.background(darkTheme))
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
    val state = LocalState.current!!
    val darkTheme = isSystemInDarkTheme()
    val systemUiController = rememberSystemUiController()
    val colorScheme = when (state.themeType) {
        ThemeType.Light -> dynamicLightColorScheme(context)
        ThemeType.Dark -> dynamicDarkColorScheme(context)
        ThemeType.Auto -> if (darkTheme) dynamicDarkColorScheme(context) else dynamicLightColorScheme(context)
    }
    systemUiController.setSystemBarsColor(
        color = colorScheme.background
    )
    MaterialTheme(
        colorScheme = colorScheme,
        typography = AppTypography,
        content = content
    )
}

