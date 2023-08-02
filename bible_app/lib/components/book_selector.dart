import "package:flutter/material.dart";
import "package:flutter_reactive_value/flutter_reactive_value.dart";
import '../domain/book.dart';
import '../state.dart';
import 'books_list.dart';
import 'chapters_list.dart';

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
