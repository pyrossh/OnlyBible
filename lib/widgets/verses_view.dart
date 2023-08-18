import "package:flutter/gestures.dart";
import "package:flutter/material.dart";
import "package:flutter_swipe_detector/flutter_swipe_detector.dart";
import "package:only_bible_app/state.dart";

class VersesView extends StatelessWidget {
  const VersesView({super.key});

  @override
  Widget build(BuildContext context) {
    final app = AppModel.of(context);
    final model = ChapterViewModel.of(context);
    final chapter = ChapterViewModel.selectedChapter(context);
    final textStyle = DefaultTextStyle.of(context).style;
    return SwipeDetector(
      onSwipeLeft: (offset) {
        model.onNext(context, model.book, model.chapter);
      },
      onSwipeRight: (offset) {
        model.onPrevious(context, model.book, model.chapter);
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              // const Padding(
              //   padding: EdgeInsets.only(top: 0),
              // ),
              Text.rich(
                // scrollPhysics: const BouncingScrollPhysics(),
                // contextMenuBuilder: null,
                textScaleFactor: app.textScaleFactor,
                // onSelectionChanged: (selection, _) {
                // },
                TextSpan(
                  style: app.fontBold
                      ? textStyle.copyWith(
                          fontWeight: FontWeight.w500,
                        )
                      : textStyle,
                  // recognizer: TapAndPanGestureRecognizer()..onDragEnd = (e) => print("Hello"),
                  children: chapter.verses
                      .map(
                        (v) => [
                          WidgetSpan(
                            child: Transform.translate(
                              offset: const Offset(0, -2),
                              child: Text("${v.index + 1} ", style: Theme.of(context).textTheme.labelMedium),
                            ),
                          ),
                          TextSpan(
                            text: "${v.text}\n",
                            style: model.isVerseSelected(v)
                                ? TextStyle(
                                    backgroundColor: Theme.of(context).highlightColor,
                                  )
                                : null,
                            recognizer: TapGestureRecognizer()..onTap = () => model.onVerseSelected(context, v),
                          ),
                          const WidgetSpan(
                            child: Padding(
                              padding: EdgeInsets.only(top: 16, bottom: 16),
                            ),
                          ),
                        ],
                      )
                      .expand((element) => element)
                      .toList(),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: app.actionsShown ? 120 : 0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
