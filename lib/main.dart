import "package:flutter/material.dart";
import "package:flutter/foundation.dart";
import "package:flutter_azure_tts/flutter_azure_tts.dart";
import "package:flutter_dotenv/flutter_dotenv.dart";
import "package:flutter_web_plugins/url_strategy.dart";
import "package:firebase_core/firebase_core.dart";
import "package:firebase_crashlytics/firebase_crashlytics.dart";
import "package:only_bible_app/firebase_options.dart";
import "package:flutter_native_splash/flutter_native_splash.dart";
import "package:only_bible_app/app.dart";
import "package:only_bible_app/navigation.dart";
import "package:only_bible_app/state.dart";

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FlutterError.onError = (errorDetails) {
    FlutterError.presentError(errorDetails);
    FirebaseCrashlytics.instance.recordFlutterError(errorDetails);
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack);
    return true;
  };
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  usePathUrlStrategy();
  await dotenv.load(fileName: ".env");
  AzureTts.init(
    subscriptionKey: dotenv.get("TTS_SUBSCRIPTION_KEY"),
    region: "centralindia",
    withLogs: false,
  );
  await initState();
  updateStatusBar(darkMode.value);
  bibleCache.value = loadBible(bibleName.value);
  runApp(const App());
  FlutterNativeSplash.remove();
}
