package dev.pyrossh.onlyBible

import android.app.Application
import android.app.LocaleManager
import android.content.Context
import android.content.Context.MODE_PRIVATE
import android.content.Intent
import android.os.Build
import android.os.LocaleList
import androidx.appcompat.app.AppCompatDelegate
import androidx.compose.foundation.lazy.LazyListState
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableIntStateOf
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.setValue
import androidx.core.os.LocaleListCompat
import androidx.lifecycle.AndroidViewModel
import androidx.lifecycle.viewModelScope
import com.microsoft.cognitiveservices.speech.SpeechConfig
import com.microsoft.cognitiveservices.speech.SpeechSynthesisEventArgs
import com.microsoft.cognitiveservices.speech.SpeechSynthesizer
import dev.pyrossh.onlyBible.domain.BOOKS_COUNT
import dev.pyrossh.onlyBible.domain.Verse
import dev.pyrossh.onlyBible.domain.Verse.Companion.chapterSizes
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
import java.util.Locale

class AppViewModel(application: Application) : AndroidViewModel(application) {
    private val context
        get() = getApplication<Application>()
    private val prefs
        get() = context.getSharedPreferences("data", MODE_PRIVATE)
    val speechService = SpeechSynthesizer(
        SpeechConfig.fromSubscription(
            BuildConfig.subscriptionKey,
            "centralindia"
        )
    )

    init {
        val started = { _: Any, _: SpeechSynthesisEventArgs ->
            isPlaying = true
        }
        val completed = { _: Any, _: SpeechSynthesisEventArgs ->
            isPlaying = false
        }
        speechService.SynthesisStarted.addEventListener(started)
        speechService.SynthesisCompleted.addEventListener(completed)
    }

    var isLoading by mutableStateOf(true)
    var isPlaying by mutableStateOf(false)
    var isOnError by mutableStateOf(false)
    val verses = MutableStateFlow(listOf<Verse>())
    val bookNames = MutableStateFlow(listOf<String>())
    var showBottomSheet by mutableStateOf(false)
    var highlightedVerses = MutableStateFlow(JSONObject())

    var bookIndex by mutableIntStateOf(0)
    var chapterIndex by mutableIntStateOf(0)
    var fontType by mutableStateOf(FontType.Sans)
    var fontSizeDelta by mutableIntStateOf(0)
    var fontBoldEnabled by mutableStateOf(false)
    var uiMode by mutableIntStateOf(0)
    var scrollState = LazyListState(
        0,
        0
    )

    private val _isSearching = MutableStateFlow(false)
    val isSearching = _isSearching.asStateFlow()

    //second state the text typed by the user
    private val _searchText = MutableStateFlow("")
    val searchText = _searchText.asStateFlow()

