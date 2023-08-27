import "dart:convert";
import "package:only_bible_app/dialog.dart";
import "package:only_bible_app/providers/app_provider.dart";
import "package:only_bible_app/providers/chapter_provider.dart";
import "package:url_launcher/url_launcher.dart";
import "package:flutter/foundation.dart" show defaultTargetPlatform, TargetPlatform;
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:only_bible_app/models.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:provider/provider.dart";

extension MyIterable<E> on Iterable<E> {
  Iterable<E> sortedBy(Comparable Function(E e) key) => toList()..sort((a, b) => key(a).compareTo(key(b)));
}

extension AppContext on BuildContext {
  ThemeData get theme => Theme.of(this);

  AppLocalizations get l => app.engTitles && app.locale.languageCode != "en"
      ? lookupAppLocalizations(const Locale("en"))
      : AppLocalizations.of(this)!;

  AppLocalizations get lEvent => appEvent.engTitles && appEvent.locale.languageCode != "en"
      ? lookupAppLocalizations(const Locale("en"))
      : AppLocalizations.of(this)!;

  AppProvider get app => Provider.of(this, listen: true);

  AppProvider get appEvent => Provider.of(this, listen: false);

  ChapterProvider get chapter => Provider.of(this, listen: true);

  ChapterProvider get chapterEvent => Provider.of(this, listen: false);

  double get actionsHeight {
    if (isIOS()) {
      return 80.0;
    }
    if (isWide) {
      return 60;
    }
    return 50.0;
  }

  bool get isWide {
    if (defaultTargetPlatform == TargetPlatform.android || defaultTargetPlatform == TargetPlatform.iOS) {
      return false;
    }
    final width = MediaQuery.of(this).size.width;
    return width > 700;
  }

  List<AppLocalizations> get supportedLocalizations {
    return AppLocalizations.supportedLocales
        .sortedBy((e) => e.languageCode)
        .map((e) => lookupAppLocalizations(e))
        .toList();
  }

  List<String> get bookNames {
    return [
      l.genesis,
      l.exodus,
      l.leviticus,
      l.numbers,
      l.deuteronomy,
      l.joshua,
      l.judges,
      l.ruth,
      l.firstSamuel,
      l.secondSamuel,
      l.firstKings,
      l.secondKings,
      l.firstChronicles,
      l.secondChronicles,
      l.ezra,
      l.nehemiah,
      l.esther,
      l.job,
      l.psalms,
      l.proverbs,
      l.ecclesiastes,
      l.song_of_solomon,
      l.isaiah,
      l.jeremiah,
      l.lamentations,
      l.ezekiel,
      l.daniel,
      l.hosea,
      l.joel,
      l.amos,
      l.obadiah,
      l.jonah,
      l.micah,
      l.nahum,
      l.habakkuk,
      l.zephaniah,
      l.haggai,
      l.zechariah,
      l.malachi,
      l.matthew,
      l.mark,
      l.luke,
      l.john,
      l.acts,
      l.romans,
      l.firstCorinthians,
      l.secondCorinthians,
      l.galatians,
      l.ephesians,
      l.philippians,
      l.colossians,
      l.firstThessalonians,
      l.secondThessalonians,
      l.firstTimothy,
      l.secondTimothy,
      l.titus,
      l.philemon,
      l.hebrews,
      l.james,
      l.firstPeter,
      l.secondPeter,
      l.firstJohn,
      l.secondJohn,
      l.thirdJohn,
      l.jude,
      l.revelation,
    ];
  }
}

bool isDesktop() {
  return defaultTargetPlatform == TargetPlatform.macOS ||
      defaultTargetPlatform == TargetPlatform.windows ||
      defaultTargetPlatform == TargetPlatform.linux;
}

bool isIOS() {
  return defaultTargetPlatform == TargetPlatform.iOS;
}

bool isAndroid() {
  return defaultTargetPlatform == TargetPlatform.android;
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
  if (context.isWide || slideDir == null) {
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

getBibleFromAsset(String file) async {
  final bytes = await rootBundle.load("assets/bibles/$file.txt");
  return getBibleFromText(utf8.decode(bytes.buffer.asUint8List(), allowMalformed: false));
}

openUrl(BuildContext context, String url) async {
  final uri = Uri.parse(url);
  if (await canLaunchUrl(uri)) {
    if (await launchUrl(uri)) {
      return;
    }
  }
  if (!context.mounted) return;
  showError(context, context.l.urlError);
}
