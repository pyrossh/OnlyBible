package dev.pyrossh.onlyBible

import androidx.compose.animation.EnterTransition
import androidx.compose.animation.ExitTransition
import androidx.compose.animation.core.tween
import androidx.compose.runtime.Composable
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import androidx.navigation.compose.rememberNavController
import androidx.navigation.toRoute

@Composable
fun AppHost(model: AppViewModel) {
    val navController = rememberNavController()
    val navigateToChapter = { props: ChapterScreenProps ->
        model.resetScrollState()
        navController.navigate(props)
    }
    val onSwipeLeft = {
        val pair = model.getForwardPair()
        navigateToChapter(
            ChapterScreenProps(
                bookIndex = pair.first,
                chapterIndex = pair.second,
            )
        )
    }
    val onSwipeRight = {
        val pair = model.getBackwardPair()
        if (navController.previousBackStackEntry != null) {
            val previousBook =
                navController.previousBackStackEntry?.arguments?.getInt("bookIndex")
                    ?: 0
            val previousChapter =
                navController.previousBackStackEntry?.arguments?.getInt("chapterIndex")
                    ?: 0
//          println("currentBackStackEntry ${previousBook} ${previousChapter} || ${pair.first} ${pair.second}")
            if (previousBook == pair.first && previousChapter == pair.second) {
                model.resetScrollState()
                navController.popBackStack()
            } else {
                navigateToChapter(
                    ChapterScreenProps(
                        bookIndex = pair.first,
                        chapterIndex = pair.second,
                        dir = Dir.Right.name,
                    )
                )
            }
        } else {
            navigateToChapter(
                ChapterScreenProps(
                    bookIndex = pair.first,
                    chapterIndex = pair.second,
                    dir = Dir.Right.name
                )
            )
        }
    }
    NavHost(
        navController = navController,
        startDestination = ChapterScreenProps(0, 0)
    ) {
        composable<ChapterScreenProps>(
            enterTransition = {
                val props = this.targetState.toRoute<ChapterScreenProps>()
                slideIntoContainer(
                    Dir.valueOf(props.dir).slideDirection(),
                    tween(400),
                )
            },
            exitTransition = {
                ExitTransition.None
            },
            popEnterTransition = {
                EnterTransition.None
            },
            popExitTransition = {
                val props = this.targetState.toRoute<ChapterScreenProps>()
                slideOutOfContainer(
                    Dir.valueOf(props.dir).reverse().slideDirection(),
                    tween(400),
                )
            }
        ) {
            val props = it.toRoute<ChapterScreenProps>()
            ChapterScreen(
                model = model,
                onSwipeLeft = onSwipeLeft,
                onSwipeRight = onSwipeRight,
                bookIndex = props.bookIndex,
                chapterIndex = props.chapterIndex,
                navigateToChapter = navigateToChapter,
            )
        }
    }
}