import "package:flutter/material.dart";
import 'package:go_router/go_router.dart';
import 'package:kannada_bible_app/domain/book.dart';
import 'package:kannada_bible_app/state.dart';
import 'routes/index.dart';
import 'routes/select.dart';
import "components/sidebar.dart";

var loadedState = (0, 0);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  loadedState = await loadState();
  runApp(const App());
}

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();
final _router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: "/${allBooks[loadedState.$1]}/${loadedState.$2}",
  routes: [
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      routes: [
        $homeScreenRoute,
        $selectScreenRoute,
      ],
      builder: (context, state, child) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: Row(
            children: [
              const Sidebar(),
              Flexible(
                child: child,
              ),
            ],
          ),
        );
      },
    ),
  ],
);

const lightColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: Color(0xFF4C2323),
  onPrimary: Color(0xFF4C2323),
  secondary: Colors.white,
  onSecondary: Colors.white,
  error: Colors.red,
  onError: Colors.red,
  background: Colors.white,
  onBackground: Colors.white,
  surface: Colors.white,
  onSurface: Colors.white,
);

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: const Color(0xFF4C2323),
        secondaryHeaderColor: const Color(0xFFFFB341),
        highlightColor: const Color(0xAAF8D0DC),
        fontFamily: "SanFranciscoPro",
        colorScheme: lightColorScheme,
        textTheme: const TextTheme(
          bodyMedium: TextStyle(
            color: Color(0xFF010101),
            fontSize: 16,
            fontFamily: "SanFranciscoPro",
            fontWeight: FontWeight.w400,
            // letterSpacing: 0.5,
          ),
          headlineLarge: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.5,
          ),
          headlineMedium: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
          labelMedium: TextStyle(
            fontFamily: "SanFrancisco",
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Color(0xFF9A1111),
            letterSpacing: 0.5,
          ),
          labelSmall: TextStyle(
            fontFamily: "SanFrancisco",
            fontSize: 12,
            fontWeight: FontWeight.w800,
            color: Color(0xFF9A1111),
            letterSpacing: 0.5,
          ),
          labelLarge: TextStyle(
            fontSize: 38,
            fontWeight: FontWeight.w700,
            color: Color(0xFFFFB341),
          ),
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.light,
        primaryColor: const Color(0xFF4C2323),
        secondaryHeaderColor: const Color(0xFFFFB341),
        highlightColor: const Color(0xAAF8D0DC),
        fontFamily: "SanFranciscoPro",
        textTheme: const TextTheme(
          bodyMedium: TextStyle(
            color: Color(0xFF010101),
            fontSize: 16,
            fontFamily: "SanFranciscoPro",
            fontWeight: FontWeight.w400,
            // letterSpacing: 0.5,
          ),
          headlineLarge: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.5,
          ),
          headlineMedium: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
          labelMedium: TextStyle(
            fontFamily: "SanFrancisco",
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
            letterSpacing: 0.5,
          ),
          labelSmall: TextStyle(
            fontFamily: "SanFrancisco",
            fontSize: 12,
            fontWeight: FontWeight.w800,
            color: Color(0xFF9A1111),
            letterSpacing: 0.5,
          ),
          labelLarge: TextStyle(
            fontSize: 38,
            fontWeight: FontWeight.w700,
            color: Color(0xFFFFB341),
          ),
        ),
      ),
    );
  }
}
