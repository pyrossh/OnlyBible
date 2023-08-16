import "package:flutter/material.dart";
import "package:only_bible_app/screens/book_select_screen.dart";
import "package:only_bible_app/state.dart";

class ChapterAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ChapterAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(40);

  @override
  Widget build(BuildContext context) {
    final selectedBible = AppModel.of(context).bible;
    final model = ChapterViewModel.of(context);
    final selectedBook = selectedBible.books[model.book];
    final bookName = selectedBook.name;
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.only(left: 18, right: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              enableFeedback: true,
              onTap: () {
                Navigator.of(context).push(
                  createNoTransitionPageRoute(
                    BookSelectScreen(bible: selectedBible),
                  ),
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "$bookName ${model.chapter + 1}",
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  Icon(
                    Icons.expand_more,
                    size: 28,
                    color: Theme.of(context).textTheme.headlineMedium!.color,
                  ),
                ],
              ),
            ),
            IconButton(
              padding: EdgeInsets.zero,
              onPressed: () => AppModel.ofEvent(context).showSettings(context),
              icon: const Icon(Icons.more_vert, size: 24),
            ),
          ],
        ),
      ),
    );
  }
}
