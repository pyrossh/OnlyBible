package dev.pyrossh.onlyBible.composables

import android.view.SoundEffectConstants
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
import androidx.compose.material.icons.automirrored.outlined.OpenInNew
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
import androidx.compose.runtime.collectAsState
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
import androidx.compose.ui.platform.LocalView
import androidx.compose.ui.text.AnnotatedString
import androidx.compose.ui.text.LinkAnnotation
import androidx.compose.ui.text.SpanStyle
import androidx.compose.ui.text.TextLinkStyles
import androidx.compose.ui.text.TextStyle
import androidx.compose.ui.text.buildAnnotatedString
import androidx.compose.ui.text.font.FontStyle
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.fromHtml
import androidx.compose.ui.text.withStyle
import androidx.compose.ui.unit.IntOffset
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.compose.ui.window.Popup
import dev.pyrossh.onlyBible.AppViewModel
import dev.pyrossh.onlyBible.ChapterScreenProps
import dev.pyrossh.onlyBible.FontType
import dev.pyrossh.onlyBible.darkHighlights
import dev.pyrossh.onlyBible.domain.Verse
import dev.pyrossh.onlyBible.isLightTheme
import dev.pyrossh.onlyBible.lightHighlights
import dev.pyrossh.onlyBible.shareVerses
import dev.pyrossh.onlyBible.utils.LocalNavController
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch

@Composable
fun VerseText(
    model: AppViewModel,
    fontType: FontType,
    fontSizeDelta: Int,
    fontBoldEnabled: Boolean,
    verse: Verse,
    highlightWord: String?,
) {
    var barYPosition by remember {
        mutableIntStateOf(0)
    }
    val selectedVerses by model.selectedVerses.collectAsState()
    val isLight = isLightTheme(model.themeType, isSystemInDarkTheme())
    val buttonInteractionSource = remember { MutableInteractionSource() }
    val isSelected = selectedVerses.contains(verse)
    val highlightedColorIndex = model.getHighlightForVerse(verse)
    val currentHighlightColors = if (isLight) lightHighlights else darkHighlights
    val currentHighlightWordKey = if (isLight) "background" else "color"
    val text = if (highlightWord != null)
        verse.text.replace(
            highlightWord,
            "<span style=\"${currentHighlightWordKey}: yellow;\">${highlightWord}</span>",
            true
        )
    else
        verse.text
    Text(
        modifier = Modifier
            .onPlaced {
                barYPosition = it.positionInRoot().y.toInt() + it.size.height
            }
            .clickable(
                interactionSource = buttonInteractionSource,
                indication = null
            ) {
                model.setSelectedVerses(
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
            fontFamily = fontType.family(),
            color = if (isLight)
                Color(0xFF000104)
            else
                if (highlightedColorIndex != null)
                    currentHighlightColors[highlightedColorIndex]
                else
                    Color(0xFFBCBCBC),
            fontWeight = if (fontBoldEnabled)
                FontWeight.W700
            else
                FontWeight.W400,
            fontSize = (17 + fontSizeDelta).sp,
            lineHeight = (23 + fontSizeDelta).sp,
            letterSpacing = 0.sp,
        ),
        text = buildAnnotatedString {
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
                append("${verse.verseIndex + 1} ")
            }
            append(
                AnnotatedString.Companion.fromHtml(
                    htmlString = text,
                    linkStyles = TextLinkStyles(
                        style = SpanStyle(
                            fontSize = (14 + model.fontSizeDelta).sp,
                            fontStyle = FontStyle.Italic,
                            color = Color(0xFF008AE6),
                        )
                    ),
                    linkInteractionListener = {
                        println("SOUTT ${(it as LinkAnnotation.Url).url}")
                    },
                )
            )
        }
    )
    if (isSelected && selectedVerses.last() == verse) {
        Menu(
            model = model,
            barYPosition = barYPosition,
            verse = verse,
            highlightWord = highlightWord,
        )
    }
}

@Composable
private fun Menu(
    model: AppViewModel,
    barYPosition: Int,
    verse: Verse,
    highlightWord: String?,
) {
    val view = LocalView.current
    val context = LocalContext.current
    val navController = LocalNavController.current
    val scope = rememberCoroutineScope()
    val selectedVerses by model.selectedVerses.collectAsState()
    Popup(
        alignment = Alignment.TopCenter,
        offset = IntOffset(0, y = barYPosition),
    ) {
        Surface(
            modifier = Modifier
                .width(360.dp)
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
                    view.playSoundEffect(SoundEffectConstants.CLICK)
                    model.removeHighlightedVerses(selectedVerses)
                    model.setSelectedVerses(listOf())
                }) {
                    Icon(
                        imageVector = Icons.Outlined.Cancel,
                        contentDescription = "Clear",
                    )
                }
                lightHighlights.forEachIndexed { i, tint ->
                    IconButton(onClick = {
                        view.playSoundEffect(SoundEffectConstants.CLICK)
                        model.addHighlightedVerses(selectedVerses, i)
                        model.setSelectedVerses(listOf())
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
                    view.playSoundEffect(SoundEffectConstants.CLICK)
                    if (model.isAudioPlaying) {
                        model.speechService.StopSpeakingAsync()
                    } else {
                        scope.launch(Dispatchers.IO) {
                            for (v in selectedVerses.sortedBy { it.verseIndex }) {
                                model.playAudio(v.text)
                            }
                        }
                    }
                }) {
                    Icon(
//                            modifier = Modifier.size(36.dp),
                        imageVector = if (model.isAudioPlaying)
                            Icons.Outlined.PauseCircle
                        else
                            Icons.Outlined.PlayCircle,
                        contentDescription = "Audio",
                    )
                }
                IconButton(onClick = {
                    view.playSoundEffect(SoundEffectConstants.CLICK)
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
                if (highlightWord != null) {
                    IconButton(onClick = {
                        view.playSoundEffect(SoundEffectConstants.CLICK)
                        navController.navigate(
                            ChapterScreenProps(
                                bookIndex = verse.bookIndex,
                                chapterIndex = verse.chapterIndex,
                                verseIndex = verse.verseIndex,
                            )
                        )
                    }) {
                        Icon(
//                            modifier = Modifier.size(32.dp),
                            imageVector = Icons.AutoMirrored.Outlined.OpenInNew,
                            contentDescription = "Goto",
                        )
                    }
                }
            }
        }
    }
}