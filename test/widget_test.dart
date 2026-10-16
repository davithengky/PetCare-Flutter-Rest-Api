import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_application_1/app.dart';

void main() {
  testWidgets('PetCareApp smoke test', (WidgetTester tester) async {
    // Build PetCareApp and trigger a frame.
    await tester.pumpWidget(
      const ProviderScope(
        child: PetCareApp(),
      ),
    );
    await tester.pumpAndSettle();

    // Verify that login screen is displayed initially with PetCare header and Masuk button.
    expect(find.text('PetCare'), findsOneWidget);
    expect(find.text('Masuk'), findsOneWidget);
  });
}
