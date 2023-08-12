import "package:flutter/material.dart";
import "package:flutter_reactive_value/flutter_reactive_value.dart";
import "package:only_bible_app/screens/bible_select_screen.dart";
import "package:only_bible_app/screens/book_select_screen.dart";
import "package:only_bible_app/widgets/play_button.dart";
import "package:only_bible_app/widgets/menu.dart";
import "package:only_bible_app/state.dart";

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    final book = bookIndex.reactiveValue(context);
    final chapter = chapterIndex.reactiveValue(context);
    final selectedBook = selectedBible.value!.books[book];
    final isDesktop = isWide(context);
    return Container(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: isWide(context) ? 10 : 0,
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextButton.icon(
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    backgroundColor: Theme.of(context).colorScheme.background,
                    elevation: 0,
                  ),
                  label: Icon(
                    Icons.expand_more,
                    size: 28,
                    color: Theme.of(context).textTheme.headlineMedium!.color,
                  ),
                  icon: Text(
                    "${selectedBook.name} ${chapter + 1}",
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  onPressed: () {
                    Navigator.of(context).push(
                      PageRouteBuilder(
                        opaque: false,
                        transitionDuration: Duration.zero,
                        reverseTransitionDuration: Duration.zero,
                        pageBuilder: (context, _, __) => const BookSelectScreen(),
                      ),
                    );
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (isDesktop)
                      Container(
                        margin: EdgeInsets.only(right: isWide(context) ? 10 : 8),
                        child: TextButton(
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                          ),
                          child: Text(selectedBible.reactiveValue(context)!.name),
                          onPressed: () {
                            Navigator.of(context).push(
                              PageRouteBuilder(
                                opaque: false,
                                transitionDuration: Duration.zero,
                                reverseTransitionDuration: Duration.zero,
                                pageBuilder: (context, _, __) => const BibleSelectScreen(),
                              ),
                            );
                          },
                        ),
                      ),
                    if (isDesktop)
                      Container(
                        margin: EdgeInsets.only(right: isWide(context) ? 10 : 8),
                        child: const PlayButton(),
                      ),
                    const Menu(),
                  ],
                ),
              ],
            ),
            const Divider(thickness: 1.5, endIndent: 10),
          ],
        ));
  }
}
