package dev.pyrossh.onlyBible

import android.content.SharedPreferences
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableIntStateOf
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.setValue
import androidx.compose.runtime.staticCompositionLocalOf
import androidx.compose.ui.text.font.FontFamily
import androidx.compose.ui.text.font.GenericFontFamily
import androidx.lifecycle.ViewModel

val LocalState = staticCompositionLocalOf<State?> { null }

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

class State(p: SharedPreferences) : ViewModel() {
    private val prefs: SharedPreferences = p
    var showBottomSheet by mutableStateOf(false)
    var fontType by mutableStateOf(
        FontType.valueOf(
            prefs.getString("fontType", FontType.Sans.name) ?: FontType.Sans.name
        )
    )
    var fontSizeDelta by mutableIntStateOf(prefs.getInt("fontSizeDelta", 0))
    var boldEnabled by mutableStateOf(prefs.getBoolean("bold", false))

    fun getBookIndex(): Int {
        return prefs.getInt("bookIndex", 0)
    }

    fun setBookIndex(v: Int) {
        val editor = prefs.edit()
        editor.putInt("bookIndex", v)
        editor.apply()
    }

    fun getChapterIndex(): Int {
        return prefs.getInt("chapterIndex", 0)
    }

    fun setChapterIndex(v: Int) {
        val editor = prefs.edit()
        editor.putInt("chapterIndex", v)
        editor.apply()
    }

    fun showSheet() {
        showBottomSheet = true
    }

    fun closeSheet() {
        showBottomSheet = false
    }

    fun updateFontSize(v: Int) {
        fontSizeDelta = v
        val editor = prefs.edit()
        editor.putInt("fontSizeDelta", v)
        editor.apply()
    }

    fun updateBoldEnabled(v: Boolean) {
        boldEnabled = v
        val editor = prefs.edit()
        editor.putBoolean("bold", v)
        editor.apply()
    }

    fun updateFontType(v: FontType) {
        fontType = v
        val editor = prefs.edit()
        editor.putString("fontType", v.name)
        editor.apply()
    }

}