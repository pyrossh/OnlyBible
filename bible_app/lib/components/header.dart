import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
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
        top: isWide(context) ? 10 : 0,
        bottom: isWide(context) ? 10 : 0,
      ),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(width: 1.5)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextButton.icon(
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              foregroundColor: const Color(0xFF9A1111),
            ),
            label: Icon(Icons.expand_more, size: 28, color: theme.value.headerText.color),
            icon: Text("${selectedBible.value[book].name} ${chapter + 1}", style: theme.value.headerText),
            onPressed: () {
              Navigator.of(context).push(SideMenuPage());
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                margin: EdgeInsets.only(right: isWide(context) ? 10 : 8),
                child: const PlayButton(),
              ),
              const Menu(),
            ],
          ),
        ],
      ),
    );
  }
}
