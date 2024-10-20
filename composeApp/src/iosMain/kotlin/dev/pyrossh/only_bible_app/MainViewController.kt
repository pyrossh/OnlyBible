package dev.pyrossh.only_bible_app

import androidx.compose.ui.window.ComposeUIViewController
import com.russhwolf.settings.NSUserDefaultsSettings

fun MainViewController() = ComposeUIViewController {
    val settings = NSUserDefaultsSettings.Factory().create()
    val model = AppViewModel()
    model.loadData(settings)
    App(model = model)
}