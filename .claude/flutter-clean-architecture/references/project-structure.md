# Project Structure

## Full Folder Tree

```
lib/
├── core/
│   ├── constants/
│   ├── theme/
│   ├── router/
│   ├── extensions/
│   ├── utils/
│   ├── services/
│   ├── network/
│   ├── storage/
│   ├── error/
│   └── logger/
│
├── features/
│   ├── authentication/
│   │   ├── presentation/
│   │   │   ├── view/
│   │   │   ├── viewmodel/
│   │   │   └── widgets/
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   ├── repositories/
│   │   │   └── usecases/
│   │   └── data/
│   │       ├── datasources/
│   │       ├── models/
│   │       └── repositories/
│   │
│   └── home/
│       └── ... (cấu trúc tương tự authentication)
│
├── shared/
│   ├── components/
│   │   ├── buttons/
│   │   ├── textfields/
│   │   ├── dialogs/
│   │   ├── bottom_sheet/
│   │   ├── cards/
│   │   ├── avatars/
│   │   ├── image/
│   │   ├── loading/
│   │   ├── empty/
│   │   ├── error/
│   │   └── animations/
│   ├── models/
│   └── extensions/
│
├── assets/
├── l10n/
└── main.dart
```

## Feature-First Rule

Mỗi feature (`features/<feature_name>/`) là 1 đơn vị độc lập, chứa đủ 3 layer riêng.
Không import chéo giữa 2 feature (`features/home/` không được `import` trực tiếp từ
`features/authentication/domain/...`). Nếu cần chia sẻ logic/entity giữa 2 feature trở lên,
nâng nó lên `shared/`.

## Khi nào đưa vào `shared/`

Quy tắc: **dùng ít nhất 2 lần** ở 2 nơi khác nhau mới tách vào `shared/`. Nếu chỉ dùng 1 lần,
để nguyên trong `features/<feature>/presentation/widgets/`.

## `core/` chứa gì

| Folder | Nội dung |
|--------|---------|
| `constants/` | App-wide constants (không phải string cứng trong UI — đó phải qua l10n) |
| `theme/` | `AppColors`, `AppSpacing`, `AppRadius`, `AppTypography`, ThemeData Material 3 |
| `router/` | GoRouter config, typed route, navigation guard |
| `extensions/` | Extension methods dùng chung (String, DateTime, BuildContext...) |
| `utils/` | Pure helper function, không side-effect |
| `services/` | App-level service (analytics, permission, deep link handler...) |
| `network/` | Dio client, interceptor, API endpoint constants |
| `storage/` | Hive box setup, SharedPreferences wrapper, SecureStorage wrapper |
| `error/` | `Failure` hierarchy (`NetworkFailure`, `ServerFailure`...) |
| `logger/` | App logger wrapper |

## File Naming Convention

Tất cả file: `snake_case.dart`.

| Loại | Suffix | Ví dụ file |
|------|--------|-----------|
| ViewModel | `_view_model.dart` | `home_view_model.dart` |
| View/Page | `_page.dart` | `home_page.dart` |
| UseCase | `_usecase.dart` | `get_profile_usecase.dart` |
| Repository interface | `i_<noun>_repository.dart` | `i_user_repository.dart` |
| Repository impl | `_repository.dart` | `user_repository.dart` |
| Model/DTO | `_model.dart` | `user_model.dart` |
| Entity | `<noun>.dart` (không suffix) | `user.dart` |
| DataSource | `_datasource.dart` | `user_remote_datasource.dart` |

## Import Alias

Dùng package import tuyệt đối, không dùng relative import xuyên nhiều cấp (`../../../`):

```dart
// BAD
import '../../../../core/theme/app_colors.dart';

// GOOD
import 'package:my_app/core/theme/app_colors.dart';
```

## Khi tạo feature mới — checklist

- [ ] Tạo đủ 3 layer: `presentation/`, `domain/`, `data/`
- [ ] `presentation/` có đủ `view/`, `viewmodel/`, `widgets/`
- [ ] `domain/` có đủ `entities/`, `repositories/` (interface), `usecases/`
- [ ] `data/` có đủ `datasources/`, `models/`, `repositories/` (implementation)
- [ ] Không file nào vượt giới hạn dòng (xem `architecture-mvvm.md`)
- [ ] Đăng ký route trong `core/router/` nếu có page mới
- [ ] Đăng ký DI (provider/GetIt) trong nơi tập trung, không rải rác
