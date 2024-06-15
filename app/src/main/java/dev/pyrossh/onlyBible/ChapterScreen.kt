package dev.pyrossh.onlyBible

import FontType
import PreferencesManager
import Verse
import android.annotation.SuppressLint
import android.content.Context
import androidx.compose.foundation.ExperimentalFoundationApi
import androidx.compose.foundation.background
import androidx.compose.foundation.gestures.detectHorizontalDragGestures
import androidx.compose.foundation.gestures.detectTapGestures
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.wrapContentSize
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.text.selection.DisableSelection
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Close
import androidx.compose.material.icons.filled.FaceRetouchingNatural
import androidx.compose.material.icons.filled.FormatBold
import androidx.compose.material.icons.filled.FormatLineSpacing
import androidx.compose.material.icons.filled.FormatSize
import androidx.compose.material.icons.outlined.MoreVert
import androidx.compose.material.icons.outlined.Share
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.HorizontalDivider
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.ModalBottomSheet
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
import androidx.compose.material3.rememberModalBottomSheetState
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableFloatStateOf
import androidx.compose.runtime.mutableIntStateOf
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
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.text.SpanStyle
import androidx.compose.ui.text.TextStyle
import androidx.compose.ui.text.buildAnnotatedString
import androidx.compose.ui.text.font.FontFamily
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.withStyle
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.datastore.preferences.core.edit
import androidx.datastore.preferences.core.intPreferencesKey
import androidx.navigation.NavController
import convertVersesToSpeech
import kotlinx.coroutines.Job
import kotlinx.coroutines.launch
import kotlinx.serialization.Serializable
import shareVerses

// TODO: once androidx.navigation 2.8.0 is released
@Serializable
data class ChapterScreenProps(
    val bookIndex: Int,
    val chapterIndex: Int,
)

val fontSizeDeltaKey = intPreferencesKey("fontSizeDelta");

suspend fun incrementFontSize(context: Context) {
    context.dataStore.edit { settings ->
        val currentCounterValue = settings[fontSizeDeltaKey] ?: 0
        settings[fontSizeDeltaKey] = currentCounterValue + 1
    }
}

suspend fun decrementFontSize(context: Context) {
    context.dataStore.edit { settings ->
        val currentCounterValue = settings[fontSizeDeltaKey] ?: 0
        settings[fontSizeDeltaKey] = currentCounterValue - 1
    }
}

