import "package:flutter/material.dart";
import "package:only_bible_app/models.dart";
import "package:provider/provider.dart";
import "package:shared_preferences/shared_preferences.dart";
import "package:only_bible_app/utils.dart";
import "package:only_bible_app/providers/app_provider.dart";

class ChapterProvider extends ChangeNotifier {
  final int book;
  final int chapter;

  static ChapterProvider of(BuildContext context) {
    return Provider.of(context, listen: true);
  }

  static ChapterProvider ofEvent(BuildContext context) {
    return Provider.of(context, listen: false);
  }

  static Book selectedBook(BuildContext context) {
    final model = of(context);
    return AppProvider.of(context).bible.books[model.book];
  }

  static Chapter selectedChapter(BuildContext context) {
    final model = of(context);
    return AppProvider.of(context).bible.books[model.book].chapters[model.chapter];
  }

  ChapterProvider({required this.book, required this.chapter}) {
    save(book, chapter);
  }

  save(int book, int chapter) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt("book", book);
    prefs.setInt("chapter", chapter);
  }

  navigateBookChapter(BuildContext context, int book, int chapter, TextDirection? dir) {
    context.appEvent.pushBookChapter(context, book, chapter, dir);
  }

  onNext(BuildContext context, int book, int chapter) {
    final selectedBible = AppProvider.ofEvent(context).bible;
    final selectedBook = selectedBible.books[book];
    if (selectedBook.chapters.length > chapter + 1) {
      navigateBookChapter(context, selectedBook.index, chapter + 1, TextDirection.ltr);
    } else {
      if (selectedBook.index + 1 < selectedBible.books.length) {
        final nextBook = selectedBible.books[selectedBook.index + 1];
        navigateBookChapter(context, nextBook.index, 0, TextDirection.ltr);
      }
    }
  }

  onPrevious(BuildContext context, int book, int chapter) {
    final selectedBible = AppProvider.ofEvent(context).bible;
    final selectedBook = selectedBible.books[book];
    if (chapter - 1 >= 0) {
      // if (Navigator.of(context).canPop()) {
      //   Navigator.of(context).pop();
      // } else {
      navigateBookChapter(context, selectedBook.index, chapter - 1, TextDirection.rtl);
      // }
    } else {
      if (selectedBook.index - 1 >= 0) {
        final prevBook = selectedBible.books[selectedBook.index - 1];
        navigateBookChapter(context, prevBook.index, prevBook.chapters.length - 1, TextDirection.rtl);
      }
    }
  }
}
