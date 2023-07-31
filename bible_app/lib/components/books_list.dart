import "package:flutter/material.dart";
import "../state.dart";

class BooksList extends StatelessWidget {
  final int offset;
  final List<String> books;

  const BooksList({super.key, required this.offset, required this.books});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: List.generate(books.length, (index) {
        final name = books[index].replaceAll(" ", "").substring(0, 3).toUpperCase();
        return InkWell(
          borderRadius: const BorderRadius.all(Radius.circular(30)),
          onTap: () {
            DefaultTabController.of(context).animateTo(1);
            tabBookIndex.value = offset + index;
          },
          child: Container(
            width: isDesktop() ? 90 : 50,
            height: isDesktop() ? 50 : 40,
            margin: const EdgeInsets.all(8),
            child: Material(
              elevation: 3,
              borderRadius: const BorderRadius.all(Radius.circular(30)),
              child: Center(
                child: Text(
                  name,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.labelMedium,
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}


