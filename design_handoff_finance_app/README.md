# Handoff: Spendly — Personal Finance App (Flutter)

## Overview
Full UI/UX prototype for "Spendly", a personal expense-tracking mobile app: income/expense tracking, monthly budget, calendar heatmap of daily spend, reports, and category budgets. Target stack: **Flutter, Material Design 3, Supabase (Auth/Postgres/Storage/Realtime), Google + Email login.**

## About the Design Files
The bundled file `Finance App Prototype.dc.html` is a **design reference built in HTML/React**, not production code. It is a clickable prototype (phone-frame mock with working navigation) meant to communicate exact layout, color, type, spacing, and interaction — **not to be embedded or copied as HTML into the Flutter app**. Recreate every screen natively in Flutter widgets using Material 3 theming, matching this reference pixel-for-pixel where values are given below.

## Fidelity
**High-fidelity.** All colors, type sizes/weights, radii, spacing, and copy (Vietnamese) below are final. Icons are named from **Material Symbols Rounded** — map directly to Flutter's `Icons` (rounded variant) or the `material_symbols_icons` package.

---

## Design Tokens

### Colors (Light)
| Token | Hex | Usage |
|---|---|---|
| Primary | `#4F46E5` | CTAs, active nav, links, chart primary |
| Success | `#22C55E` | Income amounts, under-budget, low-spend days |
| Warning | `#F59E0B` | Secondary chart series, warnings |
| Danger | `#EF4444` | Expense amounts, over-budget, high-spend days |
| Background | `#F8FAFC` | Screen background |
| Surface | `#FFFFFF` | Cards |
| Surface Alt | `#F1F5F9` | Inputs, chips, track backgrounds |
| Border | `#E2E8F0` | Card/input borders |
| Text Primary | `#1E293B` | Headings, body |
| Text Secondary | `#64748B` | Sub-labels |
| Text Tertiary | `#94A3B8` | Placeholders, disabled |
| Primary tint | `#EEF2FF` | Selected chip/category background |
| Success tint | `#ECFDF5` | Income icon bg, under-budget bg |
| Danger tint | `#FEF2F2` | Expense-danger bg, over-budget card bg |

### Colors (Dark)
| Token | Hex |
|---|---|
| Background | `#111827` |
| Surface | `#1F2937` |
| Surface Alt | `#182234` |
| Border | `#2D3748` |
| Text Primary | `#F1F5F9` |
| Text Secondary | `#94A3B8` |
| Text Tertiary | `#64748B` |
| Primary | `#818CF8` |
| Success | `#34D399` |
| Warning | `#FBBF24` |
| Danger | `#F87171` |

### Category chart palette (fixed hues, used consistently across Pie charts)
Ăn uống `#4F46E5` · Shopping `#F59E0B` · Đi lại `#22C55E` · Giải trí `#F43F5E` · Gia đình `#8B5CF6` · Khác `#94A3B8`

### Typography
- Family: **Inter** (400/500/600/700/800) for all UI text.
- Family: **IBM Plex Mono** (400/500) for all monetary amounts and small meta/mono labels (structural accent).
- Scale used: 10–11px (meta/chips) · 12–13px (secondary/body-small) · 14–15px (body/labels) · 17–19px (screen titles) · 22–30px (hero numbers/headlines).

### Shape & elevation
- Card radius: **20px**. Small controls (chips, inputs, icon buttons): **12–16px**. Pills/segmented controls/avatars: **999px**.
- Card shadow (light): `0 20px 44px rgba(15,23,42,0.10)`. Card shadow (dark): `0 20px 44px rgba(0,0,0,0.5)`.
- Card border: 1px solid Border token, always paired with the shadow (soft "floating card" look — no heavy borders alone).

### Spacing
Base unit 2px; common paddings 8/10/12/14/16/18/20/22px; screen horizontal padding **20px**; gaps between stacked cards **12–16px**.

