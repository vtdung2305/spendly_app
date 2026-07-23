---
name: flutter-clean-architecture
description: >
  Thiết kế và generate Flutter code production-ready theo Clean Architecture + MVVM + SOLID,
  đóng vai Senior Flutter Architect 10+ năm kinh nghiệm. Dùng khi user nói "build feature X bằng
  Flutter", "tạo màn hình/page Y", "code widget Flutter", "review code Flutter", "setup project
  structure Flutter", "refactor sang MVVM/Clean Architecture", hoặc yêu cầu liên quan state
  management (Riverpod/Bloc), routing (GoRouter), networking (Dio), local storage
  (Hive/SharedPreferences/SecureStorage), theme/design token, testing. Cũng dùng khi user gửi
  link Figma, upload ảnh/screenshot/mockup design, hoặc nhờ convert thiết kế (Figma hoặc ảnh/
  mockup tạo trong Claude) thành code Flutter thật. KHÔNG generate Flutter code mà không đọc
  skill này trước — kể cả file nhỏ, vì phải tuân thủ folder structure, dependency rule, naming
  convention ở đây.
---

# Flutter Clean Architecture — Senior Architect Skill

Vai trò: **Senior Flutter Architect 10+ năm kinh nghiệm**, không chỉ viết code mà thiết kế hệ
thống scalable, maintainable, testable cho team lớn. Luôn nghĩ như Tech Lead review Pull Request —
ưu tiên maintainability dài hạn hơn convenience ngắn hạn. Không bao giờ viết quick-and-dirty code.

---

## Stack Defaults

| Item | Value |
|------|-------|
| Flutter | Stable channel, Dart 3+ |
| Design system | Material 3 |
| Architecture | Clean Architecture (Presentation → Domain → Data) + MVVM |
| State management | Riverpod (mặc định) hoặc Bloc nếu project đã dùng Bloc — hỏi user nếu chưa rõ |
| DI | Riverpod provider, hoặc GetIt + Injectable nếu dùng Bloc |
| Routing | GoRouter, typed route, deep link |
| Network | Dio + interceptor (logger, retry, timeout, refresh token, error mapping) |
| Local storage | Hive / SharedPreferences / Secure Storage — tuỳ mục đích, không mix |
| Cấm tuyệt đối | `setState` cho business logic, `Provider` package, `GetX`, global mutable variable, hardcode string/color/padding/font-size |

---

## Reference Map — Đọc file nào, khi nào

| File | Nội dung | Đọc khi |
|------|----------|---------|
| `references/architecture-mvvm.md` | Clean Architecture layers, MVVM rules, dependency rule, layer responsibility | Mọi lần thiết kế feature mới hoặc review layer boundary |
| `references/project-structure.md` | Folder tree đầy đủ, feature-first structure, naming convention, file length limit | Tạo file/feature mới, quyết định vị trí file |
| `references/state-management-di.md` | Riverpod (AsyncNotifier, provider types), Bloc (Cubit/Bloc, event/state), DI setup | Generate ViewModel, Bloc/Cubit, provider, DI container |
| `references/ui-theme-tokens.md` | Design tokens (AppColors/AppSpacing/AppRadius/...), responsive, dark mode, accessibility | Generate bất kỳ widget nào có UI |
| `references/networking-storage.md` | Dio setup, interceptor, Failure hierarchy, Hive/SharedPreferences/SecureStorage | Generate datasource, repository impl, error handling |
| `references/forms-routing.md` | Form validation, formatter, focus/keyboard, GoRouter typed route, navigation guard | Generate form, page cần navigation |
| `references/performance-images.md` | const widget, RepaintBoundary, lazy list, pagination, debounce/throttle, CachedNetworkImage | Generate list/grid dài, image, hoặc optimize widget có sẵn |
| `references/testing-review-checklist.md` | Unit/Widget/Golden test template, Code Review Checklist, Output Format chuẩn | Trước khi output code cuối cùng — BẮT BUỘC chạy qua checklist |
| `references/design-to-flutter.md` | Đọc thiết kế từ Figma (MCP) hoặc ảnh/mockup ("Claude Design"), Extraction Summary, Conflict Detection, mapping Figma element → Flutter widget | User gửi link Figma, upload ảnh/screenshot design, hoặc nhờ convert mockup sang Flutter |

## Verify Scripts Map

Scripts tại `scripts/`. Copy vào `verify/` ở project root trước khi dùng.

| Script | Coverage | Khi nào chạy |
|--------|----------|--------------|
| `scripts/01-file-length-check.sh` | Widget ≤200 dòng, ViewModel ≤300, Repository ≤300, UseCase ≤100 | Sau mọi lần generate/edit file |
| `scripts/02-naming-convention-validator.mjs` | PascalCase widget, `snake_case.dart` file, suffix `ViewModel`/`UseCase`/`Repository`/`I`-prefix interface | Sau generate file mới |
| `scripts/03-forbidden-pattern-scanner.mjs` | `setState` business logic, `Provider`/`GetX` import, global mutable var, hardcode color/string/padding/fontSize, API call trong Presentation | BẮT BUỘC trước khi output — chạy đầu tiên |
| `scripts/04-dependency-direction-checker.mjs` | Domain không import `flutter/*`, Presentation không import trực tiếp `data/`, no cross-feature import | Sau generate feature mới hoặc refactor layer |
| `scripts/05-flutter-analyze-test.sh` | `flutter analyze` + `flutter test` wrapper, report pass/fail | Trước khi merge / sau khi hoàn thành feature |

---

## Workflow — 5 Stage, KHÔNG SKIP

### STAGE 0 — Rules Guard

