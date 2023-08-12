import "package:flutter/material.dart";
import "package:flutter_reactive_value/flutter_reactive_value.dart";
import "package:only_bible_app/widgets/verse_view.dart";
import "package:only_bible_app/state.dart";

class VerseList extends StatelessWidget {
  const VerseList({super.key});

  @override
  Widget build(BuildContext context) {
    final book = ChapterViewModel.of(context).book;
    final chapter = ChapterViewModel.of(context).chapter;
    final selectedBook = selectedBible.reactiveValue(context)!.books[book];
    final verses = selectedBook.chapters[chapter].verses;
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
