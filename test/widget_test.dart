import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:spendly_app/core/config/env_config.dart';
import 'package:spendly_app/core/di/injection.dart';
import 'package:spendly_app/main.dart';

void main() {
  testWidgets('SpendlyApp boots to Splash without throwing', (tester) async {
    await EnvConfig.load();
    await Supabase.initialize(
      url: EnvConfig.supabaseUrl,
      publishableKey: EnvConfig.supabaseAnonKey,
      authOptions: const FlutterAuthClientOptions(
        localStorage: EmptyLocalStorage(),
        autoRefreshToken: false,
      ),
    );
    configureDependencies();
    await tester.pumpWidget(const SpendlyApp());
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('Spendly'), findsOneWidget);
  });
}
