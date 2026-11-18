import 'package:flutter_test/flutter_test.dart';

import 'package:myportofolio_mobile/main.dart';

void main() {
  testWidgets('App renders smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that the app bar title is displayed.
    expect(find.text('MyPortfolio'), findsOneWidget);
    expect(find.text('Lihat Proyek'), findsOneWidget);
  });
}
