package dev.pyros.bibleapp

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
            startDestination = "/books/{book}/chapters/{chapter}",
            enterTransition = {
                slideIntoContainer(
                    AnimatedContentTransitionScope.SlideDirection.Left,
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