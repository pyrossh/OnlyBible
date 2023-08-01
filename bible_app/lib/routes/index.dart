import "package:flutter/material.dart";
import 'package:go_router/go_router.dart';
import 'package:kannada_bible_app/domain/book.dart';
import '../components/header.dart';
import '../domain/kannada_gen.dart';
import '../components/verse_view.dart';
import '../state.dart';
import '../utils/dialog.dart';

part 'index.g.dart';

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

    return NoTransitionPage(
      child: Column(
        children: [
          Header(book: allBooks.indexWhere((it) => it == book), chapter: chapter),
          Flexible(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(
                vertical: 20,
                horizontal: isDesktop() ? 40 : 20,
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
        ],
      ),
    );
  }
}