### Icons
Material Symbols Rounded, filled (`FILL 1`), 18–26px depending on context. Bottom nav icons 24px, list-row icons 20px, category-grid icons 22px.

### Touch targets
Minimum 48×48px on all tappable controls (buttons, nav items, list rows, chips) per accessibility requirement.

---

## Global Chrome

### Bottom Navigation (Dashboard, Calendar, Reports, Profile only — not on Login/Register/Add/Settings/history/etc.)
5 slots, evenly spaced, height ~88px + safe-area padding, `Surface`/`#151c2b`(dark) background, 1px top border:
1. Home icon `home` → Dashboard
2. `calendar_month` → Calendar
3. Center **FAB**, 52px circle, Primary background, white `add` icon, raised 26px above the bar, shadow `0 8px 20px rgba(79,70,229,.4)` → opens Add Transaction (defaults to Expense tab)
4. `bar_chart` → Reports
5. `person` → Profile
Active tab: icon + 10px label in Primary; inactive: Text Tertiary.

### Snackbar (success confirmation)
Appears bottom-anchored above the nav bar after saving a transaction, auto-dismiss 2.5s: dark pill, `check_circle` (Success color) + "Đã lưu khoản chi" / "Đã lưu khoản thu".

---

## Screens

### 1. Splash
**Purpose:** brand moment while Supabase session/auth state resolves.
**Layout:** full-bleed gradient `135deg, Primary → #8B5CF6` (light) / `→ #3730A3` (dark), centered column: 84px rounded-24 icon tile (`savings` icon, white, 44px) → app name "Spendly" 28px/800 white → tagline 14px white 75% opacity → 3 pulsing dots.
**Behavior:** auto-navigate to Login after ~2s if no session, or Dashboard if session valid.
**States:** Loading (dots) is the default; add a retry/error state if auth check fails after a timeout.

### 2. Login
**Purpose:** fast sign-in, Google-first.
**Layout:** top-padded column, 56px rounded-16 icon tile, "Chào bạn trở lại" 26px/800, subtitle 14px secondary. Below: outlined Google button (52px, radius 16, icon + "Tiếp tục với Google") → "hoặc" divider → email field → password field (both 50px, radius 14, icon + placeholder, Surface bg, Border outline) → "Quên mật khẩu?" link right-aligned → Primary button "Đăng nhập" (52px, radius 16) → bottom-anchored "Chưa có tài khoản? Đăng ký" link.
**States:** inline red border + helper text on invalid credentials; spinner in the primary button while authenticating.

### 3. Register
**Purpose:** create account via email.
**Layout:** back arrow (38px icon button) → "Tạo tài khoản" 26px/800 → subtitle → 3 stacked fields (Email, Password, Confirm Password, same input style as Login) → Primary button "Đăng ký" → bottom link "Đã có tài khoản? Đăng nhập".
**States:** per-field inline validation errors (email taken, password mismatch); button spinner on submit.

### 4. Dashboard (most important screen)
**Layout, top to bottom, 20px side padding:**
1. Header row: "Xin chào 👋" (13px secondary) + "Minh Anh" (19px/700) left; month chip "Tháng 7, 2026" (pill, Surface Alt) right.
2. **Hero savings card**: gradient Primary→accent, radius 24, padding 22. Mono-label "TIẾT KIỆM THÁNG NÀY" (11px, 70% white, letterspaced) → big amount `26.500.000 ₫` (30px/800, IBM Plex Mono, white) → 2-up row of translucent-white mini stats: "Thu nhập" `45.000.000` / "Chi tiêu" `18.500.000`.
3. **Budget summary row** (tappable → Budget screen): circular progress ring (conic-gradient, Primary for the used arc) with "62%" centered, label "Ngân sách tháng" + "Đã dùng 62% · còn 12.500.000 ₫", chevron.
4. **Category pie card**: donut (conic-gradient, category palette) with total `18.5M` centered, legend list (dot + label + %) to the right — categories: Ăn uống 32%, Shopping 22%, Đi lại 16%, Giải trí 12%, Gia đình 12%, Khác 6%.
5. **Daily spend bar card**: 14 thin vertical bars, color-coded (green=low, primary=mid, red=high day).
6. **Recent Transactions**: header row "Giao dịch gần đây" + "Xem tất cả" link → Transaction History. List of up to 10 rows: 42px rounded-12 icon tile (category tint bg/icon color) + name (truncate) + "category · date" (11.5px tertiary) + amount right-aligned in IBM Plex Mono, **green with `+` prefix for income, red with `-` prefix for expense**.
7. FAB (see Global Chrome) always visible.
**States:** Empty (no transactions) — centered illustration icon `receipt_long`, "Chưa có giao dịch nào" + CTA hint. Loading — shimmer blocks in place of chart and each list row.

