package dev.pyrossh.onlyBible

import androidx.compose.animation.AnimatedContentTransitionScope
import androidx.compose.animation.core.tween
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.material3.CircularProgressIndicator
import androidx.compose.runtime.Composable
import androidx.compose.runtime.SideEffect
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.alpha
import androidx.lifecycle.viewmodel.compose.viewModel
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import androidx.navigation.compose.rememberNavController
import androidx.navigation.toRoute

@Composable
fun AppHost(model: AppViewModel = viewModel()) {
    val navController = rememberNavController()
    Box(
        modifier = Modifier.fillMaxSize().let {
            if (model.isLoading) it.alpha(0.5f) else it
        }
    ) {
        if (model.verses.isNotEmpty()) {
            AppDrawer(navController = navController) { openDrawer ->
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
//                exitTransition = {
//                    val props = this.targetState.toRoute<ChapterScreenProps>()
//                    slideOutOfContainer(
//                        Dir.valueOf(props.dir).slideDirection(),
//                        tween(400),
//                    )
//                },
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
                        SideEffect {
                            model.bookIndex = props.bookIndex
                            model.chapterIndex = props.chapterIndex
                        }
                        ChapterScreen(
                            model = model,
                            bookIndex = props.bookIndex,
                            chapterIndex = props.chapterIndex,
                            navController = navController,
                            openDrawer = openDrawer,
                        )
                    }
                }
            }
        }
        if (model.isLoading) {
            Column(
                modifier = Modifier.fillMaxSize(),
                verticalArrangement = Arrangement.Center,
                horizontalAlignment = Alignment.CenterHorizontally
            ) {
                CircularProgressIndicator()
            }
        }
    }
}