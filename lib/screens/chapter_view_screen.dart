import "package:flutter/material.dart";
import "package:flutter_reactive_value/flutter_reactive_value.dart";
import "package:flutter_swipe_detector/flutter_swipe_detector.dart";
import "package:only_bible_app/widgets/header.dart";
import "package:only_bible_app/state.dart";
import "package:only_bible_app/widgets/play_button.dart";
import "package:only_bible_app/widgets/sidebar.dart";
import "package:only_bible_app/widgets/verse_list.dart";

class ChapterViewScreen extends StatelessWidget {
  final int book;
  final int chapter;

  const ChapterViewScreen({super.key, required this.book, required this.chapter});

  @override
  Widget build(BuildContext context) {
    final isDesktop = isWide(context);
    final showPlay = selectedVerses.reactiveValue(context).isNotEmpty;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      bottomSheet: !isDesktop && showPlay
          ? BottomSheet(
              enableDrag: false,
              onClosing: () {},
              builder: (BuildContext ctx) => Container(
                padding: const EdgeInsets.only(bottom: 40),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    PlayButton(),
                  ],
                ),
              ),
            )
          : null,
      body: SafeArea(
        child: SwipeDetector(
          onSwipeLeft: (offset) {
            onNext(context);
          },
          onSwipeRight: (offset) {
            onPrevious(context);
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
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
