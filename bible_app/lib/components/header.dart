import 'package:bible_app/components/book_selector.dart';
import 'package:bible_app/state.dart';
import 'package:flutter/material.dart';
import 'dart:math';

import 'package:flutter_reactive_value/flutter_reactive_value.dart';

const headingStyle = TextStyle(
  fontSize: 20,
  fontWeight: FontWeight.w500,
  letterSpacing: 0.5,
);

class Header extends StatelessWidget {
  final String bookName;

  const Header({super.key, required this.bookName});

  @override
  Widget build(BuildContext context) {
    final chapter = chapterIndex.reactiveValue(context);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 40),
      padding: const EdgeInsets.symmetric(vertical: 15),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(width: 1.5)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          InkWell(
              onTap: () {
                showDialog<void>(
                    context: context,
                    barrierDismissible: true,
                    builder: (BuildContext context) {
                      return const BookSelector();
                    });
              },
              child: Row(
                children: [
                  Text("${bookName} ${chapter+1}", style: headingStyle),
                  Container(
                    margin: const EdgeInsets.only(left: 3),
                    child: Transform.rotate(
                      angle: -pi / 2,
                      child: const Icon(Icons.chevron_left, size: 24),
                    ),
                  ),
                ],
              )),
        ],
      ),
    );
  }
}
