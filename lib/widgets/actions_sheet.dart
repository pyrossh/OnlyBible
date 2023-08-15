import "package:flutter/material.dart";
import "package:only_bible_app/state.dart";
import "package:only_bible_app/widgets/play_button.dart";

class ActionsSheet extends StatelessWidget {
  const ActionsSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.background,
      padding: EdgeInsets.only(bottom: isIOS() ? 20 : 0),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          PlayButton(),
        ],
      ),
    );
  }
}
