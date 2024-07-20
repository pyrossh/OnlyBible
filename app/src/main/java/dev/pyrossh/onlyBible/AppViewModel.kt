package dev.pyrossh.onlyBible

import android.app.Application
import android.app.LocaleManager
import android.content.Context
import android.content.Intent
import android.os.Build
import android.os.LocaleList
import androidx.appcompat.app.AppCompatDelegate
import androidx.compose.foundation.lazy.LazyListState
import androidx.compose.runtime.MutableState
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableIntStateOf
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.setValue
import androidx.core.os.LocaleListCompat
import androidx.datastore.preferences.core.Preferences
import androidx.datastore.preferences.core.booleanPreferencesKey
import androidx.datastore.preferences.core.edit
import androidx.datastore.preferences.core.intPreferencesKey
import androidx.datastore.preferences.core.stringPreferencesKey
import androidx.datastore.preferences.preferencesDataStore
import androidx.lifecycle.AndroidViewModel
import androidx.lifecycle.viewModelScope
import com.microsoft.cognitiveservices.speech.SpeechConfig
import com.microsoft.cognitiveservices.speech.SpeechSynthesizer
import dev.pyrossh.onlyBible.domain.Verse
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.FlowPreview
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.SharingStarted
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.flow.collectLatest
import kotlinx.coroutines.flow.combine
import kotlinx.coroutines.flow.debounce
import kotlinx.coroutines.flow.distinctUntilChanged
import kotlinx.coroutines.flow.map
import kotlinx.coroutines.flow.stateIn
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import java.io.IOException
import java.util.Locale

internal val Context.dataStore by preferencesDataStore(name = "onlyBible")

class AppViewModel(application: Application) : AndroidViewModel(application) {
    private val context
        get() = getApplication<Application>()
    val speechService = SpeechSynthesizer(
        SpeechConfig.fromSubscription(
            BuildConfig.subscriptionKey,
            "centralindia"
        )
    )
    var isLoading by mutableStateOf(true)
    var isOnError by mutableStateOf(false)
    val verses = MutableStateFlow(listOf<Verse>())
    val bookNames = MutableStateFlow(listOf<String>())
    var showBottomSheet by mutableStateOf(false)
    var bookIndex by preferenceMutableState(
        coroutineScope = viewModelScope,
        context = context,
        keyName = "bookIndex",
        initialValue = 0,
        defaultValue = 0,
        getPreferencesKey = ::intPreferencesKey,
    )
    var chapterIndex by preferenceMutableState(
        coroutineScope = viewModelScope,
        context = context,
        keyName = "chapterIndex",
        initialValue = 0,
        defaultValue = 0,
        getPreferencesKey = ::intPreferencesKey,
    )
    var scrollState = LazyListState(
        0,
        0
    )
    var uiMode by mutableIntStateOf(0)
    var fontType by preferenceMutableState(
        coroutineScope = viewModelScope,
        context = context,
        keyName = "fontType",
        initialValue = FontType.Sans.name,
        defaultValue = FontType.Sans.name,
        getPreferencesKey = ::stringPreferencesKey,
    )
    var fontSizeDelta by preferenceMutableState(
        coroutineScope = viewModelScope,
        context = context,
        keyName = "fontSizeDelta",
        initialValue = 0,
        defaultValue = 0,
        getPreferencesKey = ::intPreferencesKey,
    )
    var fontBoldEnabled by preferenceMutableState(
        coroutineScope = viewModelScope,
        context = context,
        keyName = "fontBoldEnabled",
        initialValue = false,
        defaultValue = false,
        getPreferencesKey = ::booleanPreferencesKey,
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

    fun initData(p: Preferences) {
        uiMode = context.applicationContext.resources.configuration.uiMode
        scrollState = LazyListState(
            p[intPreferencesKey("scrollIndex")] ?: 0,
            p[intPreferencesKey("scrollOffset")] ?: 0
        )
    }

    fun resetScrollState() {
        scrollState = LazyListState(0, 0)
    }

    fun loadBible(loc: Locale, context: Context) {
        viewModelScope.launch(Dispatchers.IO) {
            launch(Dispatchers.Main) {
                isLoading = true
                isOnError = false
            }
            try {
                val buffer =
                    context.assets.open("bibles/${loc.getDisplayLanguage(Locale.ENGLISH)}.txt")
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
                launch(Dispatchers.Main) {
                    isLoading = false
                    isOnError = false
                    verses.value = localVerses
                    bookNames.value = localVerses.distinctBy { it.bookName }.map { it.bookName }
                }
            } catch (e: IOException) {
                e.printStackTrace()
                launch(Dispatchers.Main) {
                    isLoading = false
                    isOnError = true
                }
            }
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

private inline fun <reified T, reified NNT : T> preferenceMutableState(
    coroutineScope: CoroutineScope,
    context: Context,
    keyName: String,
    initialValue: T,
    defaultValue: T,
    getPreferencesKey: (keyName: String) -> Preferences.Key<NNT>,
): MutableState<T> {
    val snapshotMutableState: MutableState<T> = mutableStateOf(initialValue)
    val key: Preferences.Key<NNT> = getPreferencesKey(keyName)
    coroutineScope.launch {
        context.dataStore.data
            .map { if (it[key] == null) defaultValue else it[key] }
            .distinctUntilChanged()
            .collectLatest {
                withContext(Dispatchers.Main) {
                    snapshotMutableState.value = it as T
                }
            }
    }
    return object : MutableState<T> {
        override var value: T
            get() = snapshotMutableState.value
            set(value) {
                val rollbackValue = snapshotMutableState.value
                snapshotMutableState.value = value
                coroutineScope.launch {
                    try {
                        context.dataStore.edit {
                            if (value != null) {
                                it[key] = value as NNT
                            } else {
                                it.remove(key)
                            }
                        }
                    } catch (e: Exception) {
                        snapshotMutableState.value = rollbackValue
                    }
                }
            }

        override fun component1() = value
        override fun component2(): (T) -> Unit = { value = it }
    }
}