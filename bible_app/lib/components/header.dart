import "dart:math";
import "package:flutter/material.dart";
import "package:just_audio/just_audio.dart";
import "package:kannada_bible_app/components/play_button.dart";
import "package:kannada_bible_app/components/slide_page.dart";
import "package:kannada_bible_app/domain/book.dart";
import "../routes/select.dart";
import "../state.dart";
import "../utils/dialog.dart";

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
      margin: EdgeInsets.symmetric(horizontal: isDesktop() ? 40 : 20),
      padding: EdgeInsets.symmetric(vertical: isDesktop() ? 15 : 0),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(width: 1.5)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          InkWell(
            onTap: () {
              Navigator.of(context).push(SlidePage());
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
          PlayButton(book: book, chapter: chapter),
          const Spacer(flex: 1),
        ],
      ),
    );
  }
}
