// import "package:firebase_performance/firebase_performance.dart";
import "package:flutter/services.dart";
import "package:flutter/material.dart";
import "package:only_bible_app/screens/bible_select_screen.dart";
import "package:only_bible_app/screens/book_select_screen.dart";
import "package:only_bible_app/models.dart";
import "package:only_bible_app/widgets/actions_sheet.dart";
import "package:only_bible_app/widgets/note_sheet.dart";
import "package:only_bible_app/widgets/settings_sheet.dart";
import "package:provider/provider.dart";
import "package:shared_preferences/shared_preferences.dart";
import "package:get_storage/get_storage.dart";
import "package:only_bible_app/utils.dart";

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
  final TextEditingController noteTextController = TextEditingController();
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

  bool hasNote(Verse v) {
    return box.hasData("${v.book}:${v.chapter}:${v.index}:note");
  }

  showNoteField(BuildContext context, Verse v) {
    final noteText = box.read("${v.book}:${v.chapter}:${v.index}:note") ?? "";
    noteTextController.text = noteText;
    showModalBottomSheet(
      context: context,
      isDismissible: true,
      enableDrag: true,
      showDragHandle: true,
      useSafeArea: true,
      isScrollControlled: true,
      builder: (context) => NoteSheet(verse: v),
    );
  }

  saveNote(BuildContext context, Verse v) {
    final note = noteTextController.text;
    box.write("${v.book}:${v.chapter}:${v.index}:note", note);
    box.save();
    // Close the bottom sheet
    // if (!mounted) return;
    // Navigator.of(context).pop();
    notifyListeners();
    hideNoteField(context);
  }

  deleteNote(BuildContext context, Verse v) {
    box.remove("${v.book}:${v.chapter}:${v.index}:note");
    box.save();
    notifyListeners();
    hideNoteField(context);
  }

  hideNoteField(BuildContext context) {
    Navigator.of(context).pop();
  }
}
