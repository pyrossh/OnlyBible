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
      padding: EdgeInsets.only(
        // horizontal: isDesktop() ? 40 : 20,
        top: isDesktop() ? 10 : 0,
        bottom: isDesktop() ? 10 : 0,
      ),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(width: 1.5)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          InkWell(
            onTap: () {
              Navigator.of(context).push(SideMenuPage());
            },
            child: Row(
              children: [
                Text("${selectedBible.value[book].name} ${chapter + 1}", style: theme.value.headerText),
                const Icon(Icons.expand_more, size: 30),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                margin: EdgeInsets.only(right: isDesktop() ? 50 : 8),
                child: PlayButton(book: book, chapter: chapter, verses: verses),
              ),
              Menu(),
            ],
          ),
        ],
      ),
    );
  }
}
