package dev.pyrossh.onlyBible

import androidx.compose.animation.EnterTransition
import androidx.compose.animation.ExitTransition
import androidx.compose.animation.core.tween
import androidx.compose.runtime.Composable
import androidx.lifecycle.viewmodel.compose.viewModel
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import androidx.navigation.compose.rememberNavController
import androidx.navigation.toRoute

@Composable
fun AppHost(model: AppViewModel = viewModel()) {
    val navController = rememberNavController()
    val navigateToChapter = { props: ChapterScreenProps ->
        model.resetScrollState()
        navController.navigate(props)
    }
    if (!model.isLoading) {
        NavHost(
            navController = navController,
            startDestination = ChapterScreenProps(model.bookIndex, model.chapterIndex)
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
                    bookIndex = props.bookIndex,
                    chapterIndex = props.chapterIndex,
                    navigateToChapter = navigateToChapter,
                )
            }
        }
    }
}