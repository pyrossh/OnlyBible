import 'package:flutter/material.dart';
import 'package:flutter_persistent_value_notifier/flutter_persistent_value_notifier.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:go_router/go_router.dart';
import 'package:one_context/one_context.dart';
import 'package:only_bible_app/models/theme.dart';
import 'components/shell.dart';
import 'routes/home_screen.dart';
import 'state.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await initPersistentValueNotifier();
  await loadBible();
  await updateStatusBar();
  runApp(MaterialApp.router(
    debugShowCheckedModeBanner: false,
    builder: OneContext().builder,
    theme: ThemeData(
      visualDensity: VisualDensity.adaptivePlatformDensity,
    ),
    routerConfig: GoRouter(
      debugLogDiagnostics: true,
      initialLocation:
          "/${selectedBible.value[bookIndex.value].name}/${chapterIndex.value}",
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
  ));
  FlutterNativeSplash.remove();
}
