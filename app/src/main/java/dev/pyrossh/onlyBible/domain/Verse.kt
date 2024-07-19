package dev.pyrossh.onlyBible.domain

import android.os.Parcelable
import kotlinx.parcelize.Parcelize
import kotlinx.serialization.Serializable

const val BOOKS_COUNT = 66;

val engTitles = listOf(
    "Genesis",
    "Exodus",
    "Leviticus",
    "Numbers",
    "Deuteronomy",
    "Joshua",
    "Judges",
    "Ruth",
    "1 Samuel",
    "2 Samuel",
    "1 Kings",
    "2 Kings",
    "1 Chronicles",
    "2 Chronicles",
    "Ezra",
    "Nehemiah",
    "Esther",
    "Job",
    "Psalms",
    "Proverbs",
    "Ecclesiastes",
    "Song of Solomon",
    "Isaiah",
    "Jeremiah",
    "Lamentations",
    "Ezekiel",
    "Daniel",
    "Hosea",
    "Joel",
    "Amos",
    "Obadiah",
    "Jonah",
    "Micah",
    "Nahum",
    "Habakkuk",
    "Zephaniah",
    "Haggai",
    "Zechariah",
    "Malachi",
    "Matthew",
    "Mark",
    "Luke",
    "John",
    "Acts",
    "Romans",
    "1 Corinthians",
    "2 Corinthians",
    "Galatians",
    "Ephesians",
    "Philippians",
    "Colossians",
    "1 Thessalonians",
    "2 Thessalonians",
    "1 Timothy",
    "2 Timothy",
    "Titus",
    "Philemon",
    "Hebrews",
    "James",
    "1 Peter",
    "2 Peter",
    "1 John",
    "2 John",
    "3 John",
    "Jude",
    "Revelation",
)

@Serializable
@Parcelize
data class Verse(
    val bookIndex: Int,
    val bookName: String,
    val chapterIndex: Int,
    val verseIndex: Int,
    val heading: String,
    val text: String,
) : Parcelable {

    fun toSSML(voice: String): String {
        return """
            <speak version="1.0" xmlns="http://www.w3.org/2001/10/synthesis" xml:lang="en-US">
                <voice name="$voice">
                    $text
                </voice>
            </speak>
            """.trimIndent()
    }

    companion object {
        val chapterSizes = listOf(
            50,
            40,
            27,
            36,
            34,
            24,
            21,
            4,
            31,
            24,
            22,
            25,
            29,
            36,
            10,
            13,
            10,
            42,
            150,
            31,
            12,
            8,
            66,
            52,
            5,
            48,
            12,
            14,
            3,
            9,
            1,
            4,
            7,
            3,
            3,
            3,
            2,
            14,
            4,
            28,
            16,
            24,
            21,
            28,
            16,
            16,
            13,
            6,
            6,
            4,
            4,
            5,
            3,
            6,
            4,
            3,
            1,
            13,
            5,
            5,
            3,
            5,
            1,
            1,
            1,
            22
        )

        fun getForwardPair(book: Int, chapter: Int): Pair<Int, Int> {
            val sizes = chapterSizes[book];
            if (sizes > chapter + 1) {
                return Pair(book, chapter + 1)
            }
            if (book + 1 < BOOKS_COUNT) {
                return Pair(book + 1, 0)
            }
            return Pair(0, 0)
        }

        fun getBackwardPair(book: Int, chapter: Int): Pair<Int, Int> {
            if (chapter - 1 >= 0) {
                return Pair(book, chapter - 1)
            }
            if (book - 1 >= 0) {
                return Pair(book - 1, chapterSizes[book - 1] - 1)
            }
            return Pair(BOOKS_COUNT - 1, chapterSizes[BOOKS_COUNT - 1] - 1)
        }
    }
}
