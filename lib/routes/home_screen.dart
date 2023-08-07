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
    if (slideTextDir.value == null) {
      return NoTransitionPage(
        child: SwipeDetector(
          onSwipeLeft: (offset) {
            onNext(context);
          },
          onSwipeRight: (offset) {
            onPrevious(context);
          },
          child: const Column(
            children: [
              Header(),
              Flexible(
                child: VerseList(),
              ),
            ],
          ),
        ),
      );
    }
    return CustomTransitionPage(
      barrierDismissible: false,
      barrierColor: Theme.of(context).colorScheme.background,
      transitionDuration: const Duration(milliseconds: 360),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return SwipeDetector(
          onSwipeLeft: (offset) {
            onNext(context);
          },
          onSwipeRight: (offset) {
            onPrevious(context);
          },
          child: Column(
            children: [
              const Header(),
              Flexible(
                child: SlideTransition(
                  textDirection: slideTextDir.value,
                  position: Tween(begin: const Offset(1, 0), end: Offset.zero)
                      .chain(CurveTween(curve: Curves.linear))
                      .animate(animation),
                  child: child,
                ),
              ),
            ],
          ),
        );
      },
      child: const VerseList(),
    );
  }
}

class VerseList extends StatelessWidget {
  const VerseList({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedBook = selectedBible.value[bookIndex.value];
    final verses = selectedBook.chapters[chapterIndex.value].verses;
    return SelectionArea(
      child: ListView.builder(
        shrinkWrap: false,
        padding: const EdgeInsets.only(
          left: 20,
          right: 20,
          bottom: 20,
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
    );
  }
}
