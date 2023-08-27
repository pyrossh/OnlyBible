import "package:flutter/material.dart";
import "package:only_bible_app/dialog.dart";
import "package:only_bible_app/providers/app_provider.dart";
import "package:only_bible_app/utils.dart";

class ActionsSheet extends StatelessWidget {
  const ActionsSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final app = AppProvider.of(context);
    final bottom = isIOS() ? 20.0 : 0.0;
    final height = isIOS() ? 100.0 : 65.0;
    final iconColor = app.darkMode ? Colors.white.withOpacity(0.9) : Colors.black.withOpacity(0.9);
    final audioIcon = app.isPlaying ? Icons.pause_circle_outline : Icons.play_circle_outline;
    final audioEnabled = app.hasAudio(context);
    return Container(
      height: height,
      color: Theme.of(context).colorScheme.background,
      padding: EdgeInsets.only(left: 20, right: 20, bottom: bottom),
      child: Row(
        mainAxisAlignment: context.isWide ? MainAxisAlignment.spaceEvenly : MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            padding: EdgeInsets.zero,
            onPressed: () => context.appEvent.removeSelectedHighlights(context),
            icon: Icon(Icons.cancel_outlined, size: 28, color: iconColor),
          ),
          IconButton(
            padding: EdgeInsets.zero,
            onPressed: () => context.appEvent.showHighlights(context),
            icon: Icon(Icons.border_color_outlined, size: 28, color: iconColor),
          ),
          IconButton(
            padding: EdgeInsets.zero,
            onPressed: () {
              if (audioEnabled) {
                context.appEvent.onPlay(context);
              } else {
                showError(context, context.l10n.audioNotAvailable);
              }
            },
            icon: Icon(audioIcon, size: 34, color: audioEnabled ? iconColor : Colors.grey),
          ),
          IconButton(
            padding: EdgeInsets.zero,
            onPressed: () => context.appEvent.showNoteField(context, context.appEvent.selectedVerses.first),
            icon: Icon(Icons.post_add_outlined, size: 34, color: iconColor),
          ),
          IconButton(
            padding: EdgeInsets.zero,
            onPressed: () => context.appEvent.shareVerses(context),
            icon: Icon(Icons.share_outlined, size: 34, color: iconColor),
          ),
        ],
      ),
    );
  }
}
