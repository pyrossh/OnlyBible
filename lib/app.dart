import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:only_bible_app/screens/bible_select_screen.dart";
import "package:only_bible_app/screens/chapter_view_screen.dart";
import "package:only_bible_app/store/state.dart";
import "package:only_bible_app/theme.dart";
import "package:only_bible_app/utils.dart";

final globalNavigatorKey = GlobalKey<NavigatorState>();

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: globalNavigatorKey,
      onGenerateTitle: (context) => context.l.title,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      debugShowCheckedModeBanner: false,
      themeMode: darkModeAtom.watch(context) ? ThemeMode.dark : ThemeMode.light,
      theme: lightTheme,
      darkTheme: darkTheme,
      locale: Locale(languageCodeAtom.watch(context)),
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
