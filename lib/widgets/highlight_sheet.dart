import "package:flutter/material.dart";
import "package:only_bible_app/theme.dart";
import "package:only_bible_app/utils.dart";
import "package:only_bible_app/widgets/highlight_button.dart";

class HighlightSheet extends StatelessWidget {
  const HighlightSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = isWide(context);
    final bottom = isIOS() ? 20.0 : 0.0;
    final height = isIOS() ? 100.0 : 80.0;
    void onHighlight(int index) {
      final verses = context.appEvent.selectedVerses;
      context.appEvent.setHighlight(context, verses, index);
      context.appEvent.closeActions(context);
    }
    // context.app.darkMode ? const Color(0xFF69A9FC) :

    return Container(
      height: height,
      color: context.theme.colorScheme.background,
      padding: EdgeInsets.only(left: 20, right: 20, top: isDesktop ? 10 : 10, bottom: bottom),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(
          4,
          (i) => HighlightButton(
            index: i,
            color: context.app.darkMode ? darkHighlights[i] : lightHighlights[i],
            onHighlightSelected: onHighlight,
          ),
        ),
      ),
    );
  }
}
