import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_reactive_value/flutter_reactive_value.dart';
import 'package:kannada_bible_app/utils/dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'components/book_selector.dart';

final selectedVerses = ValueNotifier([]);
final isPlaying = ValueNotifier(false);

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

Future<void> saveState(int bookIndex, int chapterIndex) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setInt("bookIndex", bookIndex);
  await prefs.setInt("chapterIndex", chapterIndex);
}

Future<(int, int)> loadState() async {
  final prefs = await SharedPreferences.getInstance();
  final bookIndex = prefs.getInt("bookIndex") ?? 0;
  final chapterIndex = prefs.getInt("chapterIndex") ?? 0;
  return (bookIndex, chapterIndex);
}

bool isDesktop() {
  return Platform.isMacOS || Platform.isLinux || Platform.isWindows;
}


showBookMenu(BuildContext context) {
  tabBookIndex.value = 0;
  showCustomDialog<(int, int)>(context, BookSelector()).then((rec) {
    if (rec != null) {
      // selectedVerses.value.clear();
      // onBookChange(rec.$1);
      // onChapterChange(rec.$2);
      SchedulerBinding.instance.addPostFrameCallback((duration) {
        tabIndex.value = 0;
      });
    }
  });
}