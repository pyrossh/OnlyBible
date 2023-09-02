import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:only_bible_app/blocs/bible_bloc.dart";
import "package:only_bible_app/screens/bible_select_screen.dart";
import "package:only_bible_app/screens/chapter_view_screen.dart";
import "package:only_bible_app/state.dart";
import "package:only_bible_app/theme.dart";
import "package:only_bible_app/utils.dart";
import "package:only_bible_app/widgets/scaffold_markdown.dart";

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<BibleBloc>(
      create: (context) => BibleBloc(null)
        ..add(
          firstOpen.value ? const BibleEvent.firstLoad() : BibleEvent.load(bibleName.value),
        ),
      child: Builder(
        builder: (context) {
          return MaterialApp(
            onGenerateTitle: (context) => context.l.title,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            debugShowCheckedModeBanner: false,
            themeMode: darkMode.watch(context) ? ThemeMode.dark : ThemeMode.light,
            theme: lightTheme,
            darkTheme: darkTheme,
            locale: Locale(languageCode.watch(context)),
            // initialRoute: "",
            routes: {
              // TODO: maybe have a landing page
              // "/": (context) => const ScaffoldMarkdown(title: "Privacy Policy", file: "privacy-policy.md"),
              "/privacy-policy": (context) =>
                  const ScaffoldMarkdown(title: "Privacy Policy", file: "privacy-policy.md"),
              "/about-us": (context) => const ScaffoldMarkdown(title: "About Us", file: "about-us.md"),
            },
            home: firstOpen.value
                ? const BibleSelectScreen()
                : ChapterViewScreen(
                    bookIndex: savedBook.value,
                    chapterIndex: savedChapter.value,
                  ),
          );
        },
      ),
    );
  }
}
