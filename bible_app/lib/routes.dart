import "package:flutter/material.dart";
import 'package:go_router/go_router.dart';
import 'screens/book_selector.dart';
import 'components/header.dart';
import 'domain/kannada_gen.dart';
import 'components/verse.dart';
import 'state.dart';

part 'routes.g.dart';

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

  @override
  Page buildPage(BuildContext context, GoRouterState state) {
    final width = MediaQuery.of(context).size.width;
    final right = width/10;
    return NoPageTransition(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            child: Container(
              margin: EdgeInsets.only(left: 40, top: 20, right: right),
              child: const BookSelectorScreen(),
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
            reverseTransitionDuration: const Duration(milliseconds: 0),
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
