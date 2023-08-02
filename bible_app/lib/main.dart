import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'domain/book.dart';
import 'state.dart';
import 'routes/index.dart';
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
  debugLogDiagnostics: true,
  routes: [
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) {
        SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
          systemNavigationBarColor: Colors.white,
          systemNavigationBarIconBrightness: Brightness.dark,
          statusBarColor: Colors.white,
          statusBarIconBrightness: Brightness.dark,
        ));
        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Row(
              children: [
                isDesktop() ? const Sidebar() : Container(),
                Flexible(
                  child: child,
                ),
              ],
            ),
          ),
        );
      },
      routes: [
        GoRouteData.$route(
          path: '/:book/:chapter',
          factory: (GoRouterState state) => HomeScreenRoute(
            book: state.pathParameters['book']!,
            chapter: int.parse(state.pathParameters['chapter']!),
          ),
        ),
      ],
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
      debugShowCheckedModeBanner: false,
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
