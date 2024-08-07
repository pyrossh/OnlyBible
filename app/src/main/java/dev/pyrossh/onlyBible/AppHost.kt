package dev.pyrossh.onlyBible

import androidx.compose.animation.EnterTransition
import androidx.compose.animation.ExitTransition
import androidx.compose.animation.core.tween
import androidx.compose.runtime.Composable
import androidx.compose.runtime.CompositionLocalProvider
import androidx.navigation.NavType
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import androidx.navigation.compose.rememberNavController
import androidx.navigation.navArgument
import dev.pyrossh.onlyBible.utils.LocalNavController

@Composable
fun AppHost(
    model: AppViewModel
) {
    val navController = rememberNavController()
    if (!model.isLoading) {
        CompositionLocalProvider(LocalNavController provides navController) {
            NavHost(
                navController = navController,
                startDestination = "{bookId}:{chapterId}:{verseId}"
            ) {
                composable(
                    enterTransition = {
//                        val props = this.targetState.toRoute<ChapterScreenProps>()
                        slideIntoContainer(
                            Dir.valueOf(Dir.Left.name).slideDirection(),
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
//                        val props = this.targetState.toRoute<ChapterScreenProps>()
                        slideOutOfContainer(
                            Dir.valueOf(Dir.Left.name).reverse().slideDirection(),
                            tween(400),
                        )
                    },
                    route = "{bookId}:{chapterId}:{verseId}",
                    arguments = listOf(
                        navArgument("bookId") { type = NavType.IntType },
                        navArgument("chapterId") { type = NavType.IntType },
                        navArgument("verseId") { type = NavType.IntType },
                    ),
                ) {
                    ChapterScreen(
                        model = model,
                        bookIndex = it.arguments?.getInt("bookId") ?: 0,
                        chapterIndex =  it.arguments?.getInt("chapterId") ?: 0,
                        verseIndex =  it.arguments?.getInt("verseId") ?: 0,
                    )
                }
            }
        }
    }
}