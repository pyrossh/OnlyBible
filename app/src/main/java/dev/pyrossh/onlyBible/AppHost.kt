package dev.pyrossh.onlyBible

import androidx.compose.animation.AnimatedContentTransitionScope
import androidx.compose.animation.core.tween
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.wrapContentHeight
import androidx.compose.material3.CircularProgressIndicator
import androidx.compose.runtime.Composable
import androidx.compose.runtime.SideEffect
import androidx.compose.runtime.getValue
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.lifecycle.viewmodel.compose.viewModel
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import androidx.navigation.compose.rememberNavController
import androidx.navigation.toRoute
import dev.burnoo.compose.rememberpreference.rememberIntPreference

@Composable
fun AppHost(model: AppViewModel = viewModel()) {
    val navController = rememberNavController()
    var bookIndex by rememberIntPreference(keyName = "bookIndex", initialValue = 0, defaultValue = 0)
    var chapterIndex by rememberIntPreference(keyName = "chapterIndex", initialValue = 0, defaultValue = 0)
    if (model.isLoading) {
        Box(
            modifier = Modifier
                .fillMaxWidth()
                .wrapContentHeight()
        ) {
            Column(
                modifier = Modifier.fillMaxSize(),
                verticalArrangement = Arrangement.Center,
                horizontalAlignment = Alignment.CenterHorizontally
            ) {
                CircularProgressIndicator()
            }
        }
    } else {
        val bookNames = model.verses.distinctBy { it.bookName }.map { it.bookName }
        AppDrawer(navController = navController) { openDrawer ->
            NavHost(
                navController = navController,
                startDestination = ChapterScreenProps(bookIndex, chapterIndex)
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
                        bookIndex = props.bookIndex
                        chapterIndex = props.chapterIndex
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

}