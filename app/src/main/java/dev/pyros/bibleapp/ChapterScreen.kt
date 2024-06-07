package dev.pyros.bibleapp

import Verse
import android.annotation.SuppressLint
import androidx.compose.animation.core.tween
import androidx.compose.foundation.ExperimentalFoundationApi
import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.gestures.AnchoredDraggableState
import androidx.compose.foundation.gestures.DraggableAnchors
import androidx.compose.foundation.gestures.detectHorizontalDragGestures
import androidx.compose.foundation.gestures.detectTapGestures
import androidx.compose.foundation.interaction.MutableInteractionSource
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.offset
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.outlined.MoreVert
import androidx.compose.material3.BottomAppBar
import androidx.compose.material3.DropdownMenu
import androidx.compose.material3.DropdownMenuItem
import androidx.compose.material3.ExperimentalMaterial3Api
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
import androidx.compose.runtime.saveable.rememberSaveable
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.geometry.Offset
import androidx.compose.ui.geometry.Rect
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.RectangleShape
import androidx.compose.ui.input.pointer.pointerInput
import androidx.compose.ui.layout.boundsInWindow
import androidx.compose.ui.layout.onGloballyPositioned
import androidx.compose.ui.platform.LocalDensity
import androidx.compose.ui.text.SpanStyle
import androidx.compose.ui.text.TextStyle
import androidx.compose.ui.text.buildAnnotatedString
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.text.withStyle
import androidx.compose.ui.unit.DpOffset
import androidx.compose.ui.unit.IntOffset
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.compose.ui.window.Popup
import androidx.compose.ui.zIndex
import androidx.navigation.NavController
import fontFamily
import kotlinx.coroutines.Job
import kotlinx.serialization.Serializable

enum class DragAnchors {
    Start,
    Center,
    End,
}


// TODO: once androidx.navigation 2.8.0 is released
@Serializable
data class ChapterScreenProps(
    val bookIndex: Int,
    val chapterIndex: Int,
)

@SuppressLint("MutableCollectionMutableState")
@OptIn(ExperimentalFoundationApi::class, ExperimentalMaterial3Api::class)
@Composable
fun ChapterScreen(
    verses: List<Verse>,
    bookIndex: Int,
    chapterIndex: Int,
    navController: NavController,
    openDrawer: (MenuType, Int) -> Job,
) {
    val density = LocalDensity.current
    var selectedVerseBounds: Rect by remember { mutableStateOf(Rect.Zero) }
    var selectedVerses by rememberSaveable {
        mutableStateOf(listOf<Int>())
    }
    var dragAmount by remember {
        mutableFloatStateOf(0.0f)
    }
    val state = remember {
        AnchoredDraggableState(
            initialValue = DragAnchors.Start,
            anchors = DraggableAnchors {
                DragAnchors.Start at 0f
                DragAnchors.End at 1000f
            },
            positionalThreshold = { distance: Float -> distance * 0.5f },
            velocityThreshold = { with(density) { 100.dp.toPx() } },
            animationSpec = tween(),
            confirmValueChange = {
                if (it == DragAnchors.End) {
                    true
                } else {
                    false
                }
            }
        )
    }
    val chapterVerses =
        verses.filter { it.bookIndex == bookIndex && it.chapterIndex == chapterIndex };
    Scaffold(
        modifier = Modifier.fillMaxSize(),
    ) { innerPadding ->
        if (selectedVerses.isNotEmpty()) {
            Box(
                Modifier
                    .zIndex(99f)
                    .offset {
                        IntOffset(
                            selectedVerseBounds.centerLeft.x.toInt() + 400,
                            selectedVerseBounds.centerLeft.y.toInt() + 300,
                        )
                    }
            ) {
                Surface(
                    modifier = Modifier
                        .width(200.dp)
                        .height(60.dp)
                        .border(
                            1.dp,
                            Color.Black,
                            RoundedCornerShape(0, 0, 0, 0),
                        ),
                ) {
                    Text(
                        modifier = Modifier
                            .fillMaxWidth(),
                        textAlign = TextAlign.Center,
                        text = "Bottom app bar",
                    )
                }
            }
        }
        Column(
            modifier = Modifier
                .fillMaxSize()
                .padding(innerPadding)
                .padding(horizontal = 16.dp)
                .verticalScroll(rememberScrollState())
//            .anchoredDraggable(state, Orientation.Horizontal, reverseDirection = true)
                .pointerInput(Unit) {
                    detectHorizontalDragGestures(
                        onDragEnd = {
//                            println("END " + dragAmount);
                            if (dragAmount < 0) {
                                val pair = Verse.getForwardPair(bookIndex, chapterIndex)
                                navController.navigate(route = "/books/${pair.first}/chapters/${pair.second}")
                            } else if (dragAmount > 0) {
                                val pair = Verse.getBackwardPair(bookIndex, chapterIndex)
                                val previousBook =
                                    navController.currentBackStackEntry?.arguments?.getInt("book")
                                        ?: 0
                                val previousChapter =
                                    navController.currentBackStackEntry?.arguments?.getInt("chapter")
                                        ?: 0
                                if (previousBook == pair.first && previousChapter == pair.second) {
                                    navController.popBackStack(
                                        route = "/books/${pair.first}/chapters/${pair.second}",
                                        inclusive = false
                                    )
                                } else {
                                    navController.popBackStack()
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
                    IconButton(onClick = { }) {
                        Icon(Icons.Outlined.MoreVert, "Close")
                    }
                }
            }
            chapterVerses.map { v ->
                val isSelected = selectedVerses.contains(v.verseIndex);
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
                        .padding(bottom = 10.dp)
                        .onGloballyPositioned { coordinates ->
                            val boundsInWindow = coordinates.boundsInWindow()
                            selectedVerseBounds = coordinates.boundsInWindow()
                            println("boundsInWindow blx:" + boundsInWindow.bottomLeft.x.dp)
                            println("boundsInWindow bly:" + boundsInWindow.bottomLeft.y.dp)
//                            println("boundsInWindow brx:"+boundsInWindow.bottomRight.x)
//                            println("boundsInWindow bry:"+boundsInWindow.bottomRight.y)
                        }
                        .pointerInput(Unit) {
                            detectTapGestures(
                                onTap = {
                                    selectedVerses = if (selectedVerses.contains(v.verseIndex)) {
                                        selectedVerses - v.verseIndex
                                    } else {
                                        selectedVerses + v.verseIndex
                                    }
                                }
                            )
                        },
                    text = buildAnnotatedString {
                        withStyle(
                            style = SpanStyle(
                                background = background,
                                fontFamily = fontFamily,
                                fontSize = 14.sp,
                                color = Color(0xFF9A1111),
//                                    fontSize = if (it.verseIndex == 0) 24.sp else 14.sp,
                                fontWeight = FontWeight.W600,
//                                    color = if (it.verseIndex == 0) Color.Black else Color(0xFF9A1111),
                            )
                        ) {
                            append("${v.verseIndex + 1} ")
//                                append(if (it.verseIndex == 0) "${chapterIndex + 1} " else "${it.verseIndex + 1} ")
                        }
                        withStyle(
                            style = SpanStyle(
                                background = background,
                                fontFamily = fontFamily,
//                                    fontFamily = FontFamily.Serif,
                                fontSize = 16.sp,
                                fontWeight = FontWeight.Normal,
                                color = Color.Black,
                            )
                        ) {
                            append(v.text)
                        }
                    }
                )
            }
        }
    }
}