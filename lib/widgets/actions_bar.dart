import "package:flutter/material.dart";
import "package:only_bible_app/state.dart";
import "package:only_bible_app/widgets/play_button.dart";

class ActionsBar extends StatelessWidget {
  const ActionsBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomSheet(
      enableDrag: false,
      onClosing: () {},
      builder: (BuildContext ctx) => Container(
        padding: EdgeInsets.only(bottom: isIOS() ? 20 : 0),
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
