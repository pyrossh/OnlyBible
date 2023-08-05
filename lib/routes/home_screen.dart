import "package:flutter/material.dart";
import 'package:go_router/go_router.dart';
import 'package:only_bible_app/components/header.dart';
import 'package:only_bible_app/components/verse_view.dart';
import 'package:only_bible_app/state.dart';

class HomeScreen extends GoRouteData {
  final String book;
  final int chapter;

  HomeScreen({required this.book, required this.chapter}) {
    selectedVerses.value.clear();
  }

  @override
  Page buildPage(BuildContext context, GoRouterState state) {
    final selectedBook = selectedBible.value.firstWhere((it) => book == it.name);
    final verses = selectedBook.chapters[chapter].verses;
    return NoTransitionPage(
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: isWide(context) ? 40 : 20,
        ),
        child: Column(
          children: [
            Header(book: selectedBook.index, chapter: chapter, verses: verses),
            Flexible(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 20),
                itemCount: verses.length,
                itemBuilder: (BuildContext context, int index) {
                  final v = verses[index];
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    child: VerseText(index: index, text: v.text),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
