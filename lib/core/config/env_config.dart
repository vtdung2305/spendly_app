import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Typed access to `.env` — never read `dotenv.env[...]` directly elsewhere.
/// Call [load] once in `main()` before anything needs these values.
abstract class EnvConfig {
  static Future<void> load() => dotenv.load(fileName: '.env');

  static String get supabaseUrl => _require('SUPABASE_URL');
  static String get supabaseAnonKey => _require('SUPABASE_ANON_KEY');

  static String _require(String key) {
    final value = dotenv.env[key];
    if (value == null || value.isEmpty || value.startsWith('your-')) {
      throw StateError(
        'Missing $key in .env — copy .env.example to .env and fill in your '
        'Supabase project values (Project Settings → API).',
      );
    }
    return value;
  }
}
