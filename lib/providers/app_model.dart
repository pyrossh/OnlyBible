// import "package:firebase_performance/firebase_performance.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:flutter/services.dart";
import "package:flutter/material.dart";
import "package:only_bible_app/screens/bible_select_screen.dart";
import "package:only_bible_app/screens/book_select_screen.dart";
import "package:only_bible_app/models.dart";
import "package:only_bible_app/widgets/actions_sheet.dart";
import "package:only_bible_app/widgets/highlight_button.dart";
import "package:only_bible_app/widgets/scaffold_markdown.dart";
import "package:only_bible_app/widgets/note_sheet.dart";
import "package:only_bible_app/widgets/settings_sheet.dart";
import "package:package_info_plus/package_info_plus.dart";
import "package:provider/provider.dart";
import "package:share_plus/share_plus.dart";
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
  late PackageInfo packageInfo;
  late Bible bible;
  late Locale locale;
  bool engTitles = false;
  bool darkMode = false;
  bool fontBold = false;
  double textScaleFactor = 0;
  bool actionsShown = false;
  bool highlightMenuShown = false;
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
    await prefs.setString("bibleName", bible.name);
    await prefs.setBool("darkMode", darkMode);
    await prefs.setBool("fontBold", fontBold);
    await prefs.setDouble("textScaleFactor", textScaleFactor);
    await prefs.setString("languageCode", locale.languageCode);
  }

  Future<(int, int)> loadData() async {
    packageInfo = await PackageInfo.fromPlatform();
    final prefs = await SharedPreferences.getInstance();
    darkMode = prefs.getBool("darkMode") ?? false;
    fontBold = prefs.getBool("fontBold") ?? false;
    textScaleFactor = prefs.getDouble("textScaleFactor") ?? 1;
    locale = Locale(prefs.getString("languageCode") ?? "en");
    bible = await loadBible(prefs.getString("bibleName") ?? "English");
    // await Future.delayed(Duration(seconds: 3));
    final book = prefs.getInt("book") ?? 0;
    final chapter = prefs.getInt("chapter") ?? 0;
    updateStatusBar();
    return (book, chapter);
  }

  Future<Bible> loadBible(String name) async {
    // Trace customTrace;
    // if (!isDesktop()) {
    //   customTrace = FirebasePerformance.instance.newTrace("loadBible");
    //   await customTrace.start();
    // }
    final books = await getBibleFromAsset(name);
    // if (!isDesktop()) {
    //   await customTrace.stop();
    // }
    return Bible.withBooks(
      name: name,
      hasAudio: true,
      books: books,
    );
  }

  List<String> getBookNames(BuildContext context) {
    final l = engTitles ? lookupAppLocalizations(Locale("en")) : AppLocalizations.of(context)!;
    return [
      l.genesis,
      l.exodus,
      l.leviticus,
      l.numbers,
      l.deuteronomy,
      l.joshua,
      l.judges,
      l.ruth,
      l.firstSamuel,
      l.secondSamuel,
      l.firstKings,
      l.secondKings,
      l.firstChronicles,
      l.secondChronicles,
      l.ezra,
      l.nehemiah,
      l.esther,
      l.job,
      l.psalms,
      l.proverbs,
      l.ecclesiastes,
      l.song_of_solomon,
      l.isaiah,
      l.jeremiah,
      l.lamentations,
      l.ezekiel,
      l.daniel,
      l.hosea,
      l.joel,
      l.amos,
      l.obadiah,
      l.jonah,
      l.micah,
      l.nahum,
      l.habakkuk,
      l.zephaniah,
      l.haggai,
      l.zechariah,
      l.malachi,
      l.matthew,
      l.mark,
      l.luke,
      l.john,
      l.acts,
      l.romans,
      l.firstCorinthians,
      l.secondCorinthians,
      l.galatians,
      l.ephesians,
      l.philippians,
      l.colossians,
      l.firstThessalonians,
      l.secondThessalonians,
      l.firstTimothy,
      l.secondTimothy,
      l.titus,
      l.philemon,
      l.hebrews,
      l.james,
      l.firstPeter,
      l.secondPeter,
      l.firstJohn,
      l.secondJohn,
      l.thirdJohn,
      l.jude,
      l.revelation,
    ];
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

  // TODO: maybe don't pass name here
  updateCurrentBible(BuildContext context, Locale l, String name) async {
    // TODO: maybe use a future as the bible needs to load
    locale = l;
    bible = await loadBible(name);
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

  toggleDarkMode() {
    darkMode = !darkMode;
    updateStatusBar();
    notifyListeners();
    save();
  }

  toggleEngBookNames() {
    engTitles = !engTitles;
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
      clipBehavior: Clip.antiAliasWithSaveLayer,
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

  static Color fromHexS(String hexString) {
    return Color(int.parse(hexString, radix: 16));
  }

  String toHexS(Color c) => '${c.alpha.toRadixString(16).padLeft(2, '0')}'
      '${c.red.toRadixString(16).padLeft(2, '0')}'
      '${c.green.toRadixString(16).padLeft(2, '0')}'
      '${c.blue.toRadixString(16).padLeft(2, '0')}';

  Color? getHighlight(Verse v) {
    final key = "${v.book}:${v.chapter}:${v.index}:highlight";
    if (box.hasData(key)) {
      // box.remove(key);
      // print(box.read(key));
      return fromHexS(box.read(key));
    }
    return null;
  }

  void setHighlight(BuildContext context, List<Verse> verses, Color c) {
    for (final v in verses) {
      box.write("${v.book}:${v.chapter}:${v.index}:highlight", toHexS(c));
    }
    box.save();
  }

  void removeHighlight(BuildContext context, List<Verse> verses) {
    for (final v in verses) {
      box.remove("${v.book}:${v.chapter}:${v.index}:highlight");
    }
    box.save();
  }

  void showHighlightMenu(BuildContext context, List<Verse> verses, Offset position) {
    hideHighlightMenu(context);
    highlightMenuShown = true;
    final overlay = Overlay.of(context).context.findRenderObject();
    onTap(c) => setHighlight(context, verses, c);

    showMenu(
        context: context,
        position: RelativeRect.fromRect(
          Rect.fromLTWH(position.dx, position.dy + 30, 100, 100),
          Rect.fromLTWH(0, 0, overlay!.paintBounds.size.width, overlay.paintBounds.size.height),
        ),
        items: [
          PopupMenuItem(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                HighlightButton(
                  color: const Color(0xFFDAEFFE),
                  onColorSelected: onTap,
                ),
                HighlightButton(
                  color: const Color(0xFFFFFBB1),
                  onColorSelected: onTap,
                ),
                HighlightButton(
                  color: const Color(0xFFFFDEF3),
                  onColorSelected: onTap,
                ),
                HighlightButton(
                  color: const Color(0xFFE6FCC3),
                  onColorSelected: onTap,
                ),
                HighlightButton(
                  color: const Color(0xFFEADDFF),
                  onColorSelected: onTap,
                ),
              ],
            ),
          ),
        ]);
  }

  void hideHighlightMenu(BuildContext context) {
    if (highlightMenuShown) {
      Navigator.of(context).pop();
    }
  }

  void shareAppLink(BuildContext context) {
    if (isAndroid()) {
      Share.share(
        subject: "Only Bible App",
        "https://play.google.com/store/apps/details?id=${packageInfo.packageName}",
      );
    } else if (isIOS()) {
      Share.share(
        subject: "Only Bible App",
        "https://apps.apple.com/us/app/hare-pro/id123",
      );
    } else {
      Share.share(
        subject: "Only Bible App",
        "https://onlybible.app",
      );
    }
  }

  void rateApp(BuildContext context) {
    if (isAndroid()) {
      openUrl(context, "https://play.google.com/store/apps/details?id=${packageInfo.packageName}");
    } else if (isIOS()) {
      openUrl(context, "https://apps.apple.com/us/app/hare-pro/id123");
    }
  }

  showPrivacyPolicy(BuildContext context) {
    Navigator.of(context).push(
      createNoTransitionPageRoute(
        const ScaffoldMarkdown(title: "Privacy Policy", file: "privacy-policy.md"),
      ),
    );
  }

  showAboutUs(BuildContext context) {
    Navigator.of(context).push(
      createNoTransitionPageRoute(
        const ScaffoldMarkdown(title: "About Us", file: "about-us.md"),
      ),
    );
  }
}
