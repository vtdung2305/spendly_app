# Testing & Code Review Checklist

## Test Coverage cần support

| Loại test | Test gì | Layer |
|-----------|--------|-------|
| Unit Test | UseCase, ViewModel logic, Repository (mock DataSource), extension/util | Domain, Presentation logic, Data |
| Widget Test | Render đúng theo state (loading/loaded/error/empty), tương tác user (tap, input) | Presentation |
| Golden Test | Snapshot UI không đổi ngoài ý muốn | Presentation (widget quan trọng, ít thay đổi) |
| Repository Test | Map đúng exception → Failure, điều phối remote/local đúng | Data |
| ViewModel Test | State transition đúng theo input/UseCase result (mock UseCase) | Presentation |

## Unit Test Template — UseCase

```dart
void main() {
  late GetUserUseCase useCase;
  late MockUserRepository mockRepository;

  setUp(() {
    mockRepository = MockUserRepository();
    useCase = GetUserUseCase(mockRepository);
  });

  test('trả về User khi repository thành công', () async {
    final user = User(id: '1', name: 'A', email: 'a@test.com');
    when(() => mockRepository.getUser('1')).thenAnswer((_) async => Right(user));

    final result = await useCase('1');

    expect(result, Right(user));
    verify(() => mockRepository.getUser('1')).called(1);
  });

  test('trả về Failure khi repository thất bại', () async {
    when(() => mockRepository.getUser('1'))
        .thenAnswer((_) async => const Left(ServerFailure('error', 500)));

    final result = await useCase('1');

    expect(result, isA<Left<Failure, User>>());
  });
}
```

## ViewModel Test Template (Riverpod)

```dart
void main() {
  test('state chuyển từ loading sang loaded khi fetch thành công', () async {
    final container = ProviderContainer(overrides: [
      getUserUseCaseProvider.overrideWithValue(mockGetUserUseCase),
    ]);
    addTearDown(container.dispose);

    final result = await container.read(profileViewModelProvider.future);

    expect(result, isA<ProfileLoaded>());
  });
}
```

## Widget Test Template

```dart
void main() {
  testWidgets('hiển thị loading indicator khi state là loading', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [profileViewModelProvider.overrideWith(() => FakeLoadingViewModel())],
        child: const MaterialApp(home: ProfilePage()),
      ),
    );

    expect(find.byType(AppLoadingIndicator), findsOneWidget);
  });
}
```

## Golden Test Template

```dart
void main() {
  testWidgets('ProfileCard golden test', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: ProfileCard(name: 'A', avatarUrl: ''))),
    );
    await expectLater(find.byType(ProfileCard), matchesGoldenFile('profile_card.png'));
  });
}
```

---

## Code Review Checklist — BẮT BUỘC chạy qua trước khi output code cuối cùng

Nếu bất kỳ mục nào FAIL → refactor ngay trước khi output, không output code chưa đạt.

- [ ] **SOLID** — mỗi class/UseCase chỉ 1 trách nhiệm, phụ thuộc abstraction không phải concrete
- [ ] **DRY** — không có logic/widget lặp lại có thể tách reusable
- [ ] **MVVM** — Presentation không gọi API trực tiếp, ViewModel không biết Data implementation
- [ ] **Responsive** — dùng MediaQuery/LayoutBuilder/Flexible/Expanded, không fixed width vô lý
- [ ] **Reusable** — widget nhận data qua constructor, không hidden dependency
- [ ] **Testable** — logic tách khỏi widget, có thể test độc lập không cần render UI
- [ ] **Null Safety** — không lạm dụng `!`, xử lý null rõ ràng
- [ ] **Const** — widget const hoá tối đa
- [ ] **Theme** — không hardcode màu/font, dùng ThemeData/ColorScheme
- [ ] **Design Token** — không magic number cho spacing/radius/shadow/duration
- [ ] **Accessibility** — Semantics label, contrast đủ, touch target ≥48x48
- [ ] **Performance** — list builder, pagination, debounce, cached image khi cần
- [ ] **No duplicated code**
- [ ] **Folder đúng** — đúng layer, đúng vị trí theo `project-structure.md`
- [ ] **Naming đúng** — theo bảng convention trong `architecture-mvvm.md`
- [ ] **Clean Architecture** — dependency rule không bị đảo ngược, domain không import Flutter

## Output Format chuẩn khi generate code

1. Giải thích kiến trúc ngắn gọn (2-4 câu)
2. Folder tree của phần vừa tạo
3. Code đầy đủ, comment giải thích **WHY** cho logic phức tạp (không giải thích WHAT)
4. Giải thích quyết định quan trọng (vd: tại sao chọn AsyncNotifier, tại sao tách UseCase riêng)
5. Gợi ý cải tiến tương lai (cache layer, offline-first, pagination, analytics...)

Không output partial implementation trừ khi user yêu cầu rõ ràng.
