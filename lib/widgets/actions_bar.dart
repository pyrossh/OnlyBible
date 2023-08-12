import "package:flutter/material.dart";
import "package:only_bible_app/state.dart";
import "package:only_bible_app/widgets/play_button.dart";

class ActionsBar extends StatelessWidget {
  const ActionsBar({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = isWide(context);
    final showPlay = ChapterViewModel.of(context).hasSelectedVerses();
    if (isDesktop || !showPlay) {
      // TODO: hack fix this
      return const ColoredBox(color: Colors.transparent);
    }
    return BottomSheet(
      enableDrag: false,
      onClosing: () {},
      builder: (BuildContext ctx) => Container(
        // TODO: check if this is needed
        // padding: const EdgeInsets.only(bottom: 0),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            PlayButton(),
          ],
        ),
      ),
    );
  }
}
