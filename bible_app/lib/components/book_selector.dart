import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../domain/book.dart';

class BookSelector extends StatelessWidget {
  final Function(int i) onBookChange;

  const BookSelector({super.key, required this.onBookChange});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(200),
      padding: const EdgeInsets.all(20),
      color: Colors.white,
      child: GridView.count(
          crossAxisCount: 8,
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 10.0,
          children: List.generate(allBooks.length, (index) {
            return GestureDetector(
              onTap: () {
                onBookChange(index);
                Navigator.pop(context, index);
              },
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.red,
                ),
                child: Center(
                  child: Text(allBooks[index]),
                ),
              ),
            );
          })),
    );
  }
}
