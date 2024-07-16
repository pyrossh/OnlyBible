package dev.pyrossh.onlyBible

import android.app.Application
import android.content.Context
import android.content.Intent
import androidx.compose.runtime.MutableState
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.setValue
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
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.delay
import kotlinx.coroutines.flow.collectLatest
import kotlinx.coroutines.flow.distinctUntilChanged
import kotlinx.coroutines.flow.map
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import java.io.IOException
import java.util.concurrent.Future

internal val Context.dataStore by preferencesDataStore(name = "onlyBible")

class AppViewModel(application: Application) : AndroidViewModel(application) {
    private val context
        get() = getApplication<Application>()
    var isLoading by mutableStateOf(true)
    var isOnError by mutableStateOf(false)
    var bibleName by mutableStateOf("English")
    var verses by mutableStateOf(listOf<Verse>())
    var bookNames by mutableStateOf(listOf<String>())
    var showBottomSheet by mutableStateOf(false)
    var themeType by preferenceMutableState(
        coroutineScope = viewModelScope,
        context = context,
        keyName = "themeType",
        initialValue = ThemeType.Auto.name,
        defaultValue = ThemeType.Auto.name,
        getPreferencesKey = ::stringPreferencesKey,
    )
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


    fun isDarkTheme(isSystemDark: Boolean): Boolean {
        val themeType = ThemeType.valueOf(themeType)
        return themeType == ThemeType.Dark || (themeType == ThemeType.Auto && isSystemDark)
    }

    fun showSheet() {
        showBottomSheet = true
    }

    fun closeSheet() {
        showBottomSheet = false
    }

    fun setBibleName(context: Context, b: String) {
        bibleName = b
        context.getSharedPreferences("settings", Context.MODE_PRIVATE).edit().putString("bibleName", b).apply()
        loadBible(context)
    }

    fun loadBible(context: Context) {
        viewModelScope.launch(Dispatchers.IO) {
            launch(Dispatchers.Main) {
                isLoading = true
                isOnError = false
            }
            try {
                val buffer =
                    context.assets.open("bibles/${bibleName}.txt").bufferedReader()
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
                    verses = localVerses
                    bookNames = localVerses.distinctBy { it.bookName }.map { it.bookName }
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