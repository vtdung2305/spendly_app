/// Animation durations — all product motion must land within 200-350ms.
abstract class AppAnimation {
  static const buttonPress = Duration(milliseconds: 150);
  static const fast = Duration(milliseconds: 200);
  static const normal = Duration(milliseconds: 250);
  static const sheet = Duration(milliseconds: 280);
  static const chartValue = Duration(milliseconds: 300);
  static const pageTransition = Duration(milliseconds: 300);
  static const slow = Duration(milliseconds: 350);
  static const dotsPulse = Duration(milliseconds: 900);
  static const snackbarVisible = Duration(milliseconds: 2500);
}
