import 'package:flutter/material.dart';
import 'package:flutter_reactive_value/flutter_reactive_value.dart';
import 'package:go_router/go_router.dart';
import 'package:one_context/one_context.dart';
import 'package:only_bible_app/routes/home_screen.dart';
import 'package:only_bible_app/state.dart';
import 'package:only_bible_app/widgets/sidebar.dart';
import 'package:only_bible_app/theme.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      builder: OneContext().builder,
      themeMode: darkMode.reactiveValue(context) ? ThemeMode.dark : ThemeMode.light,
      theme: lightTheme,
      darkTheme: darkTheme,
      routerConfig: GoRouter(
        debugLogDiagnostics: true,
        initialLocation: "/${selectedBible.value[bookIndex.value].name}/${chapterIndex.value}",
        routes: [
          ShellRoute(
            builder: (context, state, child) {
              if (isWide(context)) {
                return Scaffold(
                  backgroundColor: Theme.of(context).colorScheme.background,
                  body: Row(
                    children: [
                      const Sidebar(),
                      Flexible(
                        child: child,
                      ),
                    ],
                  ),
                );
              }
              return Scaffold(
                backgroundColor: Theme.of(context).colorScheme.background,
                body: SafeArea(
                  child: child,
                ),
              );
            },
            routes: [
              GoRouteData.$route(
                path: '/:book/:chapter',
                factory: (GoRouterState state) => HomeScreen(
                  book: state.pathParameters['book']!,
                  chapter: int.parse(state.pathParameters['chapter']!),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
