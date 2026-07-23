# Forms & Routing

## Form Rules

Mọi form phải có đủ:
- **Validation** — validate ở ViewModel, không validate logic phức tạp ngay trong widget.
- **Formatter** — dùng `TextInputFormatter` cho input cần format (số điện thoại, ngày tháng, tiền tệ).
- **FocusNode** — quản lý focus rõ ràng, dispose đúng trong ViewModel/State.
- **Keyboard action** — `TextInputAction.next`/`.done` + `onSubmitted` chuyển focus hợp lý.
- **Autofill** — `AutofillHints` cho email/password/phone để hỗ trợ password manager.

```dart
class LoginFormViewModel {
  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Email không được để trống';
    final regex = RegExp(r'^[\w.+-]+@[\w-]+\.[\w.-]+$');
    if (!regex.hasMatch(value)) return 'Email không hợp lệ';
    return null;
  }
}

TextFormField(
  focusNode: _emailFocusNode,
  textInputAction: TextInputAction.next,
  autofillHints: const [AutofillHints.email],
  keyboardType: TextInputType.emailAddress,
  validator: viewModel.validateEmail,
  onFieldSubmitted: (_) => _passwordFocusNode.requestFocus(),
)
```

## Routing — GoRouter

Dùng **typed route** (không dùng string path rải rác) để tránh lỗi typo và dễ refactor.

```dart
// core/router/app_router.dart
class AppRouter {
  static final router = GoRouter(
    initialLocation: HomeRoute.path,
    redirect: _authGuard,
    routes: [
      GoRoute(
        path: HomeRoute.path,
        name: HomeRoute.name,
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: ProfileRoute.path,
        name: ProfileRoute.name,
        builder: (context, state) {
          final userId = state.pathParameters['userId']!;
          return ProfilePage(userId: userId);
        },
      ),
    ],
  );

  static String? _authGuard(BuildContext context, GoRouterState state) {
    final isLoggedIn = /* đọc từ auth state provider */ true;
    final isLoggingIn = state.matchedLocation == LoginRoute.path;
    if (!isLoggedIn && !isLoggingIn) return LoginRoute.path;
    if (isLoggedIn && isLoggingIn) return HomeRoute.path;
    return null;
  }
}

// core/router/routes/home_route.dart
abstract class HomeRoute {
  static const path = '/home';
  static const name = 'home';
}
```

## Navigation Guard

Guard đặt tập trung ở `core/router/`, không rải rác `if (!isLoggedIn) { ... }` trong từng
page riêng lẻ — dễ miss case và khó maintain.

## Deep Link

Khai báo scheme/host trong `AndroidManifest.xml`/`Info.plist`, map path tới route tương ứng qua
GoRouter — không tự parse URL thủ công trong widget.

## Navigation Trigger từ ViewModel

ViewModel không nên tự `context.go(...)` trực tiếp (vì cần `BuildContext`, khó test). Thay vào đó
expose 1 signal/event, View lắng nghe và tự thực hiện navigation:

```dart
// ViewModel expose 1-time navigation event qua state
sealed class LoginState {
  const LoginState();
}
class LoginNavigateToHome extends LoginState {
  const LoginNavigateToHome();
}

// View lắng nghe qua ref.listen (Riverpod) hoặc BlocListener (Bloc)
ref.listen(loginViewModelProvider, (previous, next) {
  if (next case LoginNavigateToHome()) {
    context.goNamed(HomeRoute.name);
  }
});
```
