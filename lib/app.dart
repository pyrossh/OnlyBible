import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:flutter_reactive_value/flutter_reactive_value.dart";
import "package:only_bible_app/screens/chapter_view_screen.dart";
import "package:only_bible_app/state.dart";
import "package:only_bible_app/theme.dart";

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Only Bible App",
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      debugShowCheckedModeBanner: false,
      themeMode: darkMode.reactiveValue(context) ? ThemeMode.dark : ThemeMode.light,
      theme: lightTheme,
      darkTheme: darkTheme,
      home: ChapterViewScreen(book: bookIndex.value, chapter: chapterIndex.value),
      // routerConfig: GoRouter(
      //   debugLogDiagnostics: true,
      //   initialLocation: "/${selectedBible.value!.books[bookIndex.value].name}/${chapterIndex.value}",
      //   screens: [
      //     ShellRoute(
      //       builder: (context, state, child) {
      //         if (isWide(context)) {
      //           return Scaffold(
      //             backgroundColor: Theme.of(context).colorScheme.background,
      //             body: Row(
      //               children: [
      //                 const Sidebar(),
      //                 Flexible(
      //                   child: child,
      //                 ),
      //               ],
      //             ),
      //           );
      //         }
      //         return Scaffold(
      //           backgroundColor: Theme.of(context).colorScheme.background,
      //           body: SafeArea(
      //             child: child,
      //           ),
      //         );
      //       },
      //       screens: [
      //         GoRouteData.$route(
      //           path: "/:book/:chapter",
      //           factory: (GoRouterState state) => HomeScreen(
      //             book: state.pathParameters["book"]!,
      //             chapter: int.parse(state.pathParameters["chapter"]!),
      //           ),
      //         ),
      //       ],
      //     ),
      //   ],
      // ),
    );
  }
}
