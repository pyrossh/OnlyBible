import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:only_bible_app/screens/bible_select_screen.dart";
import "package:only_bible_app/screens/chapter_view_screen.dart";
import "package:only_bible_app/theme.dart";
import "package:only_bible_app/utils.dart";
import "package:only_bible_app/widgets/scaffold_markdown.dart";

class App extends StatelessWidget {
  final int initialBook;
  final int initialChapter;

  const App({super.key, required this.initialBook, required this.initialChapter});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateTitle: (context) => context.l.title,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      debugShowCheckedModeBanner: false,
      themeMode: context.app.darkMode ? ThemeMode.dark : ThemeMode.light,
      theme: lightTheme,
      darkTheme: darkTheme,
      locale: context.app.locale,
      // initialRoute: "",
      routes: {
        // TODO: maybe have a landing page
        // "/": (context) => const ScaffoldMarkdown(title: "Privacy Policy", file: "privacy-policy.md"),
        "/privacy-policy": (context) => const ScaffoldMarkdown(title: "Privacy Policy", file: "privacy-policy.md"),
        "/about-us": (context) => const ScaffoldMarkdown(title: "About Us", file: "about-us.md"),
      },
      home: context.app.firstOpen
          ? const BibleSelectScreen()
          : ChapterViewScreen(bookIndex: initialBook, chapterIndex: initialChapter),
    );
  }
}
