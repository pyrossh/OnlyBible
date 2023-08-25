import 'dart:ui' as ui;
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:only_bible_app/providers/app_model.dart";
import "package:only_bible_app/screens/chapter_view_screen.dart";
import "package:only_bible_app/theme.dart";

class App extends StatelessWidget {
  final int initialBook;
  final int initialChapter;

  const App({super.key, required this.initialBook, required this.initialChapter});

  @override
  Widget build(BuildContext context) {
    final model = AppModel.of(context);
    return MaterialApp(
      title: "Only Bible App",
      locale: model.locale,
      // onGenerateTitle: (context) =>
      //   DemoLocalizations.of(context).title,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      debugShowCheckedModeBanner: false,
      themeMode: model.darkMode ? ThemeMode.dark : ThemeMode.light,
      theme: lightTheme,
      darkTheme: darkTheme,
      home: ChapterViewScreen(book: initialBook, chapter: initialChapter),
    );
  }
}
