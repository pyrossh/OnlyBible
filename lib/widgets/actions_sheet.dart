import "package:flutter/material.dart";
import "package:only_bible_app/dialog.dart";
import "package:only_bible_app/providers/app_provider.dart";
import "package:only_bible_app/utils.dart";
import "package:only_bible_app/widgets/icon_button_text.dart";

class ActionsSheet extends StatelessWidget {
  const ActionsSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final app = AppProvider.of(context);
    final isDesktop = isWide(context);
    final bottom = isIOS() ? 20.0 : 0.0;
    final height = isIOS() ? 100.0 : 80.0;
    final iconColor = app.darkMode ? Colors.white.withOpacity(0.9) : Colors.black.withOpacity(0.9);
    final bodySmall = Theme.of(context).textTheme.bodySmall;
    final audioIcon = app.isPlaying ? Icons.pause_circle_outline : Icons.play_circle_outline;
    final audioText = app.isPlaying ? "Pause" : "Play";
    final audioEnabled = app.hasAudio(context);
    return Container(
      height: height,
      color: Theme.of(context).colorScheme.background,
      padding: EdgeInsets.only(left: 20, right: 20, top: isDesktop ? 10 : 10, bottom: bottom),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButtonText(
                leading: IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: () => context.appEvent.removeSelectedHighlights(context),
                  icon: Icon(Icons.cancel_outlined, size: 28, color: iconColor),
                ),
                trailing: Text("Clear", style: bodySmall),
              ),
              IconButtonText(
                leading: IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: () => context.appEvent.showHighlights(context),
                  icon: Icon(Icons.border_color_outlined, size: 28, color: iconColor),
                ),
                trailing: Text("Highlight", style: bodySmall),
              ),
              IconButtonText(
                leading: IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    if (audioEnabled) {
                      context.appEvent.onPlay(context);
                    } else {
                      showError(
                        context,
                        "This Bible doesn't support audio. Currently audio is only available for the Kannada Bible.",
                      );
                    }
                  },
                  icon: Icon(audioIcon, size: 34, color: audioEnabled ? iconColor : Colors.grey),
                ),
                trailing: Text(
                  audioText,
                  style: bodySmall!.copyWith(
                    color: audioEnabled ? bodySmall.color : Colors.grey,
                  ),
                ),
              ),
              IconButtonText(
                leading: IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: () => context.appEvent.showNoteField(context, context.appEvent.selectedVerses.first),
                  icon: Icon(Icons.post_add_outlined, size: 34, color: iconColor),
                ),
                trailing: Text("Note", style: bodySmall),
              ),
              IconButtonText(
                leading: IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: () => context.appEvent.shareVerses(context),
                  icon: Icon(Icons.share_outlined, size: 34, color: iconColor),
                ),
                trailing: Text("Share", style: bodySmall),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
