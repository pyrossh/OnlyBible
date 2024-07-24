package dev.pyrossh.onlyBible

import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.lazy.grid.GridCells
import androidx.compose.foundation.lazy.grid.GridItemSpan
import androidx.compose.foundation.lazy.grid.LazyGridItemScope
import androidx.compose.foundation.lazy.grid.LazyGridScope
import androidx.compose.foundation.lazy.grid.LazyVerticalGrid
import androidx.compose.foundation.lazy.grid.items
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Close
import androidx.compose.material3.Button
import androidx.compose.material3.DrawerValue
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.ModalDrawerSheet
import androidx.compose.material3.ModalNavigationDrawer
import androidx.compose.material3.Text
import androidx.compose.material3.rememberDrawerState
import androidx.compose.runtime.Composable
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableIntStateOf
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.rememberCoroutineScope
import androidx.compose.runtime.saveable.rememberSaveable
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.text.TextStyle
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import dev.pyrossh.onlyBible.domain.Verse
import kotlinx.coroutines.Job
import kotlinx.coroutines.launch
import java.util.Locale

enum class MenuType {
    Bible,
    Book,
    Chapter,
}

fun shortName(name: String): String {
    if (name[0] == '1' || name[0] == '2' || name[0] == '3') {
        return "${name[0]}${name[2].uppercase()}${name.substring(3, 4).lowercase()}"
    }
    return "${name[0].uppercase()}${name.substring(1, 3).lowercase()}"
}

fun LazyGridScope.header(
    content: @Composable LazyGridItemScope.() -> Unit
) {
    item(span = { GridItemSpan(this.maxLineSpan) }, content = content)
}

