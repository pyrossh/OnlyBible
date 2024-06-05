package dev.pyros.bibleapp

import androidx.compose.animation.AnimatedContentTransitionScope
import androidx.compose.animation.core.tween
import androidx.compose.material3.rememberModalBottomSheetState
import androidx.compose.runtime.Composable
import androidx.compose.runtime.rememberCoroutineScope
import androidx.compose.ui.Modifier
import androidx.navigation.NavType
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import androidx.navigation.compose.rememberNavController
import androidx.navigation.navArgument

@Composable
fun AppHost(verses: List<Verse>, modifier: Modifier = Modifier) {
    val navController = rememberNavController()
    NavHost(
        modifier = modifier,
        navController = navController,
        startDestination = "/books/{book}/chapters/{chapter}",
        enterTransition = {
            slideIntoContainer(
                AnimatedContentTransitionScope.SlideDirection.Left,
                tween(500),
            )
        },
        exitTransition = {
            slideOutOfContainer(
                AnimatedContentTransitionScope.SlideDirection.Left,
                tween(500),
            )
        },
//        popEnterTransition = {
//            slideIntoContainer(
//                AnimatedContentTransitionScope.SlideDirection.Right,
//                tween(500),
//            )
//        },
//        popExitTransition = {
//            slideOutOfContainer(
//                AnimatedContentTransitionScope.SlideDirection.Right,
//                tween(500),
//            )
//        }
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
                navController = navController,
            )
        }
    }
//    val scope = rememberCoroutineScope()
//    val sheetState = rememberModalBottomSheetState()
//    var showBottomSheet by rememberSaveable { mutableStateOf(false) }
//    val showSheet = {
//        showBottomSheet = true
//    }
//    if (showBottomSheet) {
//        ModalBottomSheet(
//            onDismissRequest = {
//                showBottomSheet = false
//            },
//            sheetState = sheetState
//        ) {
//            Text("All Chapters")
//            LazyVerticalGrid(
//                columns = GridCells.Adaptive(minSize = 128.dp)
//            ) {
//                items(chapters.size) { c ->
//                    Button(onClick = {
//                        changeChapter(c)
//                        scope.launch {
//                            sheetState.hide()
//                        }.invokeOnCompletion {
//                            if (!sheetState.isVisible) {
//                                showBottomSheet = false
//                            }
//                        }
//                    }) {
//                        Text(
//                            modifier = Modifier.padding(bottom = 4.dp),
//                            style = TextStyle(
//                                fontSize = 16.sp,
//                                fontWeight = FontWeight.W500,
//                                color = Color(0xFF9A1111),
//                            ),
//                            text = (c + 1).toString(),
//                        )
//                    }
//                }
//            }
//        }
//    }
}