import "package:flutter/material.dart";
import "package:only_bible_app/state.dart";
import "package:only_bible_app/widgets/highlight_button.dart";
import "package:only_bible_app/widgets/icon_button_text.dart";

class ActionsSheet extends StatelessWidget {
  const ActionsSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final iconColor = AppModel.of(context).darkMode ? Colors.white.withOpacity(0.9) : Colors.black.withOpacity(0.9);
    final bodySmall = Theme.of(context).textTheme.bodySmall;
    final model = ChapterViewModel.of(context);
    final audioIcon = model.isPlaying ? Icons.pause_circle_outline : Icons.play_circle_outline;
    return Container(
      height: 140,
      color: Theme.of(context).colorScheme.background,
      padding: EdgeInsets.only(bottom: isIOS() ? 20 : 0, left: 20, right: 20, top: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
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
                  onPressed: () {},
                  icon: Icon(Icons.copy, size: 28, color: iconColor),
                ),
                trailing: Text("Copy", style: bodySmall),
              ),
              IconButtonText(
                leading: IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: () {},
                  icon: Icon(Icons.post_add_outlined, size: 32, color: iconColor),
                ),
                trailing: Text("Note", style: bodySmall),
              ),
              IconButtonText(
                leading: IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: () => model.onPlay(context),
                  icon: Icon(audioIcon, size: 40, color: iconColor),
                ),
                trailing: Text("Play", style: bodySmall),
              ),
              IconButtonText(
                leading: IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: () {},
                  icon: Icon(Icons.share_outlined, size: 28, color: iconColor),
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
