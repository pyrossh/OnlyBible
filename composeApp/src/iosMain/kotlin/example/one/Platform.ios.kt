package example.one

import androidx.compose.runtime.Composable
import androidx.compose.ui.ExperimentalComposeUiApi
import androidx.compose.ui.platform.LocalWindowInfo
import androidx.compose.ui.unit.Dp
import androidx.compose.ui.unit.dp
import example.one.domain.Verse
import platform.UIKit.UIScreen
//import platform.AVKit.Audio

@OptIn(ExperimentalComposeUiApi::class)
@Composable
actual fun getScreenWidth(): Dp = LocalWindowInfo.current.containerSize.width.pxToPoint().dp

@OptIn(ExperimentalComposeUiApi::class)
@Composable
actual fun getScreenHeight(): Dp = LocalWindowInfo.current.containerSize.height.pxToPoint().dp

fun Int.pxToPoint(): Double = this.toDouble() / UIScreen.mainScreen.scale

@OptIn(ExperimentalComposeUiApi::class)
@Composable
actual fun playClickSound() {
//    AudioServicesPlayAlertSound(SystemSoundID(1322))
}

actual fun shareVerses(verses: List<Verse>) {
}