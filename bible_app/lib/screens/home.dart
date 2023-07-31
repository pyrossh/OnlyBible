import "package:flutter/material.dart";
import 'package:go_router/go_router.dart';
import "../components/book_selector.dart";
import "../components/header.dart";
import "../domain/kannada_gen.dart";
import "../components/verse.dart";
import "../state.dart";

part 'home.g.dart';

@TypedGoRoute<HomeScreenRoute>(
  path: "/:book/:chapter",
)
@immutable
class HomeScreenRoute extends GoRouteData {
  final String book;
  final int chapter;

  HomeScreenRoute({required this.book, required this.chapter}) {
    selectedVerses.value.clear();
  }

  @override
  Page buildPage(BuildContext context, GoRouterState state) {
    final selectedBook = kannadaBible.firstWhere((it) => book == it.name);
    final verses = selectedBook.chapters[chapter].verses;

    return NoPageTransition(
      child: Column(
        children: [
          Header(bookName: selectedBook.name, chapter: chapter),
          Flexible(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(
                vertical: 20,
                horizontal: 40,
              ),
              itemCount: verses.length,
              itemBuilder: (BuildContext context, int index) {
                final v = verses[index];
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  child: Verse(index: v.index - 1, text: v.text),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

@TypedGoRoute<SelectScreenRoute>(
  path: "/select",
)
@immutable
class SelectScreenRoute extends GoRouteData {
  SelectScreenRoute() {
    tabIndex.value = 0;
  }

  @override
  Page buildPage(BuildContext context, GoRouterState state) {
    return NoPageTransition(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Header(bookName: "", chapter: 1),
          Flexible(
            child: Container(
              margin: const EdgeInsets.only(left: 40, top: 20, right: 300),
              child: const BookSelector(),
            ),
          ),
        ],
      ),
    );
  }
}

class NoPageTransition extends CustomTransitionPage {
  NoPageTransition({required super.child})
      : super(
            transitionDuration: const Duration(milliseconds: 0),
            reverseTransitionDuration:  const Duration(milliseconds: 0),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            });
}

// key: state.pageKey,
// barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
// barrierDismissible: true,
// barrierColor: Colors.black.withOpacity(0.7),
// transitionDuration: const Duration(milliseconds: 0),
// reverseTransitionDuration: const Duration(milliseconds: 0),
// transitionsBuilder: (context, animation, secondaryAnimation, child) {
// return FadeTransition(
// opacity: animation,
// child: child,
// );
// },
// opaque: false,
// fullscreenDialog: false,
