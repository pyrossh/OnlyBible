import "package:flutter/material.dart";
import "package:only_bible_app/screens/book_select_screen.dart";
import "package:only_bible_app/state.dart";
import "package:only_bible_app/widgets/more_button.dart";

class ChapterAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ChapterAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(30);

  @override
  Widget build(BuildContext context) {
    final selectedBible = AppModel.of(context).bible;
    final model = ChapterViewModel.of(context);
    final selectedBook = selectedBible.books[model.book];
    final bookName = selectedBook.name;
    return AppBar(
      excludeHeaderSemantics: true,
      // bottom: const PreferredSize(
      //   preferredSize: Size.fromHeight(1),
      //   child: Divider(height: 0, thickness: 1, indent: 18, endIndent: 20),
      // ),
      title: TextButton.icon(
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
          "$bookName ${model.chapter + 1}",
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        onPressed: () {
          Navigator.of(context).push(
            createNoTransitionPageRoute(
              BookSelectScreen(bible: selectedBible),
            ),
          );
        },
      ),
      centerTitle: false,
      surfaceTintColor: Colors.white,
      leading: null,
      automaticallyImplyLeading: false,
      actions: const [
        MoreButton(),
      ],
    );
  }
}