### 5 & 6. Add Expense / Add Income (implemented as one unified screen, entry point sets default tab)
**Layout:** header with `close` icon-button (returns to Dashboard) + "Thêm giao dịch" title. Segmented control (Surface Alt track, radius 14): **Chi tiêu** / **Thu nhập** — active segment is white/Surface with colored label (danger for expense, success for income).
- **Chi tiêu tab:** "Danh mục" label → 4-column grid of 8 category cards (icon 22px + 10.5px label, radius 16, selected = 2px colored border + tint bg): Ăn uống(restaurant)/Shopping(shopping_bag)/Đi lại(directions_car)/Giải trí(sports_esports)/Y tế(medical_services)/Gia đình(home)/Du lịch(flight)/Thú cưng(pets).
- **Thu nhập tab:** "Nguồn thu" label → vertical list of 4 rows (icon + label + radio checkmark), selected = 2px Primary border + tint: Lương(payments)/Freelance(laptop_mac)/Bonus(redeem)/Khác(more_horiz).
- Below (both tabs): "Số tiền" label → large amount input (Surface Alt bg, radius 16, 24px/800 IBM Plex Mono, live "." thousands separator, trailing "₫") → "Ngày" row with a date chip defaulting to **today**, calendar icon → "Ghi chú" label → single-line text field (optional) → Primary "Lưu giao dịch" button, **disabled (45% opacity) until a category/source AND an amount are set**.
**Interaction:** presented as a bottom-sheet-style push (slide-up translateY, ~280ms ease). On save → snackbar + return to Dashboard, fields reset.
**States:** validation only (button disabled state); no separate empty/error state needed.

### 7. Calendar
**Layout:** "Tháng 7, 2026" 19px/700 + "Tổng chi: 18.500.000 ₫" subtitle. 7-column weekday header (T2..CN) then a day grid (2 leading blank cells for month-start alignment, 31 numbered cells). Each day cell: rounded-10 square, day number (12px/700) + abbreviated amount (9px mono, e.g. "1.2M", "250K", "—" for zero) — **background tinted red for high-spend days (≥1,000,000₫), green for low-spend (>0 and ≤300,000₫), primary tint for mid-range, neutral surface for 0**. Legend row below (red = "Chi nhiều", green = "Chi ít").
**Interaction:** tap a day → bottom sheet (scrim fades in, sheet slides up from bottom, radius 28 top corners) listing that day's transactions with inline `edit`/`delete` icon actions; tap scrim or drag down to dismiss.
**States:** Loading = skeleton grid (all cells shimmering) in place of the day grid.

### 8. Reports
**Layout:** title "Báo cáo" → segmented control **Tuần / Tháng / Năm** (same segmented style as Add Transaction) → 2×2 grid of mini stat cards (Top danh mục, TB mỗi ngày, Ngày chi nhiều nhất [danger color], Tỷ lệ tiết kiệm [success color]) → Pie chart card (same donut + legend pattern as Dashboard) → weekly Bar chart card (4 bars, labeled T1–T4).
**States:** Loading = shimmer per chart card; Empty = light illustration when a period has no data. Filterable by period tab (Week/Month/Year) — swapping tabs should animate chart values (~400ms).

