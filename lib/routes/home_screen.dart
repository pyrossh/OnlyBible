import "package:flutter/material.dart";
import 'package:flutter_swipe_detector/flutter_swipe_detector.dart';
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
      child: SwipeDetector(
        onSwipeLeft: (offset) {
          if (selectedBook.chapters.length > chapter + 1) {
            navigateBookChapter(context, selectedBook.index, chapter + 1);
          } else {
            if (selectedBook.index + 1 < selectedBible.value.length) {
              final nextBook = selectedBible.value[selectedBook.index + 1];
              navigateBookChapter(context, nextBook.index, 0);
            }
          }
        },
        onSwipeRight: (offset) {
          if (chapter - 1 >= 0) {
            navigateBookChapter(context, selectedBook.index, chapter - 1);
          } else {
            if (selectedBook.index - 1 >= 0) {
              final prevBook = selectedBible.value[selectedBook.index - 1];
              navigateBookChapter(context, prevBook.index, prevBook.chapters.length - 1);
            }
          }
        },
        child: Container(
          margin: EdgeInsets.symmetric(
            horizontal: isWide(context) ? 40 : 20,
          ),
          child: Column(
            children: [
              const Header(),
              Flexible(
                child: SelectionArea(
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
