import "package:flutter/material.dart";
import "package:only_bible_app/state.dart";
import "package:only_bible_app/utils.dart";
import "package:only_bible_app/widgets/chapter_app_bar.dart";
import "package:only_bible_app/widgets/sidebar.dart";
import "package:only_bible_app/widgets/verses_view.dart";
import "package:provider/provider.dart";

class ChapterViewScreen extends StatelessWidget {
  final int bookIndex;
  final int chapterIndex;

  const ChapterViewScreen({super.key, required this.bookIndex, required this.chapterIndex});

  @override
  Widget build(BuildContext context) {
    // FutureBuilder(
    //   future: loadData(), // This reloads everytime theme changes
    //   builder: (context, snapshot) {
    //     if (snapshot.hasData && snapshot.data != null && snapshot.connectionState == ConnectionState.done) {
    //       return ChangeNotifierProvider(
    //         create: (_) => BibleViewModel(bible: snapshot.data!.$1),
    //         child: ChapterViewScreen(book: snapshot.data!.$2, chapter: snapshot.data!.$3),
    //       );
    //     }
    //     return ColoredBox(
    //       color: Theme.of(context).colorScheme.background,
    //       child: const Center(
    //         child: CircularProgressIndicator(),
    //       ),
    //     );
    //   },
    // ),
    final book = bible.watch(context).books[bookIndex];
    final chapter = book.chapters[chapterIndex];
    return Scaffold(
      appBar: context.isWide ? null : ChapterAppBar(book: book, chapter: chapter),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: context.isWide
            ? Row(
                children: [
                  const Sidebar(),
                  Flexible(
                    child: Column(
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
                    ),
                  ),
                ],
              )
            : VersesView(chapter: chapter),
      ),
    );
  }
}
