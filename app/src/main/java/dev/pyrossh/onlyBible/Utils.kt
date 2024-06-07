
import com.microsoft.cognitiveservices.speech.SpeechConfig
import com.microsoft.cognitiveservices.speech.SpeechSynthesizer
import dev.pyrossh.onlyBible.BuildConfig
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.delay
import kotlinx.coroutines.withContext
import java.util.concurrent.Future


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
    for (v in verses) {
        speechService.SpeakSsmlAsync(
            """
            <speak version="1.0" xmlns="http://www.w3.org/2001/10/synthesis" xml:lang="en-US">
                <voice name="en-US-AvaMultilingualNeural">
                    ${v.text}
                </voice>
            </speak>
            """.trimIndent()
        ).wait()
    }
}