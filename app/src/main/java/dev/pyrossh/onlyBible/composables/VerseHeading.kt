package dev.pyrossh.onlyBible.composables

import android.view.SoundEffectConstants
import androidx.compose.foundation.layout.padding
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.platform.LocalView
import androidx.compose.ui.text.AnnotatedString
import androidx.compose.ui.text.LinkAnnotation
import androidx.compose.ui.text.SpanStyle
import androidx.compose.ui.text.TextLinkStyles
import androidx.compose.ui.text.TextStyle
import androidx.compose.ui.text.font.FontStyle
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.fromHtml
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import dev.pyrossh.onlyBible.ChapterScreenProps
import dev.pyrossh.onlyBible.FontType

@Composable
fun VerseHeading(
    text: String,
    fontType: FontType,
    fontSizeDelta: Int,
    navigateToChapter: (ChapterScreenProps) -> Unit
) {
    val view = LocalView.current
    Text(
        modifier = Modifier.padding(bottom = 12.dp),
        style = TextStyle(
            fontFamily = fontType.family(),
            fontSize = (16 + fontSizeDelta).sp,
            fontWeight = FontWeight.W700,
            color = MaterialTheme.colorScheme.onSurface,
        ),
        text = AnnotatedString.fromHtml(
            htmlString = text,
            linkStyles = TextLinkStyles(
                style = SpanStyle(
                    fontSize = (14 + fontSizeDelta).sp,
                    fontStyle = FontStyle.Italic,
                    color = Color(0xFF008AE6),
                )
            ),
            linkInteractionListener = {
                view.playSoundEffect(SoundEffectConstants.CLICK)
                val url = (it as LinkAnnotation.Url).url
                val parts = url.split(":")
                navigateToChapter(
                    ChapterScreenProps(
                        bookIndex = parts[0].toInt(),
                        chapterIndex = parts[1].toInt(),
                    )
                )
            },
        ),
    )
}