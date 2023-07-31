import "package:flutter/material.dart";
import "package:flutter_reactive_value/flutter_reactive_value.dart";
import "package:kannada_bible_app/screens/home.dart";
import "../domain/book.dart";
import "../domain/kannada_gen.dart";

final tabIndex = ValueNotifier(0);
final tabBookIndex = ValueNotifier(0);

onTabBookChange(int i) {
  tabIndex.value = 1;
  tabBookIndex.value = i;
}

// class BookSelector extends StatelessWidget {
//   const BookSelector({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final tab = tabIndex.reactiveValue(context);
//     if (tab == 1) {
//       final book = kannadaBible[tabBookIndex.reactiveValue(context)];
//       return Container(
//         // margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
//         color: Colors.white,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Container(
//               margin: const EdgeInsets.only(bottom: 10),
//               child: Text(book.name, style: Theme.of(context).textTheme.headlineMedium),
//             ),
//             const Expanded(child: ChaptersList()),
//           ],
//         ),
//       );
//     }
//     return Container(
//       // margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
//       color: Colors.white,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Container(
//             margin: const EdgeInsets.only(bottom: 10),
//             child: Text("Old Testament", style: Theme.of(context).textTheme.headlineMedium),
//           ),
//           Expanded(child: BooksList(offset: 0, books: oldTestament)),
//           Container(
//             margin: const EdgeInsets.symmetric(vertical: 15),
//             child: Text("New Testament", style: Theme.of(context).textTheme.headlineMedium),
//           ),
//           Expanded(child: BooksList(offset: 39, books: newTestament)),
//         ],
//       ),
//     );
//   }
// }

class MyTabbedPage extends StatefulWidget {
  const MyTabbedPage({super.key});

  @override
  State<MyTabbedPage> createState() => _MyTabbedPageState();
}

class _MyTabbedPageState extends State<MyTabbedPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 2);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final book = kannadaBible[tabBookIndex.reactiveValue(context)];
    onBookTap(i) {
      _tabController.animateTo(1);
    }
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TabBar(
              // overlayColor:
              indicatorWeight: 10,
              dividerColor: Colors.black,
              labelColor: Colors.black,
              labelStyle: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
              ),
              indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: Colors.greenAccent,
              ),
              controller: _tabController,
              tabs: const [
                Tab(text: 'Book'),
                Tab(text: 'Chapter'),
              ],
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          Container(
            // margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: Text("Old Testament", style: Theme
                      .of(context)
                      .textTheme
                      .headlineMedium),
                ),
                Expanded(child: BooksList(offset: 0, books: oldTestament, onBookTap: onBookTap)),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 15),
                  child: Text("New Testament", style: Theme
                      .of(context)
                      .textTheme
                      .headlineMedium),
                ),
                Expanded(child: BooksList(offset: 39, books: newTestament, onBookTap: onBookTap)),
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
                  child: Text(book.name, style: Theme
                      .of(context)
                      .textTheme
                      .headlineMedium),
                ),
                const Expanded(child: ChaptersList()),
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
  final Function(int) onBookTap;

  const BooksList({super.key, required this.offset, required this.books, required this.onBookTap});

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
            onBookTap(offset + index);
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
                style: Theme
                    .of(context)
                    .textTheme
                    .labelMedium,
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
                style: Theme
                    .of(context)
                    .textTheme
                    .labelMedium,
              ),
            ),
          ),
        );
      }),
    );
  }
}
