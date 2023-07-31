import 'package:flutter/material.dart';
import 'package:flutter_reactive_value/flutter_reactive_value.dart';
import "package:flutter_persistent_value_notifier/flutter_persistent_value_notifier.dart";

final bookIndex = PersistentValueNotifier(
  sharedPreferencesKey: "bookIndex",
  initialValue: 0,
);
final chapterIndex = PersistentValueNotifier(
  sharedPreferencesKey: "chapterIndex",
  initialValue: 0,
);
final selectedVerses = ValueNotifier([]);

onBookChange(int i) {
  bookIndex.value = i;
}

onChapterChange(int i) {
  chapterIndex.value = i;
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

final tabBookIndex = ValueNotifier(0);

onTabBookChange(int i) {
  tabBookIndex.value = i;
}
