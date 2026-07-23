# Design → Flutter (Figma & Claude Design/Screenshot)

Skill này có thể sinh code Flutter trực tiếp từ thiết kế, qua 2 nguồn:

1. **Figma** — qua Figma MCP tools (nếu server Figma đã được connect).
2. **Claude Design** — ảnh/mockup người dùng paste/upload thẳng vào chat (screenshot, ảnh chụp
   design, ảnh từ Photoshop/Sketch/ảnh design bất kỳ), hoặc mockup được tạo trực tiếp trong
   Claude (vd qua Visualizer/artifact) mà user muốn convert thành Flutter thật.

Dù nguồn nào, output cuối cùng vẫn phải tuân thủ đầy đủ `architecture-mvvm.md`,
`project-structure.md`, `ui-theme-tokens.md` — design chỉ quyết định UI, không được phá vỡ layer
rule hay design token convention.

---

## Input Modes

| Mode | Khi nào | Cách lấy dữ liệu |
|------|---------|-------------------|
| **Figma MCP (link)** | User gửi link `figma.com/design/...` hoặc `figma.com/file/...` | Dùng `Figma:get_design_context` (ưu tiên số 1) để lấy layout, spacing, color, typography, component structure. Nếu cần ảnh tham chiếu, thêm `Figma:get_screenshot`. Nếu cần giá trị token gốc, `Figma:get_variable_defs` |
| **Figma Dev Mode values** | User paste giá trị (hex, px, font) copy từ Dev Mode | Dùng thẳng, không cần gọi tool, nhưng vẫn hỏi lại nếu thiếu giá trị quan trọng |
| **Claude Design — ảnh/screenshot** | User upload ảnh (screenshot Figma, ảnh chụp app khác, mockup PNG/JPG) | Đọc trực tiếp bằng vision (ảnh đã có sẵn trong context) — extract thủ công màu/spacing/typography/layout theo mắt, đánh dấu confidence rõ ràng |
| **Claude Design — mockup tự tạo trong chat** | User đã nhờ Claude tạo mockup UI (HTML/SVG qua Visualizer) trước đó và giờ muốn convert sang Flutter thật | Dùng lại chính spec/markup của mockup đó làm nguồn structure + style, không cần đọc lại ảnh |
| **Design system export (JSON/CSS)** | User attach file token export | Parse file, map sang `AppColors`/`AppSpacing`/... tương ứng |

**Ưu tiên thứ tự khi có nhiều nguồn cùng lúc**: Figma MCP > Dev Mode values/export file > ảnh/screenshot (vì ảnh luôn có sai số đọc bằng mắt).

---

## Quy trình 4 bước — bắt buộc theo thứ tự

### Bước 1 — Lấy dữ liệu thiết kế

**Nếu có Figma link:**
```
Figma:get_design_context   → layout, spacing, color, typography, component tree
Figma:get_screenshot       → ảnh render để đối chiếu trực quan (nếu cần)
Figma:get_variable_defs    → design token gốc (nếu Figma file có variables/styles)
Figma:download_assets      → xuất icon/ảnh cần dùng thật (SVG/PNG) trong Flutter
```
Nếu Figma file dùng design system có component library, dùng `Figma:search_design_system` để
kiểm tra component đã map với token/asset nào chưa, tránh tạo trùng.

**Nếu là ảnh (Claude Design/screenshot):** đọc trực tiếp ảnh trong context, không cần tool. Extract theo checklist ở Bước 2.

### Bước 2 — Extraction Summary (BẮT BUỘC output trước khi code)

Luôn output bảng này trước khi viết bất kỳ dòng code nào:

```
## Design Extraction Summary
| Property        | Giá trị từ design | Flutter mapping              | Confidence   | Ghi chú             |
|------------------|--------------------|-------------------------------|--------------|---------------------|
| Primary color    | #005BAC            | AppColors.primary             | ✅ exact     | Từ Figma variable   |
| Heading style    | 24px/32px, 600     | textTheme.headlineSmall       | ✅ exact     |                     |
| Card padding     | 16px               | AppSpacing.md                 | ⚠️ estimated | Đọc từ screenshot   |
| Corner radius    | ?                  | ?                              | ❓ unknown   | Cần hỏi user        |
| Button style     | Filled, full width | AppButton.primary (shared/)   | ✅ exact     |                     |
```

- ✅ **exact** — lấy từ Figma MCP/Dev Mode/export file, số liệu chính xác.
- ⚠️ **estimated** — đọc bằng mắt từ ảnh/screenshot, có thể sai lệch nhỏ.
- ❓ **unknown** — **DỪNG lại, hỏi user ngay**, không tự đoán và không tiếp tục sang Bước 3.

### Bước 3 — Conflict Detection

