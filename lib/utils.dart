import "dart:convert";
import "package:flutter/foundation.dart" show defaultTargetPlatform, TargetPlatform;
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:only_bible_app/models.dart";


bool isDesktop() {
  return defaultTargetPlatform == TargetPlatform.macOS ||
      defaultTargetPlatform == TargetPlatform.windows ||
      defaultTargetPlatform == TargetPlatform.linux;
}

bool isIOS() {
  return defaultTargetPlatform == TargetPlatform.iOS;
}

bool isWide(BuildContext context) {
  if (defaultTargetPlatform == TargetPlatform.android || defaultTargetPlatform == TargetPlatform.iOS) {
    return false;
  }
  final width = MediaQuery.of(context).size.width;
  return width > 600;
}

createNoTransitionPageRoute(Widget page) {
  return PageRouteBuilder(
    opaque: false,
    transitionDuration: Duration.zero,
    reverseTransitionDuration: Duration.zero,
    pageBuilder: (context, _, __) => page,
  );
}

createSlideRoute({required BuildContext context, TextDirection? slideDir, required Widget page}) {
  if (isWide(context) || slideDir == null) {
    return PageRouteBuilder(
      pageBuilder: (context, _, __) {
        return page;
      },
    );
  }
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0);
      const end = Offset.zero;
      const curve = Curves.ease;
      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      return SlideTransition(
        textDirection: slideDir,
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}

getBibleFromAsset(String languageCode, String file) async {
  final bytes = await rootBundle.load("assets/bibles/$file.txt");
  return getBibleFromText(languageCode, utf8.decode(bytes.buffer.asUint8List(), allowMalformed: false));
}