# State Management & Dependency Injection

Project có thể dùng **Riverpod** hoặc **Bloc** tuỳ theo project — luôn kiểm tra `pubspec.yaml`
hoặc code có sẵn trước; nếu là project mới và user chưa chỉ định, mặc định đề xuất **Riverpod**.

**Cấm tuyệt đối**: `setState` cho business logic, package `provider`, `GetX`, biến global mutable.

---

## Option A — Riverpod (mặc định cho project mới)

### Provider types — chọn đúng loại

| Loại | Dùng khi |
|------|---------|
| `Provider` | Giá trị/dependency không đổi (vd: instance UseCase, Repository) |
| `NotifierProvider` / `AsyncNotifierProvider` | State có thể thay đổi, có method mutate |
| `FutureProvider` | Fetch data 1 lần, không cần method mutate phức tạp |
| `StreamProvider` | Lắng nghe stream (vd: auth state changes) |

Ưu tiên `AsyncNotifier` cho ViewModel có async loading — tự động expose `AsyncValue<T>`
(loading/data/error) mà không cần tự quản lý union type thủ công.

```dart
// presentation/viewmodel/home_view_model.dart
part 'home_view_model.g.dart';

@riverpod
class HomeViewModel extends _$HomeViewModel {
  @override
  Future<HomeState> build() async {
    final useCase = ref.read(getHomeFeedUseCaseProvider);
    final result = await useCase();
    return result.fold(
      (failure) => throw failure, // AsyncNotifier tự map exception → AsyncError
      (feed) => HomeState(feed: feed),
    );
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => build());
  }
}
```

### Dependency Injection với Riverpod

Đăng ký dependency qua `Provider`, inject bằng constructor — không `new` trực tiếp trong ViewModel.

```dart
// core/di/repository_providers.dart
part 'repository_providers.g.dart';

@riverpod
IUserRepository userRepository(UserRepositoryRef ref) {
  return UserRepository(
    ref.read(userRemoteDataSourceProvider),
    ref.read(userLocalDataSourceProvider),
  );
}

@riverpod
GetUserUseCase getUserUseCase(GetUserUseCaseRef ref) {
  return GetUserUseCase(ref.read(userRepositoryProvider));
}
```

**Không** khởi tạo Repository/UseCase thủ công (`UserRepository()`) trong widget hay ViewModel —
luôn qua provider để dễ mock trong test.

---

## Option B — Bloc (nếu project đã dùng Bloc từ trước)

Dùng `Cubit` cho state đơn giản (không cần phân biệt nhiều event), dùng `Bloc` đầy đủ khi cần
xử lý event phức tạp, debounce/throttle giữa các event, hoặc cần transformer.

```dart
// presentation/viewmodel/home_cubit.dart (đặt cùng thư mục viewmodel/, đóng vai ViewModel)
class HomeCubit extends Cubit<HomeState> {
  HomeCubit(this._getHomeFeedUseCase) : super(const HomeState.initial());

  final GetHomeFeedUseCase _getHomeFeedUseCase;

  Future<void> loadFeed() async {
    emit(const HomeState.loading());
    final result = await _getHomeFeedUseCase();
    result.fold(
      (failure) => emit(HomeState.error(failure.message)),
      (feed) => emit(HomeState.loaded(feed)),
    );
  }
}
```

Dùng `freezed` cho state union (`HomeState.initial/loading/loaded/error`) để View dùng
`state.when(...)` exhaustive, tránh thiếu case.

### Dependency Injection với Bloc → GetIt + Injectable

```dart
// core/di/injection.dart
@injectable
class HomeCubit extends Cubit<HomeState> {
  HomeCubit(@factoryParam this._getHomeFeedUseCase) : super(const HomeState.initial());
  final GetHomeFeedUseCase _getHomeFeedUseCase;
}
```

**Không** dùng `GetIt.instance<HomeCubit>()` rải rác khắp nơi — đăng ký qua `BlocProvider` ở
gốc của page, và chỉ page đó biết tới GetIt để lấy instance ban đầu.

```dart
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<HomeCubit>()..loadFeed(),
      child: const HomeView(),
    );
  }
}
```

---

## Quy tắc chung cho cả 2 approach

- ViewModel/Cubit/Bloc **không bao giờ** import Dio, Hive, hay bất kỳ implementation cụ thể nào
  của Data layer — chỉ phụ thuộc vào UseCase (abstract qua Domain).
- Mỗi ViewModel tương ứng 1 View/Page — không share 1 ViewModel cho nhiều page không liên quan.
- State phải là immutable class (`freezed` khuyến khích) — không dùng `Map<String, dynamic>`
  làm state.
- Loading state phải phân biệt rõ: `Loading` (lần đầu) vs `Refreshing` (đã có data, đang tải lại)
  — không dùng chung 1 boolean `isLoading` cho cả 2 trường hợp nếu UI cần hiển thị khác nhau.
