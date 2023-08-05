import 'package:flutter/material.dart';
import 'package:flutter_persistent_value_notifier/flutter_persistent_value_notifier.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:go_router/go_router.dart';
import 'package:one_context/one_context.dart';
import 'package:only_bible_app/components/shell.dart';
import 'package:only_bible_app/routes/home_screen.dart';
import 'package:only_bible_app/state.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await initPersistentValueNotifier();
  await loadBible();
  await updateStatusBar();
  runApp(
    MaterialApp.router(
      debugShowCheckedModeBanner: false,
      builder: OneContext().builder,
      themeMode: ThemeMode.system,
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
        primaryColor: const Color(0xFF4C2323),
        secondaryHeaderColor: const Color(0xFFFFB341),
        highlightColor: const Color(0xAAF8D0DC),
        dividerColor: Colors.black,
        shadowColor: Colors.black,
        colorScheme: const ColorScheme.light(
          background: Colors.white,
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            shape: const RoundedRectangleBorder(),
            elevation: 1,
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
        primaryColor: const Color(0xFF4C2323),
        secondaryHeaderColor: const Color(0xFFFFB341),
        highlightColor: const Color(0xAAF8D0DC),
        dividerColor: Colors.white,
        shadowColor: Colors.white,
        colorScheme: const ColorScheme.dark(
          background: Color(0xFF1F1F22),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            shape: const RoundedRectangleBorder(),
            elevation: 1,
            backgroundColor: const Color(0xFF323232),
            foregroundColor: const Color(0xFFBBBBBB),
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
            color: Color(0xFFFFB341),
          ),
          headlineMedium: TextStyle(
            color: Color(0xFFBCBEC4),
            fontSize: 20,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.5,
          ),
          labelMedium: TextStyle(
            color: Color(0xFFBBBBBB),
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
          Shell(
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
    ),
  );
  FlutterNativeSplash.remove();
}
