import 'package:bible_app/components/header.dart';
import 'package:bible_app/domain/kannada_gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reactive_value/flutter_reactive_value.dart';
import '../components/sidebar.dart';
import '../components/verse.dart';
import '../state.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final book = kannadaBible[bookIndex.reactiveValue(context)];
    final items = book.chapters[chapterIndex.reactiveValue(context)].verses;

    return Scaffold(
        backgroundColor: Colors.white,
        body: Row(
          children: [
            const Sidebar(),
            Flexible(
                child: Column(
              children: [
                Header(bookName: book.name),
                Flexible(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      vertical: 20,
                      horizontal: 40,
                    ),
                    itemCount: items.length,
                    itemBuilder: (BuildContext context, int index) {
                      final v = items[index];
                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        child: Verse(index: v.index - 1, text: v.text),
                      );
                    },
                  ),
                )
              ],
            ))
          ],
        ));
  }
}
