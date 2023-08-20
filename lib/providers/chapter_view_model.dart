import "dart:developer";
import "package:firebase_crashlytics/firebase_crashlytics.dart";
import "package:firebase_storage/firebase_storage.dart";
import "package:flutter/services.dart";
import "package:flutter/material.dart";
import "package:just_audio/just_audio.dart";
import "package:only_bible_app/screens/chapter_view_screen.dart";
import "package:only_bible_app/dialog.dart";
import "package:only_bible_app/models.dart";
import "package:provider/provider.dart";
import "package:share_plus/share_plus.dart";
import "package:shared_preferences/shared_preferences.dart";
import "package:only_bible_app/utils.dart";
import "package:only_bible_app/providers/app_model.dart";

class ChapterViewModel extends ChangeNotifier {
  final int book;
  final int chapter;
  final List<Verse> selectedVerses;
  final player = AudioPlayer();
  bool isPlaying = false;

  static ChapterViewModel of(BuildContext context) {
    return Provider.of(context, listen: true);
  }

  static ChapterViewModel ofEvent(BuildContext context) {
    return Provider.of(context, listen: false);
  }

  static Book selectedBook(BuildContext context) {
    final model = of(context);
    return AppModel.of(context).bible.books[model.book];
  }

  static Chapter selectedChapter(BuildContext context) {
    final model = of(context);
    return AppModel.of(context).bible.books[model.book].chapters[model.chapter];
  }

  ChapterViewModel({required this.book, required this.chapter, required this.selectedVerses}) {
    save(book, chapter);
  }

  save(int book, int chapter) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt("book", book);
    prefs.setInt("chapter", chapter);
  }

  navigateBookChapter(BuildContext context, int book, int chapter, TextDirection? dir) {
    if (isPlaying) {
      pause();
    }
    AppModel.ofEvent(context).hideActions(context);
    Navigator.of(context).push(
      createSlideRoute(
        context: context,
        slideDir: dir,
        page: ChapterViewScreen(book: book, chapter: chapter),
      ),
    );
  }

  onNext(BuildContext context, int book, int chapter) {
    final selectedBible = AppModel.ofEvent(context).bible;
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
    final selectedBible = AppModel.ofEvent(context).bible;
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

  bool hasSelectedVerses() {
    return selectedVerses.isNotEmpty;
  }

  void clearSelections(BuildContext context) {
    selectedVerses.clear();
    AppModel.ofEvent(context).hideActions(context);
    notifyListeners();
  }

  bool isVerseSelected(Verse v) {
    return selectedVerses.any((el) => el.index == v.index);
  }

  bool isVerseHighlighted(BuildContext context) {
    // box.read("${book}:${chapter}:${verse}", "color");
    return false;
  }

  void onVerseSelected(BuildContext context, Verse v) {
    if (selectedVerses.isEmpty) {
      AppModel.ofEvent(context).showActions(context);
    }
    if (isVerseSelected(v)) {
      selectedVerses.removeWhere((it) => it.index == v.index);
    } else {
      selectedVerses.add(v);
    }
    if (selectedVerses.isEmpty) {
      AppModel.ofEvent(context).hideActions(context);
    }
    notifyListeners();
  }

  void copyVerses() {
    final text = selectedVerses.map((e) => e.text).join("\n");
    Clipboard.setData(ClipboardData(text: text));
    // maybe close the action menu or show a snackbar on iOS (android already does this)
    // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Copied to clipboard")));
  }

  void shareVerses(BuildContext context) {
    final bible = AppModel.ofEvent(context).bible;
    final name = bible.books[selectedVerses.first.book].name;
    final chapter = selectedVerses.first.chapter + 1;
    final title = "$name $chapter: ${selectedVerses.map((e) => e.index + 1).join(", ")}";
    final text = selectedVerses.map((e) => e.text).join("\n");
    Share.share("$title\n$text", subject: title);
  }

  pause() async {
    await player.pause();
    isPlaying = false;
    notifyListeners();
  }

  onPlay(BuildContext context) async {
    final bible = AppModel.ofEvent(context).bible;
    if (!bible.hasAudio) {
      showError(
        context,
        "This Bible doesn't support audio. Currently audio is only available for the Kannada Bible.",
      );
      return;
    }
    if (isPlaying) {
      pause();
    } else {
      isPlaying = true;
      notifyListeners();
      for (final v in selectedVerses) {
        final bibleName = bible.name;
        final book = (v.book + 1).toString().padLeft(2, "0");
        final chapter = (v.chapter + 1).toString().padLeft(3, "0");
        final verseNo = (v.index + 1).toString().padLeft(3, "0");
        final pathname = "$bibleName/$book-$chapter-$verseNo.mp3";
        try {
          final url = await FirebaseStorage.instance.ref(pathname).getDownloadURL();
          await player.setUrl(url);
          await player.play();
          await player.stop();
        } catch (err) {
          log("Could not play audio", name: "play", error: (err.toString(), pathname));
          FirebaseCrashlytics.instance.recordFlutterError(FlutterErrorDetails(exception: (err.toString(), pathname)));
          showError(context, "Could not play audio");
          return;
        } finally {
          pause();
        }
      }
    }
  }
}