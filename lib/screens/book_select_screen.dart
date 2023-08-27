import "package:flutter/material.dart";
import "package:only_bible_app/utils.dart";
import "package:only_bible_app/widgets/scaffold_menu.dart";
import "package:only_bible_app/screens/chapter_select_screen.dart";
import "package:only_bible_app/widgets/sliver_heading.dart";
import "package:only_bible_app/widgets/sliver_tile_grid.dart";
import "package:only_bible_app/models.dart";

class BookSelectScreen extends StatelessWidget {
  final Bible bible;

  const BookSelectScreen({super.key, required this.bible});

  onBookSelected(BuildContext context, int index) {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        opaque: false,
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
        pageBuilder: (context, _, __) => ChapterSelectScreen(
          book: bible.books[index],
          selectedBookIndex: index,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMenu(
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverHeading(title: context.l.oldTestamentTitle, showClose: true),
          SliverTileGrid(
            children: List.of(
              bible.getOldBooks().map((book) {
                return TextButton(
                  child: Text(book.shortName(context)),
                  onPressed: () => onBookSelected(context, book.index),
                );
              }),
            ),
          ),
          SliverHeading(title: context.l.newTestamentTitle, top: 30, bottom: 20),
          SliverTileGrid(
            children: List.of(
              bible.getNewBooks().map((book) {
                return TextButton(
                  child: Text(book.shortName(context)),
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
