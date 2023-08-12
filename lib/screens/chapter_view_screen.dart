import "package:flutter/material.dart";
import "package:flutter_swipe_detector/flutter_swipe_detector.dart";
import "package:only_bible_app/widgets/actions_bar.dart";
import "package:only_bible_app/widgets/header.dart";
import "package:only_bible_app/state.dart";
import "package:only_bible_app/widgets/sidebar.dart";
import "package:only_bible_app/widgets/verse_list.dart";
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
    final model = ChapterViewModel(
      book: book,
      chapter: chapter,
      selectedVerses: [],
    );
    return ChangeNotifierProvider.value(
      value: model,
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        bottomSheet: const ActionsBar(),
        body: SafeArea(
          child: SwipeDetector(
            onSwipeLeft: (offset) {
              model.onNext(context, book, chapter);
            },
            onSwipeRight: (offset) {
              model.onPrevious(context, book, chapter);
            },
            child: Row(
              children: [
                if (isWide(context)) const Sidebar(),
                const Flexible(
                  child: Column(
                    children: [
                      Header(),
                      Flexible(
                        child: VerseList(),
                      ),
                      // TODO: add padding only if bottom sheet is shown
                      // Padding(
                      //   padding: EdgeInsets.only(bottom: 40),
                      // )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
