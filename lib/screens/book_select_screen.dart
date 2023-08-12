import "package:flutter/material.dart";
import "package:only_bible_app/state.dart";
import "package:only_bible_app/widgets/scaffold_menu.dart";
import "package:only_bible_app/screens/chapter_select_screen.dart";
import "package:only_bible_app/widgets/sliver_heading.dart";
import "package:only_bible_app/widgets/sliver_tile_grid.dart";

class BookSelectScreen extends StatelessWidget {
  const BookSelectScreen({super.key});

  onBookSelected(BuildContext context, int index) {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        opaque: false,
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
        pageBuilder: (context, _, __) => ChapterSelectScreen(
          selectedBookIndex: index,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMenu(
      child: CustomScrollView(
        slivers: [
          const SliverHeading(title: "Old Testament", showClose: true),
          SliverTileGrid(
            children: List.of(
              selectedBible.value!.getOldBooks().map((book) {
                return TextButton(
                  child: Text(book.shortName()),
                  onPressed: () => onBookSelected(context, book.index),
                );
              }),
            ),
          ),
          const SliverHeading(title: "New Testament", top: 30, bottom: 20),
          SliverTileGrid(
            children: List.of(
              selectedBible.value!.getNewBooks().map((book) {
                return TextButton(
                  child: Text(book.shortName()),
                  onPressed: () => onBookSelected(context, book.index),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
