package dev.pyrossh.onlyBible

import Verse
import androidx.compose.animation.AnimatedContentTransitionScope
import androidx.compose.animation.core.tween
import androidx.compose.runtime.Composable
import androidx.navigation.NavType
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import androidx.navigation.compose.rememberNavController
import androidx.navigation.navArgument

@Composable
fun AppHost(verses: List<Verse>) {
    val navController = rememberNavController()
    Drawer(navController) { openDrawer ->
        NavHost(
            navController = navController,
            startDestination = "/books/0/chapters/0?dir=left",
        ) {
            composable(
                route = "/books/{book}/chapters/{chapter}?dir={dir}",
                arguments = listOf(
                    navArgument("book") { type = NavType.IntType },
                    navArgument("chapter") { type = NavType.IntType },
                    navArgument("dir") { type = NavType.StringType },
                ),
                enterTransition = {
                    val dir = this.targetState.arguments?.getString("dir") ?: "left"
                    val slideDirection = when (dir) {
                        "left" -> AnimatedContentTransitionScope.SlideDirection.Left
                        else -> AnimatedContentTransitionScope.SlideDirection.Right
                    }
                    slideIntoContainer(
                        slideDirection,
                        tween(400),
                    )
                },
//            exitTransition = {
//                slideOutOfContainer(
//                    AnimatedContentTransitionScope.SlideDirection.Left,
//                    tween(300),
//                )
//            },
                popEnterTransition = {
                    slideIntoContainer(
                        AnimatedContentTransitionScope.SlideDirection.Right,
                        tween(400),
                    )
                },
                popExitTransition = {
                    slideOutOfContainer(
                        AnimatedContentTransitionScope.SlideDirection.Right,
                        tween(400),
                    )
                }
            ) {
                ChapterScreen(
                    verses = verses,
                    bookIndex = it.arguments?.getInt("book")!!,
                    chapterIndex = it.arguments?.getInt("chapter")!!,
                    navController = navController,
                    openDrawer = openDrawer,
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
//        }
//    }
    }
}