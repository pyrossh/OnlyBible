package dev.pyrossh.onlyBible

import android.app.UiModeManager
import android.content.Context
import android.content.Context.MODE_PRIVATE
import android.content.Context.UI_MODE_SERVICE
import android.content.Intent
import android.text.Html
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableIntStateOf
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.setValue
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.microsoft.cognitiveservices.speech.SpeechConfig
import com.microsoft.cognitiveservices.speech.SpeechSynthesisEventArgs
import com.microsoft.cognitiveservices.speech.SpeechSynthesizer
import dev.pyrossh.onlyBible.domain.BOOKS_COUNT
import dev.pyrossh.onlyBible.domain.Bible
import dev.pyrossh.onlyBible.domain.Verse
import dev.pyrossh.onlyBible.domain.bibles
import dev.pyrossh.onlyBible.domain.chapterSizes
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.FlowPreview
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.SharingStarted
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.flow.combine
import kotlinx.coroutines.flow.debounce
import kotlinx.coroutines.flow.stateIn
import kotlinx.coroutines.launch
import org.json.JSONObject
import java.io.IOException

class AppViewModel : ViewModel() {
    val speechService = SpeechSynthesizer(
        SpeechConfig.fromSubscription(
            BuildConfig.subscriptionKey,
            "centralindia"
        )
    )
    private val started = { _: Any, _: SpeechSynthesisEventArgs ->
        isAudioPlaying = true
    }
    private val completed = { _: Any, _: SpeechSynthesisEventArgs ->
        isAudioPlaying = false
    }

    init {
        speechService.SynthesisStarted.addEventListener(started)
        speechService.SynthesisCompleted.addEventListener(completed)
    }

    override fun onCleared() {
        super.onCleared()
        speechService.SynthesisStarted.removeEventListener(started)
        speechService.SynthesisCompleted.removeEventListener(completed)
    }

    var isLoading by mutableStateOf(true)
    var isAudioPlaying by mutableStateOf(false)
    val verses = MutableStateFlow(listOf<Verse>())
    val bookNames = MutableStateFlow(listOf<String>())
    private val highlightedVerses = MutableStateFlow(JSONObject())

    var bible by mutableStateOf(bibles.first())
    var bookIndex by mutableIntStateOf(0)
    var chapterIndex by mutableIntStateOf(0)
    var verseIndex by mutableIntStateOf(0)
    var fontType by mutableStateOf(FontType.Sans)
    var fontSizeDelta by mutableIntStateOf(0)
    var fontBoldEnabled by mutableStateOf(false)
    var lineSpacingDelta by mutableIntStateOf(0)
    var nightMode by mutableIntStateOf(UiModeManager.MODE_NIGHT_AUTO)
    val selectedVerses = MutableStateFlow(listOf<Verse>())
    val searchText = MutableStateFlow("")

    @OptIn(FlowPreview::class)
    val searchedVerses = searchText.asStateFlow()
        .debounce(300)
        .combine(verses.asStateFlow()) { text, verses ->
            verses.filter { verse ->
                if (text.trim().isEmpty())
                    false
                else
                    verse.text.lowercase().contains(
                        text.trim().lowercase()
                    )
            }
        }.stateIn(
            scope = viewModelScope,
            started = SharingStarted.WhileSubscribed(5000),
            initialValue = listOf()
        )

    fun onSearchTextChange(text: String) {
        searchText.value = text
    }

    fun setApplicationNightMode(context: Context, v: Int) {
        val uiModeManager = context.getSystemService(UI_MODE_SERVICE) as UiModeManager
        uiModeManager.setApplicationNightMode(v)
        nightMode = v
    }

    fun setSelectedVerses(verses: List<Verse>) {
        selectedVerses.value = verses
    }

    fun clearSelectedVerses() {
        selectedVerses.value = listOf()
    }

