import "package:flutter/material.dart";
import "package:only_bible_app/widgets/verse_view.dart";
import "package:only_bible_app/state.dart";

class VerseList extends StatelessWidget {
  const VerseList({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedBible = AppModel.of(context).bible;
    final model = ChapterViewModel.of(context);
    final verses = selectedBible.books[model.book].chapters[model.chapter].verses;
    return SelectionArea(
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        shrinkWrap: false,
        padding: const EdgeInsets.only(
          left: 20,
          right: 20,
          bottom: 55, // TODO: maybe make this 55 only when actions bar is show else 20
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
