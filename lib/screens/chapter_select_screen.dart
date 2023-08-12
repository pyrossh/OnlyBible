import "package:flutter/material.dart";
import "package:only_bible_app/state.dart";
import "package:only_bible_app/widgets/scaffold_menu.dart";
import "package:only_bible_app/widgets/sliver_tile_grid.dart";
import "package:only_bible_app/widgets/sliver_heading.dart";

class ChapterSelectScreen extends StatelessWidget {
  final int selectedBookIndex;

  const ChapterSelectScreen({super.key, required this.selectedBookIndex});

  onChapterSelected(BuildContext context, int index) {
    navigateBookChapter(context, selectedBookIndex, index, true);
  }

  @override
  Widget build(BuildContext context) {
    final book = selectedBible.value!.books[selectedBookIndex];
    return ScaffoldMenu(
      child: CustomScrollView(
        slivers: [
          SliverHeading(title: book.name, showClose: true),
          SliverTileGrid(
            children: List.generate(book.chapters.length, (index) {
              return TextButton(
                child: Text("${index + 1}"),
                onPressed: () => onChapterSelected(context, index),
              );
            }),
          ),
        ],
      ),
    );
  }
}