@OptIn(ExperimentalMaterial3Api::class, ExperimentalFoundationApi::class)
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
    val prefs = PreferencesManager(context)
    var fontType by remember { mutableStateOf(prefs.getFontType()) }
    var fontSizeDelta by remember { mutableIntStateOf(prefs.getFontSize()) }
    var boldEnabled by remember { mutableStateOf(prefs.getBold()) }
    val fontFamily = when (fontType) {
        FontType.Sans -> FontFamily.SansSerif
        FontType.Serif -> FontFamily.Serif
        FontType.Mono -> FontFamily.Monospace
    }
    val boldWeight = if (boldEnabled) FontWeight.W700 else FontWeight.W400
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
        val sheetState = rememberModalBottomSheetState()
        var showBottomSheet by rememberSaveable { mutableStateOf(false) }
        val showSheet = {
            showBottomSheet = true
        }
        val closeSheet = {
            showBottomSheet = false
        }
        if (showBottomSheet) {
            ModalBottomSheet(
                onDismissRequest = {
                    showBottomSheet = false
                },
                sheetState = sheetState
            ) {
                Column(
                    modifier = Modifier
                        .fillMaxSize()
                        .padding(horizontal = 16.dp),
                ) {
                    Row(
                        modifier = Modifier.fillMaxWidth(),
                        horizontalArrangement = Arrangement.SpaceBetween,
                        verticalAlignment = Alignment.CenterVertically,
                    ) {
                        Text(
                            text = "Text Settings",
                            fontSize = 20.sp,
                            fontWeight = FontWeight.W500
                        )
                        Row(horizontalArrangement = Arrangement.End) {
                            IconButton(onClick = {
                                scope.launch {
                                    closeSheet()
                                }
                            }) {
                                Icon(Icons.Filled.Close, "Close")
                            }
                        }
                    }
                    HorizontalDivider()
                    Row(
                        modifier = Modifier
                            .fillMaxWidth()
                            .padding(top = 16.dp),
                        horizontalArrangement = Arrangement.SpaceBetween,
                        verticalAlignment = Alignment.CenterVertically,
                    ) {
                        Surface(
                            shape = RoundedCornerShape(8.dp),
                            modifier = Modifier
                                .fillMaxWidth()
                                .height(60.dp)
                                .padding(end = 16.dp)
                                .weight(1f),
                            onClick = {
                                fontSizeDelta -= 1
                                prefs.setFontSize(fontSizeDelta)
                            }
                        ) {
                            Column(
                                modifier = Modifier
                                    .background(Color(0xFFFAFAFA)),
                                verticalArrangement = Arrangement.Center,
                                horizontalAlignment = Alignment.CenterHorizontally
                            ) {
                                Icon(
                                    imageVector = Icons.Filled.FormatSize,
                                    contentDescription = "Bold",
                                    modifier = Modifier.size(14.dp),
                                )
                            }
                        }
                        Surface(
                            shape = RoundedCornerShape(8.dp),
                            modifier = Modifier
                                .fillMaxWidth()
                                .height(60.dp)
                                .padding(end = 16.dp)
                                .weight(1f),
                            onClick = {
                                fontSizeDelta += 1
                                prefs.setFontSize(fontSizeDelta)
                            }
                        ) {
                            Column(
                                modifier = Modifier
                                    .background(Color(0xFFFAFAFA)),
                                verticalArrangement = Arrangement.Center,
                                horizontalAlignment = Alignment.CenterHorizontally
                            ) {
                                Icon(
                                    imageVector = Icons.Filled.FormatSize,
                                    contentDescription = "Bold"
                                )
                            }
                        }
                        Surface(
                            shape = RoundedCornerShape(8.dp),
                            modifier = Modifier
                                .fillMaxWidth()
                                .height(60.dp)
                                .padding(end = 16.dp)
                                .weight(1f),
                            onClick = {
                                boldEnabled = !boldEnabled
                                prefs.setBold(boldEnabled)
                            }
                        ) {
                            Column(
                                modifier = Modifier
                                    .background(Color(0xFFFAFAFA)),
                                verticalArrangement = Arrangement.Center,
                                horizontalAlignment = Alignment.CenterHorizontally
                            ) {
                                Icon(
                                    imageVector = Icons.Filled.FormatBold,
                                    contentDescription = "Bold"
                                )
                            }
                        }
                        Surface(
                            shape = RoundedCornerShape(8.dp),
                            modifier = Modifier
                                .fillMaxWidth()
                                .height(60.dp)
                                .padding(end = 16.dp)
                                .weight(1f),
                            onClick = {}
                        ) {
                            Column(
                                modifier = Modifier
                                    .background(Color(0xFFFAFAFA)),
                                verticalArrangement = Arrangement.Center,
                                horizontalAlignment = Alignment.CenterHorizontally
                            ) {
                                Icon(
                                    imageVector = Icons.Filled.FormatLineSpacing,
                                    contentDescription = "Line Spacing"
                                )
                            }
                        }
                    }
                    Row(
                        modifier = Modifier
                            .fillMaxWidth()
                            .padding(top = 16.dp),
                        horizontalArrangement = Arrangement.SpaceBetween,
                        verticalAlignment = Alignment.CenterVertically,
                    ) {
                        Surface(
                            shape = RoundedCornerShape(8.dp),
                            modifier = Modifier
                                .fillMaxWidth()
                                .height(60.dp)
                                .padding(end = 16.dp)
                                .weight(1f),
                            onClick = {
                                fontType = FontType.Sans
                                prefs.setFontType(fontType)
                            }
                        ) {
                            Column(
                                modifier = Modifier
                                    .background(Color(0xFFFAFAFA)),
                                verticalArrangement = Arrangement.Center,
                                horizontalAlignment = Alignment.CenterHorizontally
                            ) {
                                Text(
                                    text = "Sans",
                                    style = TextStyle(
                                        fontSize = 18.sp,
                                        fontWeight = FontWeight.Medium,
                                    )
                                )
                            }
                        }
                        Surface(
                            shape = RoundedCornerShape(8.dp),
                            modifier = Modifier
                                .fillMaxWidth()
                                .height(60.dp)
                                .padding(end = 16.dp)
                                .weight(1f),
                            onClick = {
                                fontType = FontType.Serif
                                prefs.setFontType(fontType)
                            }
                        ) {
                            Column(
                                modifier = Modifier
                                    .background(Color(0xFFFAFAFA)),
                                verticalArrangement = Arrangement.Center,
                                horizontalAlignment = Alignment.CenterHorizontally
                            ) {
                                Text(
                                    text = "Serif",
                                    style = TextStyle(
                                        fontSize = 18.sp,
                                        fontWeight = FontWeight.Medium,
                                    )
                                )
                            }
                        }
                        Surface(
                            shape = RoundedCornerShape(8.dp),
                            modifier = Modifier
                                .fillMaxWidth()
                                .height(60.dp)
                                .padding(end = 16.dp)
                                .weight(1f),
                            onClick = {
                                fontType = FontType.Mono
                                prefs.setFontType(fontType)
                            }
                        ) {
                            Column(
                                modifier = Modifier
                                    .background(Color(0xFFFAFAFA)),
                                verticalArrangement = Arrangement.Center,
                                horizontalAlignment = Alignment.CenterHorizontally
                            ) {
                                Text(
                                    text = "Mono",
                                    style = TextStyle(
                                        fontSize = 18.sp,
                                        fontWeight = FontWeight.Medium,
                                    )
                                )
                            }
                        }
                    }
                    Row(
                        modifier = Modifier
                            .fillMaxWidth()
                            .padding(top = 16.dp),
                        horizontalArrangement = Arrangement.SpaceBetween,
                        verticalAlignment = Alignment.CenterVertically,
                    ) {
                        // #72abbf on active
                        // #ebe0c7 on yellow
                        // #424547 on dark
                        Surface(
                            shape = RoundedCornerShape(8.dp),
                            modifier = Modifier
                                .fillMaxWidth()
                                .height(80.dp)
                                .padding(end = 16.dp)
                                .weight(1f),
                            onClick = {}
                        ) {
                            Icon(
                                painter = painterResource(id = R.drawable.text_theme),
                                contentDescription = "Light",
                                tint = Color(0xFF424547),
                                modifier = Modifier
                                    .background(Color.White)
                                    .padding(8.dp)
                            )
                        }
                        Surface(
                            shape = RoundedCornerShape(8.dp),
                            modifier = Modifier
                                .fillMaxWidth()
                                .height(80.dp)
                                .padding(end = 16.dp)
                                .weight(1f),
                            onClick = {}
                        ) {
                            Icon(
                                painter = painterResource(id = R.drawable.text_theme),
                                contentDescription = "Warm",
                                tint = Color(0xFF424547),
                                modifier = Modifier
                                    .background(Color(0xFFe5e0d1))
                                    .padding(8.dp)
                            )
                        }
                        Surface(
                            shape = RoundedCornerShape(8.dp),
                            modifier = Modifier
                                .fillMaxWidth()
                                .height(80.dp)
                                .padding(end = 16.dp)
                                .weight(1f),
                            onClick = {}
                        ) {
                            Icon(
                                painter = painterResource(id = R.drawable.text_theme),
                                contentDescription = "Dark",
                                tint = Color(0xFFd3d7da),
                                modifier = Modifier
                                    .background(Color(0xFF2c2e30))
                                    .padding(8.dp)
                            )
                        }
                        Surface(
                            shape = RoundedCornerShape(8.dp),
                            modifier = Modifier
                                .fillMaxWidth()
                                .height(80.dp)
                                .padding(end = 16.dp)
                                .weight(1f),
                            onClick = {}
                        ) {
                            Column(
                                modifier = Modifier
                                    .background(Color(0xFFFAFAFA)),
                                verticalArrangement = Arrangement.Center,
                                horizontalAlignment = Alignment.CenterHorizontally
                            ) {
                                Text(
                                    text = "Auto",
                                    style = TextStyle(
                                        fontSize = 18.sp,
                                        fontWeight = FontWeight.Medium,
                                    )
                                )
                            }
                        }
                    }
                }
            }
        }
        LazyColumn(
//            verticalArrangement = Arrangement.spacedBy(4.dp),
            modifier = Modifier
                .fillMaxSize()
                .padding(innerPadding)
                .padding(horizontal = 16.dp)
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
                                    convertVersesToSpeech(
                                        scope,
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
                                showSheet()
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
                                top = if (v.verseIndex != 0) 12.dp else 0.dp,
                                bottom = 12.dp
                            ),
                            style = TextStyle(
                                fontFamily = fontFamily,
                                fontSize = (16 + fontSizeDelta).sp,
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
                        fontWeight = boldWeight,
                        fontSize = (16 + fontSizeDelta).sp,
                        lineHeight = (22 + fontSizeDelta).sp,
                        letterSpacing = 0.sp,
                    ),
                    text = buildAnnotatedString {
                        withStyle(
                            style = SpanStyle(
                                fontSize = (13 + fontSizeDelta).sp,
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