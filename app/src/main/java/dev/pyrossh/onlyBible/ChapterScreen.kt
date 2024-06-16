package dev.pyrossh.onlyBible

import Verse
import android.annotation.SuppressLint
import android.os.Parcelable
import androidx.compose.animation.AnimatedContentTransitionScope
import androidx.compose.foundation.ExperimentalFoundationApi
import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.gestures.detectHorizontalDragGestures
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.wrapContentSize
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.text.selection.DisableSelection
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.FaceRetouchingNatural
import androidx.compose.material.icons.outlined.MoreVert
import androidx.compose.material.icons.outlined.Share
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableFloatStateOf
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.rememberCoroutineScope
import androidx.compose.runtime.saveable.rememberSaveable
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.input.pointer.pointerInput
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.text.SpanStyle
import androidx.compose.ui.text.TextStyle
import androidx.compose.ui.text.buildAnnotatedString
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.withStyle
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.navigation.NavController
import convertVersesToSpeech
import kotlinx.coroutines.Job
import kotlinx.coroutines.launch
import kotlinx.parcelize.Parcelize
import kotlinx.serialization.Serializable
import shareVerses

@Serializable
@Parcelize
data class ChapterScreenProps(
    val bookIndex: Int,
    val chapterIndex: Int,
    // TODO: fix this
    val dir: String = Dir.Left.name,
) : Parcelable

@Parcelize
enum class Dir : Parcelable {
    Left, Right;

    fun slideDirection(): AnimatedContentTransitionScope.SlideDirection {
        return when (this) {
            Left -> AnimatedContentTransitionScope.SlideDirection.Left
            Right -> AnimatedContentTransitionScope.SlideDirection.Right
        }
    }
}


