# Networking & Local Storage

## Dio Setup — `core/network/`

```dart
// core/network/dio_client.dart
class DioClient {
  DioClient(this._dio) {
    _dio.interceptors.addAll([
      LoggerInterceptor(),
      RetryInterceptor(dio: _dio, retries: 3),
      AuthInterceptor(refreshTokenUseCase: /* injected */ null),
      ErrorMappingInterceptor(),
    ]);
    _dio.options
      ..connectTimeout = const Duration(seconds: 10)
      ..receiveTimeout = const Duration(seconds: 15);
  }

  final Dio _dio;
  Dio get instance => _dio;
}
```

Interceptor bắt buộc phải có:
- **Logger** — log request/response (chỉ bật ở debug build).
- **Retry** — retry với backoff cho lỗi network tạm thời (timeout, 5xx).
- **Refresh token** — tự động refresh token khi nhận 401, queue lại request đang chờ.
- **Error mapping** — convert `DioException` → domain `Failure`, không để raw exception lọt ra
  ngoài data layer.

## Failure Hierarchy — `core/error/`

Mọi API/repository trả về `Success` hoặc `Failure`, **không bao giờ throw raw Exception lên UI**.

```dart
// core/error/failure.dart
sealed class Failure {
  const Failure(this.message);
  final String message;
}

class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
  factory NetworkFailure.fromDioException(DioException e) =>
      NetworkFailure(e.message ?? 'Network error');
}

class ServerFailure extends Failure {
  const ServerFailure(super.message, this.statusCode);
  final int statusCode;
}

class ValidationFailure extends Failure {
  const ValidationFailure(super.message, this.fieldErrors);
  final Map<String, String> fieldErrors;
}

class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure(super.message);
}

class UnknownFailure extends Failure {
  const UnknownFailure(super.message);
}
```

Repository trả `Either<Failure, T>` (dùng package `fpdart` hoặc `dartz`) hoặc sealed
`Result<T>` tự định nghĩa nếu team không muốn thêm dependency functional programming.

## Local Storage — chọn đúng công cụ, không mix trách nhiệm

| Công cụ | Dùng cho | Không dùng cho |
|---------|---------|----------------|
| **Hive** | Cache object phức tạp, list data, offline-first data | Token/credential nhạy cảm |
| **SharedPreferences** | Setting đơn giản (theme mode, locale, onboarding flag) | Object phức tạp, data nhạy cảm |
| **Secure Storage** | Token, refresh token, credential, PII nhạy cảm | Data lớn, list dài (chậm vì encrypt) |

```dart
// core/storage/secure_storage_service.dart
class SecureStorageService {
  const SecureStorageService(this._storage);
  final FlutterSecureStorage _storage;

  Future<void> saveAccessToken(String token) =>
      _storage.write(key: 'access_token', value: token);

  Future<String?> getAccessToken() => _storage.read(key: 'access_token');
}
```

**Không** lưu access token trong SharedPreferences hoặc Hive không mã hoá — vi phạm bảo mật.

## DataSource Pattern

Tách riêng interface remote/local, Repository điều phối cả hai:

```dart
// data/datasources/user_remote_datasource.dart
abstract class UserRemoteDataSource {
  Future<UserModel> fetchUser(String id);
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  const UserRemoteDataSourceImpl(this._dio);
  final Dio _dio;

  @override
  Future<UserModel> fetchUser(String id) async {
    final response = await _dio.get('/users/$id');
    return UserModel.fromJson(response.data);
  }
}

// data/datasources/user_local_datasource.dart
abstract class UserLocalDataSource {
  Future<void> cacheUser(UserModel model);
  Future<UserModel?> getCachedUser(String id);
}
```

## Privacy & Data Exposure Checklist

Trước khi commit bất kỳ config network/storage nào, kiểm tra:
- [ ] Token/credential chỉ lưu ở Secure Storage, không log ra console ở release build
- [ ] Interceptor logger tắt hoàn toàn ở production (`if (kDebugMode)`)
- [ ] Không hardcode API key/secret trong source — dùng `--dart-define` hoặc `.env` không commit
- [ ] Response chứa PII không cache lâu hơn cần thiết, có cơ chế clear khi logout
