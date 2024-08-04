package dev.pyrossh.onlyBible.utils

import androidx.compose.runtime.compositionLocalOf
import androidx.navigation.NavController

val LocalNavController = compositionLocalOf<NavController> { error("No NavController found!") }