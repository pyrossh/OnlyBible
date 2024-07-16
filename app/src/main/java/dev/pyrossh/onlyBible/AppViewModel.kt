package dev.pyrossh.onlyBible

import android.content.Context
import android.content.Intent
import android.content.SharedPreferences
import androidx.compose.runtime.State
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.setValue
import androidx.compose.runtime.staticCompositionLocalOf
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.microsoft.cognitiveservices.speech.SpeechConfig
import com.microsoft.cognitiveservices.speech.SpeechSynthesizer
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.delay
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import java.io.IOException
import java.util.concurrent.Future

val LocalSettings = staticCompositionLocalOf<AppViewModel?> { null }

data class UiState(
    val isLoading: Boolean,
    val isOnError: Boolean,
    val bibleName: String,
    val verses: List<Verse>,
)

class AppViewModel() : ViewModel() {

    private fun getPrefs(context: Context): SharedPreferences {
        return context.getSharedPreferences("settings", Context.MODE_PRIVATE)
    }

    private val _uiState = mutableStateOf(
        UiState(
            isLoading = true,
            isOnError = false,
            bibleName = "English",
            verses = listOf(),
        )
    )
    val uiState: State<UiState> = _uiState
    var showBottomSheet by mutableStateOf(false)

    fun showSheet() {
        showBottomSheet = true
    }

    fun closeSheet() {
        showBottomSheet = false
    }

    fun setBibleName(context: Context, b: String) {
        _uiState.value = uiState.value.copy(
            bibleName = b,
        )
        getPrefs(context).edit().putString("bibleName", b).apply()
        loadBible(context)
    }


    fun loadBible(context: Context) {
        viewModelScope.launch(Dispatchers.IO) {
            launch(Dispatchers.Main) {
                _uiState.value = uiState.value.copy(
                    isLoading = true,
                    isOnError = false,
                )
            }
            try {
                val buffer =
                    context.assets.open("bibles/${_uiState.value.bibleName}.txt").bufferedReader()
                val verses = buffer.readLines().filter { it.isNotEmpty() }.map {
                    val arr = it.split("|")
                    val bookName = arr[0]
                    val book = arr[1].toInt()
                    val chapter = arr[2].toInt()
                    val verseNo = arr[3].toInt()
                    val heading = arr[4]
                    val verseText = arr.subList(5, arr.size).joinToString("|")
                    Verse(
                        bookIndex = book,
                        bookName = bookName,
                        chapterIndex = chapter,
                        verseIndex = verseNo,
                        heading = heading,
                        text = verseText,
                    )
                }
                launch(Dispatchers.Main) {
                    _uiState.value = uiState.value.copy(
                        isLoading = false,
                        isOnError = false,
                        verses = verses
                    )
                }
            } catch (e: IOException) {
                e.printStackTrace()
                launch(Dispatchers.Main) {
                    _uiState.value = uiState.value.copy(
                        isLoading = false,
                        isOnError = true,
                    )
                }
            }
        }
    }
}

val speechService = SpeechSynthesizer(
    SpeechConfig.fromSubscription(
        BuildConfig.subscriptionKey,
        "centralindia"
    )
)

suspend fun <T> Future<T>.wait(timeoutMs: Int = 30000): T? {
    val start = System.currentTimeMillis()
    while (!isDone) {
        if (System.currentTimeMillis() - start > timeoutMs)
            return null
        delay(500)
    }
    return withContext(Dispatchers.IO) {
        get()
    }
}

suspend fun convertVersesToSpeech(scope: CoroutineScope, verses: List<Verse>) {
    withContext(Dispatchers.IO) {
        for (v in verses) {
            speechService.SpeakSsmlAsync(
                """
            <speak version="1.0" xmlns="http://www.w3.org/2001/10/synthesis" xml:lang="en-US">
                <voice name="en-US-AvaMultilingualNeural">
                    ${v.text}
                </voice>
            </speak>
            """.trimIndent()
            )
        }
    }
}

fun stopVerses(scope: CoroutineScope, verses: List<Verse>) {
    //TODOD
}

fun shareVerses(context: Context, verses: List<Verse>) {
    val items = verses.sortedBy { it.verseIndex }
    val versesThrough =
        if (items.size >= 3) "${items.first().verseIndex + 1}-${items.last().verseIndex + 1}" else items.map { it.verseIndex + 1 }
            .joinToString(",");
    val title = "${verses[0].bookName} ${verses[0].chapterIndex + 1}:${versesThrough}"
    val text = verses.joinToString("\n") {
        it.text.replace("<span style=\"color:red;\">", "")
            .replace("<em>", "")
            .replace("</span>", "")
            .replace("</em>", "")
    };
    val sendIntent = Intent().apply {
        action = Intent.ACTION_SEND
        putExtra(Intent.EXTRA_TEXT, "${title}\n${text}")
        type = "text/plain"
    }
    val shareIntent = Intent.createChooser(sendIntent, null)
    context.startActivity(shareIntent)
}