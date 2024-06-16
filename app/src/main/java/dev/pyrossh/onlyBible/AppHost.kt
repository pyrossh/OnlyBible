package dev.pyrossh.onlyBible

import Verse
import androidx.compose.animation.AnimatedContentTransitionScope
import androidx.compose.animation.core.tween
import androidx.compose.runtime.Composable
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import androidx.navigation.compose.rememberNavController
import androidx.navigation.toRoute

@Composable
fun AppHost(verses: List<Verse>) {
    val navController = rememberNavController()
    val state = LocalState.current!!
    Drawer(navController) { openDrawer ->
        NavHost(
            navController = navController,
            startDestination = ChapterScreenProps(state.getBookIndex(), state.getChapterIndex())
        ) {
            composable<ChapterScreenProps>(
                enterTransition = {
                    val props = this.targetState.toRoute<ChapterScreenProps>()
                    slideIntoContainer(
                        Dir.valueOf(props.dir).slideDirection(),
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
                val props = it.toRoute<ChapterScreenProps>()
                state.setBookIndex(props.bookIndex)
                state.setChapterIndex(props.chapterIndex)
                ChapterScreen(
                    verses = verses,
                    bookIndex = props.bookIndex,
                    chapterIndex = props.chapterIndex,
                    navController = navController,
                    openDrawer = openDrawer,
                )
            }
        }
    }
}