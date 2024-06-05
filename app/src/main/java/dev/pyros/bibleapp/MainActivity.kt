package dev.pyros.bibleapp

import android.os.Bundle
import android.util.Log
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.activity.enableEdgeToEdge
import bookNames
import dev.pyros.bibleapp.ui.theme.BibleAppTheme
import java.io.BufferedReader

data class Verse(
    val bookIndex: Int,
    val bookName: String,
    val chapterIndex: Int,
    val verseIndex: Int,
    val heading: String,
    val text: String
)

fun parseBibleTxt(name: String, buffer: BufferedReader): List<Verse> {
    Log.i("loading", "parsing bible $name")
    return buffer.readLines().filter { it.isNotEmpty() }.map {
        val arr = it.split("|")
        val book = arr[0].toInt()
        val chapter = arr[1].toInt()
        val verseNo = arr[2].toInt()
        val heading = arr[3]
        val verseText = arr.subList(4, arr.size).joinToString("|")
        Verse(
            bookIndex = book,
            bookName = bookNames[book],
            chapterIndex = chapter,
            verseIndex = verseNo,
            heading = heading,
            text = verseText,
        )
    }
}

class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        enableEdgeToEdge()
        val verses = parseBibleTxt("English", assets.open("English.txt").bufferedReader())
        setContent {
            BibleAppTheme {
                AppHost(verses = verses)
            }
        }
    }
}

