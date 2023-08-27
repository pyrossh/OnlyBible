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

  AppLocalizations get l10n => app.engTitles && app.locale.languageCode != "en"
      ? lookupAppLocalizations(const Locale("en"))
      : AppLocalizations.of(this)!;

  AppProvider get app => Provider.of(this, listen: true);

  AppProvider get appEvent => Provider.of(this, listen: false);

  ChapterProvider get chapter => Provider.of(this, listen: true);

  ChapterProvider get chapterEvent => Provider.of(this, listen: false);

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
      l10n.genesis,
      l10n.exodus,
      l10n.leviticus,
      l10n.numbers,
      l10n.deuteronomy,
      l10n.joshua,
      l10n.judges,
      l10n.ruth,
      l10n.firstSamuel,
      l10n.secondSamuel,
      l10n.firstKings,
      l10n.secondKings,
      l10n.firstChronicles,
      l10n.secondChronicles,
      l10n.ezra,
      l10n.nehemiah,
      l10n.esther,
      l10n.job,
      l10n.psalms,
      l10n.proverbs,
      l10n.ecclesiastes,
      l10n.song_of_solomon,
      l10n.isaiah,
      l10n.jeremiah,
      l10n.lamentations,
      l10n.ezekiel,
      l10n.daniel,
      l10n.hosea,
      l10n.joel,
      l10n.amos,
      l10n.obadiah,
      l10n.jonah,
      l10n.micah,
      l10n.nahum,
      l10n.habakkuk,
      l10n.zephaniah,
      l10n.haggai,
      l10n.zechariah,
      l10n.malachi,
      l10n.matthew,
      l10n.mark,
      l10n.luke,
      l10n.john,
      l10n.acts,
      l10n.romans,
      l10n.firstCorinthians,
      l10n.secondCorinthians,
      l10n.galatians,
      l10n.ephesians,
      l10n.philippians,
      l10n.colossians,
      l10n.firstThessalonians,
      l10n.secondThessalonians,
      l10n.firstTimothy,
      l10n.secondTimothy,
      l10n.titus,
      l10n.philemon,
      l10n.hebrews,
      l10n.james,
      l10n.firstPeter,
      l10n.secondPeter,
      l10n.firstJohn,
      l10n.secondJohn,
      l10n.thirdJohn,
      l10n.jude,
      l10n.revelation,
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
  showError(context, context.l10n.urlError);
}
