import "package:flutter/material.dart";
import "package:only_bible_app/utils.dart";
import "package:only_bible_app/widgets/highlight_button.dart";

class HighlightSheet extends StatelessWidget {
  const HighlightSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = isWide(context);
    final height = isDesktop || isIOS() ? 100.0 : 70.0;
    onHighlight(Color c) {
      final verses = context.appEvent.selectedVerses;
      context.appEvent.setHighlight(context, verses, c);
      context.appEvent.closeActions(context);
    }

    return Container(
      height: height,
      color: Theme.of(context).colorScheme.background,
      padding: EdgeInsets.only(left: 20, right: 20, top: isDesktop ? 10 : 10, bottom: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          HighlightButton(
            color: const Color(0xFFDAEFFE),
            onColorSelected: onHighlight,
          ),
          HighlightButton(
            color: const Color(0xFFFFFBB1),
            onColorSelected: onHighlight,
          ),
          HighlightButton(
            color: const Color(0xFFFFDEF3),
            onColorSelected: onHighlight,
          ),
          HighlightButton(
            color: const Color(0xFFE6FCC3),
            onColorSelected: onHighlight,
          ),
          HighlightButton(
            color: const Color(0xFFAACCAA),
            onColorSelected: onHighlight,
          ),
        ],
      ),
    );
  }
}