So sánh giá trị design với token/convention hiện có của project:

```
## Conflicts Detected
| # | Design value        | Vi phạm rule                       | Đề xuất xử lý                        |
|---|----------------------|-------------------------------------|----------------------------------------|
| 1 | color: #FF0000 lạ    | Không có trong AppColors hiện tại  | Thêm token mới `AppColors.error`, không hardcode |
| 2 | spacing 15px         | Không khớp scale 4/8/16/24/32       | Làm tròn AppSpacing.md (16px), confirm với designer |
| 3 | Button dùng GetX     | Cấm theo state-management-di.md    | Đổi sang Riverpod/Bloc theo project hiện tại |
```

Không có conflict → ghi `✅ No conflicts detected`. Có conflict ảnh hưởng cấu trúc/token →
**chờ user confirm** trước khi sang Bước 4.

### Bước 4 — Generate Code

Áp dụng widget mapping bên dưới, tách widget theo `architecture-mvvm.md` (Component Design
Rules — không nhồi 1 page > 200 dòng), dùng token đã map ở Bước 2, và tiếp tục theo **STAGE 3**
trong `SKILL.md` chính (thứ tự output file domain → data → presentation nếu đây là 1 feature/page
đầy đủ, hoặc chỉ presentation nếu chỉ là 1 UI component tái sử dụng).

---

## Figma/Design Element → Flutter Widget Mapping

| Design element | Flutter widget |
|----------------|-----------------|
| Frame/Group (layout dọc) | `Column` |
| Frame/Group (layout ngang) | `Row` |
| Frame auto-layout với wrap | `Wrap` |
| Frame có scroll | `ListView` / `SingleChildScrollView` |
| Rectangle/background shape | `Container` với `AppColors`/`AppRadius`/`AppShadow` |
| Text layer | `Text` với `Theme.of(context).textTheme.*` tương ứng |
| Image | `CachedNetworkImage` (xem `performance-images.md`) |
| Icon (từ icon set) | `Icon(...)` (Material icon) hoặc `SvgPicture.asset` nếu icon custom export từ Figma |
| Button (filled) | Custom `AppButton` trong `shared/components/buttons/` (tạo mới nếu chưa có, tái sử dụng nếu đã có) |
| Input field | `TextFormField` theo `forms-routing.md` |
| Card component | Custom `AppCard`/`<Feature>Card` trong `shared/components/cards/` hoặc `features/<feature>/presentation/widgets/` nếu chỉ dùng riêng |
| Bottom sheet / Modal | `showModalBottomSheet` + widget riêng trong `shared/components/bottom_sheet/` |
| Avatar | `shared/components/avatars/AppAvatar` (dùng `CachedNetworkImage` + fallback initials) |
| Loading skeleton trong design | `shared/components/loading/AppLoadingIndicator` hoặc shimmer widget riêng |
| Component lặp lại (list item) | Tách thành widget riêng, dùng trong `ListView.builder` — không copy-paste nhiều instance |

Quy tắc: nếu Figma có **component/instance** (không phải shape rời), luôn tạo 1 Flutter widget
tương ứng 1-1, đặt tên theo layer name trong Figma (chuẩn hoá về PascalCase) — không tự ý gộp
nhiều component Figma thành 1 widget Flutter trừ khi được xác nhận.

---

## Asset Handling

- Icon/ảnh cần dùng thật trong app: dùng `Figma:download_assets` để export (SVG ưu tiên cho icon,
  PNG/WebP cho ảnh raster), lưu vào `assets/icons/` hoặc `assets/images/` theo cấu trúc project,
  khai báo trong `pubspec.yaml`.
- Ảnh chỉ dùng để tham khảo (screenshot toàn màn hình) — không export làm asset, chỉ dùng để đọc
  giá trị.
- Icon set chuẩn của Material 3 → ưu tiên `Icon(Icons.xxx)` thay vì export riêng nếu design dùng
  đúng icon Material.

---

## Khi thiếu thông tin — luôn hỏi, không đoán

| Tình huống | Hành động |
|------------|-----------|
| Ảnh/screenshot mờ, không đọc rõ số đo | Ghi ❓ trong Extraction Summary, hỏi giá trị chính xác |
| Figma chỉ có 1 frame (không có tablet/desktop) | Hỏi có cần tự suy responsive hay chờ spec riêng |
| Design dùng animation/transition | Hỏi có cần implement animation thật hay bỏ qua giai đoạn đầu |
| Component design không khớp bất kỳ widget có sẵn nào trong `shared/` | Xác nhận tạo widget mới hay tái dùng widget gần giống đã có |
| Không rõ đây là page mới hay chỉ thêm UI vào feature có sẵn | Hỏi trước khi quyết định tạo domain/data layer mới hay chỉ update presentation |
