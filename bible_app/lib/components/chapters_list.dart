import "package:flutter/material.dart";
import 'package:flutter/scheduler.dart';
import 'package:flutter_reactive_value/flutter_reactive_value.dart';
import 'package:go_router/go_router.dart';
import '../domain/kannada_gen.dart';
import '../state.dart';
import 'tile.dart';

class ChaptersList extends StatelessWidget {
  const ChaptersList({super.key});

  @override
  Widget build(BuildContext context) {
    final bookIndex = tabBookIndex.reactiveValue(context);
    final book = kannadaBible[bookIndex];
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
                context.push("/${book.name}/$index");
                saveState(bookIndex, index);
                context.pop();
                SchedulerBinding.instance.addPostFrameCallback((_) {
                  tabIndex.value = 0;
                });
              },
              child: Tile(name: "${index + 1}"),
            );
          }),
        )
      ],
    );
  }
}
