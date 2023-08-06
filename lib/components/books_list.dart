import "package:flutter/material.dart";
import 'package:go_router/go_router.dart';
import 'package:only_bible_app/state.dart';
import 'package:only_bible_app/components/tile.dart';
import 'package:only_bible_app/models/book.dart';

class BooksList extends StatelessWidget {
  final String title;
  final List<Book> books;
  final Function(int) onTap;
  final bool showClose;

  const BooksList({
    super.key,
    required this.title,
    required this.books,
    required this.onTap,
    required this.showClose,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Text(title, style: Theme.of(context).textTheme.headlineMedium),
              ),
              if (showClose)
                Container(
                  margin: const EdgeInsets.only(right: 30),
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
            books.map((book) {
              final name = book.shortName();
              return Tile(
                name: name,
                onPressed: () => onTap(book.index),
              );
            }),
          ),
        ),
      ],
    );
  }
}