@OptIn(ExperimentalFoundationApi::class)
@SuppressLint("MutableCollectionMutableState")
@Composable
fun ChapterScreen(
    verses: List<Verse>,
    bookIndex: Int,
    chapterIndex: Int,
    navController: NavController,
    openDrawer: (MenuType, Int) -> Job,
) {
    val context = LocalContext.current
    val state = LocalState.current!!
    val fontFamily = state.fontType.family()
    val boldWeight = if (state.boldEnabled) FontWeight.W700 else FontWeight.W400
    val scope = rememberCoroutineScope()
    var selectedVerses by rememberSaveable {
        mutableStateOf(listOf<Verse>())
    }
    var dragAmount by remember {
        mutableFloatStateOf(0.0f)
    }
    val chapterVerses =
        verses.filter { it.bookIndex == bookIndex && it.chapterIndex == chapterIndex }
    Scaffold(
        modifier = Modifier.fillMaxSize(),
    ) { innerPadding ->
        LazyColumn(
            verticalArrangement = Arrangement.spacedBy(12.dp),
            modifier = Modifier
                .fillMaxSize()
                .padding(innerPadding)
                .padding(horizontal = 16.dp)
                .pointerInput(Unit) {
                    detectHorizontalDragGestures(onDragEnd = {
//                            println("END " + dragAmount);
                        if (dragAmount < 0) {
                            val pair = Verse.getForwardPair(bookIndex, chapterIndex)
                            navController.navigate(
                                ChapterScreenProps(
                                    bookIndex = pair.first,
                                    chapterIndex = pair.second,
                                )
                            )
                        } else if (dragAmount > 0) {
                            val pair = Verse.getBackwardPair(bookIndex, chapterIndex)
                            if (navController.previousBackStackEntry != null) {
                                val previousBook =
                                    navController.previousBackStackEntry?.arguments?.getInt("book")
                                        ?: 0
                                val previousChapter =
                                    navController.previousBackStackEntry?.arguments?.getInt("chapter")
                                        ?: 0
//                                    println("currentBackStackEntry ${previousBook} ${previousChapter} || ${pair.first} ${pair.second}")
                                if (previousBook == pair.first && previousChapter == pair.second) {
                                    println("Popped")
                                    navController.popBackStack()
                                } else {
                                    navController.navigate(
                                        ChapterScreenProps(
                                            bookIndex = pair.first,
                                            chapterIndex = pair.second,
                                            dir = Dir.Right.name,
                                        )
                                    )
                                }
                            } else {
//                                    println("navigated navigate")
                                navController.navigate(
                                    ChapterScreenProps(
                                        bookIndex = pair.first,
                                        chapterIndex = pair.second,
                                        dir = Dir.Right.name
                                    )
                                )
                            }
                        }
                    }, onHorizontalDrag = { change, da ->
                        dragAmount = da
                        change.consume()
                    })
                }) {
            stickyHeader {
                Row(
                    modifier = Modifier
                        .fillMaxWidth()
                        .background(Color.White),
                    horizontalArrangement = Arrangement.Start,
                    verticalAlignment = Alignment.CenterVertically,
                ) {
                    Row(
                        horizontalArrangement = Arrangement.Start,
                    ) {
                        Surface(onClick = { openDrawer(MenuType.Book, bookIndex) }) {
                            Text(
                                Verse.bookNames[bookIndex], style = TextStyle(
                                    fontSize = 22.sp,
                                    fontWeight = FontWeight.W500,
                                    color = Color.Black,
                                )
                            )

                        }
                        Surface(onClick = { openDrawer(MenuType.Chapter, bookIndex) }) {
                            Text(
                                "${chapterIndex + 1}", style = TextStyle(
                                    fontSize = 22.sp,
                                    fontWeight = FontWeight.W500,
                                    color = Color.Black,
                                )
                            )
                        }
                    }
                    Row(
                        modifier = Modifier.fillMaxWidth(),
                        horizontalArrangement = Arrangement.End,
                    ) {
                        if (selectedVerses.isNotEmpty()) {
                            IconButton(onClick = {
                                scope.launch {
                                    convertVersesToSpeech(scope,
                                        selectedVerses.sortedBy { it.verseIndex })
                                }.invokeOnCompletion {
                                    selectedVerses = listOf()
                                }
                            }) {
                                Icon(Icons.Filled.FaceRetouchingNatural, "Share")
                            }
                            IconButton(onClick = {
                                shareVerses(context, selectedVerses)
                                selectedVerses = listOf()
                            }) {
                                Icon(Icons.Outlined.Share, "Share")
                            }
                        }
                        Box(modifier = Modifier.wrapContentSize(Alignment.TopEnd)) {
                            IconButton(onClick = {
                                state.showSheet()
                            }) {
                                Icon(Icons.Outlined.MoreVert, "More")
                            }
                        }
                    }
                }
            }
            items(chapterVerses) { v ->
                if (v.heading.isNotEmpty()) {
                    DisableSelection {
                        Text(
                            modifier = Modifier.padding(
                                top = if (v.verseIndex != 0) 12.dp else 0.dp, bottom = 12.dp
                            ),
                            style = TextStyle(
                                fontFamily = fontFamily,
                                fontSize = (16 + state.fontSizeDelta).sp,
                                fontWeight = FontWeight.W700,
                                color = Color.Black,
                            ),
                            text = v.heading.replace("<br>", "\n\n"),
                        )
                    }
                }
                val isSelected = selectedVerses.contains(v);
                val background =
                    if (isSelected) Color(0xFFEEEEEE) else MaterialTheme.colorScheme.background
                Text(modifier = Modifier
                    .clickable {
                        selectedVerses = if (selectedVerses.contains(v)) {
                            selectedVerses - v
                        } else {
                            selectedVerses + v
                        }
                    },
                    style = TextStyle(
                        background = background,
                        fontFamily = fontFamily,
                        color = Color.Black,
                        fontWeight = boldWeight,
                        fontSize = (16 + state.fontSizeDelta).sp,
                        lineHeight = (22 + state.fontSizeDelta).sp,
                        letterSpacing = 0.sp,
                    ),
                    text = buildAnnotatedString {
                        withStyle(
                            style = SpanStyle(
                                fontSize = (13 + state.fontSizeDelta).sp,
                                color = Color(0xFF9A1111),
                                fontWeight = FontWeight.W700,
                            )
                        ) {
                            append("${v.verseIndex + 1} ")
                        }
                        append(v.text)
                    })
            }
        }
    }
}