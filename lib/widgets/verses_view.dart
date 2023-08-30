import "package:flutter/gestures.dart";
import "package:flutter/material.dart";
import "package:flutter_swipe_detector/flutter_swipe_detector.dart";
import "package:only_bible_app/models.dart";
import "package:only_bible_app/navigation.dart";
import "package:only_bible_app/state.dart";

class VersesView extends StatelessWidget {
  final Chapter chapter;

  const VersesView({super.key, required this.chapter});

  @override
  Widget build(BuildContext context) {
    final textStyle = DefaultTextStyle.of(context).style;
    return SwipeDetector(
      onSwipeLeft: (offset) {
        nextChapter(context, bible.value, chapter.book, chapter.index);
      },
      onSwipeRight: (offset) {
        previousChapter(context, bible.value, chapter.book, chapter.index);
      },
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // const Padding(
              //   padding: EdgeInsets.only(top: 0),
              // ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text.rich(
                  textScaleFactor: 1.1 + textScale.watch(context),
                  textAlign: TextAlign.left,
                  TextSpan(
                    style: fontBold.watch(context)
                        ? textStyle.copyWith(
                            fontWeight: FontWeight.w500,
                          )
                        : textStyle,
                    children: chapter.verses
                        .map(
                          (v) => [
                            WidgetSpan(
                              child: Transform.translate(
                                offset: const Offset(0, -2),
                                child: Text("${v.index + 1} ", style: Theme.of(context).textTheme.labelMedium),
                              ),
                            ),
                            if (hasNote(v))
                              WidgetSpan(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 3, right: 3),
                                  child: GestureDetector(
                                    onTap: () {
                                      showNoteField(context, v);
                                    },
                                    child: const Icon(
                                      Icons.sticky_note_2_outlined,
                                      size: 18,
                                      color: Colors.blue,
                                    ),
                                  ),
                                ),
                              ),
                            TextSpan(
                              text: "${v.text}\n",
                              style: getHighlightStyle(context, v),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  onVerseSelected(context, v);
                                },
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
              ),
              Padding(
                padding: EdgeInsets.only(bottom: actionsShown.watch(context) ? 120 : 0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
