import "package:flutter/material.dart";
import "package:flutter/foundation.dart";
import "package:firebase_core/firebase_core.dart";
import "package:firebase_crashlytics/firebase_crashlytics.dart";
import "package:only_bible_app/firebase_options.dart";
import "package:flutter_native_splash/flutter_native_splash.dart";
import "package:only_bible_app/state.dart";
import "package:only_bible_app/app.dart";
import "package:provider/provider.dart";

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterError(errorDetails);
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack);
    return true;
  };
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  final model = AppModel();
  final (book, chapter) = await model.loadData();
  runApp(
    ChangeNotifierProvider.value(
      value: model,
      child: App(initialBook: book, initialChapter: chapter),
    ),
  );
  FlutterNativeSplash.remove();
}
