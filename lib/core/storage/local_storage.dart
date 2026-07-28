import 'package:shared_preferences/shared_preferences.dart';

/// Thin wrapper over `SharedPreferences` — a single injected instance so
/// call sites never touch the plugin API directly. Registered in
/// `injection.dart` after an async `SharedPreferences.getInstance()` in
/// `main.dart`, same pattern as `Supabase.instance.client`.
class AppLocalStorage {
  const AppLocalStorage(this._prefs);

  final SharedPreferences _prefs;

  String? getString(String key) => _prefs.getString(key);

  Future<void> setString(String key, String value) =>
      _prefs.setString(key, value);
}
