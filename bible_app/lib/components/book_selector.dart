import 'dart:io' show Platform;
import "package:flutter/material.dart";
import "package:flutter_reactive_value/flutter_reactive_value.dart";
import "package:kannada_bible_app/screens/home.dart";
import "../domain/book.dart";
import "../domain/kannada_gen.dart";

final tabBookIndex = ValueNotifier(0);

onTabBookChange(int i) {
  tabBookIndex.value = i;
}

class BookSelector extends StatelessWidget {
  const BookSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final book = kannadaBible[tabBookIndex.reactiveValue(context)];

    return DefaultTabController(
      length: 2,
      animationDuration: Platform.isMacOS ? Duration.zero: const Duration(milliseconds: 300),
      child: Column(
        children: [
          SizedBox(
            width: 250,
            child: TabBar(
              labelPadding: EdgeInsets.zero,
              labelColor: Colors.black,
              labelStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
              indicator: BoxDecoration(
                border: Border.all(color: Colors.blue.shade700, width: 3),
                borderRadius: BorderRadius.circular(50),
              ),
              tabs: const [
                Tab(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.book_outlined, color: Colors.red, size: 24),
                      SizedBox(width: 8),
                      Text('BOOK'),
                    ],
                  ),
                ),
                Tab(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.bookmark_outline, color: Colors.blue, size: 24),
                      SizedBox(width: 8),
                      Text('CHAPTER'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 20),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(width: 1.5)),
            ),
          ),
          Flexible(
            child: TabBarView(
              children: [
                Container(
                  // margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        child: Text("Old Testament", style: Theme.of(context).textTheme.headlineMedium),
                      ),
                      Expanded(child: BooksList(offset: 0, books: oldTestament)),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 15),
                        child: Text("New Testament", style: Theme.of(context).textTheme.headlineMedium),
                      ),
                      Expanded(child: BooksList(offset: 39, books: newTestament)),
                    ],
                  ),
                ),
                Container(
                  // margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        child: Text(book.name, style: Theme.of(context).textTheme.headlineMedium),
                      ),
                      const Expanded(child: ChaptersList()),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class BooksList extends StatelessWidget {
  final int offset;
  final List<String> books;

  const BooksList({super.key, required this.offset, required this.books});

  @override
  Widget build(BuildContext context) {
    return GridView.extent(
      crossAxisSpacing: 10.0,
      mainAxisSpacing: 10.0,
      maxCrossAxisExtent: 80.0,
      children: List.generate(books.length, (index) {
        final name = books[index].replaceAll(" ", "").substring(0, 3).toUpperCase();
        return InkWell(
          onTap: () {
            DefaultTabController.of(context).animateTo(1);
            tabBookIndex.value = offset + index;
          },
          child: Container(
            margin: const EdgeInsets.all(3),
            decoration: const BoxDecoration(
              color: Color(0xFFC8C5C5),
            ),
            child: Center(
              child: Text(
                name,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.labelMedium,
              ),
            ),
          ),
        );
      }),
    );
  }
}

class ChaptersList extends StatelessWidget {
  const ChaptersList({super.key});

  @override
  Widget build(BuildContext context) {
    final bookIndex = tabBookIndex.reactiveValue(context);
    final book = kannadaBible[bookIndex];
    return GridView.extent(
      primary: false,
      padding: const EdgeInsets.all(0),
      crossAxisSpacing: 10.0,
      mainAxisSpacing: 10.0,
      maxCrossAxisExtent: 80.0,
      children: List.generate(book.chapters.length, (index) {
        return InkWell(
          onTap: () {
            HomeScreenRoute(book: book.name, chapter: index).go(context);
          },
          child: Container(
            margin: const EdgeInsets.all(3),
            decoration: const BoxDecoration(
              color: Color(0xFFC8C5C5),
            ),
            child: Center(
              child: Text(
                "${index + 1}",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.labelMedium,
              ),
            ),
          ),
        );
      }),
    );
  }
}
