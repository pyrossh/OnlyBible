import "package:flutter/gestures.dart";
import "package:flutter/material.dart";
import "package:flutter_swipe_detector/flutter_swipe_detector.dart";
import "package:only_bible_app/state.dart";

class VersesView extends StatelessWidget {
  const VersesView({super.key});

  @override
  Widget build(BuildContext context) {
    final textScaleFactor = AppModel.of(context).textScaleFactor;
    final model = ChapterViewModel.of(context);
    final chapter = ChapterViewModel.selectedChapter(context);
    return SwipeDetector(
      onSwipeLeft: (offset) {
        model.onNext(context, model.book, model.chapter);
      },
      onSwipeRight: (offset) {
        model.onPrevious(context, model.book, model.chapter);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SelectableText.rich(
          scrollPhysics: const BouncingScrollPhysics(),
          contextMenuBuilder: null,
          textScaleFactor: textScaleFactor,
          // onSelectionChanged: (selection, _) {
          //   // Show copy, highlight, note, audio, share
          //   //bottom: 55, // TODO: maybe make this 55 only when actions bar is shown else 20
          // },
          TextSpan(
            style: DefaultTextStyle.of(context).style,
            // recognizer: TapAndPanGestureRecognizer()..onDragEnd = (e) => print("Hello"),
            children: chapter.verses
                .asMap()
                .entries
                .map(
                  (e) => [
                    WidgetSpan(
                      child: Transform.translate(
                        offset: const Offset(0, -2),
                        child: Text("${e.key + 1} ", style: Theme.of(context).textTheme.labelMedium),
                      ),
                    ),
                    TextSpan(
                      text: "${e.value.text}\n",
                      style: model.isVerseSelected(e.key)
                          ? TextStyle(
                              backgroundColor: Theme.of(context).highlightColor,
                            )
                          : null,
                      recognizer: TapGestureRecognizer()..onTap = () => model.onVerseSelected(context, e.key),
                    ),
                    const WidgetSpan(
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 30),
                      ),
                    ),
                  ],
                )
                .expand((element) => element)
                .toList(),
          ),
        ),
      ),
    );
  }
}
