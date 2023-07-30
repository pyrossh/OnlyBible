import 'package:flutter/material.dart';
import 'package:flutter_reactive_value/flutter_reactive_value.dart';

final bookIndex = ValueNotifier(0);
final chapterIndex = ValueNotifier(0);
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
  if(selectedVerses.value.contains(i)) {
    selectedVerses.value.remove(i);
  } else {
    selectedVerses.value.add(i);
  }
}