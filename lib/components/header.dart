import "package:flutter/material.dart";
import 'package:flutter_reactive_value/flutter_reactive_value.dart';
import 'package:only_bible_app/components/play_button.dart';
import 'package:only_bible_app/components/side_menu_page.dart';
import 'package:only_bible_app/components/menu.dart';
import 'package:only_bible_app/state.dart';

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    final book = bookIndex.reactiveValue(context);
    final chapter = chapterIndex.reactiveValue(context);
    final selectedBook = selectedBible.value[book];
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
              "${selectedBook.name} ${chapter + 1}",
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
