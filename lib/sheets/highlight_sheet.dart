import "package:flutter/material.dart";
import 'package:only_bible_app/store/state.dart';
import "package:only_bible_app/theme.dart";
import "package:only_bible_app/utils.dart";
import "package:only_bible_app/widgets/highlight_button.dart";

class HighlightSheet extends StatelessWidget {
  const HighlightSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final bottom = isIOS() ? 20.0 : 0.0;
    final iconColor = darkModeAtom.value ? Colors.white.withOpacity(0.9) : Colors.black.withOpacity(0.9);
    void onHighlight(int index) {
      setHighlight(context, index);
    }

    return Container(
      height: context.actionsHeight,
      color: context.theme.colorScheme.background,
      padding: EdgeInsets.only(left: 20, right: 20, bottom: bottom),
      child: Row(
        mainAxisAlignment: context.isWide ? MainAxisAlignment.spaceEvenly : MainAxisAlignment.spaceAround,
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
    );
  }
}
