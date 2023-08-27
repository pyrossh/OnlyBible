import "package:flutter/material.dart";
import "package:only_bible_app/utils.dart";
import "package:only_bible_app/widgets/bible_loader.dart";
import "package:only_bible_app/widgets/chapter_app_bar.dart";
import "package:only_bible_app/widgets/sidebar.dart";
import "package:only_bible_app/widgets/verses_view.dart";

class ChapterViewScreen extends StatelessWidget {
  final int bookIndex;
  final int chapterIndex;

  const ChapterViewScreen({super.key, required this.bookIndex, required this.chapterIndex});

  @override
  Widget build(BuildContext context) {
    if (context.isWide) {
      return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: SafeArea(
          child: Row(
            children: [
              const Sidebar(),
              Flexible(
                child: BibleLoader(
                  builder: (bible) {
                    final book = bible.books[bookIndex];
                    final chapter = book.chapters[chapterIndex];
                    return Column(
                      children: [
                        ChapterAppBar(book: book, chapter: chapter),
                        const Padding(
                          padding: EdgeInsets.only(bottom: 10),
                          child: Divider(height: 5, indent: 20, endIndent: 20, thickness: 1.5),
                        ),
                        Flexible(
                          child: VersesView(chapter: chapter),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      );
    }
    return BibleLoader(
      builder: (bible) {
        final book = bible.books[bookIndex];
        final chapter = book.chapters[chapterIndex];
        return Scaffold(
          appBar: ChapterAppBar(book: book, chapter: chapter),
          backgroundColor: Theme.of(context).colorScheme.background,
          body: SafeArea(
            child: VersesView(chapter: chapter),
          ),
        );
      },
    );
  }
}
