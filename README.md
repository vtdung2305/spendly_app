# spendly_app

## Cài đặt

```bash
flutter pub get
```

Copy `.env.dev.example` thành `.env.dev` và `.env.prod.example` thành `.env.prod`, sau đó điền
giá trị Supabase (`SUPABASE_URL`, `SUPABASE_ANON_KEY`) và cấu hình backend cho từng môi trường.

## Chạy (run)

```bash
flutter run                            # DEV (mặc định)
flutter run --dart-define=ENV=prod     # PROD
```

## Build release

```bash
# Android APK
flutter build apk --release --dart-define=ENV=dev
flutter build apk --release --dart-define=ENV=prod

# iOS IPA
flutter build ipa --release --dart-define=ENV=dev
flutter build ipa --release --dart-define=ENV=prod

## build only device id
flutter run --release \
  -d 00008101-001A54C02112001E  \
  --dart-define=ENV=staging
```