import "package:flutter/gestures.dart";
import "package:flutter/material.dart";
import "package:only_bible_app/state.dart";

class VerseList extends StatelessWidget {
  const VerseList({super.key});

  @override
  Widget build(BuildContext context) {
    final model = ChapterViewModel.of(context);
    final chapter = ChapterViewModel.selectedChapter(context);
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SelectableText.rich(
        contextMenuBuilder: null,
        textScaleFactor: 1,
        onSelectionChanged: (selection, _) {
          // Show copy, highlight, note, audio, share
          //bottom: 55, // TODO: maybe make this 55 only when actions bar is show else 20
        },
        TextSpan(
          style: DefaultTextStyle.of(context).style,
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
        // userSelections: model.selectedVerses
        //     .map(
        //       (e) => UserSelection(
        //         hasCaret: false,
        //         highlightStyle: _primaryHighlightStyle,
        //         selection: TextSelection(baseOffset: e , extentOffset: 10),
        //       ),
        //     )
        //     .toList(),
      ),
    );
  }
}
