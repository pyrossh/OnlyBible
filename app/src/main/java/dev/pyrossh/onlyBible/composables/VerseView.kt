package dev.pyrossh.onlyBible.composables

import android.graphics.Typeface
import android.text.Html
import android.text.style.BulletSpan
import android.text.style.ForegroundColorSpan
import android.text.style.StyleSpan
import androidx.compose.foundation.border
import androidx.compose.foundation.clickable
import androidx.compose.foundation.interaction.MutableInteractionSource
import androidx.compose.foundation.isSystemInDarkTheme
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Circle
import androidx.compose.material.icons.outlined.Cancel
import androidx.compose.material.icons.outlined.PauseCircle
import androidx.compose.material.icons.outlined.PlayCircle
import androidx.compose.material.icons.outlined.Share
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableIntStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.rememberCoroutineScope
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.shadow
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.layout.onPlaced
import androidx.compose.ui.layout.positionInRoot
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.text.SpanStyle
import androidx.compose.ui.text.TextStyle
import androidx.compose.ui.text.buildAnnotatedString
import androidx.compose.ui.text.font.FontStyle
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.withStyle
import androidx.compose.ui.unit.IntOffset
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.compose.ui.window.Popup
import dev.pyrossh.onlyBible.AppViewModel
import dev.pyrossh.onlyBible.R
import dev.pyrossh.onlyBible.darkHighlights
import dev.pyrossh.onlyBible.domain.Verse
import dev.pyrossh.onlyBible.isLightTheme
import dev.pyrossh.onlyBible.lightHighlights
import dev.pyrossh.onlyBible.shareVerses
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch

@Composable
fun VerseView(
    model: AppViewModel,
    verse: Verse,
    selectedVerses: List<Verse>,
    setSelectedVerses: (List<Verse>) -> Unit,
) {
    var barYPosition by remember {
        mutableIntStateOf(0)
    }
    val isLight = isLightTheme(model.uiMode, isSystemInDarkTheme())
    val fontSizeDelta = model.fontSizeDelta
    val boldWeight = if (model.fontBoldEnabled) FontWeight.W700 else FontWeight.W400
    val buttonInteractionSource = remember { MutableInteractionSource() }
    val isSelected = selectedVerses.contains(verse)
    val highlightedColorIndex = model.getHighlightForVerse(verse)
    val currentHighlightColors = if (isLight) lightHighlights else darkHighlights
    Text(
        modifier = Modifier
            .onPlaced {
                barYPosition = it.positionInRoot().y.toInt() + it.size.height
            }
            .clickable(
                interactionSource = buttonInteractionSource,
                indication = null
            ) {
                setSelectedVerses(
                    if (selectedVerses.contains(verse)) {
                        selectedVerses - verse
                    } else {
                        selectedVerses + verse
                    }
                )
            },
        style = TextStyle(
            background = if (isSelected)
                MaterialTheme.colorScheme.outline
            else
                if (highlightedColorIndex != null && isLight)
                    currentHighlightColors[highlightedColorIndex]
                else
                    Color.Unspecified,
            fontFamily = model.fontType.family(),
            color = if (isLight)
                Color(0xFF000104)
            else
                if (highlightedColorIndex != null)
                    currentHighlightColors[highlightedColorIndex]
                else
                    Color(0xFFBCBCBC),
            fontWeight = boldWeight,
            fontSize = (17 + fontSizeDelta).sp,
            lineHeight = (23 + fontSizeDelta).sp,
            letterSpacing = 0.sp,
        ),
        text = buildAnnotatedString {
            val spanned = Html.fromHtml(verse.text, Html.FROM_HTML_MODE_COMPACT)
            val spans = spanned.getSpans(0, spanned.length, Any::class.java)
            val verseNo = "${verse.verseIndex + 1} "
            withStyle(
                style = SpanStyle(
                    fontSize = (13 + fontSizeDelta).sp,
                    color = if (isLight)
                        Color(0xFFA20101)
                    else
                        Color(0xFFCCCCCC),
                    fontWeight = FontWeight.W700,
                )
            ) {
                append(verseNo)
            }
            append(spanned.toString())
            spans
                .filter { it !is BulletSpan }
                .forEach { span ->
                    val start = spanned.getSpanStart(span)
                    val end = spanned.getSpanEnd(span)
                    when (span) {
                        is ForegroundColorSpan ->
                            if (isLight) SpanStyle(color = Color(0xFFFF0000))
                            else SpanStyle(color = Color(0xFFFF636B))

                        is StyleSpan -> when (span.style) {
                            Typeface.BOLD -> SpanStyle(fontWeight = FontWeight.Bold)
                            Typeface.ITALIC -> SpanStyle(fontStyle = FontStyle.Italic)
                            Typeface.BOLD_ITALIC -> SpanStyle(
                                fontWeight = FontWeight.Bold,
                                fontStyle = FontStyle.Italic,
                            )

                            else -> null
                        }

                        else -> {
                            null
                        }
                    }?.let { spanStyle ->
                        addStyle(
                            spanStyle,
                            start + verseNo.length - 1,
                            end + verseNo.length
                        )
                    }
                }
        }
    )
    if (isSelected && selectedVerses.last() == verse) {
        Menu(barYPosition, model, selectedVerses, setSelectedVerses)
    }
}

