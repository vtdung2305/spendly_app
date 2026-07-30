import 'package:dio/dio.dart';

import 'package:spendly_app/core/config/env_config.dart';
import 'package:spendly_app/core/network/token_storage.dart';

/// Shared Dio instance for every backend-mode datasource. Attaches the
/// stored access token to every request except `/auth/*`, and transparently
/// refreshes+retries once on a 401 (the backend rotates refresh tokens, so a
/// second concurrent 401 waits on the first refresh instead of racing it).
class BackendApiClient {
  BackendApiClient(this._tokenStorage) {
    _dio = Dio(BaseOptions(
      baseUrl: EnvConfig.backendBaseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
    ));
    _refreshDio = Dio(BaseOptions(baseUrl: EnvConfig.backendBaseUrl));

    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        if (!options.path.startsWith('auth/')) {
          final token = await _tokenStorage.readAccessToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
        }
        handler.next(options);
      },
      onError: (error, handler) async {
        final isAuthPath = error.requestOptions.path.startsWith('auth/');
        final alreadyRetried = error.requestOptions.extra['retried'] == true;
        if (error.response?.statusCode != 401 || isAuthPath || alreadyRetried) {
          handler.next(error);
          return;
        }

        final refreshed = await _refreshTokens();
        if (!refreshed) {
          await _tokenStorage.clear();
          handler.next(error);
          return;
        }

        try {
          final newToken = await _tokenStorage.readAccessToken();
          final retryOptions = error.requestOptions
            ..extra['retried'] = true
            ..headers['Authorization'] = 'Bearer $newToken';
          final response = await _dio.fetch(retryOptions);
          handler.resolve(response);
        } catch (_) {
          handler.next(error);
        }
      },
    ));
  }

  late final Dio _dio;
  late final Dio _refreshDio;
  final TokenStorage _tokenStorage;

  Future<bool>? _refreshing;

  Dio get dio => _dio;

  /// Deduplicates concurrent refresh attempts — the second caller awaits the
  /// first's in-flight refresh instead of also hitting `/auth/refresh`
  /// (whose refresh tokens are single-use/rotated).
  Future<bool> _refreshTokens() {
    return _refreshing ??= _doRefresh().whenComplete(() => _refreshing = null);
  }

  Future<bool> _doRefresh() async {
    final refreshToken = await _tokenStorage.readRefreshToken();
    if (refreshToken == null) return false;
    try {
      final response = await _refreshDio.post<Map<String, dynamic>>(
        'auth/refresh',
        data: {'refreshToken': refreshToken},
      );
      final data = response.data?['data'] as Map<String, dynamic>?;
      if (data == null) return false;
      await _tokenStorage.saveTokens(
        accessToken: data['accessToken'] as String,
        refreshToken: data['refreshToken'] as String,
      );
      return true;
    } catch (_) {
      return false;
    }
  }
}
