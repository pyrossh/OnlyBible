package dev.pyros.bibleapp

import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.absolutePadding
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.lazy.grid.GridCells
import androidx.compose.foundation.lazy.grid.LazyVerticalGrid
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Close
import androidx.compose.material3.Button
import androidx.compose.material3.ButtonDefaults
import androidx.compose.material3.DrawerDefaults
import androidx.compose.material3.DrawerValue
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.ModalDrawerSheet
import androidx.compose.material3.ModalNavigationDrawer
import androidx.compose.material3.Text
import androidx.compose.material3.rememberDrawerState
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.rememberCoroutineScope
import androidx.compose.runtime.saveable.rememberSaveable
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.RectangleShape
import androidx.compose.ui.text.TextStyle
import androidx.compose.ui.text.font.FontFamily
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.navigation.NavController
import bookNames
import chapterSizes
import kotlinx.coroutines.Job
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

@Composable
fun NonlazyGrid(
    columns: Int,
    itemCount: Int,
    modifier: Modifier = Modifier,
    content: @Composable() (Int) -> Unit
) {
    Column(modifier = modifier) {
        var rows = (itemCount / columns)
        if (itemCount.mod(columns) > 0) {
            rows += 1
        }

        for (rowId in 0 until rows) {
            val firstIndex = rowId * columns

            Row {
                for (columnId in 0 until columns) {
                    val index = firstIndex + columnId
                    Box(
                        modifier = Modifier
                            .fillMaxWidth()
                            .weight(1f)
                    ) {
                        if (index < itemCount) {
                            content(index)
                        }
                    }
                }
            }
        }
    }
}

@Composable
fun Drawer(
    navController: NavController,
    bookIndex: Int,
    setBookIndex: (Int) -> Unit,
    content: @Composable ((MenuType) -> Job) -> Unit
) {
    val scope = rememberCoroutineScope()
    val drawerState = rememberDrawerState(initialValue = DrawerValue.Closed)
    var menuType by rememberSaveable {
        mutableStateOf(MenuType.Chapter)
    }
    val openDrawer = { m: MenuType ->
        menuType = m
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
                drawerContainerColor = Color.White,
                drawerContentColor = Color.Black,
                drawerTonalElevation = 0.dp,
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
                            "Select a ${menuType.name.lowercase()}",
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
                    LazyVerticalGrid(
                        modifier = Modifier.fillMaxSize(),
                        verticalArrangement = Arrangement.spacedBy(10.dp),
                        horizontalArrangement = Arrangement.spacedBy(10.dp),
                        columns = GridCells.Fixed(
                            count = when (menuType) {
                                MenuType.Bible -> 2
                                MenuType.Book -> 4
                                MenuType.Chapter -> 5
                            }
                        )
                    ) {
                        items(
                            when (menuType) {
                                MenuType.Bible -> 1
                                MenuType.Book -> bookNames.size
                                MenuType.Chapter -> chapterSizes[bookIndex]
                            }
                        ) { c ->
                            Button(
                                shape = RoundedCornerShape(2.dp),
                                colors = ButtonDefaults.buttonColors(
                                    containerColor = Color(0xFFEAE9E9),
                                    contentColor = Color.Black,
                                ),
                                contentPadding = PaddingValues(4.dp),
                                elevation = ButtonDefaults.elevatedButtonElevation(),
                                onClick = {
                                    scope.launch {
                                        when (menuType) {
                                            MenuType.Bible -> ""
                                            MenuType.Book -> {
                                                setBookIndex(c)
                                                menuType = MenuType.Chapter
//                                                navController.navigate(route = "/books/${c}/chapters/0")
                                            }
                                            MenuType.Chapter -> {
                                                navController.navigate(route = "/books/${bookIndex}/chapters/${c}")
                                            }
                                        }
                                        drawerState.close();
                                    }
                                }) {
                                Text(
                                    modifier = Modifier.padding(bottom = 4.dp),
                                    style = TextStyle(
//                                        fontFamily = FontFamily.Monospace,
                                        fontSize = 18.sp,
                                        fontWeight = FontWeight.W500,
                                        color = Color(0xFF8A4242)
                                    ),
                                    text = when (menuType) {
                                        MenuType.Bible -> ""
                                        MenuType.Book -> shortName(bookNames[c])
                                        MenuType.Chapter -> "${c + 1}"
                                    }
                                )
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