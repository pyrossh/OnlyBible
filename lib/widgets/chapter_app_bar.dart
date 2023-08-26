import "package:flutter/material.dart";
import "package:only_bible_app/providers/app_provider.dart";
import "package:only_bible_app/providers/chapter_provider.dart";
import "package:only_bible_app/utils.dart";

class ChapterAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ChapterAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(40);

  // TODO: add next/prev buttons for desktop mode

  @override
  Widget build(BuildContext context) {
    final app = AppProvider.of(context);
    final model = ChapterProvider.of(context);
    final selectedBook = app.bible.books[model.book];
    final bookName = selectedBook.name(context);
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
                      onPressed: () => model.onPrevious(context, model.book, model.chapter),
                      style: TextButton.styleFrom(
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        shadowColor: Theme.of(context).shadowColor,
                        backgroundColor: Theme.of(context).colorScheme.background,
                        foregroundColor: Theme.of(context).colorScheme.primary,
                      ),
                      icon: const Icon(Icons.chevron_left),
                      label: const Text("Prev"),
                    ),
                  if (isDesktop) const SizedBox(width: 10),
                  if (isDesktop)
                    TextButton.icon(
                      onPressed: () => model.onNext(context, model.book, model.chapter),
                      style: TextButton.styleFrom(
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        shadowColor: Theme.of(context).shadowColor,
                        backgroundColor: Theme.of(context).colorScheme.background,
                        foregroundColor: Theme.of(context).colorScheme.primary,
                      ),
                      icon: const Icon(Icons.chevron_right),
                      label: const Text("Next"),
                    ),
                  if (isDesktop) const SizedBox(width: 20),
                  if (isDesktop)
                    TextButton.icon(
                      onPressed: () => app.changeBibleFromHeader(context),
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
                      label: Text(app.bible.name),
                    ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      onPressed: () => AppProvider.ofEvent(context).showSettings(context),
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
