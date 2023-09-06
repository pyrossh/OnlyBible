import "package:flutter/material.dart";
import "package:flutter/foundation.dart";
import "package:flutter/scheduler.dart";
import "package:flutter_azure_tts/flutter_azure_tts.dart";
import "package:flutter_dotenv/flutter_dotenv.dart";
import "package:flutter_web_plugins/url_strategy.dart";
import "package:flutter_native_splash/flutter_native_splash.dart";
import "package:only_bible_app/app.dart";
import "package:only_bible_app/dialog.dart";
import "package:only_bible_app/navigation.dart";
import "package:only_bible_app/store/state.dart";

void main() async {
  FlutterError.onError = (errorDetails) {
    SchedulerBinding.instance.addPostFrameCallback((d) {
      showReportError(
        globalNavigatorKey.currentState!.context,
        errorDetails.exception.toString(),
        errorDetails.stack,
      );
    });
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    Future.delayed(const Duration(seconds: 1), () {
      showReportError(
        globalNavigatorKey.currentState!.context,
        error.toString(),
        stack,
      );
    });
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
