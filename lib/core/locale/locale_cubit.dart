import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:spendly_app/core/storage/local_storage.dart';

const _kLocaleCodeKey = 'locale_code';

/// App-wide language — `null` means no language has been chosen yet, which
/// gates Splash into the first-launch Language Select screen. Persisted so
/// the choice survives restarts.
class LocaleCubit extends Cubit<Locale?> {
  LocaleCubit(this._storage) : super(_loadInitial(_storage));

  final AppLocalStorage _storage;

  static Locale? _loadInitial(AppLocalStorage storage) {
    final code = storage.getString(_kLocaleCodeKey);
    return code == null ? null : Locale(code);
  }

  Future<void> setLocale(Locale locale) async {
    await _storage.setString(_kLocaleCodeKey, locale.languageCode);
    emit(locale);
  }
}
