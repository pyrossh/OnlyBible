import 'dart:io' show Platform;
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_reactive_value/flutter_reactive_value.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'utils/dialog.dart';
import 'components/book_selector.dart';

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