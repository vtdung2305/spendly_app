/// Thrown when the backend's envelope is `{success:false, error:{...}}`.
/// Caught by `backend_error_mapper.dart` alongside `DioException`.
class BackendApiException implements Exception {
  const BackendApiException({
    required this.code,
    required this.message,
    this.statusCode,
  });

  final String code;
  final String message;
  final int? statusCode;

  @override
  String toString() => 'BackendApiException($code: $message)';
}

/// Unwraps the backend's response envelope:
/// `{success:true, data:{...}, meta:{...}}` → returns `data`.
/// `{success:false, error:{code,message,details}}` → throws
/// [BackendApiException].
dynamic unwrapBackendData(dynamic body, {int? statusCode}) {
  if (body is! Map<String, dynamic>) return body;
  if (body['success'] == false) {
    final error = body['error'] as Map<String, dynamic>? ?? const {};
    // TEMP DEBUG — remove after diagnosing validation error details.
    // print('raw backend error: $error');
    throw BackendApiException(
      code: error['code'] as String? ?? 'UNKNOWN',
      message: error['message'] as String? ?? 'Đã có lỗi xảy ra',
      statusCode: statusCode,
    );
  }
  return body['data'];
}
