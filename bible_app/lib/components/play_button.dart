import "package:flutter/material.dart";
import "package:flutter_reactive_value/flutter_reactive_value.dart";
import "package:just_audio/just_audio.dart";
import "../models/book.dart";
import "../state.dart";
import "../utils/dialog.dart";

class PlayButton extends StatelessWidget {
  final int book;
  final int chapter;
  final List<Verse> verses;

  const PlayButton({super.key, required this.book, required this.chapter, required this.verses});

  @override
  Widget build(BuildContext context) {
    final icon = isPlaying.reactiveValue(context) ? Icons.pause_circle_filled : Icons.play_circle_fill;
    return IconButton(
      padding: EdgeInsets.symmetric(horizontal: 50),
      icon: Icon(icon, size: 36),
      onPressed: () async {
        final player = AudioPlayer();
        player.setUrl("https://github.com/pyrossh/bible-app/raw/master/public/audio/output.mp3");
        // player.setUrl("asset:output.mp3");
        if (isPlaying.value) {
          await player.pause();
          onPause();
        } else {
          try {
            onPlay();
            final filteredVerses =
                verses.asMap().keys.where((it) => selectedVerses.value.contains(it)).map((it) => verses[it]);
            for (final v in filteredVerses) {
              await player.setClip(
                start: Duration(milliseconds: (v.audioRange.start * 1000).toInt()),
                end: Duration(milliseconds: (v.audioRange.end * 1000).toInt()),
              );
              await player.play();
              await player.pause();
            }
          } catch (err) {
            showError(context, "Could not play audio");
          } finally {
            await player.pause();
            onPause();
          }
        }
      },
    );
  }
}
