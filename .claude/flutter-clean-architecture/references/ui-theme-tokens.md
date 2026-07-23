# UI, Theme & Design Tokens

## Nguyên tắc cốt lõi

**Không bao giờ hardcode**: màu, spacing, radius, font size, duration animation, shadow, border.
Mọi giá trị phải lấy từ Theme hoặc Design Token. Nếu token cần thiết chưa tồn tại, tạo mới trong
`core/theme/`, không viết giá trị số/hex trực tiếp trong widget.

```dart
// BAD
Container(
  padding: const EdgeInsets.all(16), // ❌ magic number
  decoration: BoxDecoration(
    color: const Color(0xFF005BAC), // ❌ hardcode color
    borderRadius: BorderRadius.circular(8), // ❌ magic number
  ),
)

// GOOD
Container(
  padding: EdgeInsets.all(AppSpacing.md),
  decoration: BoxDecoration(
    color: AppColors.primary,
    borderRadius: BorderRadius.circular(AppRadius.md),
  ),
)
```

## Design Token Structure

```dart
// core/theme/app_colors.dart
abstract class AppColors {
  static const primary = Color(0xFF005BAC);
  static const onPrimary = Color(0xFFFFFFFF);
  static const surface = Color(0xFFF5F5F5);
  static const error = Color(0xFFD32F2F);
  // ...luôn dùng semantic naming (primary/surface/error), không dùng blue500/red400
}

// core/theme/app_spacing.dart
abstract class AppSpacing {
  static const xs = 4.0;
  static const sm = 8.0;
  static const md = 16.0;
  static const lg = 24.0;
  static const xl = 32.0;
}

// core/theme/app_radius.dart
abstract class AppRadius {
  static const sm = 4.0;
  static const md = 8.0;
  static const lg = 16.0;
  static const full = 999.0;
}

// core/theme/app_typography.dart — dùng TextTheme của Material 3, không tự định nghĩa TextStyle rời rạc
abstract class AppTypography {
  static TextTheme textTheme(BuildContext context) => Theme.of(context).textTheme;
}

// core/theme/app_animation.dart
abstract class AppAnimation {
  static const fast = Duration(milliseconds: 150);
  static const normal = Duration(milliseconds: 300);
  static const slow = Duration(milliseconds: 500);
}

// core/theme/app_shadow.dart
abstract class AppShadow {
  static const card = [
    BoxShadow(color: Color(0x1A000000), blurRadius: 8, offset: Offset(0, 2)),
  ];
}
```

Không duplicate theme — mọi ThemeData (light/dark) build từ cùng 1 bộ token, không định nghĩa
2 bộ giá trị rời rạc cho 2 theme nếu chỉ khác nhau ở màu.

## Material 3 ThemeData

```dart
// core/theme/app_theme.dart
class AppTheme {
  static ThemeData light() => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
    // ...
  );

  static ThemeData dark() => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.dark,
    ),
  );
}
```

## Responsive — bắt buộc support Phone / Tablet / Desktop / Landscape

Luôn dùng `MediaQuery`, `LayoutBuilder`, `Flexible`, `Expanded`. **Không dùng fixed width** trừ
khi thật sự cần thiết (vd: icon size cố định).

```dart
class ResponsiveBreakpoint {
  static const mobile = 600.0;
  static const tablet = 1024.0;
}

LayoutBuilder(
  builder: (context, constraints) {
    if (constraints.maxWidth >= ResponsiveBreakpoint.tablet) {
      return const _DesktopLayout();
    } else if (constraints.maxWidth >= ResponsiveBreakpoint.mobile) {
      return const _TabletLayout();
    }
    return const _MobileLayout();
  },
)
```

## Accessibility & Text Scale

- Không disable `textScaleFactor` — để user tự điều chỉnh cỡ chữ hệ thống.
- Thêm `Semantics` label cho icon-only button, image có ý nghĩa.
- Đảm bảo contrast màu đạt chuẩn WCAG AA tối thiểu cho text/background.
- Touch target tối thiểu 48x48 (Material guideline).

## Localization

Không hardcode string trong UI — mọi text hiển thị lấy từ `l10n/` (`AppLocalizations.of(context)`).

```dart
// BAD
Text('Đăng nhập') // ❌ hardcode string

// GOOD
Text(AppLocalizations.of(context)!.loginButtonLabel)
```

## Loading States chuẩn cần support

| State | Widget dùng chung (`shared/components/`) |
|-------|---------------------------------------|
| Loading (lần đầu) | `AppLoadingIndicator` |
| Refreshing | `RefreshIndicator` wrap quanh content cũ, giữ data hiển thị |
| Empty | `AppEmptyView` (icon + message + optional CTA) |
| Loaded | Content thật |
| Error | `AppErrorView` (message + retry button) |
| Offline | `AppOfflineBanner` |

Mọi ViewModel expose state phải cover đủ các case này qua sealed class/union type
(`freezed` khuyến khích), View dùng `switch`/`when` exhaustive — không dùng `if/else` lồng nhau
để check từng field boolean riêng lẻ.
