import "dart:math";
import "package:flutter/material.dart";
import "package:just_audio/just_audio.dart";
import "package:kannada_bible_app/domain/book.dart";
import "../routes/select.dart";
import "../state.dart";
import "../domain/kannada_gen.dart";

class Header extends StatelessWidget {
  final int book;
  final int chapter;
  final player = AudioPlayer();

  Header({super.key, required this.book, required this.chapter}) {
    player.setUrl("https://github.com/pyrossh/bible-app/raw/master/public/audio/output.mp3");
    // player.setUrl("asset:output.mp3");
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 40),
      padding: const EdgeInsets.symmetric(vertical: 15),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(width: 1.5)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          InkWell(
            onTap: () {
              SelectScreenRoute().go(context);
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("${allBooks[book]} ${chapter + 1}", style: Theme.of(context).textTheme.headlineLarge),
                Container(
                  margin: const EdgeInsets.only(left: 3),
                  child: Transform.rotate(
                    angle: -pi / 2,
                    child: const Icon(Icons.chevron_left, size: 28),
                  ),
                ),
              ],
            ),
          ),
          const Spacer(flex: 8),
          IconButton(
            icon: const Icon(Icons.play_circle_fill, size: 36),
            onPressed: () async {
              final verses = kannadaBible[book].chapters[chapter].verses;
              final filteredVerses =
                  verses.asMap().keys.where((it) => selectedVerses.value.contains(it)).map((it) => verses[it]);
              // Todo: play/pause button
              for (final v in filteredVerses) {
                try {
                  await player.setClip(
                    start: Duration(milliseconds: (v.audioRange.start * 1000).toInt()),
                    end: Duration(milliseconds: (v.audioRange.end * 1000).toInt()),
                  );
                  await player.play();
                  await player.pause();
                } catch (err) {
                  // show
                }
              }
            },
          ),
          const Spacer(flex: 1),
        ],
      ),
    );
  }
}
