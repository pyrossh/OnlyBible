import "package:flutter/material.dart";
import "package:only_bible_app/state.dart";

class ChapterSelector extends StatelessWidget {
  final int selectedBookIndex;

  const ChapterSelector({super.key, required this.selectedBookIndex});

  onChapterSelected(BuildContext context, int index) {
    navigateBookChapter(context, selectedBookIndex, index, true);
  }

  @override
  Widget build(BuildContext context) {
    final book = selectedBible.value!.books[selectedBookIndex];
    return Container(
      margin: EdgeInsets.only(top: isWide(context) ? 5 : 0, left: 20, right: 20),
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.only(bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(book.name, style: Theme.of(context).textTheme.headlineMedium),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, size: 28),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          ),
          SliverGrid.count(
            crossAxisCount: 6,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.6,
            children: List.generate(book.chapters.length, (index) {
              return TextButton(
                child: Text("${index + 1}"),
                onPressed: () => onChapterSelected(context, index),
              );
            }),
          ),
        ],
      ),
    );
  }
}
