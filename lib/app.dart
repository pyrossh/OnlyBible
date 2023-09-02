import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:only_bible_app/screens/bible_select_screen.dart";
import "package:only_bible_app/screens/chapter_view_screen.dart";
import 'package:only_bible_app/store/state.dart';
import "package:only_bible_app/theme.dart";
import "package:only_bible_app/utils.dart";
import "package:only_bible_app/widgets/scaffold_markdown.dart";

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateTitle: (context) => context.l.title,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      debugShowCheckedModeBanner: false,
      themeMode: darkModeAtom.watch(context) ? ThemeMode.dark : ThemeMode.light,
      theme: lightTheme,
      darkTheme: darkTheme,
      locale: Locale(languageCodeAtom.watch(context)),
      // initialRoute: "",
      routes: {
        // TODO: maybe have a landing page
        // "/": (context) => const ScaffoldMarkdown(title: "Privacy Policy", file: "privacy-policy.md"),
        "/privacy-policy": (context) => const ScaffoldMarkdown(title: "Privacy Policy", file: "privacy-policy.md"),
        "/about-us": (context) => const ScaffoldMarkdown(title: "About Us", file: "about-us.md"),
      },
      home: firstOpenAtom.value
          ? const BibleSelectScreen()
          : ChapterViewScreen(
              bibleName: bibleNameAtom.value,
              bookIndex: savedBookAtom.value,
              chapterIndex: savedChapterAtom.value,
            ),
    );
  }
}
