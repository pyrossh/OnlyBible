import 'dart:convert';
import 'package:flutter/foundation.dart' show defaultTargetPlatform, TargetPlatform;
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_persistent_value_notifier/flutter_persistent_value_notifier.dart';
import 'package:flutter_reactive_value/flutter_reactive_value.dart';
import 'package:go_router/go_router.dart';
import 'package:just_audio/just_audio.dart';
import 'package:only_bible_app/utils.dart';
import 'package:only_bible_app/utils/dialog.dart';
import 'package:only_bible_app/models.dart';

final shellNavigatorKey = GlobalKey<NavigatorState>();
final routeNavigatorKey = GlobalKey<NavigatorState>();

final darkMode = PersistentValueNotifier<bool>(
  sharedPreferencesKey: 'darkMode',
  initialValue: false,
);

final fontBold = PersistentValueNotifier<bool>(
  sharedPreferencesKey: 'fontBold',
  initialValue: false,
);

final selectedBibleId = PersistentValueNotifier(
  sharedPreferencesKey: 'selectedBibleId',
  initialValue: 1,
);

final bookIndex = PersistentValueNotifier<int>(
  sharedPreferencesKey: 'bookIndex',
  initialValue: 0,
);

final chapterIndex = PersistentValueNotifier<int>(
  sharedPreferencesKey: 'chapterIndex',
  initialValue: 0,
);

final slideTextDir = ValueNotifier<TextDirection?>(null);
final selectedBible = ValueNotifier<Bible?>(null);
final selectedVerses = ValueNotifier([]);
final isPlaying = ValueNotifier(false);
final fontSizeDelta = ValueNotifier(0);

bool isWide(BuildContext context) {
  if (defaultTargetPlatform == TargetPlatform.android || defaultTargetPlatform == TargetPlatform.iOS) {
    return false;
  }
  final width = MediaQuery.of(context).size.width;
  return width > 600;
}

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
      systemNavigationBarColor: Color(0xFF1F1F22),
      statusBarColor: Color(0xFF1F1F22),
      systemNavigationBarIconBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.light,
    ));
  } else {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.white,
      statusBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.dark,
    ));
  }
}

changeBible(BuildContext context, int i) {
  selectedBibleId.value = i;
  loadBible();
  // This page is invoked with the other navigator so can't use context.pop()
  Navigator.of(context).pop();
}

navigateBookChapter(BuildContext context, int book, int chapter, bool noAnim) {
  if (isWide(context) || noAnim) {
    slideTextDir.value = null;
  } else {
    slideTextDir.value = bookIndex.value > book || chapterIndex.value > chapter ? TextDirection.rtl : TextDirection.ltr;
  }
  bookIndex.value = book;
  chapterIndex.value = chapter;
  context.push("/${selectedBible.value!.books[book].name}/$chapter");
  // Use this or use navigatorKey once header moves scaffold
  // if (!isWide(context)) {
  //   Navigator.of(context).pop();
  // }
}

onNext(BuildContext context) {
  final selectedBook = selectedBible.value!.books[bookIndex.value];
  final chapter = chapterIndex.value;
  if (selectedBook.chapters.length > chapter + 1) {
    navigateBookChapter(context, selectedBook.index, chapter + 1, false);
  } else {
    if (selectedBook.index + 1 < selectedBible.value!.books.length) {
      final nextBook = selectedBible.value!.books[selectedBook.index + 1];
      navigateBookChapter(context, nextBook.index, 0, false);
    }
  }
}

onPrevious(BuildContext context) {
  final selectedBook = selectedBible.value!.books[bookIndex.value];
  final chapter = chapterIndex.value;
  if (chapter - 1 >= 0) {
    navigateBookChapter(context, selectedBook.index, chapter - 1, false);
  } else {
    if (selectedBook.index - 1 >= 0) {
      final prevBook = selectedBible.value!.books[selectedBook.index - 1];
      navigateBookChapter(context, prevBook.index, prevBook.chapters.length - 1, false);
    }
  }
}

loadBible() async {
  final bible = bibles.firstWhere((it) => it.id == selectedBibleId.value);
  final books = await getBibleFromAsset(bible.name);
  selectedBible.value = Bible.withBooks(
    id: bible.id,
    name: bible.name,
    books: books,
  );
}

getBibleFromAsset(String file) async {
  final bytes = await rootBundle.load("assets/bibles/$file.txt");
  return getBibleFromText(utf8.decode(bytes.buffer.asUint8List(), allowMalformed: false));
}

onPlay(BuildContext context) async {
  final verses = selectedBible.value!.books[bookIndex.value].chapters[chapterIndex.value].verses;
  final filteredVerses = verses.asMap().keys.where((it) => selectedVerses.value.contains(it)).map((it) => verses[it]);
  final player = AudioPlayer();
  player.setUrl(
    "https://github.com/pyrossh/only-bible-app/raw/master/assets/output.mp3",
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
