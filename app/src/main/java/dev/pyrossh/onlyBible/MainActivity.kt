package dev.pyrossh.onlyBible

import Verse
import android.content.Context
import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.activity.enableEdgeToEdge
import androidx.compose.runtime.CompositionLocalProvider
import dev.pyrossh.onlyBible.ui.theme.BibleAppTheme

class MainActivity : ComponentActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        enableEdgeToEdge()
        val prefs = applicationContext.getSharedPreferences("settings", Context.MODE_PRIVATE)
        val verses = Verse.parseFromBibleTxt("English", assets.open("English.txt").bufferedReader())
        val state = State(prefs)
        setContent {
            BibleAppTheme {
                CompositionLocalProvider(LocalState provides state) {
                    AppHost(
                        verses = verses
                    )
                    if (state.showBottomSheet) {
                        TextSettingsBottomSheet()
                    }
                }
            }
        }
    }
}

