package dev.pyros.bibleapp

import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.lazy.grid.GridCells
import androidx.compose.foundation.lazy.grid.LazyVerticalGrid
import androidx.compose.material3.Button
import androidx.compose.material3.Divider
import androidx.compose.material3.DrawerValue
import androidx.compose.material3.ModalDrawerSheet
import androidx.compose.material3.ModalNavigationDrawer
import androidx.compose.material3.Text
import androidx.compose.material3.rememberDrawerState
import androidx.compose.runtime.Composable
import androidx.compose.runtime.rememberCoroutineScope
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.TextStyle
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.navigation.NavController
import kotlinx.coroutines.Job
import kotlinx.coroutines.launch

@Composable
fun Drawer(navController: NavController, content: @Composable (() -> Job) -> Unit) {
    val scope = rememberCoroutineScope()
    val drawerState = rememberDrawerState(initialValue = DrawerValue.Closed)
    val openDrawer = {
        scope.launch {
            drawerState.apply {
                if (isClosed) open() else close()
            }
        }
    }
    ModalNavigationDrawer(
        gesturesEnabled = false,
        drawerState = drawerState,
        drawerContent = {
            ModalDrawerSheet {
                Text("Choose a chapter", modifier = Modifier.padding(16.dp))
                Divider()
                LazyVerticalGrid(
                    columns = GridCells.Adaptive(minSize = 80.dp)
                ) {
                    items(32) { c ->
                        Button(
                            modifier = Modifier.padding(12.dp),
                            onClick = {
                                scope.launch {
                                    navController.navigate(route = "/books/0/chapters/${c}")
                                    drawerState.close();
                                }
                            }) {
                            Text(
                                modifier = Modifier.padding(bottom = 4.dp),
                                style = TextStyle(
                                    fontSize = 16.sp,
                                    fontWeight = FontWeight.W500,
                                    color = Color(0xFFFFFFFF),
                                ),
                                text = (c + 1).toString(),
                            )
                        }
                    }
                }
            }
        },
    ) {
        content(openDrawer)
    }
}