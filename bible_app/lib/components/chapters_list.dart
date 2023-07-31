import "package:flutter/material.dart";
import 'package:flutter_reactive_value/flutter_reactive_value.dart';
import '../domain/kannada_gen.dart';
import '../routes/index.dart';
import '../state.dart';

class ChaptersList extends StatelessWidget {
  const ChaptersList({super.key});

  @override
  Widget build(BuildContext context) {
    final bookIndex = tabBookIndex.reactiveValue(context);
    final book = kannadaBible[bookIndex];
    return ListView(children: [
      Container(
        margin: const EdgeInsets.only(bottom: 10, left: 10),
        child: Text(book.name, style: Theme.of(context).textTheme.headlineMedium),
      ),
      Wrap(
        children: List.generate(book.chapters.length, (index) {
          return InkWell(
            borderRadius: const BorderRadius.all(Radius.circular(30)),
            onTap: () {
              HomeScreenRoute(book: book.name, chapter: index).go(context);
              saveState(bookIndex, index);
            },
            child: Container(
              width: isDesktop() ? 90 : 50,
              height: isDesktop() ? 50 : 40,
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
      )
    ]);
  }
}