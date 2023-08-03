import "package:flutter/material.dart";
import 'package:flutter_reactive_value/flutter_reactive_value.dart';
import 'package:go_router/go_router.dart';
import '../state.dart';
import 'tile.dart';

class ChaptersList extends StatelessWidget {
  const ChaptersList({super.key});

  @override
  Widget build(BuildContext context) {
    final bookIndex = tabBookIndex.reactiveValue(context);
    final book = selectedBible.value[bookIndex];
    return ListView(
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 20),
          child: Text(book.name, style: Theme.of(context).textTheme.headlineMedium),
        ),
        Wrap(
          children: List.generate(book.chapters.length, (index) {
            return InkWell(
              borderRadius: const BorderRadius.all(Radius.circular(30)),
              onTap: () {
                saveBookIndex(bookIndex, index);
                context.push("/${book.name}/$index");
                context.pop();
                resetTab();
              },
              child: Tile(name: "${index + 1}"),
            );
          }),
        )
      ],
    );
  }
}
