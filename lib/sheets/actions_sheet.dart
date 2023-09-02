import "package:flutter/material.dart";
import "package:only_bible_app/models.dart";
import "package:only_bible_app/navigation.dart";
import 'package:only_bible_app/store/state.dart';
import "package:only_bible_app/utils.dart";

class ActionsSheet extends StatelessWidget {
  final Bible bible;

  const ActionsSheet({super.key, required this.bible});

  @override
  Widget build(BuildContext context) {
    final bottom = isIOS() ? 20.0 : 0.0;
    final iconColor = darkModeAtom.value ? Colors.white.withOpacity(0.9) : Colors.black.withOpacity(0.9);
    final audioIcon = isPlaying.watch(context) ? Icons.pause_circle_outline : Icons.play_circle_outline;
    return Container(
      height: context.actionsHeight,
      color: Theme.of(context).colorScheme.background,
      padding: EdgeInsets.only(left: 20, right: 20, bottom: bottom),
      child: Row(
        mainAxisAlignment: context.isWide ? MainAxisAlignment.spaceEvenly : MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            padding: EdgeInsets.zero,
            onPressed: () => removeHighlight(context),
            icon: Icon(Icons.cancel_outlined, size: 28, color: iconColor),
          ),
          IconButton(
            padding: EdgeInsets.zero,
            onPressed: () => showHighlights(context),
            icon: Icon(Icons.border_color_outlined, size: 28, color: iconColor),
          ),
          IconButton(
            padding: EdgeInsets.zero,
            onPressed: () {
              onPlay(context, bible);
            },
            icon: Icon(audioIcon, size: 34, color: iconColor),
          ),
          IconButton(
            padding: EdgeInsets.zero,
            onPressed: () => showNoteField(context, bible, selectedVersesAtom.value.first),
            icon: Icon(Icons.post_add_outlined, size: 34, color: iconColor),
          ),
          IconButton(
            padding: EdgeInsets.zero,
            onPressed: () => shareVerses(context, bible, selectedVersesAtom.value),
            icon: Icon(Icons.share_outlined, size: 34, color: iconColor),
          ),
        ],
      ),
    );
  }
}
