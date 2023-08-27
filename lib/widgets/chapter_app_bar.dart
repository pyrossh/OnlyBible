import "package:flutter/material.dart";
import "package:only_bible_app/models.dart";
import "package:only_bible_app/navigation.dart";
import "package:only_bible_app/state.dart";
import "package:only_bible_app/utils.dart";

class ChapterAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Book book;
  final Chapter chapter;

  const ChapterAppBar({super.key, required this.book, required this.chapter});

  @override
  Size get preferredSize => const Size.fromHeight(40);

  @override
  Widget build(BuildContext context) {
    final bookName = book.name(context);
    final isDesktop = context.isWide;
    return SafeArea(
      child: Container(
        padding: EdgeInsets.only(left: 18, right: 5, top: isDesktop ? 5 : 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            InkWell(
              enableFeedback: true,
              onTap: () => changeBook(context, bible.value),
              child: Row(
                children: [
                  Text(
                    "$bookName ${chapter.index + 1}",
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
                      style: TextButton.styleFrom(
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        shadowColor: Theme.of(context).shadowColor,
                        backgroundColor: Theme.of(context).colorScheme.background,
                        foregroundColor: Theme.of(context).colorScheme.primary,
                      ),
                      icon: const Icon(Icons.chevron_left),
                      label: const Text("Prev"),
                      onPressed: () => previousChapter(context, bible.value, book.index, chapter.index),
                    ),
                  if (isDesktop) const SizedBox(width: 10),
                  if (isDesktop)
                    TextButton.icon(
                      style: TextButton.styleFrom(
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        shadowColor: Theme.of(context).shadowColor,
                        backgroundColor: Theme.of(context).colorScheme.background,
                        foregroundColor: Theme.of(context).colorScheme.primary,
                      ),
                      icon: const Icon(Icons.chevron_right),
                      label: const Text("Next"),
                      onPressed: () => nextChapter(context, bible.value, book.index, chapter.index),
                    ),
                  if (isDesktop) const SizedBox(width: 20),
                  if (isDesktop)
                    TextButton.icon(
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        shadowColor: Theme.of(context).shadowColor,
                        backgroundColor: Theme.of(context).colorScheme.background,
                        foregroundColor: Theme.of(context).colorScheme.primary,
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            color: Theme.of(context).colorScheme.primary,
                            width: 1,
                          ),
                        ),
                      ),
                      icon: const Icon(Icons.book_outlined),
                      label: Text(bible.watch(context).name),
                      onPressed: () => changeBibleFromHeader(context),
                    ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      icon: Icon(Icons.more_vert, size: isDesktop ? 28 : 24),
                      onPressed: () => showSettings(context),
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
