# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

```bash
flutter pub get                        # install dependencies
flutter run                            # run the app in DEV (default; needs .env.dev, see below)
flutter run --dart-define=ENV=prod     # run the app against the PROD config
flutter analyze                        # lint (flutter_lints + analysis_options.yaml)
flutter test                           # run all tests
flutter test test/widget_test.dart     # run a single test file
flutter gen-l10n                       # regenerate lib/l10n/app_localizations*.dart from the .arb files
flutter pub run flutter_launcher_icons # regenerate app icons from assets/icon/app_icon.png
```

Before running the app, copy `.env.dev.example` to `.env.dev` and `.env.prod.example` to
`.env.prod`, then fill in each environment's Supabase project values (`SUPABASE_URL`,
`SUPABASE_ANON_KEY`) and backend settings. Both files are Flutter assets (declared in
`pubspec.yaml`) bundled into every build; which one is actually read at runtime is picked via
`EnvConfig.load()` based on the `ENV` dart-define (`dev` if unset, so plain `flutter run`/`flutter
test` need no flag) — never read `dotenv.env[...]` directly elsewhere, go through `EnvConfig`.
Building for release always requires an explicit `--dart-define=ENV=dev` or `ENV=prod`, e.g.:

```bash
flutter build apk --release --dart-define=ENV=prod
flutter build ipa --release --dart-define=ENV=prod
```

## Architecture

Feature-first Clean Architecture + MVVM, Bloc/Cubit for state management, GetIt for DI, GoRouter
for routing. Layers per feature, dependency direction `presentation → domain → data`:

```
lib/features/<feature>/
├── presentation/{view,viewmodel,widgets}/   # viewmodel = Cubit + its State class
├── domain/{entities,repositories,usecases}/  # repositories/ holds interfaces (IXxxRepository)
└── data/{datasources,models,repositories}/   # repositories/ holds the interface's implementation
```

- Not every feature has all three layers — some (`calendar`, `dashboard`, `settings`,
  `feedback_kit`, `language`, `add_transaction`) are presentation-only and read through another
  feature's domain/data (e.g. `transactions`, `authentication`).
- No cross-feature imports of `domain`/`data` internals; if two features need the same logic,
  it belongs in `lib/shared/`.
- `lib/core/` holds cross-cutting app infrastructure: `theme/` (design tokens + `ThemeCubit`),
  `router/` (`AppRouter`, GoRouter typed routes), `di/injection.dart` (single `configureDependencies()`
  entry point — register everything there, don't scatter `GetIt.instance<T>()` calls), `network/`
  (Dio client for the custom backend), `storage/` (SharedPreferences wrapper), `error/failure.dart`
  (Failure hierarchy), `config/env_config.dart`, `locale/` (`LocaleCubit`).

### State management

Every screen-level Cubit is registered in `core/di/injection.dart` and resolved with
`getIt<XxxCubit>()`. App-wide Cubits (`AuthCubit`, `ThemeCubit`, `LocaleCubit`) are
`registerLazySingleton` and provided once at the root via `MultiBlocProvider` in `main.dart`, so
every screen observes the same instance. Per-screen Cubits are provided at the route level in
`core/router/app_router.dart` (each route wraps its page in its own `BlocProvider`), so navigating
to a screen always creates a fresh instance. Never use `setState` for business logic, and never
introduce the `provider` or `GetX` packages — this app uses `flutter_bloc` exclusively.

### Error handling

Repository methods return `Either<Failure, T>` (via `dartz`). `Failure` subtypes
(`NetworkFailure`, `AuthFailure`, `ValidationFailure`, `UnknownFailure`) live in
`core/error/failure.dart`; `Failure.code` carries the backend's machine-readable `error.code`
(e.g. `EMAIL_NOT_VERIFIED`) for callers that need to branch on a stable code rather than the
human-readable message — only populated in backend mode.

### Dual data source (Supabase vs custom backend)

`EnvConfig.dataSource` (from `.env`'s `DATA_SOURCE`) switches between two backends for the same
domain/presentation layers:

- **`supabase`** (default): datasources talk to `Supabase.instance.client` directly.
- **`backend`**: datasources go through `BackendApiClient` (Dio) to a separate REST API
  (`BACKEND_BASE_URL`), with tokens in `TokenStorage` (`flutter_secure_storage`).

Only **Auth** and **Category Management** have real `backend`-mode implementations today; every
other feature (`transactions`, `budget`, `savings_goal`, ...) always uses Supabase regardless of
the flag. Each such feature has parallel classes for both modes — e.g.
`AuthRepository`/`BackendAuthRepository`, `AuthRemoteDataSource`/`BackendAuthRemoteDataSource` —
and `injection.dart` picks which to register based on `EnvConfig.dataSource`. When adding backend
support to a new feature, follow this same parallel-class pattern rather than branching inside a
single class.

When `useBackend` is true, `Supabase.initialize(...)` is never called and `main.dart` skips it —
don't add code that touches `Supabase.instance.client` unconditionally.

### Design tokens and localization

UI must use tokens from `core/theme/` (`AppColors`, `AppSpacing`, `AppRadius`, `AppTypography`,
`AppShadow`, `AppAnimation`) — no hardcoded colors, spacing, radii, or font sizes. All
user-facing strings go through `AppLocalizations` (generated from `lib/l10n/app_vi.arb` /
`app_en.arb`, Vietnamese is the template/default locale) — no hardcoded UI strings. After editing
an `.arb` file, run `flutter gen-l10n` before using new keys.

### Routing

`core/router/app_router.dart` defines a typed GoRouter route table. Every route transition fades
in/out (`_fadePage` helper, `CustomTransitionPage` + `FadeTransition`) rather than sliding —
reuse that helper for new routes rather than GoRouter's default push transition.

## Design reference

`design_handoff_finance_app/` contains the original HTML/CSS design prototype and logo for the
app — check it when a screen's visual spec is ambiguous from the Flutter code alone.
