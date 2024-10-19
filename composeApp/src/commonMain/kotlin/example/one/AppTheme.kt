package example.one
import androidx.compose.foundation.isSystemInDarkTheme
import androidx.compose.material3.MaterialTheme
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.font.FontFamily
import androidx.compose.ui.text.font.GenericFontFamily
import theme.darkScheme
import theme.lightScheme

enum class ThemeType {
    Light,
    Dark,
    Auto;
}

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

fun isLightTheme(themeType: ThemeType, isSystemDark: Boolean): Boolean {
    return themeType == ThemeType.Light || (themeType == ThemeType.Auto && !isSystemDark)
}

@Composable
fun AppTheme(
    themeType: ThemeType,
    content: @Composable () -> Unit
) {
//    val context = LocalContext.current as ComponentActivity
    val isLight = isLightTheme(themeType, isSystemInDarkTheme())
    val colorScheme = if (isLight) lightScheme else darkScheme
    LaunchedEffect(key1 = themeType) {
//        context.enableEdgeToEdge(
//            statusBarStyle = if (isLight) {
//                SystemBarStyle.light(
//                    colorScheme.background.toArgb(),
//                    colorScheme.onBackground.toArgb()
//                )
//            } else {
//                SystemBarStyle.dark(
//                    colorScheme.background.toArgb(),
//                )
//            },
//            navigationBarStyle = if (isLight) {
//                SystemBarStyle.light(
//                    colorScheme.background.toArgb(),
//                    colorScheme.onBackground.toArgb()
//                )
//            } else {
//                SystemBarStyle.dark(
//                    colorScheme.background.toArgb(),
//                )
//            }
//        )
    }
    MaterialTheme(
        colorScheme = colorScheme,
        content = content
    )
}

