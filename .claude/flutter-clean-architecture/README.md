# Flutter Clean Architecture Skill

Skill cho Claude đóng vai **Senior Flutter Architect 10+ năm kinh nghiệm**, generate code Flutter
production-ready theo Clean Architecture + MVVM + SOLID, cho team lớn collaborate.

## Cài đặt

Upload/save skill này vào Claude (Claude.ai, Claude Code, hoặc Cowork). Sau khi cài, Claude sẽ tự
động dùng skill khi bạn yêu cầu build feature, page, widget, hoặc bất kỳ việc gì liên quan tới
Flutter/Dart.

## Cấu trúc skill

```
flutter-clean-architecture/
├── SKILL.md                              — workflow chính, reference map, verify scripts map
├── references/
│   ├── architecture-mvvm.md              — Clean Architecture + MVVM layer rules
│   ├── project-structure.md              — folder tree, naming convention, file length limit
│   ├── state-management-di.md            — Riverpod & Bloc, DI setup
│   ├── ui-theme-tokens.md                — Material 3, design token, responsive, a11y
│   ├── networking-storage.md             — Dio, Failure hierarchy, Hive/SharedPreferences/SecureStorage
│   ├── forms-routing.md                  — form validation, GoRouter typed route, nav guard
│   ├── performance-images.md             — const, lazy list, pagination, CachedNetworkImage
│   ├── testing-review-checklist.md       — test template + code review checklist bắt buộc
│   └── design-to-flutter.md              — đọc thiết kế từ Figma (MCP) hoặc ảnh/mockup, mapping sang Flutter widget
└── scripts/
    ├── 01-file-length-check.sh
    ├── 02-naming-convention-validator.mjs
    ├── 03-forbidden-pattern-scanner.mjs
    ├── 04-dependency-direction-checker.mjs
    └── 05-flutter-analyze-test.sh
```

## Cách dùng scripts trên máy dev

```bash
# Copy scripts vào project
cp -r scripts/ ./verify/
chmod +x verify/*.sh

# Chạy lần lượt (thứ tự khuyến nghị)
node verify/03-forbidden-pattern-scanner.mjs --dir=lib --json=verify-report.json
node verify/02-naming-convention-validator.mjs --dir=lib
bash verify/01-file-length-check.sh lib
node verify/04-dependency-direction-checker.mjs --dir=lib
bash verify/05-flutter-analyze-test.sh --coverage
```

Scripts chỉ cần Node.js (không dependency ngoài) và Bash — không cần cài thêm package nào để
chạy 4 script đầu. Script 05 cần Flutter SDK đã cài sẵn trong môi trường dev.

## State management

Skill hỗ trợ cả **Riverpod** (mặc định cho project mới) và **Bloc** (nếu project đã dùng sẵn) —
xem `references/state-management-di.md` để biết pattern chi tiết cho từng approach. Claude sẽ tự
đọc code có sẵn trong project để xác định approach đang dùng; nếu là project mới và chưa rõ, sẽ
hỏi trước khi generate.

## Đọc thiết kế → sinh code Flutter

Skill hỗ trợ sinh UI trực tiếp từ 2 nguồn design (xem `references/design-to-flutter.md`):

- **Figma** — dán link `figma.com/design/...`, Claude dùng Figma MCP tools (`get_design_context`,
  `get_screenshot`, `get_variable_defs`, `download_assets`) để lấy layout/color/typography/asset.
- **Claude Design** — upload ảnh/screenshot/mockup bất kỳ vào chat, hoặc dùng lại mockup đã tạo
  trong Claude (Visualizer/artifact) — Claude đọc trực tiếp bằng vision và extract thủ công.

Dù nguồn nào, Claude luôn output **Design Extraction Summary** (giá trị + độ tin cậy) và
**Conflict Detection** (so với token/convention hiện có) trước khi viết code — không tự đoán giá
trị không rõ ràng.

## Ghi chú

- Skill này chủ về **kiến trúc & convention**, không thay thế kiến thức Flutter/Dart nền tảng của
  Claude — Claude vẫn tự quyết định API/package cụ thể (vd package nào implement Either, package
  freezed version nào...) dựa trên `pubspec.yaml` thực tế của project.
- Nếu team có convention riêng khác với default trong skill (vd: không dùng `fpdart`/`dartz`,
  dùng sealed class tự viết), cứ nói rõ trong prompt — Claude sẽ ưu tiên convention thực tế của
  project hơn default trong skill.
