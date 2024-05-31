import "package:flutter/material.dart";
import "package:only_bible_app/models.dart";
import "package:only_bible_app/navigation.dart";
import "package:only_bible_app/utils.dart";

class ChapterAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Bible bible;
  final Book book;
  final Chapter chapter;

  const ChapterAppBar({
    super.key,
    required this.book,
    required this.chapter,
    required this.bible,
  });

  @override
  Size get preferredSize => const Size.fromHeight(40);

  @override
  Widget build(BuildContext context) {
    final bookName = context.bookNames[book.index];
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.only(left: 18, right: 5, top: 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            InkWell(
              enableFeedback: true,
              onTap: () => changeChapter(context, bible, book, book.index),
              onLongPress: () => changeBook(context, bible),
              child: Row(
                children: [
                  Text(
                    "$bookName ${chapter.index + 1}",
                    style: Theme.of(context).textTheme.headlineMedium,
                    key: const Key("bookTitle"),
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
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      icon: const Icon(Icons.more_vert, size: 24),
                      onPressed: () => showSettings(context, bible),
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