@Composable
fun AppDrawer(
    model: AppViewModel,
    navigateToChapter: (ChapterScreenProps) -> Unit,
    content: @Composable ((MenuType, Int) -> Job) -> Unit
) {
    val context = LocalContext.current
    val scope = rememberCoroutineScope()
    val drawerState = rememberDrawerState(initialValue = DrawerValue.Closed)
    var bookIndex by rememberSaveable {
        mutableIntStateOf(0)
    }
    var menuType by rememberSaveable {
        mutableStateOf(MenuType.Chapter)
    }
    val bookNames by model.bookNames.collectAsState()
    val openDrawer = { m: MenuType, b: Int ->
        menuType = m
        bookIndex = b
        scope.launch {
            drawerState.apply {
                if (isClosed) open() else close()
            }
        }
    }
    ModalNavigationDrawer(
        gesturesEnabled = drawerState.isOpen,
        drawerState = drawerState,
        drawerContent = {
            ModalDrawerSheet(
                drawerTonalElevation = 2.dp,
            ) {
                Column(
                    modifier = Modifier
                        .fillMaxSize()
                        .padding(horizontal = 16.dp)
                        .padding(bottom = 16.dp),
                ) {
                    if (menuType == MenuType.Bible) {
                        val locales = getSupportedLocales(context)
                        LazyVerticalGrid(
                            modifier = Modifier.fillMaxSize(),
                            verticalArrangement = Arrangement.spacedBy(10.dp),
                            horizontalArrangement = Arrangement.spacedBy(10.dp),
                            columns = GridCells.Fixed(2)
                        ) {
                            header {
                                Row(
                                    modifier = Modifier.fillMaxWidth(),
                                    horizontalArrangement = Arrangement.SpaceBetween,
                                    verticalAlignment = Alignment.CenterVertically,
                                ) {
                                    Text(
                                        text = "Select a bible",
                                        fontSize = 20.sp,
                                        fontWeight = FontWeight.W500,
                                    )
                                    IconButton(onClick = {
                                        scope.launch {
                                            drawerState.close();
                                        }
                                    }) {
                                        Icon(Icons.Filled.Close, "Close")
                                    }
                                }
                            }
                            items(locales) { loc ->
                                QuickButton(
                                    title = loc.getDisplayName(Locale.ENGLISH),
                                    subtitle = if (loc.language == "en")
                                        "KJV"
                                    else
                                        loc.getDisplayName(loc),
                                ) {
                                    scope.launch {
                                        drawerState.close()
                                    }.invokeOnCompletion {
                                        setLocale(context, loc)
                                    }
                                }
                            }
                        }
                    }
                    if (menuType == MenuType.Book) {
                        LazyVerticalGrid(
                            modifier = Modifier.fillMaxSize(),
                            verticalArrangement = Arrangement.spacedBy(10.dp),
                            horizontalArrangement = Arrangement.spacedBy(10.dp),
                            columns = GridCells.Fixed(5)
                        ) {
                            header {
                                Row(
                                    modifier = Modifier.fillMaxWidth(),
                                    horizontalArrangement = Arrangement.SpaceBetween,
                                    verticalAlignment = Alignment.CenterVertically,
                                ) {
                                    Text(
                                        text = context.getString(R.string.old_testament),
                                        fontSize = 18.sp,
                                        fontWeight = FontWeight.W500,
                                    )
                                    IconButton(onClick = {
                                        scope.launch {
                                            drawerState.close();
                                        }
                                    }) {
                                        Icon(Icons.Filled.Close, "Close")
                                    }
                                }
                            }
                            items(39) { b ->
                                QuickButton(
                                    title = shortName(bookNames[b]),
                                    subtitle = null,
                                ) {
                                    bookIndex = b
                                    menuType = MenuType.Chapter
                                }
                            }
                            header {
                                Row(
                                    modifier = Modifier.padding(top = 16.dp, bottom = 8.dp),
                                    horizontalArrangement = Arrangement.SpaceBetween,
                                    verticalAlignment = Alignment.CenterVertically,
                                ) {
                                    Text(
                                        text = context.getString(R.string.new_testament),
                                        fontSize = 18.sp,
                                        fontWeight = FontWeight.W500
                                    )
                                }
                            }
                            items(27) { i ->
                                val b = 39 + i
                                QuickButton(
                                    title = shortName(bookNames[b]),
                                    subtitle = null,
                                ) {
                                    bookIndex = b
                                    menuType = MenuType.Chapter
                                }
                            }
                        }
                    }

                    if (menuType == MenuType.Chapter) {
                        LazyVerticalGrid(
                            modifier = Modifier.fillMaxSize(),
                            verticalArrangement = Arrangement.spacedBy(10.dp),
                            horizontalArrangement = Arrangement.spacedBy(10.dp),
                            columns = GridCells.Fixed(5)
                        ) {
                            header {
                                Row(
                                    modifier = Modifier.fillMaxWidth(),
                                    horizontalArrangement = Arrangement.SpaceBetween,
                                    verticalAlignment = Alignment.CenterVertically,
                                ) {
                                    Text(
                                        text = bookNames[bookIndex],
                                        fontSize = 20.sp,
                                        fontWeight = FontWeight.W500
                                    )
                                    IconButton(onClick = {
                                        scope.launch {
                                            drawerState.close();
                                        }
                                    }) {
                                        Icon(Icons.Filled.Close, "Close")
                                    }
                                }
                            }

                            items(Verse.chapterSizes[bookIndex]) { c ->
                                QuickButton(
                                    title = "${c + 1}",
                                    subtitle = null,
                                ) {
                                    scope.launch {
                                        navigateToChapter(
                                            ChapterScreenProps(
                                                bookIndex = bookIndex,
                                                chapterIndex = c,
                                            )
                                        )
                                        drawerState.close();
                                    }
                                }
                            }
                        }
                    }
                }
            }
        },
    ) {
        content(openDrawer)
    }
}

@Composable
fun QuickButton(title: String, subtitle: String?, onClick: () -> Unit) {
    Button(
        shape = RoundedCornerShape(2.dp),
        contentPadding = PaddingValues(4.dp),
        onClick = onClick
    ) {
        Column(
            horizontalAlignment = Alignment.CenterHorizontally,
            modifier = Modifier.padding(vertical = 8.dp)
        ) {
            Text(
                style = TextStyle(
                    fontSize = 18.sp,
                    fontWeight = FontWeight.W500,
                ),
                text = title,
            )
            if (!subtitle.isNullOrEmpty()) {
                Text(
                    modifier = Modifier.padding(top = 8.dp),
                    style = TextStyle(
                        fontSize = 18.sp,
                        fontWeight = FontWeight.W500,
                    ),
                    text = "($subtitle)",
                )
            }
        }
    }
}