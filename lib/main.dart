import 'package:flutter/material.dart';
import 'package:flutter_persistent_value_notifier/flutter_persistent_value_notifier.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:only_bible_app/state.dart';
import 'package:only_bible_app/app.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await initPersistentValueNotifier();
  await loadBible();
  await updateStatusBar();
  runApp(const App());
  FlutterNativeSplash.remove();
}
