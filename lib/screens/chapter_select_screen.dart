import "package:flutter/material.dart";
import "package:only_bible_app/models.dart";
import "package:only_bible_app/utils.dart";
import "package:only_bible_app/widgets/scaffold_menu.dart";
import "package:only_bible_app/widgets/sliver_tile_grid.dart";
import "package:only_bible_app/widgets/sliver_heading.dart";
import "package:only_bible_app/screens/chapter_view_screen.dart";

class ChapterSelectScreen extends StatelessWidget {
  final Book book;
  final int selectedBookIndex;

  const ChapterSelectScreen({super.key, required this.selectedBookIndex, required this.book});

  // TODO: move this to app and allow to pause
  onChapterSelected(BuildContext context, int index) {
    Navigator.of(context).pushReplacement(
      createNoTransitionPageRoute(
        ChapterViewScreen(book: selectedBookIndex, chapter: index),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMenu(
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
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
