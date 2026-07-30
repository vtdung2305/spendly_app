import 'package:dio/dio.dart';

import 'package:spendly_app/core/error/failure.dart';
import 'package:spendly_app/core/network/backend_response.dart';

/// Maps any exception thrown by a `BackendApiClient` call to the app's
/// existing [Failure] hierarchy, so backend-mode repositories behave like
/// their Supabase-mode counterparts from the caller's point of view.
Failure mapBackendError(Object error) {
  if (error is BackendApiException) {
    final status = error.statusCode;
    if (status == 401 || status == 403) {
      return AuthFailure(error.message, code: error.code);
    }
    if (status == 400 || status == 409 || status == 422) {
      return ValidationFailure(error.message, code: error.code);
    }
    return UnknownFailure(error.message, code: error.code);
  }

  if (error is DioException) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
        return const NetworkFailure('Không có kết nối mạng');
      case DioExceptionType.badResponse:
        final status = error.response?.statusCode;
        final body = error.response?.data;
        if (body is Map<String, dynamic>) {
          try {
            unwrapBackendData(body, statusCode: status);
          } on BackendApiException catch (e) {
            return mapBackendError(e);
          }
        }
        if (status == 401 || status == 403) {
          return const AuthFailure('Phiên đăng nhập đã hết hạn');
        }
        return UnknownFailure('Lỗi máy chủ (${status ?? '?'})');
      default:
        return UnknownFailure(error.message ?? error.toString());
    }
  }

  return UnknownFailure(error.toString());
}
