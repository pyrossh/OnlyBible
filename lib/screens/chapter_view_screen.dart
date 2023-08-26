import "package:flutter/material.dart";
import "package:only_bible_app/providers/chapter_view_model.dart";
import "package:only_bible_app/utils.dart";
import "package:only_bible_app/widgets/chapter_app_bar.dart";
import "package:only_bible_app/widgets/sidebar.dart";
import "package:only_bible_app/widgets/verses_view.dart";
import "package:provider/provider.dart";

class ChapterViewScreen extends StatelessWidget {
  final int book;
  final int chapter;

  const ChapterViewScreen({super.key, required this.book, required this.chapter});

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
    final isDesktop = isWide(context);
    return ChangeNotifierProvider(
      create: (_) => ChapterViewModel(
        book: book,
        chapter: chapter,
      ),
      child: Scaffold(
        appBar: isDesktop ? null : const ChapterAppBar(),
        backgroundColor: Theme.of(context).colorScheme.background,
        body: SafeArea(
          child: isDesktop
              ? const Row(
                  children: [
                    Sidebar(),
                    Flexible(
                      child: Column(
                        children: [
                          ChapterAppBar(),
                          Padding(
                            padding: EdgeInsets.only(bottom: 10),
                            child: Divider(height: 5, indent: 20, endIndent: 20, thickness: 1.5),
                          ),
                          Flexible(
                            child: VersesView(),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              : const VersesView(),
        ),
      ),
    );
  }
}
