package dev.pyrossh.onlyBible

import Verse
import android.annotation.SuppressLint
import android.content.Context
import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.activity.enableEdgeToEdge
import androidx.compose.runtime.CompositionLocalProvider
import dev.pyrossh.onlyBible.ui.theme.AppTheme

class MainActivity : ComponentActivity() {

    @SuppressLint("UnsafeIntentLaunch")
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        enableEdgeToEdge()
        val prefs = applicationContext.getSharedPreferences("settings", Context.MODE_PRIVATE)
        val bibles =
            assets.list("bibles")?.map { it.replace("bibles/", "").replace(".txt", "") } ?: listOf()
        val reload = {
            recreate()
//            finish();
//            overrideActivityTransition(0, 0, 0);
//            startActivity(intent);
//            overrideActivityTransition(0, 0, 0);
//            finish();
//            startActivity(intent);
        }
        val state = State(prefs, bibles, reload)
        val bibleName = state.getBibleName()
        val fileName = bibles.find { it.contains(bibleName) } ?: "English"
        val verses = Verse.parseFromBibleTxt(
            bibleName,
            assets.open("bibles/${fileName}.txt").bufferedReader()
        )

        setContent {
            AppTheme {
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