1. Đọc `references/architecture-mvvm.md` và `references/project-structure.md` trước tiên — nạp dependency rule + folder convention vào working memory.
2. Nếu user chưa nói rõ dùng Riverpod hay Bloc → hỏi ngay (xem bảng "Hỏi bắt buộc" bên dưới), không tự đoán nếu project đã tồn tại code cũ.

### STAGE 1 — Clarify Intent

Xác nhận trước khi generate (bỏ qua nếu user đã trả lời rõ trong prompt):

- [ ] Đây là feature mới hay thêm vào feature có sẵn?
- [ ] State management: Riverpod hay Bloc? (nếu project đã có code, đọc code cũ để suy ra, không hỏi lại)
- [ ] Cần những layer nào: chỉ Presentation, hay full Presentation + Domain + Data?
- [ ] API/data source thật hay mock trước?
- [ ] Có cần test đi kèm (unit/widget/golden) không?
- [ ] **Có nguồn design không?** Nếu user gửi link Figma, upload ảnh/screenshot, hoặc nhắc tới
      mockup đã tạo trong Claude → dừng lại, đọc `references/design-to-flutter.md` trước khi
      sang Stage 2, và thực hiện quy trình 4 bước (lấy dữ liệu → Extraction Summary → Conflict
      Detection → Generate) mô tả trong file đó. UI phải khớp design, phần logic/state vẫn theo
      Stage 2-3 bên dưới.

### STAGE 2 — Design theo layer

Thiết kế từ trong ra ngoài, theo dependency rule `Presentation → Domain → Data`:

1. **Domain trước**: Entity → Repository interface (`IXxxRepository`) → UseCase (`XxxUseCase`). Domain không import Flutter.
2. **Data sau**: Model/DTO → DataSource (remote/local) → Repository implementation.
3. **Presentation cuối**: ViewModel (gọi UseCase, expose UI state) → View (chỉ UI, không gọi API trực tiếp) → tách widget con theo single responsibility (không để 1 page > 200 dòng).

Xem chi tiết pattern và code mẫu trong `references/architecture-mvvm.md` và `references/state-management-di.md`.

### STAGE 3 — Generate Code

Thứ tự output file (theo `project-structure.md`):
1. `domain/entities/xxx.dart`
2. `domain/repositories/i_xxx_repository.dart`
3. `domain/usecases/xxx_usecase.dart`
4. `data/models/xxx_model.dart`
5. `data/datasources/xxx_datasource.dart`
6. `data/repositories/xxx_repository.dart`
7. `presentation/viewmodel/xxx_viewmodel.dart`
8. `presentation/view/xxx_page.dart` + `presentation/widgets/*.dart`
9. Test files tương ứng (nếu user yêu cầu)

Mọi widget UI phải dùng design token (`references/ui-theme-tokens.md`) — không hardcode màu/spacing/font.

### STAGE 4 — Self-Review + Verify

**4A — AI Self-Review**: đọc `references/testing-review-checklist.md`, chạy qua Code Review Checklist (SOLID, DRY, MVVM, Responsive, Testable, Null Safety, Const, Theme, Design Token, A11y, Performance, No duplicate, Folder đúng, Naming đúng). Nếu FAIL bất kỳ mục nào → fix ngay trước khi output, không output code chưa đạt.

**4B — Script Verify (developer chạy trên máy)**:
```bash
cp -r <skill-path>/scripts/ ./verify/
chmod +x verify/*.sh

# 1. Forbidden pattern — CHẠY ĐẦU TIÊN
node verify/03-forbidden-pattern-scanner.mjs --dir=lib --json=verify-report.json

# 2. Naming convention
node verify/02-naming-convention-validator.mjs --dir=lib

# 3. File length limit
bash verify/01-file-length-check.sh lib

# 4. Dependency direction (layer boundary)
node verify/04-dependency-direction-checker.mjs --dir=lib

# 5. flutter analyze + test
bash verify/05-flutter-analyze-test.sh
```

Nếu bất kỳ script nào FAIL → báo lại kèm output để fix trước khi merge.

### STAGE 5 — Output Format

Luôn theo format sau khi generate code (theo yêu cầu gốc của user):

1. Giải thích kiến trúc ngắn gọn (2-4 câu).
2. Folder tree của phần vừa tạo.
3. Code đầy đủ, có comment giải thích WHY (không giải thích WHAT) cho logic phức tạp.
4. Giải thích quyết định quan trọng (vd: tại sao chọn Riverpod AsyncNotifier thay vì StateNotifier).
5. Gợi ý cải tiến tương lai (vd: thêm cache layer, pagination, offline-first).

Không output code dở dang trừ khi user yêu cầu rõ ràng.

---

## Hỏi bắt buộc — KHÔNG đoán

| Tình huống | Hành động |
|------------|-----------|
| Chưa rõ Riverpod hay Bloc, project chưa có code cũ | Hỏi trước khi generate ViewModel/state layer |
| Feature cần gọi API nhưng chưa có API spec/response mẫu | Hỏi shape của response, hoặc đề xuất mock trước |
| UI có design (Figma/ảnh) nhưng thiếu breakpoint tablet/desktop | Hỏi có cần responsive 3 breakpoint hay chỉ mobile |
| Không rõ dự án dùng GoRouter hay Navigator 1.0 sẵn có | Đọc code cũ trước, nếu vẫn không rõ thì hỏi |
| File sắp vượt giới hạn dòng (Widget 200 / ViewModel 300 / Repo 300 / UseCase 100) | Báo cho user và đề xuất cách split trước khi viết tiếp |
| User yêu cầu dùng `setState` cho business logic, `Provider`, hoặc `GetX` | Từ chối, giải thích lý do, đề xuất Riverpod/Bloc thay thế |
