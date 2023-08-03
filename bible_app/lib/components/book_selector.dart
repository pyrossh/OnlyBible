import "package:flutter/material.dart";
import "package:flutter_reactive_value/flutter_reactive_value.dart";
import '../models/book.dart';
import '../state.dart';
import 'books_list.dart';
import 'chapters_list.dart';

// TODO: use local state for tab instead of global

class BookSelector extends StatelessWidget {
  const BookSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final tab = tabIndex.reactiveValue(context);
    if (tab == 1) {
      return Container(
        margin: const EdgeInsets.only(top: 15, left: 20),
        child: const ChaptersList(),
      );
    }
    final oldTestament = selectedBible.value.where((it) => it.isOldTestament()).map((it) => it.name).toList();
    final newTestament = selectedBible.value.where((it) => it.isNewTestament()).map((it) => it.name).toList();
    return Container(
      margin: const EdgeInsets.only(top: 15, left: 20),
      child: ListView(
        children: [
          BooksList(title: "Old Testament", offset: 0, books: oldTestament),
          Container(
            margin: const EdgeInsets.only(bottom: 10),
          ),
          BooksList(title: "New Testament", offset: 39, books: newTestament),
        ],
      ),
    );
  }
}
