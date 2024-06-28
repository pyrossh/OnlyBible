package dev.pyrossh.onlyBible

import Verse
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
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.ModalDrawerSheet
import androidx.compose.material3.ModalNavigationDrawer
import androidx.compose.material3.Text
import androidx.compose.material3.rememberDrawerState
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableIntStateOf
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.rememberCoroutineScope
import androidx.compose.runtime.saveable.rememberSaveable
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.text.TextStyle
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.navigation.NavController
import kotlinx.coroutines.Job
import kotlinx.coroutines.delay
import kotlinx.coroutines.launch

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
fun Drawer(
    bookNames: List<String>,
    navController: NavController,
    content: @Composable ((MenuType, Int) -> Job) -> Unit
) {
    val state = LocalState.current!!
    val scope = rememberCoroutineScope()
    val drawerState = rememberDrawerState(initialValue = DrawerValue.Closed)
    var bookIndex by rememberSaveable {
        mutableIntStateOf(0)
    }
    var menuType by rememberSaveable {
        mutableStateOf(MenuType.Chapter)
    }
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
                        .padding(horizontal = 16.dp),
                ) {
                    if (menuType == MenuType.Bible) {
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
                            items(state.bibles) { b ->
                                QuickButton(b) {
                                    scope.launch {
                                        drawerState.close()
                                        state.isLoading = true
                                        delay(500L)
                                    }.invokeOnCompletion {
                                        state.setBibleName(b)
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
                                        text = "Old Testament",
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
                                QuickButton(shortName(bookNames[b])) {
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
                                        text = "New Testament",
                                        fontSize = 18.sp,
                                        fontWeight = FontWeight.W500
                                    )
                                }
                            }
                            items(27) { i ->
                                val b = 39 + i
                                QuickButton(shortName(bookNames[b])) {
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
                                QuickButton("${c + 1}") {
                                    scope.launch {
                                        navController.navigate(
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
fun QuickButton(text: String, onClick: () -> Unit) {
    Button(
        shape = RoundedCornerShape(2.dp),
        contentPadding = PaddingValues(4.dp),
        onClick = onClick
    ) {
        Text(
            style = TextStyle(
                fontSize = 18.sp,
                fontWeight = FontWeight.W500,
            ),
            text = text,
        )
    }
}