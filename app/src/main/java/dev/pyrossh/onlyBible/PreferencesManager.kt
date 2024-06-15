import android.content.Context
import android.content.SharedPreferences

enum class FontType {
    Sans,
    Serif,
    Mono
}

class PreferencesManager(context: Context) {
    private val sharedPreferences: SharedPreferences =
        context.getSharedPreferences("settings", Context.MODE_PRIVATE)

    fun getFontSize(): Int {
        return sharedPreferences.getInt("fontSizeDelta", 0)
    }

    fun setFontSize(v: Int) {
        val editor = sharedPreferences.edit()
        editor.putInt("fontSizeDelta", v)
        editor.apply()
    }

    fun getBold(): Boolean {
        return sharedPreferences.getBoolean("bold", false)
    }

    fun setBold(v: Boolean) {
        val editor = sharedPreferences.edit()
        editor.putBoolean("bold", v)
        editor.apply()
    }

    fun getFontType(): FontType {
        val ft = sharedPreferences.getString("fontType", FontType.Sans.name) ?: FontType.Sans.name
        return FontType.valueOf(ft)
    }

    fun setFontType(v: FontType) {
        val editor = sharedPreferences.edit()
        editor.putString("fontType", v.name)
        editor.apply()
    }
}