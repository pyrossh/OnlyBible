import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_reactive_value/flutter_reactive_value.dart';
import '../domain/book.dart';
import '../domain/kannada_gen.dart';
import '../state.dart';

final tabIndex = ValueNotifier(0);
final tabBookIndex = ValueNotifier(0);

onTabBookChange(int i) {
  tabIndex.value = 1;
  tabBookIndex.value = i;
}

onTabChapterChange(int i) {
  selectedVerses.value.clear();
  onBookChange(tabBookIndex.value);
  onChapterChange(i);
  Timer(const Duration(seconds: 1), () {
    tabIndex.value = 0;
  });
}

class BookSelector extends StatelessWidget {
  const BookSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final tab = tabIndex.reactiveValue(context);
    if (tab == 1) {
      final book = kannadaBible[tabBookIndex.reactiveValue(context)];
      return Container(
          margin: const EdgeInsets.symmetric(vertical: 50, horizontal: 300),
          padding: const EdgeInsets.all(15),
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 10),
                child: Text(book.name,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 22,
                    )),
              ),
              const Expanded(flex: 1, child: ChaptersList()),
            ],
          ));
    }
    return Container(
        margin: const EdgeInsets.symmetric(vertical: 50, horizontal: 300),
        padding: const EdgeInsets.all(15),
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 10),
              child: Text("Old Testament",
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w400,
                    fontSize: 20,
                    color: Colors.grey,
                  )),
            ),
            Expanded(flex: 1, child: BooksList(offset: 0, books: oldTestament)),
            Container(
              margin: EdgeInsets.symmetric(vertical: 15),
              child: Text("New Testament",
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w400,
                    fontSize: 20,
                    color: Colors.grey,
                  )),
            ),
            Expanded(flex: 1, child: BooksList(offset: 39, books: newTestament)),
          ],
        ));
  }
}

class BooksList extends StatelessWidget {
  final int offset;
  final List<String> books;

  const BooksList({super.key, required this.offset, required this.books});

  @override
  Widget build(BuildContext context) {
    return GridView.extent(
        primary: false,
        padding: const EdgeInsets.all(0),
        crossAxisSpacing: 10.0,
        mainAxisSpacing: 10.0,
        maxCrossAxisExtent: 80.0,
        children: List.generate(books.length, (index) {
          return GestureDetector(
            onTap: () {
              onTabBookChange(offset+index);
            },
            child: Container(
              margin: const EdgeInsets.all(3),
              decoration: const BoxDecoration(
                color: Colors.blueGrey,
              ),
              child: Center(
                child: Text(
                    books[index]
                        .replaceAll(" ", "")
                        .substring(0, 3)
                        .toUpperCase(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    )),
              ),
            ),
          );
        }));
  }
}

class ChaptersList extends StatelessWidget {
  const ChaptersList({super.key});

  @override
  Widget build(BuildContext context) {
    final book = kannadaBible[tabBookIndex.reactiveValue(context)];

    return GridView.extent(
        primary: false,
        padding: const EdgeInsets.all(0),
        crossAxisSpacing: 10.0,
        mainAxisSpacing: 10.0,
        maxCrossAxisExtent: 80.0,
        children: List.generate(book.chapters.length, (index) {
          return GestureDetector(
            onTap: () {
              Navigator.pop(context, index);
              onTabChapterChange(index);
            },
            child: Container(
              margin: const EdgeInsets.all(3),
              decoration: const BoxDecoration(
                color: Colors.blueGrey,
              ),
              child: Center(
                child: Text((index+1).toString(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    )),
              ),
            ),
          );
        }));
  }
}
