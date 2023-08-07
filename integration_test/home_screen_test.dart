import 'package:flutter/cupertino.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_persistent_value_notifier/flutter_persistent_value_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:only_bible_app/app.dart';
import 'package:only_bible_app/state.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Home screen', () {
    testWidgets('should render', (tester) async {
      WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
      FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
      await initPersistentValueNotifier();
      await loadBible();
      await updateStatusBar();
      await tester.pumpWidget(const App());
      await tester.pumpAndSettle();
      FlutterNativeSplash.remove();
      expect(find.text('Genesis 1'), findsOneWidget);
      // // Finds the floating action button to tap on.
      // final Finder fab = find.byTooltip('Increment');
      //
      // // Emulate a tap on the floating action button.
      // await tester.tap(fab);
      //
      // // Trigger a frame.
      // await tester.pumpAndSettle();
      //
      // // Verify the counter increments by 1.
      // expect(find.text('1'), findsOneWidget);
    });
  });
}
