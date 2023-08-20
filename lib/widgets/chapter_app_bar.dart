import "package:flutter/material.dart";
import "package:only_bible_app/providers/app_model.dart";
import "package:only_bible_app/providers/chapter_view_model.dart";
import "package:only_bible_app/utils.dart";

class ChapterAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ChapterAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(40);

  // TODO: add next/prev buttons for desktop mode

  @override
  Widget build(BuildContext context) {
    final app = AppModel.of(context);
    final model = ChapterViewModel.of(context);
    final selectedBook = app.bible.books[model.book];
    final bookName = selectedBook.name;
    final isDesktop = isWide(context);
    return SafeArea(
      child: Container(
        padding: EdgeInsets.only(left: 18, right: 5, top: isDesktop ? 5 : 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            InkWell(
              enableFeedback: true,
              onTap: () => app.changeBook(context),
              child: Row(
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
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (isDesktop)
                    TextButton.icon(
                      onPressed: () => app.changeBibleFromHeader(context),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                      ),
                      icon: const Icon(Icons.book_outlined),
                      label: Text(
                        app.bible.name,
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      onPressed: () => AppModel.ofEvent(context).showSettings(context),
                      icon: Icon(Icons.more_vert, size: isDesktop ? 28 : 24),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
