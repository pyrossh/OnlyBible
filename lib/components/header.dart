import "package:flutter/material.dart";
import 'package:only_bible_app/components/play_button.dart';
import 'package:only_bible_app/components/side_menu_page.dart';
import 'package:only_bible_app/components/menu.dart';
import 'package:only_bible_app/models/book.dart';
import 'package:only_bible_app/state.dart';

class Header extends StatelessWidget {
  final int book;
  final int chapter;
  final List<Verse> verses;

  const Header({
    super.key,
    required this.book,
    required this.chapter,
    required this.verses,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: isWide(context) ? 10 : 0,
        bottom: isWide(context) ? 10 : 0,
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: 1.5,
            color: Theme.of(context).dividerColor,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextButton.icon(
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              backgroundColor: Theme.of(context).colorScheme.background,
              elevation: 0,
            ),
            label: Icon(
              Icons.expand_more,
              size: 28,
              color: Theme.of(context).textTheme.headlineMedium!.color,
            ),
            icon: Text(
              "${selectedBible.value[book].name} ${chapter + 1}",
              style: Theme.of(context).textTheme.headlineMedium,
            ),
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
