package dev.pyros.bibleapp

import android.os.Bundle
import android.util.Log
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.activity.enableEdgeToEdge
import androidx.compose.animation.core.AnimationSpec
import androidx.compose.animation.core.EaseInOut
import androidx.compose.animation.core.tween
import androidx.compose.foundation.ExperimentalFoundationApi
import androidx.compose.foundation.combinedClickable
import androidx.compose.foundation.gestures.Orientation
import androidx.compose.foundation.gestures.draggable
import androidx.compose.foundation.gestures.rememberDraggableState
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.offset
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.lazy.grid.GridCells
import androidx.compose.foundation.lazy.grid.LazyVerticalGrid
import androidx.compose.foundation.pager.HorizontalPager
import androidx.compose.foundation.pager.PagerDefaults
import androidx.compose.foundation.pager.PagerSnapDistance
import androidx.compose.foundation.pager.rememberPagerState
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.verticalScroll
import androidx.compose.material3.Button
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.ModalBottomSheet
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
import androidx.compose.material3.rememberModalBottomSheetState
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableIntStateOf
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.rememberCoroutineScope
import androidx.compose.runtime.saveable.rememberSaveable
import androidx.compose.runtime.setValue
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.graphicsLayer
import androidx.compose.ui.text.SpanStyle
import androidx.compose.ui.text.TextStyle
import androidx.compose.ui.text.buildAnnotatedString
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.withStyle
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.compose.ui.util.lerp
import androidx.navigation.NavType
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import androidx.navigation.compose.rememberNavController
import androidx.navigation.navArgument
import dev.pyros.bibleapp.ui.theme.BibleAppTheme
import kotlinx.coroutines.Job
import kotlinx.coroutines.launch
import kotlinx.serialization.Serializable
import java.io.BufferedReader
import kotlin.math.absoluteValue

data class Verse(
    val bookIndex: Int,
    val bookName: String,
    val chapterIndex: Int,
    val verseIndex: Int,
    val heading: String,
    val text: String
)

fun parseBibleTxt(name: String, buffer: BufferedReader): List<Verse> {
    Log.i("loading", "parsing bible $name")
    return buffer.readLines().filter { it.isNotEmpty() }.map {
        val arr = it.split("|")
        val book = arr[0].toInt()
        val chapter = arr[1].toInt()
        val verseNo = arr[2].toInt()
        val heading = arr[3]
        val verseText = arr.subList(4, arr.size).joinToString("|")
        Verse(
            bookIndex = book,
            bookName = name,
            chapterIndex = chapter,
            verseIndex = verseNo,
            heading = heading,
            text = verseText,
        )
    }
}

class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        enableEdgeToEdge()
        val verses = parseBibleTxt("English", assets.open("English.txt").bufferedReader())
        setContent {
            BibleAppTheme {
                Scaffold(modifier = Modifier.fillMaxSize()) { innerPadding ->
                    AppHost(verses = verses, modifier = Modifier.padding(innerPadding))
                }
            }
        }
    }
}

@Composable
fun AppHost(verses: List<Verse>, modifier: Modifier = Modifier) {
    val navController = rememberNavController()
    NavHost(
        modifier = modifier,
        navController = navController,
        startDestination = "/books/{book}/chapters/{chapter}"
    ) {
        composable(
            route = "/books/{book}/chapters/{chapter}",
            arguments = listOf(
                navArgument("book") { type = NavType.IntType },
                navArgument("chapter") { type = NavType.IntType },
            )
        ) {
            ChapterScreen(
                verses = verses,
                bookIndex = it.arguments?.getInt("book") ?: 0,
                chapterIndex = it.arguments?.getInt("chapter") ?: 0,
            )
        }
    }
}


@OptIn(ExperimentalFoundationApi::class, ExperimentalMaterial3Api::class)
@Composable
fun ChapterScreen(verses: List<Verse>, bookIndex: Int, chapterIndex: Int) {
    val scope = rememberCoroutineScope()
    val sheetState = rememberModalBottomSheetState()
    var showBottomSheet by rememberSaveable { mutableStateOf(false) }
    var currentBookIndex by rememberSaveable { mutableStateOf(0) }
    val chapters =
        verses.filter { it.bookIndex == currentBookIndex }.map { it.chapterIndex }.distinct();
    val pagerState = rememberPagerState(
        pageCount = {
            929
        })
    val showSheet = {
        showBottomSheet = true
    }
    val setBookIndex = { v: Int ->
        scope.launch {
            pagerState.animateScrollToPage(
                page = v,
                animationSpec = tween(
                    durationMillis = 300,
                    easing = EaseInOut,
                )
            )
        }
//        currentBookIndex = v
    }

//    val fling = PagerDefaults.flingBehavior(
//        state = pagerState,
//        pagerSnapDistance = PagerSnapDistance.atMost(10)
//    )

    if (showBottomSheet) {
        ModalBottomSheet(
            onDismissRequest = {
                showBottomSheet = false
            },
            sheetState = sheetState
        ) {
            Text("All Chapters")
            LazyVerticalGrid(
                columns = GridCells.Adaptive(minSize = 128.dp)
            ) {
                items(chapters.size) { c ->
                    Button(onClick = {
                        scope.launch {
                            sheetState.hide()
                            pagerState.animateScrollToPage(
                                page = c,
//                                        animationSpec = tween(
//                                            durationMillis = 300,
//                                            easing = EaseInOut,
//                                        )
                            )
                        }.invokeOnCompletion {
                            if (!sheetState.isVisible) {
                                showBottomSheet = false
                            }
                        }
                    }) {
                        Text(
                            modifier = Modifier.padding(bottom = 4.dp),
                            style = TextStyle(
                                fontSize = 16.sp,
                                fontWeight = FontWeight.W500,
                                color = Color(0xFF9A1111),
                            ),
                            text = (c + 1).toString(),
                        )
                    }
                }
            }
        }
    }

    HorizontalPager(
        state = pagerState,
        beyondBoundsPageCount = 10,

//        flingBehavior = fling
    ) { page ->
        val chapterVerses =
            verses.filter { it.bookIndex == currentBookIndex && it.chapterIndex == page };
        Column(
            modifier = Modifier
                .padding(16.dp)
                .verticalScroll(rememberScrollState())
                .graphicsLayer {
                    // Calculate the absolute offset for the current page from the
                    // scroll position. We use the absolute value which allows us to mirror
                    // any effects for both directions
                    val pageOffset = (
                            (pagerState.currentPage - page) + pagerState
                                .currentPageOffsetFraction
                            ).absoluteValue

                    // We animate the alpha, between 50% and 100%
                    alpha = lerp(
                        start = 0.5f,
                        stop = 1f,
                        fraction = 1f - pageOffset.coerceIn(0f, 1f)
                    )
                }
        ) {
            Header(page, chapterVerses[0].chapterIndex, showSheet, setBookIndex)
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

@OptIn(ExperimentalFoundationApi::class)
@Composable
fun Header(
    currentBookIndex: Int,
    chapterIndex: Int,
    showSheet: () -> Unit,
    setBookIndex: (Int) -> Job
) {
    Row(modifier = Modifier.padding(bottom = 8.dp)) {
        Text(
            modifier = Modifier.combinedClickable(
                enabled = true,
                onClick = {
                    showSheet()
                },
                onDoubleClick = {
                    showSheet()
                }
            ),
            style = TextStyle(
                fontSize = 22.sp,
                fontWeight = FontWeight.W600,
            ),
            text = "Genesis ${chapterIndex + 1}"
        )
    }
}