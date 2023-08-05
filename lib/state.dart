import 'dart:convert';
import 'dart:io' show GZipCodec, Platform;
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_persistent_value_notifier/flutter_persistent_value_notifier.dart';
import 'package:flutter_reactive_value/flutter_reactive_value.dart';
import 'package:just_audio/just_audio.dart';
import 'package:only_bible_app/utils/dialog.dart';
import 'package:only_bible_app/models/book.dart';

final darkMode = PersistentValueNotifier<bool>(
  sharedPreferencesKey: 'darkMode',
  initialValue: false,
);

final fontBold = PersistentValueNotifier<bool>(
  sharedPreferencesKey: 'fontBold',
  initialValue: false,
);

final selectedBibleName = PersistentValueNotifier<String>(
  sharedPreferencesKey: 'selectedBibleName',
  initialValue: "kannada.csv.gz",
);

final bookIndex = PersistentValueNotifier<int>(
  sharedPreferencesKey: 'bookIndex',
  initialValue: 0,
);

final chapterIndex = PersistentValueNotifier<int>(
  sharedPreferencesKey: 'chapterIndex',
  initialValue: 0,
);

final selectedBible = ValueNotifier<List<Book>>([]);
final selectedVerses = ValueNotifier([]);
final isPlaying = ValueNotifier(false);
final fontSizeDelta = ValueNotifier(0);

toggleMode() {
  darkMode.value = !darkMode.value;
  updateStatusBar();
}

toggleBold() {
  fontBold.value = !fontBold.value;
}

increaseFont() {
  fontSizeDelta.value += 1;
}

decreaseFont() {
  fontSizeDelta.value -= 1;
}

updateStatusBar() {
  if (darkMode.value) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.black,
      systemNavigationBarIconBrightness: Brightness.light,
      statusBarColor: Colors.black,
      statusBarIconBrightness: Brightness.light,
    ));
  } else {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
    ));
  }
}

saveBookIndex(int book, int chapter) {
  bookIndex.value = book;
  chapterIndex.value = chapter;
}

loadBible() async {
  final value = await getBibleFromAsset(selectedBibleName.value);
  selectedBible.value = value;
}

getBibleFromAsset(String file) async {
  final bytes = await rootBundle.load("assets/$file");
  final decodedBytes = GZipCodec().decode(bytes.buffer.asUint8List());
  return getBibleFromText(utf8.decode(decodedBytes, allowMalformed: false));
}

getBibleFromText(String text) {
  final List<Book> books = [];
  final items = text.split("\n").map((line) => line.split("|"));
  for (var item in items) {
    var book = int.parse(item[0]);
    var chapter = int.parse(item[1]);
    var verse = item[3];
    double start = 0;
    double end = 0;
    if (item.length > 4) {
      start = double.parse(item[4]);
      end = double.parse(item[5]);
    }
    if (books.length - 1 < book) {
      books.add(
        Book(
          index: book,
          name: bookNames[book],
          localeName: bookNames[book],
          chapters: [],
        ),
      );
    }
    if (books[book].chapters.length < chapter) {
      // ignore: prefer_const_constructors
      books[book].chapters.add(Chapter(verses: []));
    }
    books[book].chapters[chapter - 1].verses.add(
          Verse(
            text: verse,
            audioRange: TimeRange(start: start, end: end),
          ),
        );
  }
  return books;
}

onPlay(BuildContext context) async {
  final verses = selectedBible.value[bookIndex.value].chapters[chapterIndex.value].verses;
  final filteredVerses = verses.asMap().keys.where((it) => selectedVerses.value.contains(it)).map((it) => verses[it]);
  final player = AudioPlayer();
  player.setUrl(
    "https://github.com/pyrossh/bible-app/raw/master/public/audio/output.mp3",
  );
  // player.setUrl("asset:output.mp3");
  if (isPlaying.value) {
    await player.pause();
    isPlaying.value = false;
  } else {
    try {
      isPlaying.value = true;
      for (final v in filteredVerses) {
        await player.setClip(
          start: Duration(milliseconds: (v.audioRange.start * 1000).toInt()),
          end: Duration(milliseconds: (v.audioRange.end * 1000).toInt()),
        );
        await player.play();
        await player.pause();
      }
    } catch (err) {
      showError(context, "Could not play audio");
    } finally {
      await player.pause();
      isPlaying.value = false;
    }
  }
}

isVerseSelected(BuildContext context, int i) {
  return selectedVerses.reactiveValue(context).contains(i);
}

onVerseSelected(int i) {
  if (selectedVerses.value.contains(i)) {
    selectedVerses.value = [...selectedVerses.value.where((it) => it != i)];
  } else {
    selectedVerses.value = [...selectedVerses.value, i];
  }
}

bool isWide(BuildContext context) {
  if (Platform.isIOS || Platform.isAndroid) {
    return false;
  }
  final width = MediaQuery.of(context).size.width;
  return width > 600;
}
