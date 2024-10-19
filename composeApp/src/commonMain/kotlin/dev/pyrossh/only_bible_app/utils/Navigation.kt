package utils

import androidx.compose.runtime.compositionLocalOf
import androidx.navigation.NavController
import dev.pyrossh.only_bible_app.domain.BOOKS_COUNT
import dev.pyrossh.only_bible_app.domain.chapterSizes

val LocalNavController = compositionLocalOf<NavController> { error("No NavController found!") }

fun getForwardPair(bookIndex: Int, chapterIndex: Int): Pair<Int, Int> {
    val sizes = chapterSizes[bookIndex]
    if (sizes > chapterIndex + 1) {
        return Pair(bookIndex, chapterIndex + 1)
    }
    if (bookIndex + 1 < BOOKS_COUNT) {
        return Pair(bookIndex + 1, 0)
    }
    return Pair(0, 0)
}

fun getBackwardPair(bookIndex: Int, chapterIndex: Int): Pair<Int, Int> {
    if (chapterIndex - 1 >= 0) {
        return Pair(bookIndex, chapterIndex - 1)
    }
    if (bookIndex - 1 >= 0) {
        return Pair(bookIndex - 1, chapterSizes[bookIndex - 1] - 1)
    }
    return Pair(BOOKS_COUNT - 1, chapterSizes[BOOKS_COUNT - 1] - 1)
}