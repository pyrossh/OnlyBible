package dev.pyrossh.onlyBible

import android.os.Parcelable
import android.view.SoundEffectConstants
import androidx.compose.animation.AnimatedContentTransitionScope
import androidx.compose.foundation.gestures.detectDragGestures
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.LazyListState
import androidx.compose.foundation.lazy.items
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.outlined.MoreVert
import androidx.compose.material.icons.rounded.Search
import androidx.compose.material3.ButtonDefaults.ContentPadding
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Text
import androidx.compose.material3.TextButton
import androidx.compose.material3.TopAppBar
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.MutableIntState
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableIntStateOf
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.saveable.rememberSaveable
import androidx.compose.runtime.setValue
import androidx.compose.ui.Modifier
import androidx.compose.ui.input.pointer.PointerInputScope
import androidx.compose.ui.input.pointer.pointerInput
import androidx.compose.ui.platform.LocalView
import androidx.compose.ui.text.TextStyle
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import dev.pyrossh.onlyBible.composables.BibleSelector
import dev.pyrossh.onlyBible.composables.ChapterSelector
import dev.pyrossh.onlyBible.composables.EmbeddedSearchBar
import dev.pyrossh.onlyBible.composables.VerseView
import kotlinx.parcelize.Parcelize
import kotlinx.serialization.Serializable
import kotlin.math.abs


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

    fun reverse(): Dir {
        return if (this == Left) Right else Left
    }
}