    @OptIn(FlowPreview::class)
    val versesList = _searchText.asStateFlow()
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
        _searchText.value = text
    }

    fun onOpenSearch() {
        _isSearching.value = true
        if (!_isSearching.value) {
            onSearchTextChange("")
        }
    }

    fun onCloseSearch() {
        _isSearching.value = false
        if (!_isSearching.value) {
            onSearchTextChange("")
        }
    }

    fun showSheet() {
        showBottomSheet = true
    }

    fun closeSheet() {
        showBottomSheet = false
    }

    fun loadData() {
        viewModelScope.launch(Dispatchers.IO) {
            uiMode = context.applicationContext.resources.configuration.uiMode
            bookIndex = prefs.getInt("bookIndex", 0)
            chapterIndex = prefs.getInt("chapterIndex", 0)
            fontType =
                FontType.valueOf(
                    prefs.getString("fontType", FontType.Sans.name) ?: FontType.Sans.name
                )
            fontSizeDelta = prefs.getInt("fontSizeDelta", 0)
            fontBoldEnabled = prefs.getBoolean("fontBoldEnabled", false)
            highlightedVerses.value = JSONObject(prefs.getString("highlightedVerses", "{}") ?: "{}")
            scrollState = LazyListState(
                prefs.getInt("scrollIndex", 0),
                prefs.getInt("scrollOffset", 0)
            )
            loadBible()
        }
    }

    fun loadBible() {
        viewModelScope.launch(Dispatchers.Main) {
            isLoading = true
            isOnError = false
        }
        try {
            val buffer =
                context.assets.open(
                    "bibles/${
                        context.getCurrentLocale().getDisplayLanguage(Locale.ENGLISH)
                    }.txt"
                )
                    .bufferedReader()
            val localVerses = buffer.readLines().filter { it.isNotEmpty() }.map {
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
            viewModelScope.launch(Dispatchers.Main) {
                verses.value = localVerses
                bookNames.value = localVerses.distinctBy { it.bookName }.map { it.bookName }
                isLoading = false
                isOnError = false
            }
        } catch (e: IOException) {
            e.printStackTrace()
            viewModelScope.launch(Dispatchers.Main) {
                isLoading = false
                isOnError = true
            }
        }
    }

    fun saveData() {
        viewModelScope.launch(Dispatchers.IO) {
            with(prefs.edit()) {
                putInt("bookIndex", bookIndex)
                putInt("chapterIndex", chapterIndex)
                putString("fontType", fontType.name)
                putInt("fontSizeDelta", fontSizeDelta)
                putBoolean("fontBoldEnabled", fontBoldEnabled)
                putString("highlightedVerses", highlightedVerses.value.toString())
                putInt("scrollIndex", scrollState.firstVisibleItemIndex)
                putInt("scrollOffset", scrollState.firstVisibleItemScrollOffset)
                apply()
                commit()
            }
        }
    }

    fun getForwardPair(): Pair<Int, Int> {
        val sizes = chapterSizes[bookIndex];
        if (sizes > chapterIndex + 1) {
            return Pair(bookIndex, chapterIndex + 1)
        }
        if (bookIndex + 1 < BOOKS_COUNT) {
            return Pair(bookIndex + 1, 0)
        }
        return Pair(0, 0)
    }

    fun getBackwardPair(): Pair<Int, Int> {
        if (chapterIndex - 1 >= 0) {
            return Pair(bookIndex, chapterIndex - 1)
        }
        if (bookIndex - 1 >= 0) {
            return Pair(bookIndex - 1, chapterSizes[bookIndex - 1] - 1)
        }
        return Pair(BOOKS_COUNT - 1, chapterSizes[BOOKS_COUNT - 1] - 1)
    }

    fun resetScrollState() {
        scrollState = LazyListState(0, 0)
    }

    fun getHighlightForVerse(v: Verse): Int? {
        if (highlightedVerses.value.has(v.key()))
            return highlightedVerses.value.getInt(v.key())
        return null
    }

    fun addHighlightedVerses(verses: List<Verse>, colorIndex: Int) {
        verses.forEach { v ->
            highlightedVerses.value.put(
                v.key(),
                colorIndex
            )
        }
    }

    fun removeHighlightedVerses(verses: List<Verse>) {
        verses.forEach { v ->
            highlightedVerses.value.remove(v.key())
        }
    }
}

fun shareVerses(context: Context, verses: List<Verse>) {
    val versesThrough =
        if (verses.size >= 3) "${verses.first().verseIndex + 1}-${verses.last().verseIndex + 1}" else verses.map { it.verseIndex + 1 }
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

fun setLocale(context: Context, loc: Locale) {
    if (Build.VERSION.SDK_INT >= 33) {
        val localeManager = context.getSystemService(LocaleManager::class.java)
        localeManager.applicationLocales = LocaleList(loc)
    } else {
        // For this to work you need to extend MainActivity with AppCompatActivity
        AppCompatDelegate.setApplicationLocales(
            LocaleListCompat.forLanguageTags(loc.language)
        )
    }
}