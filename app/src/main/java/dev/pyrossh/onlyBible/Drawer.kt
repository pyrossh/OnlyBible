package dev.pyrossh.onlyBible

import Verse
import android.annotation.SuppressLint
import android.util.Log
import androidx.compose.foundation.background
import androidx.compose.foundation.gestures.detectTapGestures
import androidx.compose.foundation.interaction.MutableInteractionSource
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.BoxWithConstraints
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.foundation.layout.Row
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
import androidx.compose.material3.DrawerValue
import androidx.compose.material3.DropdownMenu
import androidx.compose.material3.DropdownMenuItem
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.ModalDrawerSheet
import androidx.compose.material3.ModalNavigationDrawer
import androidx.compose.material3.Text
import androidx.compose.material3.rememberDrawerState
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableIntStateOf
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.rememberCoroutineScope
import androidx.compose.runtime.saveable.rememberSaveable
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.geometry.Offset
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.input.pointer.pointerInput
import androidx.compose.ui.platform.LocalDensity
import androidx.compose.ui.text.TextStyle
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.DpOffset
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.navigation.NavController
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

@SuppressLint("UnrememberedMutableInteractionSource")
@Composable
fun DropDownSample() {
    var expanded by remember { mutableStateOf(false) }
    var touchPoint: Offset by remember { mutableStateOf(Offset.Zero) }
    val density = LocalDensity.current

    BoxWithConstraints(
        Modifier
            .fillMaxSize()
            .background(Color.Cyan)
            .pointerInput(Unit) {
                detectTapGestures {
                    Log.d("TAG", "onCreate: ${it}")
                    touchPoint = it
                    expanded = true

                }

            }
    ) {
        val (xDp, yDp) = with(density) {
            (touchPoint.x.toDp()) to (touchPoint.y.toDp())
        }
        DropdownMenu(
            expanded = expanded,
            offset = DpOffset(xDp, -maxHeight + yDp),
            onDismissRequest = {
                expanded = false
            }
        ) {

            DropdownMenuItem(
                onClick = {
                    expanded = false
                },
                interactionSource = MutableInteractionSource(),
                text = {
                    Text("Copy")
                }
            )

            DropdownMenuItem(
                onClick = {
                    expanded = false
                },
                interactionSource = MutableInteractionSource(),
                text = {
                    Text("Get Balance")
                }
            )
        }
    }
}

@Composable
fun Drawer(
    navController: NavController,
    content: @Composable ((MenuType, Int) -> Job) -> Unit
) {
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
                                MenuType.Book -> Verse.bookNames.size
                                MenuType.Chapter -> Verse.chapterSizes[bookIndex]
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
                                                bookIndex = c
                                                menuType = MenuType.Chapter
                                            }
                                            MenuType.Chapter -> {
                                                navController.navigate(route = "/books/${bookIndex}/chapters/${c}")
                                                drawerState.close();
                                            }
                                        }
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
                                        MenuType.Book -> shortName(Verse.bookNames[c])
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