import "package:flutter/material.dart";
import "package:flutter_reactive_value/flutter_reactive_value.dart";
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
    return ChangeNotifierProvider(
      create: (context) => ChapterViewModel(
        book: book,
        chapter: chapter,
        selectedVerses: [],
      ),
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        bottomSheet: const ActionsBar(),
        body: SafeArea(
          child: SwipeDetector(
            onSwipeLeft: (offset) {
              onNext(context, book, chapter);
            },
            onSwipeRight: (offset) {
              onPrevious(context, book, chapter);
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
