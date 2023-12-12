import "package:flutter/gestures.dart";
import "package:flutter/material.dart";
import "package:flutter_swipe_detector/flutter_swipe_detector.dart";
import "package:only_bible_app/models.dart";
import "package:only_bible_app/navigation.dart";
import "package:only_bible_app/store/state.dart";
import "package:only_bible_app/widgets/highlight_button.dart";
import "package:share_plus/share_plus.dart";
import "../theme.dart";

class VersesView extends StatelessWidget {
  final Bible bible;
  final Chapter chapter;

  const VersesView({super.key, required this.bible, required this.chapter});

  @override
  Widget build(BuildContext context) {
    final textStyle = DefaultTextStyle.of(context).style;
    // if (chapter.index == 2) {
    //   throw Exception("123");
    // }
    return SwipeDetector(
      onSwipeLeft: (offset) {
        nextChapter(context, bible, chapter.book, chapter.index);
      },
      onSwipeRight: (offset) {
        previousChapter(context, bible, chapter.book, chapter.index);
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
                child: SelectableText.rich(
                  textScaler: TextScaler.linear(1.1 + textScaleAtom.watch(context)),
                  textAlign: TextAlign.left,
                  contextMenuBuilder: (BuildContext context, EditableTextState editableTextState) {
                    final anchor = editableTextState.contextMenuAnchors.primaryAnchor;
                    final iconColor =
                        darkModeAtom.value ? Colors.white.withOpacity(0.9) : Colors.black.withOpacity(0.9);
                    final audioIcon = isPlaying.watch(context) ? Icons.pause_circle_outline : Icons.play_circle_outline;
                    void onHighlight(int index) {
                      setHighlight(context, index);
                    }

                    return SizedBox.expand(
                      child: Stack(
                        children: [
                          Positioned(
                            left: anchor.dx,
                            top: anchor.dy,
                            child: FractionalTranslation(
                              translation: const Offset(-0.25, -1.25),
                              child: Material(
                                // shape: const Recta(),
                                elevation: 5,
                                clipBehavior: Clip.hardEdge,
                                child: SizedBox(
                                  height: 96,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 0.0),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            IconButton(
                                              padding: EdgeInsets.zero,
                                              onPressed: () => {},
                                              icon: Icon(Icons.border_color_outlined, size: 28, color: iconColor),
                                            ),
                                            IconButton(
                                              padding: EdgeInsets.zero,
                                              onPressed: () => {},
                                              icon: Icon(Icons.copy, size: 28, color: iconColor),
                                            ),
                                            IconButton(
                                              padding: EdgeInsets.zero,
                                              onPressed: () {
                                                onPlay(context, bible);
                                              },
                                              icon: Icon(audioIcon, size: 28, color: iconColor),
                                            ),
                                            IconButton(
                                              padding: EdgeInsets.zero,
                                              onPressed: () =>
                                                  showNoteField(context, bible, selectedVersesAtom.value.first),
                                              icon: Icon(Icons.post_add_outlined, size: 28, color: iconColor),
                                            ),
                                            IconButton(
                                              padding: EdgeInsets.zero,
                                              onPressed: () => shareVerses(context, bible, selectedVersesAtom.value),
                                              icon: Icon(Icons.share_outlined, size: 28, color: iconColor),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            IconButton(
                                              padding: EdgeInsets.zero,
                                              onPressed: () => removeHighlight(context),
                                              icon: Icon(Icons.cancel_outlined, size: 28, color: iconColor),
                                            ),
                                            HighlightButton(
                                              index: 0,
                                              color: darkModeAtom.value ? darkHighlights[0] : lightHighlights[0],
                                              onHighlightSelected: onHighlight,
                                            ),
                                            HighlightButton(
                                              index: 1,
                                              color: darkModeAtom.value ? darkHighlights[1] : lightHighlights[1],
                                              onHighlightSelected: onHighlight,
                                            ),
                                            HighlightButton(
                                              index: 2,
                                              color: darkModeAtom.value ? darkHighlights[2] : lightHighlights[2],
                                              onHighlightSelected: onHighlight,
                                            ),
                                            HighlightButton(
                                              index: 3,
                                              color: darkModeAtom.value ? darkHighlights[3] : lightHighlights[3],
                                              onHighlightSelected: onHighlight,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  TextSpan(
                    style: boldFontAtom.watch(context)
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
                                      showNoteField(context, bible, v);
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
                              // style: getHighlightStyle(context, v),
                              // recognizer: TapGestureRecognizer()
                              //   ..onTap = () {
                              //     onVerseSelected(context, bible, v);
                              //   },
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
            ],
          ),
        ),
      ),
    );
  }
}
