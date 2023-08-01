import "package:flutter/material.dart";
import "package:kannada_bible_app/components/book_selector.dart";
import "package:kannada_bible_app/utils/string.dart";
import "../state.dart";
import "title.dart";

class BooksList extends StatelessWidget {
  final String title;
  final int offset;
  final List<String> books;

  const BooksList({super.key, required this.title, required this.offset, required this.books});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 20),
          child: Text(title, style: Theme
              .of(context)
              .textTheme
              .headlineMedium,
          ),
        ),
        Wrap(
          children: List.generate(books.length, (index) {
            final name = books[index].bookShortName();
            return InkWell(
              borderRadius: const BorderRadius.all(Radius.circular(30)),
              onTap: () {
                // DefaultTabController.of(context).animateTo(1);
                tabBookIndex.value = offset + index;
                tabIndex.value = 1;
              },
              child: Tile(name: name),
            );
          }),
        ),
      ],
    );
  }
}
