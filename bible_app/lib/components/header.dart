import "dart:math";
import "package:flutter/material.dart";
import "./play_button.dart";
import "./side_menu_page.dart";
import "./menu.dart";
import '../models/book.dart';
import "../state.dart";

class Header extends StatelessWidget {
  final int book;
  final int chapter;
  final List<Verse> verses;

  const Header({super.key, required this.book, required this.chapter, required this.verses});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
          // horizontal: isDesktop() ? 40 : 20,
          vertical: isDesktop() ? 15 : 0),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(width: 1.5)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          InkWell(
            onTap: () {
              Navigator.of(context).push(SideMenuPage());
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("${selectedBible.value[book].name} ${chapter + 1}", style: theme.value.headerText),
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
          const Spacer(flex: 1),
          PlayButton(book: book, chapter: chapter, verses: verses),
          Menu(),
          // const Spacer(flex: 1),
        ],
      ),
    );
  }
}
