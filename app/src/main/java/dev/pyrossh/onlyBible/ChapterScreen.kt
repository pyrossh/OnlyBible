package dev.pyrossh.onlyBible

import Verse
import android.annotation.SuppressLint
import androidx.compose.foundation.gestures.detectHorizontalDragGestures
import androidx.compose.foundation.gestures.detectTapGestures
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.outlined.MoreVert
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
import androidx.compose.ui.geometry.Rect
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.input.pointer.pointerInput
import androidx.compose.ui.layout.boundsInWindow
import androidx.compose.ui.layout.onGloballyPositioned
import androidx.compose.ui.text.SpanStyle
import androidx.compose.ui.text.TextStyle
import androidx.compose.ui.text.buildAnnotatedString
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.withStyle
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.navigation.NavController
import convertVersesToSpeech
import fontFamily
import kotlinx.coroutines.Job
import kotlinx.coroutines.launch
import kotlinx.serialization.Serializable

// TODO: once androidx.navigation 2.8.0 is released
@Serializable
data class ChapterScreenProps(
    val bookIndex: Int,
    val chapterIndex: Int,
)

@SuppressLint("MutableCollectionMutableState")
@Composable
fun ChapterScreen(
    verses: List<Verse>,
    bookIndex: Int,
    chapterIndex: Int,
    navController: NavController,
    openDrawer: (MenuType, Int) -> Job,
) {
    val scope = rememberCoroutineScope()
    var selectedVerseBounds: Rect by remember { mutableStateOf(Rect.Zero) }
    var selectedVerses by rememberSaveable {
        mutableStateOf(listOf<Verse>())
    }
    var dragAmount by remember {
        mutableFloatStateOf(0.0f)
    }
    val chapterVerses =
        verses.filter { it.bookIndex == bookIndex && it.chapterIndex == chapterIndex };
    Scaffold(
        modifier = Modifier.fillMaxSize(),
    ) { innerPadding ->
//        if (selectedVerses.isNotEmpty()) {
//            Box(
//                Modifier
//                    .zIndex(99f)
//                    .offset {
//                        IntOffset(
//                            selectedVerseBounds.centerLeft.x.toInt() + 400,
//                            selectedVerseBounds.centerLeft.y.toInt() + 300,
//                        )
//                    }
//            ) {
//                Surface(
//                    modifier = Modifier
//                        .width(200.dp)
//                        .height(60.dp)
//                        .border(
//                            1.dp,
//                            Color.Black,
//                            RoundedCornerShape(0, 0, 0, 0),
//                        ),
//                ) {
//                    Text(
//                        modifier = Modifier
//                            .fillMaxWidth(),
//                        textAlign = TextAlign.Center,
//                        text = "Bottom app bar",
//                    )
//                }
//            }
//        }
        Column(
            modifier = Modifier
                .fillMaxSize()
                .padding(innerPadding)
                .padding(horizontal = 16.dp)
                .verticalScroll(rememberScrollState())
                .pointerInput(Unit) {
                    detectHorizontalDragGestures(
                        onDragEnd = {
//                            println("END " + dragAmount);
                            if (dragAmount < 0) {
                                val pair = Verse.getForwardPair(bookIndex, chapterIndex)
                                navController.navigate(route = "/books/${pair.first}/chapters/${pair.second}?dir=left")
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
                                            route = "/books/${pair.first}/chapters/${pair.second}?dir=right",
                                        )
                                    }
                                } else {
//                                    println("navigated navigate")
                                    navController.navigate(
                                        route = "/books/${pair.first}/chapters/${pair.second}?dir=right",
                                    )
                                }
                            }
                        },
                        onHorizontalDrag = { change, da ->
                            dragAmount = da
                            change.consume()
                        }
                    )
                }
        ) {
            Row(
                modifier = Modifier.fillMaxWidth(),
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
                    IconButton(onClick = {
                        scope.launch {
                            convertVersesToSpeech(scope, selectedVerses.sortedBy { it.verseIndex })
                        }
                    }) {
                        Icon(Icons.Outlined.MoreVert, "Close")
                    }
                }
            }
            chapterVerses.map { v ->
                val isSelected = selectedVerses.contains(v);
                val background =
                    if (isSelected) Color(0xFFEEEEEE) else MaterialTheme.colorScheme.background
                if (v.heading.isNotEmpty()) {
                    Text(
                        modifier = Modifier.padding(
                            top = if (v.verseIndex != 0) 12.dp else 0.dp,
                            bottom = 12.dp
                        ),
                        style = TextStyle(
                            fontFamily = fontFamily,
                            fontSize = 16.sp,
                            fontWeight = FontWeight.W700,
                            color = Color.Black,
                        ),
                        text = v.heading.replace("<br>", "\n\n"),
                    )
                }
                Text(
                    modifier = Modifier
                        .padding(bottom = 16.dp)
                        .onGloballyPositioned { coordinates ->
                            val boundsInWindow = coordinates.boundsInWindow()
                            selectedVerseBounds = coordinates.boundsInWindow()
//                            println("boundsInWindow blx:" + boundsInWindow.bottomLeft.x.dp)
//                            println("boundsInWindow bly:" + boundsInWindow.bottomLeft.y.dp)
//                            println("boundsInWindow brx:"+boundsInWindow.bottomRight.x)
//                            println("boundsInWindow bry:"+boundsInWindow.bottomRight.y)
                        }
                        .pointerInput(Unit) {
                            detectTapGestures(
                                onTap = {
                                    selectedVerses = if (selectedVerses.contains(v)) {
                                        selectedVerses - v
                                    } else {
                                        selectedVerses + v
                                    }
                                }
                            )
                        },
                    style = TextStyle(
                        background = background,
                        fontFamily = fontFamily,
                        color = Color.Black,
                        fontWeight = FontWeight.W400,
                        fontSize = 16.sp,
                        lineHeight = 22.sp,
                        letterSpacing = 0.sp,
                    ),
                    text = buildAnnotatedString {
                        withStyle(
                            style = SpanStyle(
                                fontSize = 13.sp,
                                color = Color(0xFF9A1111),
                                fontWeight = FontWeight.W700,
                            )
                        ) {
                            append("${v.verseIndex + 1} ")
                        }
                        append(v.text)
                    }
                )
            }
        }
    }
}