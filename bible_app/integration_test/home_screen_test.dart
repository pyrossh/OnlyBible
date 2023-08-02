import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:only_bible_app/main.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Home screen', () {
    testWidgets('should render', (tester) async {
      await tester.pumpWidget(const App());
      await tester.pumpAndSettle();
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
