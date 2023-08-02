import "dart:math";
import "package:flutter/material.dart";
import "./play_button.dart";
import "./slide_page.dart";
import "../domain/book.dart";
import "../state.dart";

class Header extends StatelessWidget {
  final int book;
  final int chapter;

  const Header({super.key, required this.book, required this.chapter});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
          // horizontal: isDesktop() ? 40 : 20,
          vertical: isDesktop() ? 15 : 0
      ),
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
