# Clean Architecture + MVVM Rules

## Dependency Rule (bất di bất dịch)

```
Presentation
     ↓
   Domain
     ↓
    Data
```

- Chỉ được phụ thuộc theo chiều xuống. **Không bao giờ đảo ngược.**
- Domain **không** import bất kỳ package Flutter nào (`package:flutter/*`). Domain là pure Dart.
- Presentation **không** gọi API trực tiếp, không import `data/` — chỉ giao tiếp qua UseCase (abstract, nằm ở Domain).
- Data implement interface được định nghĩa ở Domain (Dependency Inversion — Data phụ thuộc ngược vào abstraction của Domain, không phải ngược lại).

## Presentation Layer

Chỉ chứa:
- UI (widget tree)
- Animation
- User interaction (gesture, input)

Cấm:
- Gọi API trực tiếp
- Business logic (validation phức tạp, tính toán nghiệp vụ)
- Thao tác dữ liệu thô (parse JSON, transform model)

Mọi thứ đi qua ViewModel. Widget chỉ *render* dựa trên state do ViewModel expose và *gọi method* của ViewModel khi có event.

```dart
// BAD — gọi API trực tiếp trong View
class ProfilePage extends StatelessWidget {
  Future<void> _loadProfile() async {
    final response = await http.get(Uri.parse('...')); // ❌ Presentation không được biết API
  }
}

// GOOD — chỉ gọi qua ViewModel
class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(profileViewModelProvider);
    return switch (state) {
      ProfileLoading() => const AppLoadingIndicator(),
      ProfileError(:final message) => AppErrorView(message: message),
      ProfileLoaded(:final profile) => ProfileContent(profile: profile),
    };
  }
}
```

## ViewModel

Chịu trách nhiệm:
- Business logic
- UI state (loading/loaded/error/empty...)
- Validation
- Trigger navigation (thông qua callback/event, không tự import GoRouter trực tiếp nếu muốn testable tuyệt đối — nhưng gọi router qua injected service cũng chấp nhận được tuỳ độ strict của team)
- Gọi UseCase

ViewModel **không được biết** implementation của API — chỉ phụ thuộc vào UseCase (abstract).

```dart
class ProfileViewModel extends AutoDisposeAsyncNotifier<ProfileState> {
  late final GetProfileUseCase _getProfileUseCase;

  @override
  Future<ProfileState> build() async {
    _getProfileUseCase = ref.read(getProfileUseCaseProvider);
    return _loadProfile();
  }

  Future<ProfileState> _loadProfile() async {
    final result = await _getProfileUseCase();
    return result.fold(
      (failure) => ProfileState.error(failure.message),
      (profile) => ProfileState.loaded(profile),
    );
  }
}
```

## Domain Layer

Chứa:
- **Entities**: model nghiệp vụ thuần, immutable, không phụ thuộc JSON/DTO.
- **Repository interfaces**: `abstract class IUserRepository { Future<Either<Failure, User>> getUser(String id); }`
- **UseCases**: mỗi UseCase làm đúng 1 việc, có `call()` method (callable class).

```dart
// domain/entities/user.dart
class User {
  const User({required this.id, required this.name, required this.email});

  final String id;
  final String name;
  final String email;
}

// domain/repositories/i_user_repository.dart
abstract class IUserRepository {
  Future<Either<Failure, User>> getUser(String id);
}

// domain/usecases/get_user_usecase.dart
class GetUserUseCase {
  const GetUserUseCase(this._repository);
  final IUserRepository _repository;

  Future<Either<Failure, User>> call(String id) => _repository.getUser(id);
}
```

Domain **tuyệt đối không** `import 'package:flutter/material.dart'`.

## Data Layer

Chứa:
- **DTO/Model**: có `fromJson`/`toJson`, extend hoặc convert sang Entity.
- **DataSource**: remote (Dio) và local (Hive/SharedPreferences), tách riêng interface.
- **Repository implementation**: implement interface của Domain, điều phối remote/local, map exception → Failure.

```dart
// data/repositories/user_repository.dart
class UserRepository implements IUserRepository {
  const UserRepository(this._remoteDataSource, this._localDataSource);
  final UserRemoteDataSource _remoteDataSource;
  final UserLocalDataSource _localDataSource;

  @override
  Future<Either<Failure, User>> getUser(String id) async {
    try {
      final model = await _remoteDataSource.fetchUser(id);
      await _localDataSource.cacheUser(model);
      return Right(model.toEntity());
    } on DioException catch (e) {
      return Left(NetworkFailure.fromDioException(e));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
}
```

## Component Design Rules

Tách UI thành widget nhỏ, mỗi widget 1 trách nhiệm duy nhất.

```
Bad:  HomePage → 1000 dòng, mọi thứ nhồi vào 1 file

Good: HomePage
        ├── Header
        ├── SearchBar
        ├── CategorySection
        │     └── CategoryItem
        ├── PopularSection
        │     └── PopularCard
        └── Footer
```

Mỗi widget: reusable, configurable qua constructor, stateless khi có thể, không hidden dependency
(không tự đọc global singleton bên trong nếu có thể truyền qua constructor/provider).

## File Length Limit

| Loại file | Giới hạn | Nếu vượt |
|-----------|----------|----------|
| Widget | 200 dòng | Split thành widget con |
| ViewModel | 300 dòng | Tách helper method ra extension hoặc mixin, hoặc split state |
| Repository | 300 dòng | Tách theo domain con (vd UserProfileRepository, UserAuthRepository) |
| UseCase | 100 dòng | 1 UseCase chỉ làm đúng 1 việc — nếu dài, đang vi phạm SRP |

## Naming Convention

| Loại | Convention | Ví dụ |
|------|-----------|-------|
| Widget | PascalCase | `HomeCard` |
| ViewModel | `<Feature>ViewModel` | `HomeViewModel` |
| UseCase | `<Verb><Noun>UseCase` | `GetProfileUseCase` |
| Repository | `<Noun>Repository` | `UserRepository` |
| Interface | `I<Noun>Repository` | `IUserRepository` |
| File | snake_case.dart | `home_view_model.dart` |

## Folder Ownership

Mỗi feature sở hữu `presentation/`, `domain/`, `data/`, `widgets/` riêng của nó.
**Không cross-feature import.** Chỉ dùng `shared/` khi component được tái sử dụng ở ≥2 feature.
