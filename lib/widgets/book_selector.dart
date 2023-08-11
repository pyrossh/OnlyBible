import "package:flutter/material.dart";
import "package:only_bible_app/state.dart";
import "package:only_bible_app/widgets/chapter_selector.dart";
import "package:only_bible_app/utils/side_menu_modal.dart";

class BookSelector extends StatelessWidget {
  const BookSelector({super.key});

  onBookSelected(BuildContext context, int index) {
    Navigator.of(context).pushReplacement(SideMenuModal(child: ChapterSelector(selectedBookIndex: index)));
  }

  @override
  Widget build(BuildContext context) {
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
                    child: Text("Old Testament", style: Theme.of(context).textTheme.headlineMedium),
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
            children: List.of(
              selectedBible.value!.getOldBooks().map((book) {
                return TextButton(
                  child: Text(book.shortName()),
                  onPressed: () => onBookSelected(context, book.index),
                );
              }),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.only(top: 30, bottom: 20),
              child: Text("New Testament", style: Theme.of(context).textTheme.headlineMedium),
            ),
          ),
          SliverGrid.count(
            crossAxisCount: 6,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.6,
            children: List.of(
              selectedBible.value!.getNewBooks().map((book) {
                return TextButton(
                  child: Text(book.shortName()),
                  onPressed: () => onBookSelected(context, book.index),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
