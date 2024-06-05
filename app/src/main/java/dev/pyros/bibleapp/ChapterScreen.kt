package dev.pyros.bibleapp

import androidx.compose.animation.core.tween
import androidx.compose.foundation.ExperimentalFoundationApi
import androidx.compose.foundation.border
import androidx.compose.foundation.gestures.AnchoredDraggableState
import androidx.compose.foundation.gestures.DraggableAnchors
import androidx.compose.foundation.gestures.detectHorizontalDragGestures
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.WindowInsets
import androidx.compose.foundation.layout.absolutePadding
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.lazy.grid.GridCells
import androidx.compose.foundation.lazy.grid.LazyVerticalGrid
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Menu
import androidx.compose.material3.Button
import androidx.compose.material3.Divider
import androidx.compose.material3.DrawerValue
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.ModalBottomSheet
import androidx.compose.material3.ModalDrawerSheet
import androidx.compose.material3.ModalNavigationDrawer
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
import androidx.compose.material3.TopAppBar
import androidx.compose.material3.TopAppBarDefaults.topAppBarColors
import androidx.compose.material3.rememberDrawerState
import androidx.compose.material3.rememberModalBottomSheetState
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.rememberCoroutineScope
import androidx.compose.runtime.saveable.rememberSaveable
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.input.pointer.pointerInput
import androidx.compose.ui.platform.LocalDensity
import androidx.compose.ui.text.SpanStyle
import androidx.compose.ui.text.TextStyle
import androidx.compose.ui.text.buildAnnotatedString
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.withStyle
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.navigation.NavController
import kotlinx.coroutines.Job
import kotlinx.coroutines.launch
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

@OptIn(ExperimentalFoundationApi::class, ExperimentalMaterial3Api::class)
@Composable
fun ChapterScreen(
    verses: List<Verse>,
    bookIndex: Int,
    chapterIndex: Int,
    navController: NavController,
    openDrawer: () -> Job,
) {
    val chapters =
        verses.filter { it.bookIndex == bookIndex }.map { it.chapterIndex }.distinct();

    val changeChapter = { c: Int ->
        navController.navigate(route = "/books/${bookIndex}/chapters/${c}")
    }
    val density = LocalDensity.current
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
                    changeChapter(chapterIndex + 1)
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
        topBar = {
            TopAppBar(
                colors = topAppBarColors(
                    containerColor = Color(0xFFFFFFFF),
                    titleContentColor = Color(0xFF000000),
                ),
                title = {
                    Surface(onClick = { openDrawer() }) {
                        Text("Genesis ${chapterIndex + 1}")
                    }
                },
            )
        }
    ) { innerPadding ->
        Column(
            modifier = Modifier
                .fillMaxSize()
                .padding(innerPadding)
                .padding(horizontal = 16.dp)
                .verticalScroll(rememberScrollState())
//            .anchoredDraggable(state, Orientation.Horizontal, reverseDirection = true)
                .pointerInput(Unit) {
                    detectHorizontalDragGestures { change, dragAmount ->
                        change.consume()
                        if (dragAmount < -5) {
                            changeChapter(chapterIndex - 1)
                        }
                        if (dragAmount < 5) {
                            changeChapter(chapterIndex + 1)
                        }
                    }
                }
        ) {
            chapterVerses.map {
                Text(
                    modifier = Modifier.padding(bottom = 4.dp),
                    text = buildAnnotatedString {
                        withStyle(
                            style = SpanStyle(
                                fontSize = 16.sp,
                                fontWeight = FontWeight.W500,
                                color = Color(0xFF9A1111),
                            )
                        ) {
                            append((it.verseIndex + 1).toString() + " ")
                        }
                        withStyle(
                            style = SpanStyle(
                                fontSize = 18.sp,
                                fontWeight = FontWeight.W400,
                            )
                        ) {
                            append(it.text)
                        }
                    }
                )
            }
        }
    }
}