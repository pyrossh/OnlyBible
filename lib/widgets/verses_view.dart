import "package:flutter/gestures.dart";
import "package:flutter/material.dart";
import "package:flutter_swipe_detector/flutter_swipe_detector.dart";
import "package:only_bible_app/models.dart";
import "package:only_bible_app/providers/app_provider.dart";
import "package:only_bible_app/utils.dart";

class VersesView extends StatelessWidget {
  final Book book;
  final Chapter chapter;
  const VersesView({super.key, required this.book, required this.chapter});

  @override
  Widget build(BuildContext context) {
    final app = AppProvider.of(context);
    final textStyle = DefaultTextStyle.of(context).style;
    return SwipeDetector(
      onSwipeLeft: (offset) {
        context.appEvent.onNext(context, book.index, chapter.index);
      },
      onSwipeRight: (offset) {
        context.appEvent.onPrevious(context, book.index, chapter.index);
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
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
                  // scrollPhysics: const BouncingScrollPhysics(),
                  // contextMenuBuilder: null,
                  textScaleFactor: app.textScaleFactor,
                  textAlign: TextAlign.left,
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
                            if (app.hasNote(v))
                              WidgetSpan(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 3, right: 3),
                                  child: GestureDetector(
                                    onTap: () {
                                      app.showNoteField(context, v);
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
                              style: context.app.getHighlightStyle(context, v),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  context.appEvent.onVerseSelected(context, v);
                                  // AppModel.ofEvent(context).showHighlightMenu(context, v, details.globalPosition);
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
                padding: EdgeInsets.only(bottom: app.actionsShown ? 120 : 0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
