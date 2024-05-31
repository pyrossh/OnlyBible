import "package:flutter/material.dart";
import "package:only_bible_app/models.dart";
import "package:only_bible_app/store/state.dart";
import "package:only_bible_app/utils.dart";
import "package:only_bible_app/widgets/chapter_app_bar.dart";
import "package:only_bible_app/widgets/verses_view.dart";

class ChapterViewScreen extends StatelessWidget {
  final String bibleName;
  final int bookIndex;
  final int chapterIndex;

  const ChapterViewScreen(
      {super.key,
      required this.bibleName,
      required this.bookIndex,
      required this.chapterIndex});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: bibleAtom.getValue(bibleName),
      builder: (context, state) {
        return state.when(
            loading: () => ColoredBox(
                  color: Theme.of(context).colorScheme.background,
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
            success: (Bible? bible) {
              final book = bible!.books[bookIndex];
              final chapter = book.chapters[chapterIndex];
              return Scaffold(
                appBar:
                    ChapterAppBar(bible: bible, book: book, chapter: chapter),
                backgroundColor: Theme.of(context).colorScheme.background,
                body: SafeArea(
                  child: VersesView(bible: bible, chapter: chapter),
                ),
              );
            },
            error: () {
              print(state.stackTrace);
              return ColoredBox(
                color: Theme.of(context).colorScheme.background,
                child: Center(
                  child: Text("Could not load the bible ${state.error}"),
                ),
              );
            });
      },
    );
  }
}
