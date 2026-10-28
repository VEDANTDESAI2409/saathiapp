import 'package:flutter_test/flutter_test.dart';
import 'package:saathiapp/main.dart';

void main() {
  testWidgets('SaathiApp initial render smoke test', (
    WidgetTester tester,
  ) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const SaathiApp());

    // Verify splash screen or brand elements render properly
    expect(find.byType(SaathiApp), findsOneWidget);
  });
}
