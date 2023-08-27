import "package:flutter/material.dart";
import "package:only_bible_app/models.dart";
import "package:only_bible_app/state.dart";

class BibleLoader extends StatelessWidget {
  final Function(Bible) builder;

  const BibleLoader({super.key, required this.builder});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: bibleCache.watch(context),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return builder(snapshot.data!);
        }
        return ColoredBox(
          color: Theme.of(context).colorScheme.background,
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
