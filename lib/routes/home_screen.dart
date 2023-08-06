import "package:flutter/material.dart";
import 'package:flutter_swipe_detector/flutter_swipe_detector.dart';
import 'package:go_router/go_router.dart';
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
    return CustomTransitionPage(
      barrierDismissible: false,
      barrierColor: Theme.of(context).colorScheme.background,
      transitionDuration: const Duration(milliseconds: 360),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          textDirection: slideTextDir.value,
          position: Tween(begin: const Offset(1, 0), end: Offset.zero)
              .chain(CurveTween(curve: Curves.linear))
              .animate(animation),
          child: child,
        );
      },
      child: SwipeDetector(
        onSwipeLeft: (offset) {
          onNext(context);
        },
        onSwipeRight: (offset) {
          onPrevious(context);
        },
        child: SelectionArea(
          child: ListView.builder(
            padding: EdgeInsets.symmetric(
              horizontal: isWide(context) ? 40 : 20,
              vertical: 8,
            ),
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
    );
  }
}
