import "package:flutter/material.dart";
import "package:only_bible_app/theme.dart";
import "package:only_bible_app/utils.dart";
import "package:only_bible_app/widgets/highlight_button.dart";

class HighlightSheet extends StatelessWidget {
  const HighlightSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final bottom = isIOS() ? 20.0 : 0.0;
    final height = isIOS() ? 100.0 : 65.0;
    final iconColor = context.app.darkMode ? Colors.white.withOpacity(0.9) : Colors.black.withOpacity(0.9);
    void onHighlight(int index) {
      final verses = context.appEvent.selectedVerses;
      context.appEvent.setHighlight(context, verses, index);
      context.appEvent.closeActions(context);
    }

    return Container(
      height: height,
      color: context.theme.colorScheme.background,
      padding: EdgeInsets.only(left: 20, right: 20, bottom: bottom),
      child: Row(
        mainAxisAlignment: context.isWide ? MainAxisAlignment.spaceEvenly : MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            padding: EdgeInsets.zero,
            onPressed: () => context.appEvent.removeSelectedHighlights(context),
            icon: Icon(Icons.cancel_outlined, size: 28, color: iconColor),
          ),
          HighlightButton(
            index: 0,
            color: context.app.darkMode ? darkHighlights[0] : lightHighlights[0],
            onHighlightSelected: onHighlight,
          ),
          HighlightButton(
            index: 1,
            color: context.app.darkMode ? darkHighlights[1] : lightHighlights[1],
            onHighlightSelected: onHighlight,
          ),
          HighlightButton(
            index: 2,
            color: context.app.darkMode ? darkHighlights[2] : lightHighlights[2],
            onHighlightSelected: onHighlight,
          ),
          HighlightButton(
            index: 3,
            color: context.app.darkMode ? darkHighlights[3] : lightHighlights[3],
            onHighlightSelected: onHighlight,
          ),
        ],
      ),
    );
  }
}
