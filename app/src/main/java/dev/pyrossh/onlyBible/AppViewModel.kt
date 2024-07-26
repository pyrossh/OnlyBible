package dev.pyrossh.onlyBible

import android.app.Application
import android.app.LocaleConfig
import android.app.LocaleManager
import android.app.UiModeManager
import android.content.Context
import android.content.Context.MODE_PRIVATE
import android.content.Context.UI_MODE_SERVICE
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
import dev.pyrossh.onlyBible.domain.engTitles
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

    private var loadedOnce = false
    var isPlaying by mutableStateOf(false)
    val verses = MutableStateFlow(listOf<Verse>())
    val bookNames = MutableStateFlow(engTitles)
    var showBottomSheet by mutableStateOf(false)
    private val highlightedVerses = MutableStateFlow(JSONObject())

    var bookIndex by mutableIntStateOf(0)
    var chapterIndex by mutableIntStateOf(0)
    var fontType by mutableStateOf(FontType.Sans)
    var fontSizeDelta by mutableIntStateOf(0)
    var fontBoldEnabled by mutableStateOf(false)
    var lineSpacingDelta by mutableStateOf(0)
    var nightMode by mutableStateOf(UiModeManager.MODE_NIGHT_AUTO)
    var scrollState = LazyListState(
        0,
        0
    )
    val selectedVerses = MutableStateFlow(listOf<Verse>())

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

    fun setApplicationNightMode(v: Int) {
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

    fun loadData() {
        viewModelScope.launch(Dispatchers.IO) {
            loadedOnce = prefs.getBoolean("loadedOnce", false)
            if (!loadedOnce) {
                initLocales()
            }
            bookIndex = prefs.getInt("bookIndex", 0)
            chapterIndex = prefs.getInt("chapterIndex", 0)
            fontType =
                FontType.valueOf(
                    prefs.getString("fontType", FontType.Sans.name) ?: FontType.Sans.name
                )
            fontSizeDelta = prefs.getInt("fontSizeDelta", 0)
            fontBoldEnabled = prefs.getBoolean("fontBoldEnabled", false)
            lineSpacingDelta = prefs.getInt("lineSpacingDelta", 0)
            nightMode = prefs.getInt("nightMode", UiModeManager.MODE_NIGHT_AUTO)
            highlightedVerses.value = JSONObject(prefs.getString("highlightedVerses", "{}") ?: "{}")
            scrollState = LazyListState(
                prefs.getInt("scrollIndex", 0),
                prefs.getInt("scrollOffset", 0)
            )
            loadBible()
        }
    }

    fun loadBible() {
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
            }
        } catch (e: IOException) {
            e.printStackTrace()
        }
    }

    fun saveData() {
        viewModelScope.launch(Dispatchers.IO) {
            with(prefs.edit()) {
                putBoolean("loadedOnce", true)
                putInt("bookIndex", bookIndex)
                putInt("chapterIndex", chapterIndex)
                putString("fontType", fontType.name)
                putInt("fontSizeDelta", fontSizeDelta)
                putBoolean("fontBoldEnabled", fontBoldEnabled)
                putInt("lineSpacingDelta", lineSpacingDelta)
                putInt("nightMode", nightMode)
                putString("highlightedVerses", highlightedVerses.value.toString())
                putInt("scrollIndex", scrollState.firstVisibleItemIndex)
                putInt("scrollOffset", scrollState.firstVisibleItemScrollOffset)
                apply()
                commit()
            }
        }
    }

    fun getForwardPair(): Pair<Int, Int> {
        val sizes = chapterSizes[bookIndex]
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
            .joinToString(",")
    val title = "${verses[0].bookName} ${verses[0].chapterIndex + 1}:${versesThrough}"
    val text = verses.joinToString("\n") {
        it.text.replace("<span style=\"color:red;\">", "")
            .replace("<em>", "")
            .replace("</span>", "")
            .replace("</em>", "")
    }
    val sendIntent = Intent().apply {
        action = Intent.ACTION_SEND
        putExtra(Intent.EXTRA_TEXT, "${title}\n${text}")
        type = "text/plain"
    }
    val shareIntent = Intent.createChooser(sendIntent, null)
    context.startActivity(shareIntent)
}

fun initLocales() {
    if (Build.VERSION.SDK_INT >= 33) {
        // do nothing for now
    } else {
        AppCompatDelegate.setApplicationLocales(
            LocaleListCompat.create(
                Locale("en"),
                Locale("bn"),
                Locale("gu"),
                Locale("hi"),
                Locale("kn"),
                Locale("ml"),
                Locale("ne"),
                Locale("or"),
                Locale("pa"),
                Locale("ta"),
                Locale("te"),
            )
        )
    }
}

fun Context.getCurrentLocale(): Locale {
    return if (Build.VERSION.SDK_INT >= 33) {
        resources.configuration.locales.get(0)
    } else {
        AppCompatDelegate.getApplicationLocales().get(0) ?: Locale("en")
    }
}

fun Context.getSupportedLocales(): List<Locale> {
    if (Build.VERSION.SDK_INT >= 33) {
        val localeList = LocaleConfig(this).supportedLocales!!
        return arrayOfNulls<String>(localeList.size())
            .mapIndexed { i, _ -> localeList[i] }
            .sortedBy { it.getDisplayName(Locale.ENGLISH) }
    } else {
        androidx.compose.ui.text.intl.LocaleList.current.localeList
        val localeList = AppCompatDelegate.getApplicationLocales()
        return arrayOfNulls<String>(localeList.size())
            .mapIndexed { i, _ -> localeList[i]!! }
            .sortedBy { it.getDisplayName(Locale.ENGLISH) }
    }
}

fun Context.setLocale(loc: Locale) {
    if (Build.VERSION.SDK_INT >= 33) {
        val localeManager = getSystemService(LocaleManager::class.java)
        localeManager.applicationLocales = LocaleList(loc)
    } else {
        val locales = (listOf(loc) + getSupportedLocales())
            .joinToString(separator = ",") { it.language }
        AppCompatDelegate.setApplicationLocales(LocaleListCompat.forLanguageTags(locales))
    }
}