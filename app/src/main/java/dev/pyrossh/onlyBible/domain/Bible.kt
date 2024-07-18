package dev.pyrossh.onlyBible.domain

import android.os.Parcelable
import kotlinx.parcelize.Parcelize
import kotlinx.serialization.Serializable

enum class BibleFamily {
    English,
    Indian,
    European,
    African;
}

@Serializable
@Parcelize
enum class Bible(
    val displayName: String,
    val fileName: String,
    val voiceName: String?,
    val code: String,
    val family: BibleFamily
) : Parcelable {
    English("English", "English", "en-GB-RyanNeural", "en", BibleFamily.English),
    Bengali("Bengali", "Bengali", "bn-IN-TanishaaNeural", "bn", BibleFamily.Indian),
    Gujarati("Gujarati", "Gujarati", "gu-IN-DhwaniNeural", "gu", BibleFamily.Indian),
    Hindi("Hindi", "Hindi", "hi-IN-SwaraNeural", "hi", BibleFamily.Indian),
    Kannada("Kannada", "Kannada", "kn-IN-GaganNeural", "kn", BibleFamily.Indian),
    Malayalam("Malayalam", "Malayalam", "ml-IN-SobhanaNeural", "ml", BibleFamily.Indian),
    Nepali("Nepali", "Nepali", "ne-NP-HemkalaNeural", "ne", BibleFamily.Indian),
    Oriya("Oriya", "Oriya", "or-IN-SubhasiniNeural", "or", BibleFamily.Indian),
    Punjabi("Punjabi", "Punjabi", "pa-IN-OjasNeural", "pa", BibleFamily.Indian),
    Tamil("Tamil", "Tamil", "ta-IN-PallaviNeural", "ta", BibleFamily.Indian),
    Telugu("Telugu", "Telugu", "te-IN-ShrutiNeural", "te", BibleFamily.Indian),
}