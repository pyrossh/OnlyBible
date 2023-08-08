import "package:flutter/material.dart";
import 'package:go_router/go_router.dart';
import 'package:only_bible_app/widgets/books_list.dart';
import 'package:only_bible_app/widgets/chapters_list.dart';
import 'package:only_bible_app/state.dart';

class BookSelector extends StatefulWidget {
  const BookSelector({super.key});

  @override
  State<StatefulWidget> createState() => BookSelectorState();
}

class BookSelectorState extends State<BookSelector> {
  int tab = 0;
  int bookIndex = 0;

  @override
  void initState() {
    super.initState();
    tab = 0;
  }

  onBookSelected(int index) {
    setState(() {
      bookIndex = index;
      tab = 1;
    });
  }

  onChapterSelected(int index) {
    navigateBookChapter(context, bookIndex, index, true);
  }

  @override
  Widget build(BuildContext context) {
    if (tab == 1) {
      final book = selectedBible.value!.books[bookIndex];
      return Container(
        margin: EdgeInsets.only(top: isWide(context) ? 5 : 0, left: 20),
        child: ChaptersList(
          title: book.name,
          length: book.chapters.length,
          onTap: onChapterSelected,
        ),
      );
    }
    final oldTestament = selectedBible.value!.books.where((it) => it.isOldTestament()).toList();
    final newTestament = selectedBible.value!.books.where((it) => it.isNewTestament()).toList();
    return Container(
      margin: EdgeInsets.only(top: isWide(context) ? 5 : 0, left: 20),
      child: ListView(
        children: [
          BooksList(
            title: "Old Testament",
            books: oldTestament,
            showClose: true,
            onTap: onBookSelected,
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 10),
          ),
          BooksList(
            title: "New Testament",
            books: newTestament,
            showClose: false,
            onTap: onBookSelected,
          ),
        ],
      ),
    );
  }
}
