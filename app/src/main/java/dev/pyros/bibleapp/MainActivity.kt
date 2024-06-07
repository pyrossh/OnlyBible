package dev.pyros.bibleapp

import Verse
import android.os.Bundle
import android.util.Log
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.activity.enableEdgeToEdge
import dev.pyros.bibleapp.ui.theme.BibleAppTheme

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

