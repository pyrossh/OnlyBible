package dev.pyrossh.onlyBible

import Verse
import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.activity.enableEdgeToEdge
import dev.pyrossh.onlyBible.ui.theme.BibleAppTheme

class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        enableEdgeToEdge()
        val verses = Verse.parseFromBibleTxt("English", assets.open("English.txt").bufferedReader())
        setContent {
            BibleAppTheme {
                AppHost(verses = verses)
            }
        }
    }
}

