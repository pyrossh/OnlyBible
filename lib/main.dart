import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:only_bible_app/firebase_options.dart';
import 'package:flutter_persistent_value_notifier/flutter_persistent_value_notifier.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:only_bible_app/state.dart';
import 'package:only_bible_app/app.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await initPersistentValueNotifier();
  await loadBible();
  await updateStatusBar();
  runApp(const App());
  FlutterNativeSplash.remove();
}
