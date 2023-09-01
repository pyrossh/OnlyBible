import "dart:typed_data";
import "package:only_bible_app/dialog.dart";
import "package:only_bible_app/state.dart";
import "package:url_launcher/url_launcher.dart";
import "package:flutter/foundation.dart" show defaultTargetPlatform, TargetPlatform;
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:flutter_azure_tts/flutter_azure_tts.dart";

extension MyIterable<E> on Iterable<E> {
  Iterable<E> sortedBy(Comparable Function(E e) key) => toList()..sort((a, b) => key(a).compareTo(key(b)));

  Iterable<E> removeBy(bool Function(E e) key) => toList()..removeWhere(key);

  Iterable<E> addBy(E e) => toList()..add(e);
}

extension AppContext on BuildContext {
  ThemeData get theme => Theme.of(this);

  AppLocalizations get l => engTitles.watch(this) && languageCode.watch(this) != "en"
      ? lookupAppLocalizations(const Locale("en"))
      : AppLocalizations.of(this)!;

  get hasAudio => l.audioVoice != "";

  double get actionsHeight {
    if (isIOS()) {
      return 80.0;
    }
    if (isWide) {
      return 60;
    }
    return 50.0;
  }

  bool get isWide {
    if (defaultTargetPlatform == TargetPlatform.android || defaultTargetPlatform == TargetPlatform.iOS) {
      return false;
    }
    final width = MediaQuery.of(this).size.width;
    return width > 700;
  }

  List<AppLocalizations> get supportedLocalizations {
    return AppLocalizations.supportedLocales
        .sortedBy((e) => e.languageCode)
        .map((e) => lookupAppLocalizations(e))
        .toList();
  }

  List<String> get bookNames {
    return [
      l.genesis,
      l.exodus,
      l.leviticus,
      l.numbers,
      l.deuteronomy,
      l.joshua,
      l.judges,
      l.ruth,
      l.firstSamuel,
      l.secondSamuel,
      l.firstKings,
      l.secondKings,
      l.firstChronicles,
      l.secondChronicles,
      l.ezra,
      l.nehemiah,
      l.esther,
      l.job,
      l.psalms,
      l.proverbs,
      l.ecclesiastes,
      l.song_of_solomon,
      l.isaiah,
      l.jeremiah,
      l.lamentations,
      l.ezekiel,
      l.daniel,
      l.hosea,
      l.joel,
      l.amos,
      l.obadiah,
      l.jonah,
      l.micah,
      l.nahum,
      l.habakkuk,
      l.zephaniah,
      l.haggai,
      l.zechariah,
      l.malachi,
      l.matthew,
      l.mark,
      l.luke,
      l.john,
      l.acts,
      l.romans,
      l.firstCorinthians,
      l.secondCorinthians,
      l.galatians,
      l.ephesians,
      l.philippians,
      l.colossians,
      l.firstThessalonians,
      l.secondThessalonians,
      l.firstTimothy,
      l.secondTimothy,
      l.titus,
      l.philemon,
      l.hebrews,
      l.james,
      l.firstPeter,
      l.secondPeter,
      l.firstJohn,
      l.secondJohn,
      l.thirdJohn,
      l.jude,
      l.revelation,
    ];
  }

  openUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      if (await launchUrl(uri)) {
        return;
      }
    }
    if (!mounted) return;
    showError(this, l.urlError);
  }
}

bool isDesktop() {
  return defaultTargetPlatform == TargetPlatform.macOS ||
      defaultTargetPlatform == TargetPlatform.windows ||
      defaultTargetPlatform == TargetPlatform.linux;
}

bool isIOS() {
  return defaultTargetPlatform == TargetPlatform.iOS;
}

bool isAndroid() {
  return defaultTargetPlatform == TargetPlatform.android;
}

Future<Uint8List> convertText(String langCode, String text) async {
  final ttsResponse = await AzureTts.getTts(TtsParams(
    voice: Voice(
      name: "",
      displayName: "",
      localName: "",
      shortName: langCode,
      gender: "",
      locale: langCode,
      sampleRateHertz: AudioOutputFormat.audio48khz96kBitrateMonoMp3,
      voiceType: "",
      status: "",
    ),
    audioFormat: AudioOutputFormat.audio48khz96kBitrateMonoMp3,
    rate: 0.90,
    text: text,
  ));
  return ttsResponse.audio.buffer.asUint8List();
}