suspend fun PointerInputScope.detectSwipe(
    swipeState: MutableIntState = mutableIntStateOf(-1),
    onSwipeLeft: () -> Unit = {},
    onSwipeRight: () -> Unit = {},
    onSwipeUp: () -> Unit = {},
    onSwipeDown: () -> Unit = {},
) = detectDragGestures(
    onDrag = { change, dragAmount ->
        change.consume()
        val (x, y) = dragAmount
        if (abs(x) > abs(y)) {
            when {
                x > 0 -> swipeState.intValue = 0
                x < 0 -> swipeState.intValue = 1
            }
        } else {
            when {
                y > 0 -> swipeState.intValue = 2
                y < 0 -> swipeState.intValue = 3
            }
        }
    },
    onDragEnd = {
        when (swipeState.intValue) {
            0 -> onSwipeRight()
            1 -> onSwipeLeft()
            2 -> onSwipeDown()
            3 -> onSwipeUp()
        }
    }
)

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun ChapterScreen(
    model: AppViewModel,
    onSwipeLeft: () -> Unit,
    onSwipeRight: () -> Any,
    bookIndex: Int,
    chapterIndex: Int,
    navigateToChapter: (ChapterScreenProps) -> Unit,
) {
    val view = LocalView.current
    val verses by model.verses.collectAsState()
    val bookNames by model.bookNames.collectAsState()
    val searchText by model.searchText.collectAsState()
    val isSearching by model.isSearching.collectAsState()
    val versesList by model.versesList.collectAsState()
    var chapterSelectorShown by remember { mutableStateOf(false) }
    var bibleSelectorShown by remember { mutableStateOf(false) }
    val fontSizeDelta = model.fontSizeDelta
    val headingColor = MaterialTheme.colorScheme.onSurface // MaterialTheme.colorScheme.primary,
    val chapterVerses =
        verses.filter { it.bookIndex == bookIndex && it.chapterIndex == chapterIndex }
    LaunchedEffect(key1 = chapterVerses) {
        model.clearSelectedVerses()
        model.bookIndex = bookIndex
        model.chapterIndex = chapterIndex
    }
    Scaffold(
        modifier = Modifier
            .fillMaxSize(),
        topBar = {
            if (isSearching) {
                EmbeddedSearchBar(
                    query = searchText,
                    onQueryChange = model::onSearchTextChange,
                    onSearch = model::onSearchTextChange,
                    onClose = { model.onCloseSearch() }
                ) {
                    val groups = versesList.groupBy { "${it.bookName} ${it.chapterIndex + 1}" }
                    LazyColumn {
                        groups.forEach {
                            item(
                                contentType = "header"
                            ) {
                                Text(
                                    modifier = Modifier.padding(
                                        vertical = 12.dp,
                                    ),
                                    style = TextStyle(
                                        fontFamily = model.fontType.family(),
                                        fontSize = (16 + fontSizeDelta).sp,
                                        fontWeight = FontWeight.W700,
                                        color = headingColor,
                                    ),
                                    text = it.key,
                                )
                            }
                            items(it.value) { v ->
                                VerseView(
                                    model = model,
                                    verse = v,
                                )
                            }
                        }
                    }
                }
            }
            TopAppBar(
                modifier = Modifier
                    .height(72.dp),
                title = {
                    Row(
                        modifier = Modifier
                            .fillMaxWidth(),
                    ) {
                        TextButton(
                            contentPadding = PaddingValues(
                                top = ContentPadding.calculateTopPadding(),
                                end = 12.dp,
                                bottom = ContentPadding.calculateBottomPadding()
                            ),
                            onClick = {
                                chapterSelectorShown = true
                            }
                        ) {
                            Text(
                                text = "${bookNames[bookIndex]}   ${chapterIndex + 1}",
                                style = TextStyle(
                                    fontSize = 22.sp,
                                    fontWeight = FontWeight.W500,
                                    color = headingColor,
                                )
                            )
                        }
                    }
                },
                actions = {
                    IconButton(
                        onClick = { model.onOpenSearch() },
                    ) {
                        Icon(
                            imageVector = Icons.Rounded.Search,
                            contentDescription = "Search",
                            tint = headingColor,
                        )
                    }
                    TextButton(onClick = {
                        bibleSelectorShown = true
                    }) {
                        Text(
                            text = model.getBibleName(),
                            style = TextStyle(
                                fontSize = 18.sp,
                                fontWeight = FontWeight.W500,
                                color = headingColor,
                            ),
                        )
                    }
                    TextButton(
                        onClick = {
                            view.playSoundEffect(SoundEffectConstants.CLICK)
                            model.showSheet()
                        }) {
                        Icon(
                            imageVector = Icons.Outlined.MoreVert,
                            contentDescription = "More",
                            tint = headingColor,
                        )
                    }
                },
            )
        },
    ) { innerPadding ->
        if (bibleSelectorShown) {
            BibleSelector(
                model = model,
                onClose = { bibleSelectorShown = false },
            )
        }
        if (chapterSelectorShown) {
            ChapterSelector(
                model = model,
                onClose = { chapterSelectorShown = false },
                navigateToChapter = navigateToChapter,
            )
        }

        LazyColumn(
            state = rememberSaveable(saver = LazyListState.Saver) {
                model.scrollState
            },
            verticalArrangement = Arrangement.spacedBy(16.dp + (model.lineSpacingDelta * 2).dp),
            modifier = Modifier
                .fillMaxSize()
                .padding(innerPadding)
                .padding(horizontal = 16.dp)
                .pointerInput(Unit) {
                    detectSwipe(
                        onSwipeLeft = onSwipeLeft,
                        onSwipeRight = { onSwipeRight() },
                    )
                }
        ) {
            items(chapterVerses) { v ->
                if (v.heading.isNotEmpty()) {
                    Text(
                        modifier = Modifier.padding(
                            top = if (v.verseIndex != 0) 12.dp else 0.dp, bottom = 12.dp
                        ),
                        style = TextStyle(
                            fontFamily = model.fontType.family(),
                            fontSize = (16 + fontSizeDelta).sp,
                            fontWeight = FontWeight.W700,
                            color = headingColor,
                        ),
                        text = v.heading.replace("<br>", "\n")
                    )
                }
                VerseView(
                    model = model,
                    verse = v,
                )
            }
        }
    }
}