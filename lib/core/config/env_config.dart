import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Which backend a feature's repository talks to. Only Auth and Category
/// Management have a real [backend] implementation so far — every other
/// feature ignores this flag and always uses Supabase (see
/// `lib/core/di/injection.dart`).
enum DataSourceMode { supabase, backend }

/// Typed access to `.env.dev`/`.env.prod` — never read `dotenv.env[...]`
/// directly elsewhere. Call [load] once in `main()` before anything needs
/// these values.
abstract class EnvConfig {
  /// Selected at build/run time via `--dart-define=ENV=dev|prod` — defaults
  /// to `dev` so plain `flutter run`/`flutter test` keep working unchanged.
  static const _environment = String.fromEnvironment('ENV', defaultValue: 'dev');

  static Future<void> load() => dotenv.load(fileName: '.env.$_environment');

  static String get supabaseUrl => _require('SUPABASE_URL');
  static String get supabaseAnonKey => _require('SUPABASE_ANON_KEY');

  /// Defaults to [DataSourceMode.supabase] when unset/unrecognized, since
  /// only part of the app has a backend-mode implementation today —
  /// switching requires an explicit opt-in via `.env`.
  static DataSourceMode get dataSource =>
      dotenv.env['DATA_SOURCE']?.trim().toLowerCase() == 'backend'
          ? DataSourceMode.backend
          : DataSourceMode.supabase;

  /// Not `_require`d — irrelevant for Supabase-only setups.
  static String get backendBaseUrl => dotenv.env['BACKEND_BASE_URL'] ?? '';

  /// The Google Cloud Console **"Web Client ID"** (OAuth client, type "Web
  /// application") — this is what `google_sign_in` needs as `serverClientId`
  /// to return a Google ID token (not just an access token), and it MUST
  /// match the custom backend's own `GOOGLE_SERVER_CLIENT_ID` config exactly,
  /// since it's the token's audience.
  static String get googleServerClientId =>
      dotenv.env['GOOGLE_SERVER_CLIENT_ID'] ??
      '862962792937-7ik3ei06497khubu9goja5usa28480qd.apps.googleusercontent.com';

  /// The **"Spendly iOS"** OAuth client (type "iOS") — REQUIRED as
  /// `clientId:` when constructing `GoogleSignIn(...)` on iOS.
  /// `google_sign_in_ios` does NOT read `Info.plist`'s `GIDClientID` key
  /// itself; it only resolves a client ID from this runtime parameter or
  /// from a `GoogleService-Info.plist` that's actually added as an Xcode
  /// build resource (ours isn't). Without this, `GIDSignIn` has no
  /// configuration and crashes with an uncaught native `NSException` the
  /// instant sign-in is invoked.
  static String get googleIosClientId =>
      dotenv.env['GOOGLE_IOS_CLIENT_ID'] ??
      '862962792937-7ce4f3o418ft0v171mp09e6rpihkjbhv.apps.googleusercontent.com';

  static String _require(String key) {
    final value = dotenv.env[key];
    final isPlaceholder =
        value == null || value.isEmpty || value.startsWith('your-');
    if (isPlaceholder) {
      throw StateError(
        'Missing $key in .env.$_environment — copy .env.$_environment.example '
        'to .env.$_environment and fill in your Supabase project values '
        '(Project Settings → API).',
      );
    }
    return value;
  }
}