### 9. Budget
**Layout:** title "Ngân sách" + `add_circle` icon button top-right; subtitle with total budget & % used. Stacked budget cards per category (icon + label + colored % on the right, then a rounded progress bar, then "used / budget" amounts in mono under the bar). **Card flips to danger-tint background + red border + red bar when used > budget** (see "Giải trí" example: 1.690.000 used / 1.500.000 budget = 113%, over).
**States:** Empty = CTA to set the first budget when the list is blank.

### 10. Income Management
**Layout:** title "Thu nhập" + add icon top-right. Horizontal scrollable month chips (active = Primary fill). List of income rows: 42px rounded-12 success-tint icon tile + label + date, amount right-aligned green with `+` prefix.
**States:** Empty per selected month when no income recorded.

### 11. Transaction History
**Layout:** title, then a search bar (Surface Alt, `search` icon + text input) + adjacent filter icon-button (`tune`, turns Primary-filled when the filter panel is open). Expandable filter panel: chip row (e.g. "Tuần này", "Ăn uống", "Trên 500K", "Chỉ chi tiêu" — represent Date/Category/Amount range/Type filters). Below: full transaction list (same row style as Dashboard's recent list, longer).
**States:** distinct Empty ("Không tìm thấy giao dịch" for a no-results search, `search_off` icon) vs Loading (shimmer rows).
**Interaction (Flutter target):** swipe-to-reveal Edit/Delete actions on each row (prototype shows static edit/delete icons as a stand-in — implement as real `Dismissible`/slidable in Flutter).

### 12. Profile
**Layout:** title "Hồ sơ". Identity card: 56px circular avatar (initials fallback "MA", Primary bg, white text) + name + email. Menu card (radius 20): Dark mode row with a toggle switch first, then rows for Thông báo (value "Bật"), Đơn vị tiền tệ ("VNĐ"), Ngôn ngữ ("Tiếng Việt"), Ngân sách → Budget, Quản lý thu nhập → Income Management, Cài đặt → Settings (each: leading icon, label, optional trailing value text, trailing chevron). Danger-tint "Đăng xuất" button full-width at the bottom.
**Behavior:** the Dark Mode toggle here flips the whole app's theme instantly.

### 13. Settings
**Layout:** back arrow + "Cài đặt" title. Single menu card, rows: Giao diện (value "Sáng"/"Tối"), Ngôn ngữ ("Tiếng Việt"), Sao lưu dữ liệu, Quyền riêng tư, Về ứng dụng ("v1.0.0"), Góp ý, Điều khoản — same row style as Profile menu.
**States:** static content, no empty/loading needed.

---

## Interactions & Animation Summary
- Page transitions: slide-from-right when drilling in (Login→Register, Profile→Settings), duration 250–300ms ease.
- Card entrance: fade + slight slide-up, ~250ms, on screen mount.
- Bottom sheets (Add Transaction, Calendar day list): translateY slide, ease, ~280ms; scrim fades with it.
- Button press: scale to 0.97, ~150ms.
- Progress bars / rings: animate width or arc on mount, ~300ms ease-out.
- Toggle switches: knob position transitions ~200ms.
- All durations should land in the 200–350ms range per the product brief — nothing snappier or slower.

## State Management (Flutter)
Track globally: `currentUser`, `theme (light/dark)`, `currentMonth`. Per-flow local state: `AddTransaction` (type, category/source, amount, date, note, saving/validity), `Calendar` (selectedDay, sheet open), `Reports`/`History` (period/filter selections), `Profile` (toggles). Data comes from Supabase Postgres tables for transactions/budgets/income sources, Supabase Auth for session, Realtime for live balance updates across devices.

## Assets
No custom illustrations or photography used — all iconography is Material Symbols Rounded (map to Flutter's Material icon set). No external images to source.

## Files
- `Finance App Prototype.dc.html` — the full interactive reference (all 13 screens, light/dark, Normal/Empty/Loading toggle, in-context annotations). Open directly in a browser to click through it.
