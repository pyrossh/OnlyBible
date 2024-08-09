
import android.content.Intent
import android.text.Html
import domain.Verse

actual fun shareVerses(verses: List<Verse>) {
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
    //    context.startActivity(shareIntent)
}