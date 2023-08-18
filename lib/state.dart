import "dart:convert";
import "dart:developer";
import "package:firebase_crashlytics/firebase_crashlytics.dart";
import "package:firebase_storage/firebase_storage.dart";

// import "package:firebase_performance/firebase_performance.dart";
import "package:flutter/foundation.dart" show defaultTargetPlatform, TargetPlatform;
import "package:flutter/services.dart";
import "package:flutter/material.dart";
import "package:just_audio/just_audio.dart";
import "package:only_bible_app/screens/bible_select_screen.dart";
import "package:only_bible_app/screens/book_select_screen.dart";
import "package:only_bible_app/screens/chapter_view_screen.dart";
import "package:only_bible_app/dialog.dart";
import "package:only_bible_app/models.dart";
import "package:only_bible_app/widgets/actions_sheet.dart";
import "package:only_bible_app/widgets/scaffold_menu.dart";
import "package:only_bible_app/widgets/settings_sheet.dart";
import "package:provider/provider.dart";
import "package:share_plus/share_plus.dart";
import "package:shared_preferences/shared_preferences.dart";
import "package:get_storage/get_storage.dart";

class HistoryFrame {
  final int book;
  final int chapter;
  final int? verse;

  const HistoryFrame({required this.book, required this.chapter, this.verse});
}

class AppModel extends ChangeNotifier {
  String languageCode = "en";
  Bible bible = bibles.first;
  bool darkMode = false;
  bool fontBold = false;
  double textScaleFactor = 0;
  bool actionsShown = false;
  List<HistoryFrame> history = [];
  final box = GetStorage("only-bible-app-backup");

  static AppModel of(BuildContext context) {
    return Provider.of(context, listen: true);
  }

  static AppModel ofEvent(BuildContext context) {
    return Provider.of(context, listen: false);
  }

  save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt("bibleId", bible.id);
    await prefs.setBool("darkMode", darkMode);
    await prefs.setBool("fontBold", fontBold);
    await prefs.setDouble("textScaleFactor", textScaleFactor);
  }

  Future<(int, int)> loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final bibleId = prefs.getInt("bibleId") ?? 1;
    darkMode = prefs.getBool("darkMode") ?? false;
    fontBold = prefs.getBool("fontBold") ?? false;
    textScaleFactor = prefs.getDouble("textScaleFactor") ?? 1;
    bible = await loadBible(bibleId);
    // await Future.delayed(Duration(seconds: 3));
    final book = prefs.getInt("book") ?? 0;
    final chapter = prefs.getInt("chapter") ?? 0;
    updateStatusBar();
    return (book, chapter);
  }

  Future<Bible> loadBible(int id) async {
    final selectedBible = bibles.firstWhere((it) => it.id == id);
    // Trace customTrace;
    // if (!isDesktop()) {
    //   customTrace = FirebasePerformance.instance.newTrace("loadBible");
    //   await customTrace.start();
    // }
    final books = await getBibleFromAsset(languageCode, selectedBible.name);
    // if (!isDesktop()) {
    //   await customTrace.stop();
    // }
    return Bible.withBooks(
      id: selectedBible.id,
      name: selectedBible.name,
      hasAudio: selectedBible.hasAudio,
      books: books,
    );
  }

  changeBible(BuildContext context) {
    Navigator.of(context).pushReplacement(
      createNoTransitionPageRoute(
        const BibleSelectScreen(),
      ),
    );
  }

  changeBibleFromHeader(BuildContext context) {
    Navigator.of(context).push(
      createNoTransitionPageRoute(
        const BibleSelectScreen(),
      ),
    );
  }

  updateCurrentBible(BuildContext context, int id) async {
    // TODO: maybe use a future as the bible needs to load
    bible = await loadBible(id);
    notifyListeners();
    save();
  }

  changeBook(BuildContext context) {
    Navigator.of(context).push(
      createNoTransitionPageRoute(
        BookSelectScreen(bible: bible),
      ),
    );
  }

  toggleMode() async {
    darkMode = !darkMode;
    updateStatusBar();
    notifyListeners();
    save();
  }

  updateStatusBar() {
    if (darkMode) {
      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        systemNavigationBarColor: Color(0xFF1F1F22),
        statusBarColor: Color(0xFF1F1F22),
        systemNavigationBarIconBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.light,
      ));
    } else {
      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.white,
        statusBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.dark,
      ));
    }
  }

  toggleBold() async {
    fontBold = !fontBold;
    notifyListeners();
    save();
  }

  increaseFont() async {
    textScaleFactor += 0.1;
    notifyListeners();
    save();
  }

  decreaseFont() async {
    textScaleFactor -= 0.1;
    notifyListeners();
    save();
  }

  showSettings(BuildContext context) {
    // if (isWide(context)) {
    //   Navigator.of(context).push(
    //     createNoTransitionPageRoute(
    //       const ScaffoldMenu(
    //         backgroundColor: Color(0xFFF2F2F7),
    //         child: SettingsSheet(),
    //       ),
    //     ),
    //   );
    // } else {
    showModalBottomSheet(
      context: context,
      isDismissible: true,
      enableDrag: true,
      showDragHandle: true,
      useSafeArea: true,
      builder: (context) => const SettingsSheet(),
    );
    // }
  }

  showActions(BuildContext context) {
    actionsShown = true;
    Scaffold.of(context).showBottomSheet(
      enableDrag: false,
      (context) => const ActionsSheet(),
    );
    notifyListeners();
  }

  hideActions(BuildContext context) {
    if (actionsShown) {
      actionsShown = false;
      Navigator.of(context).pop();
      notifyListeners();
    }
  }
}

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
    // maybe close the action menu or show a snackbar
    // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Email address copied to clipboard")));
  }

  void shareVerses() {
    final text = selectedVerses.map((e) => e.text).join("\n");
    Share.share(text);
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

bool isDesktop() {
  return defaultTargetPlatform == TargetPlatform.macOS ||
      defaultTargetPlatform == TargetPlatform.windows ||
      defaultTargetPlatform == TargetPlatform.linux;
}

bool isIOS() {
  return defaultTargetPlatform == TargetPlatform.iOS;
}

bool isWide(BuildContext context) {
  if (defaultTargetPlatform == TargetPlatform.android || defaultTargetPlatform == TargetPlatform.iOS) {
    return false;
  }
  final width = MediaQuery.of(context).size.width;
  return width > 600;
}

createNoTransitionPageRoute(Widget page) {
  return PageRouteBuilder(
    opaque: false,
    transitionDuration: Duration.zero,
    reverseTransitionDuration: Duration.zero,
    pageBuilder: (context, _, __) => page,
  );
}

createSlideRoute({required BuildContext context, TextDirection? slideDir, required Widget page}) {
  if (isWide(context) || slideDir == null) {
    return PageRouteBuilder(
      pageBuilder: (context, _, __) {
        return page;
      },
    );
  }
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0);
      const end = Offset.zero;
      const curve = Curves.ease;
      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      return SlideTransition(
        textDirection: slideDir,
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}

getBibleFromAsset(String languageCode, String file) async {
  final bytes = await rootBundle.load("assets/bibles/$file.txt");
  return getBibleFromText(languageCode, utf8.decode(bytes.buffer.asUint8List(), allowMalformed: false));
}
