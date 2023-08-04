import "package:flutter/material.dart";
import "package:flutter_reactive_value/flutter_reactive_value.dart";
import "../state.dart";

class PlayButton extends StatelessWidget {
  const PlayButton({super.key});

  @override
  Widget build(BuildContext context) {
    final icon = isPlaying.reactiveValue(context)
        ? Icons.pause_circle_filled
        : Icons.play_circle_fill;
    return IconButton(
        icon: Icon(icon, size: 28),
        onPressed: () {
          onPlay(context);
        });
  }
}
