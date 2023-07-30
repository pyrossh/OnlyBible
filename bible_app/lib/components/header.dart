import "dart:math";
import "package:bible_app/components/book_selector.dart";
import "package:bible_app/state.dart";
import "package:flutter/material.dart";
import "package:flutter/scheduler.dart";
import "package:flutter_reactive_value/flutter_reactive_value.dart";
import "../utils/dialog.dart";

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
                tabBookIndex.value = 0;
                showCustomDialog<(int, int)>(context, BookSelector()).then((rec) {
                  if (rec != null) {
                    selectedVerses.value.clear();
                    onBookChange(rec.$1);
                    onChapterChange(rec.$2);
                    SchedulerBinding.instance.addPostFrameCallback((duration) {
                      tabIndex.value = 0;
                    });
                  }
                });
              },
              child: Row(
                children: [
                  Text("$bookName ${chapter+1}", style: Theme.of(context).textTheme.headlineLarge),
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