    fun loadData(context: Context) {
        viewModelScope.launch(Dispatchers.IO) {
            viewModelScope.launch(Dispatchers.Main) {
                isLoading = true
            }
            val prefs = context.getSharedPreferences("data", MODE_PRIVATE)
            val bibleFileName = prefs.getString("bible", "en_kjv") ?: "en_kjv"
            bookIndex = prefs.getInt("bookIndex", 0)
            chapterIndex = prefs.getInt("chapterIndex", 0)
            verseIndex = prefs.getInt("verseIndex", 0)
            fontType = FontType.valueOf(
                prefs.getString("fontType", FontType.Sans.name) ?: FontType.Sans.name
            )
            fontSizeDelta = prefs.getInt("fontSizeDelta", 0)
            fontBoldEnabled = prefs.getBoolean("fontBoldEnabled", false)
            lineSpacingDelta = prefs.getInt("lineSpacingDelta", 0)
            nightMode = prefs.getInt("nightMode", UiModeManager.MODE_NIGHT_AUTO)
            highlightedVerses.value = JSONObject(prefs.getString("highlightedVerses", "{}") ?: "{}")
            val localBible = bibles.find { it.filename() == bibleFileName } ?: bibles.first()
            loadBible(localBible, context)
            viewModelScope.launch(Dispatchers.Main) {
                isLoading = false
            }
        }
    }

    fun loadBible(b: Bible, context: Context) {
        try {
            val buffer =
                context.assets.open("bibles/${b.filename()}.txt").bufferedReader()
            val localVerses = buffer.readLines().filter { it.isNotEmpty() }.map {
                val arr = it.split("|")
                val bookName = arr[0]
                val book = arr[1].toInt()
                val chapter = arr[2].toInt()
                val verseNo = arr[3].toInt()
                val heading = arr[4]
                val verseText = arr.subList(5, arr.size).joinToString("|")
                Verse(
                    id = "${book}:${chapter}:${verseNo}",
                    bookIndex = book,
                    bookName = bookName,
                    chapterIndex = chapter,
                    verseIndex = verseNo,
                    heading = heading,
                    text = verseText,
                )
            }
            viewModelScope.launch(Dispatchers.Main) {
                bible = b
                verses.value = localVerses
                bookNames.value = localVerses.distinctBy { it.bookName }.map { it.bookName }
            }
        } catch (e: IOException) {
            e.printStackTrace()
        }
    }

    fun saveData(context: Context) {
        viewModelScope.launch(Dispatchers.IO) {
            val prefs = context.getSharedPreferences("data", MODE_PRIVATE)
            with(prefs.edit()) {
                putString("bible", bible.filename())
                putInt("bookIndex", bookIndex)
                putInt("chapterIndex", chapterIndex)
                putInt("verseIndex", verseIndex)
                putString("fontType", fontType.name)
                putInt("fontSizeDelta", fontSizeDelta)
                putBoolean("fontBoldEnabled", fontBoldEnabled)
                putInt("lineSpacingDelta", lineSpacingDelta)
                putInt("nightMode", nightMode)
                putString("highlightedVerses", highlightedVerses.value.toString())
                apply()
                commit()
            }
        }
    }

    fun getHighlightForVerse(v: Verse): Int? {
        if (highlightedVerses.value.has(v.id))
            return highlightedVerses.value.getInt(v.id)
        return null
    }

    fun addHighlightedVerses(verses: List<Verse>, colorIndex: Int) {
        verses.forEach { v ->
            highlightedVerses.value.put(
                v.id,
                colorIndex
            )
        }
    }

    fun removeHighlightedVerses(verses: List<Verse>) {
        verses.forEach { v ->
            highlightedVerses.value.remove(v.id)
        }
    }

    fun playAudio(text: String) {
        speechService.StartSpeakingSsml(
            """
            <speak version="1.0" xmlns="http://www.w3.org/2001/10/synthesis" xml:lang="en-US">
                <voice name="${bible.voiceName}">
                    $text
                </voice>
            </speak>
        """
        )
    }
}

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

fun shareVerses(context: Context, verses: List<Verse>) {
    val versesThrough =
        if (verses.size >= 3) "${verses.first().verseIndex + 1}-${verses.last().verseIndex + 1}" else verses.map { it.verseIndex + 1 }
            .joinToString(",")
    val title = "${verses[0].bookName} ${verses[0].chapterIndex + 1}:${versesThrough}"
    val text =
        Html.fromHtml(verses.joinToString("\n") { it.text }, Html.FROM_HTML_MODE_COMPACT).toString()
    val sendIntent = Intent().apply {
        action = Intent.ACTION_SEND
        putExtra(Intent.EXTRA_TEXT, "${title}\n${text}")
        type = "text/plain"
    }
    val shareIntent = Intent.createChooser(sendIntent, null)
    context.startActivity(shareIntent)
}