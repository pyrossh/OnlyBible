import "package:flutter/material.dart";
import "package:flutter/foundation.dart";
import "package:flutter_azure_tts/flutter_azure_tts.dart";
import "package:flutter_dotenv/flutter_dotenv.dart";
import "package:flutter_web_plugins/url_strategy.dart";
import "package:flutter_native_splash/flutter_native_splash.dart";
import "package:only_bible_app/app.dart";
import "package:only_bible_app/navigation.dart";
import "package:only_bible_app/store/state.dart";
import "package:only_bible_app/utils.dart";

void main() async {
  FlutterError.onError = (errorDetails) {
    FlutterError.presentError(errorDetails);
    recordError(errorDetails.exception.toString(), errorDetails.stack);
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    recordError(error.toString(), stack);
    return true;
  };
  FlutterNativeSplash.preserve(
    widgetsBinding: WidgetsFlutterBinding.ensureInitialized(),
  );
  usePathUrlStrategy();
  await dotenv.load(fileName: ".env");
  AzureTts.init(
    subscriptionKey: dotenv.get("TTS_SUBSCRIPTION_KEY"),
    region: "centralindia",
    withLogs: false,
  );
  await initState();
  updateStatusBar(darkModeAtom.value);
  runApp(const App());
  FlutterNativeSplash.remove();
}
