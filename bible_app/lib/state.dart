import 'package:flutter/material.dart';
import 'package:flutter_reactive_value/flutter_reactive_value.dart';
import 'package:shared_preferences/shared_preferences.dart';

final selectedVerses = ValueNotifier([]);

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

final tabBookIndex = ValueNotifier(0);

onTabBookChange(int i) {
  tabBookIndex.value = i;
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