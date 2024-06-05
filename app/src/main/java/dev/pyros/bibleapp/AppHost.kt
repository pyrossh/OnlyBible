package dev.pyros.bibleapp

import androidx.compose.animation.AnimatedContentTransitionScope
import androidx.compose.animation.core.tween
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableIntStateOf
import androidx.compose.runtime.saveable.rememberSaveable
import androidx.compose.runtime.setValue
import androidx.navigation.NavType
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import androidx.navigation.compose.rememberNavController
import androidx.navigation.navArgument

@Composable
fun AppHost(verses: List<Verse>) {
    val navController = rememberNavController()
    var bookIndex by rememberSaveable {
        mutableIntStateOf(0)
    }
    val setBookIndex = { v: Int ->
        bookIndex = v
    }
    Drawer(navController, bookIndex, setBookIndex) { openDrawer ->
        NavHost(
            navController = navController,
            startDestination = "/books/{book}/chapters/{chapter}",
            enterTransition = {
                slideIntoContainer(
                    AnimatedContentTransitionScope.SlideDirection.Left,
                    tween(500),
                )
            },
//            exitTransition = {
//                slideOutOfContainer(
//                    AnimatedContentTransitionScope.SlideDirection.Left,
//                    tween(500),
//                )
//            },
            popEnterTransition = {
                slideIntoContainer(
                    AnimatedContentTransitionScope.SlideDirection.Right,
                    tween(500),
                )
            },
            popExitTransition = {
                slideOutOfContainer(
                    AnimatedContentTransitionScope.SlideDirection.Right,
                    tween(500),
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