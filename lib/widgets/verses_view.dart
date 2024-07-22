import "package:flutter/gestures.dart";
import "package:flutter/material.dart";
import "package:flutter_swipe_detector/flutter_swipe_detector.dart";
import "package:only_bible_app/models.dart";
import "package:only_bible_app/navigation.dart";
import "package:only_bible_app/store/state.dart";

class VersesView extends StatelessWidget {
  final Bible bible;
  final Chapter chapter;

  const VersesView({super.key, required this.bible, required this.chapter});

  @override
  Widget build(BuildContext context) {
    final textStyle = DefaultTextStyle.of(context).style;
    return SwipeDetector(
        onSwipeLeft: (offset) {
          nextChapter(context, bible, chapter.book, chapter.index);
        },
        onSwipeRight: (offset) {
          previousChapter(context, bible, chapter.book, chapter.index);
        },
        child: Column(
          children: [
            Expanded(
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
                          textScaler: TextScaler.linear(
                              1.1 + textScaleAtom.watch(context) / 2),
                          textAlign: TextAlign.left,
                          TextSpan(
                            style: boldFontAtom.watch(context)
                                ? textStyle.copyWith(
                                    fontWeight: FontWeight.w500,
                                  )
                                : textStyle,
                            children: chapter.verses
                                .map(
                                  (v) => [
                                    if (v.heading != "")
                                      TextSpan(
                                        text:
                                            "${v.heading.replaceAll("<br>", "\n")}\n",
                                        style:
                                            getHighlightStyle(context, v, true)
                                                .copyWith(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                          height: 2,
                                        ),
                                      ),
                                    WidgetSpan(
                                      child: Transform.translate(
                                        offset: const Offset(0, -2),
                                        child: Text("${v.index + 1} ",
                                            style: Theme.of(context)
                                                .textTheme
                                                .labelMedium),
                                      ),
                                    ),
                                    TextSpan(
                                      text: "${v.text}\n",
                                      style:
                                          getHighlightStyle(context, v, false),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          onVerseSelected(context, bible, v);
                                        },
                                    ),
                                    const WidgetSpan(
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            top: 16, bottom: 16),
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
                        padding: EdgeInsets.only(
                            bottom: actionsShownAtom.watch(context) ? 120 : 0),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}
