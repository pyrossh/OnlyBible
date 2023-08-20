import "package:flutter/material.dart";
import "package:only_bible_app/providers/app_model.dart";
import "package:only_bible_app/providers/chapter_view_model.dart";
import "package:only_bible_app/utils.dart";
import "package:only_bible_app/widgets/highlight_button.dart";
import "package:only_bible_app/widgets/icon_button_text.dart";

class ActionsSheet extends StatelessWidget {
  const ActionsSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final app = AppModel.of(context);
    final isDesktop = isWide(context);
    final iconSize = isDesktop ? 10.0 : 0.0;
    final iconColor = app.darkMode ? Colors.white.withOpacity(0.9) : Colors.black.withOpacity(0.9);
    final bodySmall = Theme.of(context).textTheme.bodySmall;
    final model = ChapterViewModel.of(context);
    final audioIcon = model.isPlaying ? Icons.pause_circle_outline : Icons.play_circle_outline;
    final audioText = model.isPlaying ? "Pause" : "Play";
    final highlightRowEnabled = !isDesktop && false;
    return Container(
      height: highlightRowEnabled
          ? 160
          : isDesktop
              ? 80
              : 100,
      color: Theme.of(context).colorScheme.background,
      padding: EdgeInsets.only(left: 20, right: 20, top: isDesktop ? 10 : 0),
      child: Column(
        mainAxisAlignment: highlightRowEnabled ? MainAxisAlignment.spaceAround : MainAxisAlignment.start,
        children: [
          if (highlightRowEnabled)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                HighlightButton(
                  color: const Color(0xFFDAEFFE),
                  onTap: () {},
                ),
                HighlightButton(
                  color: const Color(0xFFFFFBB1),
                  onTap: () {},
                ),
                HighlightButton(
                  color: const Color(0xFFFFDEF3),
                  onTap: () {},
                ),
                HighlightButton(
                  color: const Color(0xFFE6FCC3),
                  onTap: () {},
                ),
                HighlightButton(
                  color: const Color(0xFFEADDFF),
                  onTap: () {},
                ),
              ],
            ),
          // const Padding(padding: EdgeInsets.only(top: 10)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButtonText(
                leading: IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: () => model.clearSelections(context),
                  icon: Icon(Icons.cancel_outlined, size: 24 + iconSize, color: iconColor),
                ),
                trailing: Text("Clear", style: bodySmall),
              ),
              IconButtonText(
                leading: IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: model.copyVerses,
                  icon: Icon(Icons.copy, size: 24 + iconSize, color: iconColor),
                ),
                trailing: Text("Copy", style: bodySmall),
              ),
              IconButtonText(
                leading: IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: () => model.onPlay(context),
                  icon: Icon(audioIcon, size: 34 + iconSize, color: app.bible.hasAudio ? iconColor : Colors.grey),
                ),
                trailing: Text(
                  audioText,
                  style: bodySmall!.copyWith(
                    color: app.bible.hasAudio ? bodySmall!.color : Colors.grey,
                  ),
                ),
              ),
              IconButtonText(
                leading: IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: () => app.showNoteField(context, model.selectedVerses.first),
                  icon: Icon(Icons.post_add_outlined, size: 32 + iconSize, color: iconColor),
                ),
                trailing: Text("Note", style: bodySmall),
              ),
              IconButtonText(
                leading: IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: () => model.shareVerses(context),
                  icon: Icon(Icons.share_outlined, size: 28 + iconSize, color: iconColor),
                ),
                trailing: Text("Share", style: bodySmall),
              ),
              // IconButtonText(
              //   leading: IconButton(
              //     padding: EdgeInsets.zero,
              //     onPressed: () {},
              //     icon: const Text(""),
              //   ),
              //   trailing: Text("", style: bodySmall),
              // )
            ],
          ),
        ],
      ),
    );
  }
}
