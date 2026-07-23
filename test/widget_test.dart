import 'package:flutter_test/flutter_test.dart';

import 'package:spendly_app/core/di/injection.dart';
import 'package:spendly_app/main.dart';

void main() {
  testWidgets('SpendlyApp boots to Splash without throwing', (tester) async {
    configureDependencies();
    await tester.pumpWidget(const SpendlyApp());
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('Spendly'), findsOneWidget);
  });
}
