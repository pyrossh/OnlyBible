import 'package:bible_app/components/header.dart';
import 'package:bible_app/domain/kannada_gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import '../components/sidebar.dart';
import '../components/verse.dart';
import '../utils/assets.dart';
import '../utils/text.dart';

class HomeScreen extends HookWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bookIndex = useState(0);
    final chapterIndex = useState(0);
    final book = kannadaBible[bookIndex.value];
    final items = book.chapters[chapterIndex.value].verses;
    onBookChange(int i) {
      bookIndex.value = i;
    }
    return Scaffold(
      backgroundColor: Colors.white,
      body: Row(
        children: [
          const Sidebar(),
          Flexible(
              child: Column(
                children: [
                  Header(bookName: book.name, onBookChange: onBookChange),
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
                          child: Verse(index: v.index-1, text: v.text),
                        );
                      },
                    ),
                  )
                ],
              ))
        ],
      )
    );
  }
}
