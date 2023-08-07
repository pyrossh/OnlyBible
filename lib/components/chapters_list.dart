import "package:flutter/material.dart";
import 'package:go_router/go_router.dart';
import 'package:only_bible_app/state.dart';
import 'package:only_bible_app/components/tile.dart';

class ChaptersList extends StatelessWidget {
  final String title;
  final int length;
  final Function(int) onTap;

  const ChaptersList({
    super.key,
    required this.title,
    required this.length,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 20),
          child: Row(
            children: [
              Expanded(
                child: Text(title, style: Theme.of(context).textTheme.headlineMedium),
              ),
              Container(
                margin: EdgeInsets.only(right: isWide(context) ? 30 : 10),
                child: IconButton(
                  icon: const Icon(Icons.close, size: 28),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              )
            ],
          ),
        ),
        Wrap(
          children: List.generate(length, (index) {
            return Tile(
              name: "${index + 1}",
              onPressed: () => onTap(index),
            );
          }),
        )
      ],
    );
  }
}