@Composable
private fun Menu(
    barYPosition: Int,
    model: AppViewModel,
    selectedVerses: List<Verse>,
    setSelectedVerses: (List<Verse>) -> Unit,
) {
    val context = LocalContext.current
    val scope = rememberCoroutineScope()
    Popup(
        alignment = Alignment.TopCenter,
        offset = IntOffset(0, y = barYPosition),
    ) {
        Surface(
            modifier = Modifier
                .width(300.dp)
                .height(56.dp)
                .border(
                    width = 1.dp,
                    color = MaterialTheme.colorScheme.outline,
                    shape = RoundedCornerShape(4.dp)
                )
                .shadow(
                    elevation = 2.dp,
                    spotColor = MaterialTheme.colorScheme.outline,
                    ambientColor = MaterialTheme.colorScheme.outline,
                    shape = RoundedCornerShape(4.dp)
                ),
        ) {
            Row(
                modifier = Modifier
                    .fillMaxSize()
                    .padding(horizontal = 4.dp),
                horizontalArrangement = Arrangement.SpaceAround,
                verticalAlignment = Alignment.CenterVertically,
            ) {
                IconButton(onClick = {
                    model.removeHighlightedVerses(selectedVerses)
                    setSelectedVerses(listOf())
                }) {
                    Icon(
                        imageVector = Icons.Outlined.Cancel,
                        contentDescription = "Clear",
                    )
                }
                lightHighlights.forEachIndexed { i, tint ->
                    IconButton(onClick = {
                        model.addHighlightedVerses(selectedVerses, i)
                        setSelectedVerses(listOf())
                    }) {
                        Icon(
                            modifier = Modifier
                                .size(20.dp)
                                .border(
                                    width = 1.dp,
                                    color = MaterialTheme.colorScheme.onBackground,
                                    shape = RoundedCornerShape(24.dp)
                                ),
                            imageVector = Icons.Filled.Circle,
                            contentDescription = "highlight",
                            tint = tint,
                        )
                    }
                }
                IconButton(onClick = {
                    if (model.isPlaying) {
                        model.speechService.StopSpeakingAsync()
                    } else {
                        scope.launch(Dispatchers.IO) {
                            for (v in selectedVerses.sortedBy { it.verseIndex }) {
                                model.speechService.StartSpeakingSsml(
                                    v.toSSML(context.getString(R.string.voice)),
                                )
                            }
                        }
                    }
                }) {
                    Icon(
//                            modifier = Modifier.size(36.dp),
                        imageVector = if (model.isPlaying)
                            Icons.Outlined.PauseCircle
                        else
                            Icons.Outlined.PlayCircle,
                        contentDescription = "Audio",
                    )
                }
                IconButton(onClick = {
                    shareVerses(
                        context,
                        selectedVerses.sortedBy { it.verseIndex })
                }) {
                    Icon(
//                            modifier = Modifier.size(32.dp),
                        imageVector = Icons.Outlined.Share,
                        contentDescription = "Share",
                    )
                }
            }
        }
    }
}