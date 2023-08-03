import 'dart:convert';
import 'dart:io' show GZipCodec, Platform;
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_persistent_value_notifier/flutter_persistent_value_notifier.dart';
import 'package:flutter_reactive_value/flutter_reactive_value.dart';
import 'models/book.dart';

final darkMode = PersistentValueNotifier<bool>(
  sharedPreferencesKey: 'darkMode',
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
// final theme = ValueNotifier<ThemeData>();

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
  final text = utf8.decode(GZipCodec().decode(bytes.buffer.asUint8List()));
  return getBibleFromText(text);
}

getBibleFromText(String text) {
  final List<Book> books = [];
  final items = text.split("\n").map((line) => line.split("|"));
  items.forEach((item) {
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
      books.add(Book(index: book, name: bookNames[book], localeName: bookNames[book], chapters: []));
    }
    if (books[book].chapters.length < chapter) {
      books[book].chapters.add(Chapter(verses: []));
    }
    books[book].chapters[chapter - 1].verses.add(Verse(
          text: verse,
          audioRange: TimeRange(start: start, end: end),
        ));
  });
  return books;
}

onPlay() {
  isPlaying.value = true;
}

onPause() {
  isPlaying.value = false;
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

final tabIndex = ValueNotifier(0);
final tabBookIndex = ValueNotifier(0);

onTabBookChange(int i) {
  tabBookIndex.value = i;
  tabIndex.value = 1;
}

resetTab() {
  SchedulerBinding.instance.addPostFrameCallback((_) {
    tabIndex.value = 0;
  });
}

bool isDesktop() {
  return Platform.isMacOS || Platform.isLinux || Platform.isWindows;
}

bool isDesktopMode(BuildContext context) {
  if (Platform.isMacOS || Platform.isLinux || Platform.isWindows) {
    return true;
  }
  final width = MediaQuery.of(context).size.width;
  return width > 550;
}
