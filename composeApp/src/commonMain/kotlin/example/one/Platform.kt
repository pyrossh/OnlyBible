package example.one

import androidx.compose.runtime.Composable
import androidx.compose.ui.unit.Dp
import example.one.domain.Verse


@Composable
expect fun getScreenWidth(): Dp

@Composable
expect fun getScreenHeight(): Dp

@Composable
expect fun playClickSound()

expect fun shareVerses(verses: List<Verse>)

expect object SpeechService {
    fun init(onStarted: () -> Unit, onEnded: () -> Unit)
    fun dispose(onStarted: () -> Unit, onEnded: () -> Unit)
    fun startTextToSpeech(voiceName: String, text: String)
    fun stopTextToSpeech()
}