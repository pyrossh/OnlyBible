import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:integration_test/integration_test.dart";
import "package:only_bible_app/main.dart" as app;
import 'package:only_bible_app/store/state.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group("Chapter View screen", () {
    testWidgets("should render", (tester) async {
      app.main();
      await tester.pumpAndSettle();
      languageCodeAtom.value = "en";
      bibleNameAtom.update!("English");
      bibleCache.value = loadBible("English");
      await tester.pumpAndSettle();
      final bookTitle = find.byKey(const Key("bookTitle"));
      await tester.ensureVisible(bookTitle);
      await tester.tap(bookTitle);
      await tester.pumpAndSettle();

      await tester.ensureVisible(find.text("Old Testament"));
      await tester.ensureVisible(find.text("New Testament"));
      await tester.ensureVisible(find.byIcon(Icons.close));
      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();
      await tester.ensureVisible(bookTitle);
    });
  });
}
