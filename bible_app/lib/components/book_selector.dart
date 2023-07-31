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

// class CounterPage extends StatefulWidget {
//   _CounterPageState createState() => _CounterPageState();
// }
//
// class _CounterPageState extends State<CounterPage> {
//   int count = 0;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Widget Communication")),
//       body: Center(
//           child: Count(
//             count: count,
//             onCountSelected: () {
//               print("Count was selected.");
//             },
//             onCountChanged: (int val) {
//               setState(() => count += val);
//             },
//           )
//       ),
//     );
//   }
// }

class BookSelector extends StatelessWidget {
  const BookSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final book = kannadaBible[tabBookIndex.reactiveValue(context)];

    return DefaultTabController(
      length: 2,
      // animationDuration: Platform.isMacOS ? Duration.zero: const Duration(milliseconds: 300),
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
          Expanded(
            child: TabBarView(
              children: [
                ListView(children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 20, left: 10),
                    child: Text("Old Testament", style: Theme.of(context).textTheme.headlineMedium),
                  ),
                  BooksList(offset: 0, books: oldTestament),
                  Container(
                    padding: const EdgeInsets.only(bottom: 20, top: 40, left: 10),
                    child: Text("New Testament", style: Theme.of(context).textTheme.headlineMedium),
                  ),
                  BooksList(offset: 39, books: newTestament),
                ]),
                ListView(children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 10, left: 10),
                    child: Text(book.name, style: Theme.of(context).textTheme.headlineMedium),
                  ),
                  const ChaptersList(),
                ]),
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
    return Wrap(
      children: List.generate(books.length, (index) {
        final name = books[index].replaceAll(" ", "").substring(0, 3).toUpperCase();
        return InkWell(
          borderRadius: const BorderRadius.all(Radius.circular(30)),
          onTap: () {
            DefaultTabController.of(context).animateTo(1);
            tabBookIndex.value = offset + index;
          },
          child: Container(
            width: 90,
            height: 50,
            margin: const EdgeInsets.all(8),
            child: Material(
              elevation: 3,
              borderRadius: const BorderRadius.all(Radius.circular(30)),
              child: Center(
                child: Text(
                  name,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.labelMedium,
                ),
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
    return Wrap(
      children: List.generate(book.chapters.length, (index) {
        return InkWell(
          borderRadius: const BorderRadius.all(Radius.circular(30)),
          onTap: () {
            HomeScreenRoute(book: book.name, chapter: index).go(context);
          },
          child: Container(
            width: 90,
            height: 50,
            margin: const EdgeInsets.all(8),
            child: Material(
              elevation: 3,
              borderRadius: const BorderRadius.all(Radius.circular(30)),
              child: Center(
                child: Text(
                  "${index + 1}",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.labelMedium,
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
