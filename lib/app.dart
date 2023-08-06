import 'package:flutter/material.dart';
import 'package:flutter_reactive_value/flutter_reactive_value.dart';
import 'package:go_router/go_router.dart';
import 'package:one_context/one_context.dart';
import 'package:only_bible_app/routes/home_screen.dart';
import 'package:only_bible_app/state.dart';
import 'package:only_bible_app/components/sidebar.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      builder: OneContext().builder,
      themeMode: darkMode.reactiveValue(context) ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
        primaryColor: const Color(0xFF4C2323),
        primaryColorDark: const Color(0xFF3C1B1C),
        primaryColorLight: const Color(0xFF7F3D3C),
        secondaryHeaderColor: const Color(0xFFFFB341),
        highlightColor: const Color(0xAAF8D0DC),
        dividerColor: Colors.black,
        shadowColor: Colors.black,
        popupMenuTheme: const PopupMenuThemeData(
          elevation: 4,
        ),
        colorScheme: const ColorScheme.light(
          background: Colors.white,
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            shape: const RoundedRectangleBorder(),
            elevation: isWide(context) ? 1 : 0.5,
            // backgroundColor: const Color(0xFFF6F6F6),
            backgroundColor: const Color(0xFFEAE9E9),
            foregroundColor: const Color(0xFF9A1111),
            textStyle: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Color(0xFF9A1111),
              letterSpacing: 0.5,
            ),
          ),
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(
            color: Color(0xFF010101),
          ),
          headlineLarge: TextStyle(
            fontSize: 38,
            fontWeight: FontWeight.w700,
            color: Color(0xFFFFB341),
          ),
          headlineMedium: TextStyle(
            color: Color(0xFF010101),
            fontSize: 20,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.5,
          ),
          labelMedium: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w800,
            color: Color(0xFF9A1111),
            letterSpacing: 0.5,
          ),
        ),
      ),
      darkTheme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
        primaryColor: const Color(0xFF2D0B0B),
        primaryColorDark: const Color(0xFF260909),
        primaryColorLight: const Color(0xFF481514),
        secondaryHeaderColor: const Color(0xFFFFC351),
        highlightColor: const Color(0xAA5D4979),
        dividerColor: Colors.white,
        shadowColor: Colors.white,
        popupMenuTheme: const PopupMenuThemeData(
          elevation: 2,
        ),
        colorScheme: const ColorScheme.dark(
          background: Color(0xFF1F1F22),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            shape: const RoundedRectangleBorder(),
            elevation: isWide(context) ? 1 : 0.5,
            backgroundColor: const Color(0xFF323232),
            foregroundColor: const Color(0xFFBC86FC),
            textStyle: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Color(0xFF9A1111),
              letterSpacing: 0.5,
            ),
          ),
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(
            color: Color(0xFFBCBEC4),
          ),
          headlineLarge: TextStyle(
            fontSize: 38,
            fontWeight: FontWeight.w700,
            color: Color(0xFFFFC351),
          ),
          headlineMedium: TextStyle(
            color: Color(0xFFBCBEC4),
            fontSize: 20,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.5,
          ),
          labelMedium: TextStyle(
            color: Color(0xFFBA50AB),
            fontSize: 12,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.5,
          ),
        ),
      ),
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
