package dev.pyrossh.onlyBible

import androidx.compose.foundation.isSystemInDarkTheme
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.setValue
import dev.burnoo.compose.rememberpreference.rememberStringPreference

@Composable
fun isDarkMode(): Boolean {
    val (themeType) = rememberThemeType()
    return themeType == ThemeType.Dark || (themeType == ThemeType.Auto && isSystemInDarkTheme())
}

@Composable
fun rememberThemeType(): Pair<ThemeType, (ThemeType) -> Unit> {
    var data by rememberStringPreference(keyName = "themeType", initialValue = ThemeType.Auto.name, defaultValue = ThemeType.Auto.name)
    return Pair(ThemeType.valueOf(data)) { data = it.name }
}

@Composable
fun rememberFontType(): Pair<FontType, (FontType) -> Unit> {
    var data by rememberStringPreference(keyName = "fontType", initialValue = FontType.Sans.name, defaultValue = FontType.Sans.name)
    return Pair(FontType.valueOf(data)) { data = it.name }
}