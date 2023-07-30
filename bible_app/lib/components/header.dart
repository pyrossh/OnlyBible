import "dart:math";
import "package:flutter/material.dart";
import "package:flutter/scheduler.dart";
import "package:flutter_reactive_value/flutter_reactive_value.dart";
import "package:just_audio/just_audio.dart";
import "../state.dart";
import "../components/book_selector.dart";
import "../utils/dialog.dart";
import "../domain/kannada_gen.dart";

class Header extends StatelessWidget {
  final String bookName;
  final player = AudioPlayer();

  Header({super.key, required this.bookName});

  @override
  Widget build(BuildContext context) {
    final chapter = chapterIndex.reactiveValue(context);
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
              tabBookIndex.value = 0;
              showCustomDialog<(int, int)>(context, const BookSelector()).then((rec) {
                if (rec != null) {
                  selectedVerses.value.clear();
                  onBookChange(rec.$1);
                  onChapterChange(rec.$2);
                  SchedulerBinding.instance.addPostFrameCallback((duration) {
                    tabIndex.value = 0;
                  });
                }
              });
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("$bookName ${chapter + 1}", style: Theme.of(context).textTheme.headlineLarge),
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
              final verses = kannadaBible[bookIndex.value]
                  .chapters[chapterIndex.value]
                  .verses
                  .where((v) => selectedVerses.value.contains(v.index - 1));
              for (final v in verses) {
                await player.setUrl("asset:output.mp3");
                await player.setClip(
                  start: Duration(milliseconds: (v.audioRange.start * 1000).toInt()),
                  end: Duration(milliseconds: (v.audioRange.end * 1000).toInt()),
                );
                await player.play();
                await player.pause();
              }
              // "https://github.com/pyrossh/bible-app/raw/master/public/audio/output.mp3"
            },
          ),
          const Spacer(flex: 1),
        ],
      ),
    );
  }
}
