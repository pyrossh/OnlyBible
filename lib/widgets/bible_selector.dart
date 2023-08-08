import "package:flutter/material.dart";
import 'package:go_router/go_router.dart';
import 'package:only_bible_app/widgets/books_list.dart';
import 'package:only_bible_app/widgets/chapters_list.dart';
import 'package:only_bible_app/state.dart';
import 'package:only_bible_app/widgets/tile.dart';

import '../models.dart';

class BibleSelector extends StatelessWidget {
  const BibleSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: isWide(context) ? 5 : 0, left: 20),
      child: ListView(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text("Bibles", style: Theme.of(context).textTheme.headlineMedium),
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
                children: List.of(
                  bibles.map((bible) {
                    return Container(
                      margin: const EdgeInsets.only(right: 16, bottom: 16),
                      child: TextButton(
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.all(20),
                        ),
                        child: Text(bible.name),
                        onPressed: () => changeBible(context, bible.id),
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
