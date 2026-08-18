import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_vi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('vi')
  ];

  /// No description provided for @commonCancel.
  ///
  /// In vi, this message translates to:
  /// **'Hủy'**
  String get commonCancel;

  /// No description provided for @commonDelete.
  ///
  /// In vi, this message translates to:
  /// **'Xóa'**
  String get commonDelete;

  /// No description provided for @commonRetry.
  ///
  /// In vi, this message translates to:
  /// **'Thử lại'**
  String get commonRetry;

  /// No description provided for @weekdayMon.
  ///
  /// In vi, this message translates to:
  /// **'T2'**
  String get weekdayMon;

  /// No description provided for @weekdayTue.
  ///
  /// In vi, this message translates to:
  /// **'T3'**
  String get weekdayTue;

  /// No description provided for @weekdayWed.
  ///
  /// In vi, this message translates to:
  /// **'T4'**
  String get weekdayWed;

  /// No description provided for @weekdayThu.
  ///
  /// In vi, this message translates to:
  /// **'T5'**
  String get weekdayThu;

  /// No description provided for @weekdayFri.
  ///
  /// In vi, this message translates to:
  /// **'T6'**
  String get weekdayFri;

  /// No description provided for @weekdaySat.
  ///
  /// In vi, this message translates to:
  /// **'T7'**
  String get weekdaySat;

  /// No description provided for @weekdaySun.
  ///
  /// In vi, this message translates to:
  /// **'CN'**
  String get weekdaySun;

  /// No description provided for @historyGroupWeekdayMon.
  ///
  /// In vi, this message translates to:
  /// **'Thứ 2'**
  String get historyGroupWeekdayMon;

  /// No description provided for @historyGroupWeekdayTue.
  ///
  /// In vi, this message translates to:
  /// **'Thứ 3'**
  String get historyGroupWeekdayTue;

  /// No description provided for @historyGroupWeekdayWed.
  ///
  /// In vi, this message translates to:
  /// **'Thứ 4'**
  String get historyGroupWeekdayWed;

  /// No description provided for @historyGroupWeekdayThu.
  ///
  /// In vi, this message translates to:
  /// **'Thứ 5'**
  String get historyGroupWeekdayThu;

  /// No description provided for @historyGroupWeekdayFri.
  ///
  /// In vi, this message translates to:
  /// **'Thứ 6'**
  String get historyGroupWeekdayFri;

  /// No description provided for @historyGroupWeekdaySat.
  ///
  /// In vi, this message translates to:
  /// **'Thứ 7'**
  String get historyGroupWeekdaySat;

  /// No description provided for @historyGroupWeekdaySun.
  ///
  /// In vi, this message translates to:
  /// **'Chủ Nhật'**
  String get historyGroupWeekdaySun;

  /// No description provided for @categoryFood.
  ///
  /// In vi, this message translates to:
  /// **'Ăn uống'**
  String get categoryFood;

  /// No description provided for @categoryShopping.
  ///
  /// In vi, this message translates to:
  /// **'Shopping'**
  String get categoryShopping;

  /// No description provided for @categoryTransport.
  ///
  /// In vi, this message translates to:
  /// **'Đi lại'**
  String get categoryTransport;

  /// No description provided for @categoryEntertainment.
  ///
  /// In vi, this message translates to:
  /// **'Giải trí'**
  String get categoryEntertainment;

  /// No description provided for @categoryFamily.
  ///
  /// In vi, this message translates to:
  /// **'Gia đình'**
  String get categoryFamily;

  /// No description provided for @categoryOther.
  ///
  /// In vi, this message translates to:
  /// **'Khác'**
  String get categoryOther;

  /// No description provided for @categoryHealth.
  ///
  /// In vi, this message translates to:
  /// **'Y tế'**
  String get categoryHealth;

  /// No description provided for @categoryTravel.
  ///
  /// In vi, this message translates to:
  /// **'Du lịch'**
  String get categoryTravel;

  /// No description provided for @categoryPets.
  ///
  /// In vi, this message translates to:
  /// **'Thú cưng'**
  String get categoryPets;

  /// No description provided for @incomeSourceSalary.
  ///
  /// In vi, this message translates to:
  /// **'Lương'**
  String get incomeSourceSalary;

  /// No description provided for @incomeSourceFreelance.
  ///
  /// In vi, this message translates to:
  /// **'Freelance'**
  String get incomeSourceFreelance;

  /// No description provided for @incomeSourceBonus.
  ///
  /// In vi, this message translates to:
  /// **'Bonus'**
  String get incomeSourceBonus;

  /// No description provided for @reportPeriodWeek.
  ///
  /// In vi, this message translates to:
  /// **'Tuần'**
  String get reportPeriodWeek;

  /// No description provided for @reportPeriodMonth.
  ///
  /// In vi, this message translates to:
  /// **'Tháng'**
  String get reportPeriodMonth;

  /// No description provided for @reportPeriodYear.
  ///
  /// In vi, this message translates to:
  /// **'Năm'**
  String get reportPeriodYear;

  /// No description provided for @navHomeTab.
  ///
  /// In vi, this message translates to:
  /// **'Trang chủ'**
  String get navHomeTab;

  /// No description provided for @navCalendarTab.
  ///
  /// In vi, this message translates to:
  /// **'Lịch'**
  String get navCalendarTab;

  /// No description provided for @navBudgetTab.
  ///
  /// In vi, this message translates to:
  /// **'Ngân sách'**
  String get navBudgetTab;

  /// No description provided for @navReportsTab.
  ///
  /// In vi, this message translates to:
  /// **'Báo cáo'**
  String get navReportsTab;

  /// No description provided for @navProfileTab.
  ///
  /// In vi, this message translates to:
  /// **'Cá nhân'**
  String get navProfileTab;

  /// No description provided for @percentValue.
  ///
  /// In vi, this message translates to:
  /// **'{percent}%'**
  String percentValue(String percent);

  /// No description provided for @monthYearHeader.
  ///
  /// In vi, this message translates to:
  /// **'Tháng {month}, {year}'**
  String monthYearHeader(String month, String year);

  /// No description provided for @splashAppName.
  ///
  /// In vi, this message translates to:
  /// **'Spendly'**
  String get splashAppName;

  /// No description provided for @splashTagline.
  ///
  /// In vi, this message translates to:
  /// **'Quản lý chi tiêu thông minh'**
  String get splashTagline;

  /// No description provided for @splashServerErrorMessage.
  ///
  /// In vi, this message translates to:
  /// **'Không thể kết nối máy chủ. Vui lòng thử lại.'**
  String get splashServerErrorMessage;

  /// No description provided for @splashOfflineMessage.
  ///
  /// In vi, this message translates to:
  /// **'Mất kết nối mạng. Kiểm tra Wi-Fi hoặc dữ liệu di động.'**
  String get splashOfflineMessage;

  /// No description provided for @onboardingSkipButton.
  ///
  /// In vi, this message translates to:
  /// **'Bỏ qua'**
  String get onboardingSkipButton;

  /// No description provided for @onboardingContinueButton.
  ///
  /// In vi, this message translates to:
  /// **'Tiếp tục'**
  String get onboardingContinueButton;

  /// No description provided for @onboardingStartButton.
  ///
  /// In vi, this message translates to:
  /// **'Bắt đầu ngay'**
  String get onboardingStartButton;

  /// No description provided for @onboardingSlide1Title.
  ///
  /// In vi, this message translates to:
  /// **'Theo dõi mọi khoản chi'**
  String get onboardingSlide1Title;

  /// No description provided for @onboardingSlide1Desc.
  ///
  /// In vi, this message translates to:
  /// **'Ghi lại thu nhập và chi tiêu chỉ trong vài giây, mọi lúc mọi nơi.'**
  String get onboardingSlide1Desc;

  /// No description provided for @onboardingSlide2Title.
  ///
  /// In vi, this message translates to:
  /// **'Thấu hiểu dòng tiền'**
  String get onboardingSlide2Title;

  /// No description provided for @onboardingSlide2Desc.
  ///
  /// In vi, this message translates to:
  /// **'Biểu đồ trực quan giúp bạn biết tiền đi đâu, về đâu mỗi tháng.'**
  String get onboardingSlide2Desc;

  /// No description provided for @onboardingSlide3Title.
  ///
  /// In vi, this message translates to:
  /// **'Đạt mục tiêu tiết kiệm'**
  String get onboardingSlide3Title;

  /// No description provided for @onboardingSlide3Desc.
  ///
  /// In vi, this message translates to:
  /// **'Đặt ngân sách, theo dõi tiến độ và tiết kiệm nhiều hơn mỗi ngày.'**
  String get onboardingSlide3Desc;

  /// No description provided for @loginFeatureInDevelopmentSnackbar.
  ///
  /// In vi, this message translates to:
  /// **'Tính năng đang được phát triển'**
  String get loginFeatureInDevelopmentSnackbar;

  /// No description provided for @loginTitle.
  ///
  /// In vi, this message translates to:
  /// **'Chào bạn trở lại'**
  String get loginTitle;

  /// No description provided for @loginSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Đăng nhập để tiếp tục quản lý chi tiêu'**
  String get loginSubtitle;

  /// No description provided for @loginEmailLabel.
  ///
  /// In vi, this message translates to:
  /// **'Email'**
  String get loginEmailLabel;

  /// No description provided for @loginEmailHint.
  ///
  /// In vi, this message translates to:
  /// **'you@email.com'**
  String get loginEmailHint;

  /// No description provided for @loginPasswordLabel.
  ///
  /// In vi, this message translates to:
  /// **'Mật khẩu'**
  String get loginPasswordLabel;

  /// No description provided for @loginPasswordHint.
  ///
  /// In vi, this message translates to:
  /// **'Mật khẩu'**
  String get loginPasswordHint;

  /// No description provided for @loginForgotPasswordLink.
  ///
  /// In vi, this message translates to:
  /// **'Quên mật khẩu?'**
  String get loginForgotPasswordLink;

  /// No description provided for @loginSubmitButton.
  ///
  /// In vi, this message translates to:
  /// **'Đăng nhập'**
  String get loginSubmitButton;

  /// No description provided for @loginOrDivider.
  ///
  /// In vi, this message translates to:
  /// **'hoặc'**
  String get loginOrDivider;

  /// No description provided for @loginContinueWithGoogleButton.
  ///
  /// In vi, this message translates to:
  /// **'Tiếp tục với Google'**
  String get loginContinueWithGoogleButton;

  /// No description provided for @loginContinueWithFacebookButton.
  ///
  /// In vi, this message translates to:
  /// **'Đăng nhập với Facebook'**
  String get loginContinueWithFacebookButton;

  /// No description provided for @loginNoAccountPrefix.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có tài khoản? '**
  String get loginNoAccountPrefix;

  /// No description provided for @loginRegisterLink.
  ///
  /// In vi, this message translates to:
  /// **'Đăng ký'**
  String get loginRegisterLink;

  /// No description provided for @registerTitle.
  ///
  /// In vi, this message translates to:
  /// **'Tạo tài khoản'**
  String get registerTitle;

  /// No description provided for @registerSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Bắt đầu quản lý tài chính của bạn'**
  String get registerSubtitle;

  /// No description provided for @registerEmailLabel.
  ///
  /// In vi, this message translates to:
  /// **'Email'**
  String get registerEmailLabel;

  /// No description provided for @registerEmailHint.
  ///
  /// In vi, this message translates to:
  /// **'you@email.com'**
  String get registerEmailHint;

  /// No description provided for @registerPasswordLabel.
  ///
  /// In vi, this message translates to:
  /// **'Mật khẩu'**
  String get registerPasswordLabel;

  /// No description provided for @registerPasswordHint.
  ///
  /// In vi, this message translates to:
  /// **'Mật khẩu'**
  String get registerPasswordHint;

  /// No description provided for @registerConfirmPasswordLabel.
  ///
  /// In vi, this message translates to:
  /// **'Xác nhận mật khẩu'**
  String get registerConfirmPasswordLabel;

  /// No description provided for @registerConfirmPasswordHint.
  ///
  /// In vi, this message translates to:
  /// **'Xác nhận mật khẩu'**
  String get registerConfirmPasswordHint;

  /// No description provided for @registerSubmitButton.
  ///
  /// In vi, this message translates to:
  /// **'Đăng ký'**
  String get registerSubmitButton;

  /// No description provided for @registerHasAccountPrefix.
  ///
  /// In vi, this message translates to:
  /// **'Đã có tài khoản? '**
  String get registerHasAccountPrefix;

  /// No description provided for @registerLoginLink.
  ///
  /// In vi, this message translates to:
  /// **'Đăng nhập'**
  String get registerLoginLink;

  /// No description provided for @forgotPasswordSuccessSnackbar.
  ///
  /// In vi, this message translates to:
  /// **'Đã gửi liên kết đặt lại mật khẩu'**
  String get forgotPasswordSuccessSnackbar;

  /// No description provided for @forgotPasswordTitle.
  ///
  /// In vi, this message translates to:
  /// **'Quên mật khẩu?'**
  String get forgotPasswordTitle;

  /// No description provided for @forgotPasswordSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Nhập email để nhận liên kết đặt lại mật khẩu'**
  String get forgotPasswordSubtitle;

  /// No description provided for @forgotPasswordEmailLabel.
  ///
  /// In vi, this message translates to:
  /// **'Email'**
  String get forgotPasswordEmailLabel;

  /// No description provided for @forgotPasswordEmailHint.
  ///
  /// In vi, this message translates to:
  /// **'you@email.com'**
  String get forgotPasswordEmailHint;

  /// No description provided for @forgotPasswordSubmitButton.
  ///
  /// In vi, this message translates to:
  /// **'Gửi liên kết đặt lại'**
  String get forgotPasswordSubmitButton;

  /// No description provided for @forgotPasswordRememberedPrefix.
  ///
  /// In vi, this message translates to:
  /// **'Đã nhớ mật khẩu? '**
  String get forgotPasswordRememberedPrefix;

  /// No description provided for @forgotPasswordLoginLink.
  ///
  /// In vi, this message translates to:
  /// **'Đăng nhập'**
  String get forgotPasswordLoginLink;

  /// No description provided for @verifyOtpTitle.
  ///
  /// In vi, this message translates to:
  /// **'Xác thực email'**
  String get verifyOtpTitle;

  /// No description provided for @verifyOtpSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Chúng tôi đã gửi mã 6 số đến'**
  String get verifyOtpSubtitle;

  /// No description provided for @verifyOtpCodeInvalidError.
  ///
  /// In vi, this message translates to:
  /// **'Mã xác thực không đúng hoặc đã hết hạn'**
  String get verifyOtpCodeInvalidError;

  /// No description provided for @verifyOtpTooManyAttemptsError.
  ///
  /// In vi, this message translates to:
  /// **'Bạn đã nhập sai quá nhiều lần. Vui lòng gửi lại mã mới.'**
  String get verifyOtpTooManyAttemptsError;

  /// No description provided for @verifyOtpExpiresInLabel.
  ///
  /// In vi, this message translates to:
  /// **'Mã hết hạn sau {time}'**
  String verifyOtpExpiresInLabel(String time);

  /// No description provided for @verifyOtpSubmitButton.
  ///
  /// In vi, this message translates to:
  /// **'Xác thực'**
  String get verifyOtpSubmitButton;

  /// No description provided for @verifyOtpResendPrompt.
  ///
  /// In vi, this message translates to:
  /// **'Không nhận được mã?'**
  String get verifyOtpResendPrompt;

  /// No description provided for @verifyOtpResendLink.
  ///
  /// In vi, this message translates to:
  /// **'Gửi lại'**
  String get verifyOtpResendLink;

  /// No description provided for @verifyOtpChangeEmailLink.
  ///
  /// In vi, this message translates to:
  /// **'Đổi email khác'**
  String get verifyOtpChangeEmailLink;

  /// No description provided for @verifyOtpResentSnackbar.
  ///
  /// In vi, this message translates to:
  /// **'Đã gửi lại mã xác thực'**
  String get verifyOtpResentSnackbar;

  /// No description provided for @verifyOtpVerifiedSnackbar.
  ///
  /// In vi, this message translates to:
  /// **'Xác thực thành công'**
  String get verifyOtpVerifiedSnackbar;

  /// No description provided for @authInvalidEmail.
  ///
  /// In vi, this message translates to:
  /// **'Email không hợp lệ'**
  String get authInvalidEmail;

  /// No description provided for @authPasswordTooShort.
  ///
  /// In vi, this message translates to:
  /// **'Mật khẩu phải có ít nhất 6 ký tự'**
  String get authPasswordTooShort;

  /// No description provided for @authPasswordMismatch.
  ///
  /// In vi, this message translates to:
  /// **'Mật khẩu xác nhận không khớp'**
  String get authPasswordMismatch;

  /// No description provided for @authSignInFailed.
  ///
  /// In vi, this message translates to:
  /// **'Đăng nhập thất bại, vui lòng thử lại'**
  String get authSignInFailed;

  /// No description provided for @authGoogleSignInUnsupported.
  ///
  /// In vi, this message translates to:
  /// **'Đăng nhập Google chưa được hỗ trợ trong phiên bản này'**
  String get authGoogleSignInUnsupported;

  /// No description provided for @authRegisterFailed.
  ///
  /// In vi, this message translates to:
  /// **'Đăng ký thất bại, vui lòng thử lại'**
  String get authRegisterFailed;

  /// No description provided for @authConfirmEmailRequired.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng kiểm tra email để xác nhận tài khoản, sau đó đăng nhập lại. (Hoặc tắt \"Confirm email\" trong Supabase Auth settings để bỏ qua bước này.)'**
  String get authConfirmEmailRequired;

  /// No description provided for @dashboardEmptyMessage.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có giao dịch nào.\nNhấn nút + để thêm giao dịch đầu tiên.'**
  String get dashboardEmptyMessage;

  /// No description provided for @dashboardGreeting.
  ///
  /// In vi, this message translates to:
  /// **'Xin chào 👋'**
  String get dashboardGreeting;

  /// No description provided for @dashboardBudgetCardTitle.
  ///
  /// In vi, this message translates to:
  /// **'Ngân sách tháng'**
  String get dashboardBudgetCardTitle;

  /// No description provided for @dashboardBudgetUsedSummary.
  ///
  /// In vi, this message translates to:
  /// **'Đã dùng {percent}% · còn {remaining}'**
  String dashboardBudgetUsedSummary(String percent, String remaining);

  /// No description provided for @dashboardDailySpendTitle.
  ///
  /// In vi, this message translates to:
  /// **'Chi tiêu theo ngày'**
  String get dashboardDailySpendTitle;

  /// No description provided for @dashboardRecentTransactionsTitle.
  ///
  /// In vi, this message translates to:
  /// **'Giao dịch gần đây'**
  String get dashboardRecentTransactionsTitle;

  /// No description provided for @dashboardSeeAllButton.
  ///
  /// In vi, this message translates to:
  /// **'Xem tất cả'**
  String get dashboardSeeAllButton;

  /// No description provided for @dashboardSavingsCardTitle.
  ///
  /// In vi, this message translates to:
  /// **'TIẾT KIỆM THÁNG NÀY'**
  String get dashboardSavingsCardTitle;

  /// No description provided for @dashboardIncomeLabel.
  ///
  /// In vi, this message translates to:
  /// **'Thu nhập'**
  String get dashboardIncomeLabel;

  /// No description provided for @dashboardExpenseLabel.
  ///
  /// In vi, this message translates to:
  /// **'Chi tiêu'**
  String get dashboardExpenseLabel;

  /// No description provided for @dashboardCategoryPieTitle.
  ///
  /// In vi, this message translates to:
  /// **'Chi tiêu theo danh mục'**
  String get dashboardCategoryPieTitle;

  /// No description provided for @dashboardCategoryPieCenterLabel.
  ///
  /// In vi, this message translates to:
  /// **'tổng chi'**
  String get dashboardCategoryPieCenterLabel;

  /// No description provided for @dashboardOverBudgetSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Xem lại hạn mức cho danh mục này'**
  String get dashboardOverBudgetSubtitle;

  /// No description provided for @dashboardOverBudgetText.
  ///
  /// In vi, this message translates to:
  /// **'{category} đã vượt ngân sách {percent}%'**
  String dashboardOverBudgetText(String category, String percent);

  /// No description provided for @dashboardQuickActionExpense.
  ///
  /// In vi, this message translates to:
  /// **'Ghi chi'**
  String get dashboardQuickActionExpense;

  /// No description provided for @dashboardQuickActionIncome.
  ///
  /// In vi, this message translates to:
  /// **'Ghi thu'**
  String get dashboardQuickActionIncome;

  /// No description provided for @dashboardQuickActionHistory.
  ///
  /// In vi, this message translates to:
  /// **'Lịch sử'**
  String get dashboardQuickActionHistory;

  /// No description provided for @dashboardSavingsGoalTitle.
  ///
  /// In vi, this message translates to:
  /// **'Mục tiêu tiết kiệm {year}'**
  String dashboardSavingsGoalTitle(String year);

  /// No description provided for @savingsGoalDetailPageTitle.
  ///
  /// In vi, this message translates to:
  /// **'Mục tiêu tiết kiệm'**
  String get savingsGoalDetailPageTitle;

  /// No description provided for @savingsGoalDetailOfTarget.
  ///
  /// In vi, this message translates to:
  /// **'trong tổng mục tiêu {target}'**
  String savingsGoalDetailOfTarget(String target);

  /// No description provided for @savingsGoalDetailPercentComplete.
  ///
  /// In vi, this message translates to:
  /// **'{percent}% hoàn thành'**
  String savingsGoalDetailPercentComplete(String percent);

  /// No description provided for @savingsGoalDetailRemaining.
  ///
  /// In vi, this message translates to:
  /// **'còn {amount}'**
  String savingsGoalDetailRemaining(String amount);

  /// No description provided for @savingsGoalDetailDeadlineLabel.
  ///
  /// In vi, this message translates to:
  /// **'Hạn mục tiêu'**
  String get savingsGoalDetailDeadlineLabel;

  /// No description provided for @savingsGoalDetailAvgPerMonthLabel.
  ///
  /// In vi, this message translates to:
  /// **'TB mỗi tháng'**
  String get savingsGoalDetailAvgPerMonthLabel;

  /// No description provided for @savingsGoalDetailHistoryTitle.
  ///
  /// In vi, this message translates to:
  /// **'Lịch sử đóng góp'**
  String get savingsGoalDetailHistoryTitle;

  /// No description provided for @savingsGoalDetailHistoryCount.
  ///
  /// In vi, this message translates to:
  /// **'{count} lần'**
  String savingsGoalDetailHistoryCount(String count);

  /// No description provided for @savingsGoalDetailContributionMonth.
  ///
  /// In vi, this message translates to:
  /// **'Đóng góp tháng {month}'**
  String savingsGoalDetailContributionMonth(String month);

  /// No description provided for @savingsGoalDetailEmptyMessage.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có lịch sử đóng góp'**
  String get savingsGoalDetailEmptyMessage;

  /// No description provided for @addTransactionSavedExpenseSnackbar.
  ///
  /// In vi, this message translates to:
  /// **'Đã lưu khoản chi'**
  String get addTransactionSavedExpenseSnackbar;

  /// No description provided for @addTransactionSavedIncomeSnackbar.
  ///
  /// In vi, this message translates to:
  /// **'Đã lưu khoản thu'**
  String get addTransactionSavedIncomeSnackbar;

  /// No description provided for @addTransactionPageTitle.
  ///
  /// In vi, this message translates to:
  /// **'Thêm giao dịch'**
  String get addTransactionPageTitle;

  /// No description provided for @addTransactionAmountLabel.
  ///
  /// In vi, this message translates to:
  /// **'Số tiền'**
  String get addTransactionAmountLabel;

  /// No description provided for @addTransactionNoteLabel.
  ///
  /// In vi, this message translates to:
  /// **'Ghi chú'**
  String get addTransactionNoteLabel;

  /// No description provided for @addTransactionNoteHint.
  ///
  /// In vi, this message translates to:
  /// **'Thêm ghi chú (không bắt buộc)'**
  String get addTransactionNoteHint;

  /// No description provided for @addTransactionSaveButton.
  ///
  /// In vi, this message translates to:
  /// **'Lưu giao dịch'**
  String get addTransactionSaveButton;

  /// No description provided for @addTransactionCategoryLabel.
  ///
  /// In vi, this message translates to:
  /// **'Danh mục'**
  String get addTransactionCategoryLabel;

  /// No description provided for @addTransactionIncomeSourceLabel.
  ///
  /// In vi, this message translates to:
  /// **'Nguồn thu'**
  String get addTransactionIncomeSourceLabel;

  /// No description provided for @addTransactionDatePickerTitle.
  ///
  /// In vi, this message translates to:
  /// **'Chọn ngày'**
  String get addTransactionDatePickerTitle;

  /// No description provided for @addTransactionDateLabel.
  ///
  /// In vi, this message translates to:
  /// **'Ngày'**
  String get addTransactionDateLabel;

  /// No description provided for @addTransactionDateTodayLabel.
  ///
  /// In vi, this message translates to:
  /// **'Hôm nay, {date}'**
  String addTransactionDateTodayLabel(String date);

  /// No description provided for @addTransactionTypeExpense.
  ///
  /// In vi, this message translates to:
  /// **'Chi tiêu'**
  String get addTransactionTypeExpense;

  /// No description provided for @addTransactionTypeIncome.
  ///
  /// In vi, this message translates to:
  /// **'Thu nhập'**
  String get addTransactionTypeIncome;

  /// No description provided for @addTransactionCategoryUnselectedLabel.
  ///
  /// In vi, this message translates to:
  /// **'Chưa chọn'**
  String get addTransactionCategoryUnselectedLabel;

  /// No description provided for @addTransactionAddCategoryTile.
  ///
  /// In vi, this message translates to:
  /// **'Thêm'**
  String get addTransactionAddCategoryTile;

  /// No description provided for @addTransactionHintChooseCategory.
  ///
  /// In vi, this message translates to:
  /// **'Chọn danh mục và nhập số tiền để lưu'**
  String get addTransactionHintChooseCategory;

  /// No description provided for @addTransactionHintChooseSource.
  ///
  /// In vi, this message translates to:
  /// **'Chọn nguồn thu và nhập số tiền để lưu'**
  String get addTransactionHintChooseSource;

  /// No description provided for @addTransactionHintEnterAmount.
  ///
  /// In vi, this message translates to:
  /// **'Nhập số tiền để lưu'**
  String get addTransactionHintEnterAmount;

  /// No description provided for @editTransactionPageTitle.
  ///
  /// In vi, this message translates to:
  /// **'Sửa giao dịch'**
  String get editTransactionPageTitle;

  /// No description provided for @editTransactionSaveButton.
  ///
  /// In vi, this message translates to:
  /// **'Cập nhật giao dịch'**
  String get editTransactionSaveButton;

  /// No description provided for @transactionUpdatedSnackbar.
  ///
  /// In vi, this message translates to:
  /// **'Đã cập nhật giao dịch'**
  String get transactionUpdatedSnackbar;

  /// No description provided for @transactionDeletedSnackbar.
  ///
  /// In vi, this message translates to:
  /// **'Đã xóa giao dịch'**
  String get transactionDeletedSnackbar;

  /// No description provided for @transactionDeleteConfirmTitle.
  ///
  /// In vi, this message translates to:
  /// **'Xóa giao dịch?'**
  String get transactionDeleteConfirmTitle;

  /// No description provided for @calendarTotalExpenseLabel.
  ///
  /// In vi, this message translates to:
  /// **'Tổng chi: {amount}'**
  String calendarTotalExpenseLabel(String amount);

  /// No description provided for @calendarLegendHighSpend.
  ///
  /// In vi, this message translates to:
  /// **'Chi nhiều'**
  String get calendarLegendHighSpend;

  /// No description provided for @calendarLegendMidSpend.
  ///
  /// In vi, this message translates to:
  /// **'Trung bình'**
  String get calendarLegendMidSpend;

  /// No description provided for @calendarLegendLowSpend.
  ///
  /// In vi, this message translates to:
  /// **'Chi ít'**
  String get calendarLegendLowSpend;

  /// No description provided for @calendarUpdatedTransactionSnackbar.
  ///
  /// In vi, this message translates to:
  /// **'Đã cập nhật giao dịch'**
  String get calendarUpdatedTransactionSnackbar;

  /// No description provided for @calendarDeleteConfirmTitle.
  ///
  /// In vi, this message translates to:
  /// **'Xóa giao dịch?'**
  String get calendarDeleteConfirmTitle;

  /// No description provided for @calendarDeletedTransactionSnackbar.
  ///
  /// In vi, this message translates to:
  /// **'Đã xóa giao dịch'**
  String get calendarDeletedTransactionSnackbar;

  /// No description provided for @calendarDayTransactionsTitle.
  ///
  /// In vi, this message translates to:
  /// **'Giao dịch ngày {day}/{month}'**
  String calendarDayTransactionsTitle(String day, String month);

  /// No description provided for @calendarDayEmptyMessage.
  ///
  /// In vi, this message translates to:
  /// **'Không có giao dịch ngày này'**
  String get calendarDayEmptyMessage;

  /// No description provided for @calendarDayEmptySubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Thêm một khoản chi cho ngày này'**
  String get calendarDayEmptySubtitle;

  /// No description provided for @calendarDaySheetTitle.
  ///
  /// In vi, this message translates to:
  /// **'Ngày {day}/{month}/{year}'**
  String calendarDaySheetTitle(String day, String month, String year);

  /// No description provided for @calendarDaySheetSummary.
  ///
  /// In vi, this message translates to:
  /// **'{count} giao dịch ·'**
  String calendarDaySheetSummary(String count);

  /// No description provided for @calendarDaySheetEditHint.
  ///
  /// In vi, this message translates to:
  /// **'Chạm để sửa · {count} mục'**
  String calendarDaySheetEditHint(String count);

  /// No description provided for @calendarAvgPerDayLabel.
  ///
  /// In vi, this message translates to:
  /// **'Trung bình/ngày'**
  String get calendarAvgPerDayLabel;

  /// No description provided for @calendarMaxSpendDayLabel.
  ///
  /// In vi, this message translates to:
  /// **'Ngày chi nhiều nhất'**
  String get calendarMaxSpendDayLabel;

  /// No description provided for @calendarMaxSpendDayValue.
  ///
  /// In vi, this message translates to:
  /// **'{day}, {amount}'**
  String calendarMaxSpendDayValue(String day, String amount);

  /// No description provided for @calendarTopSpendingDaysTitle.
  ///
  /// In vi, this message translates to:
  /// **'TOP NGÀY CHI TIÊU'**
  String get calendarTopSpendingDaysTitle;

  /// No description provided for @calendarTopSpendingDayLabel.
  ///
  /// In vi, this message translates to:
  /// **'Ngày {day}/{month}'**
  String calendarTopSpendingDayLabel(String day, String month);

  /// No description provided for @calendarEditAmountLabel.
  ///
  /// In vi, this message translates to:
  /// **'{label} · Sửa số tiền'**
  String calendarEditAmountLabel(String label);

  /// No description provided for @commonSave.
  ///
  /// In vi, this message translates to:
  /// **'Lưu'**
  String get commonSave;

  /// No description provided for @reportsTitle.
  ///
  /// In vi, this message translates to:
  /// **'Báo cáo'**
  String get reportsTitle;

  /// No description provided for @reportsStatTopCategoryLabel.
  ///
  /// In vi, this message translates to:
  /// **'Top danh mục'**
  String get reportsStatTopCategoryLabel;

  /// No description provided for @reportsStatAvgPerDayLabel.
  ///
  /// In vi, this message translates to:
  /// **'TB mỗi ngày'**
  String get reportsStatAvgPerDayLabel;

  /// No description provided for @reportsStatMaxSpendDayLabel.
  ///
  /// In vi, this message translates to:
  /// **'Ngày chi nhiều nhất'**
  String get reportsStatMaxSpendDayLabel;

  /// No description provided for @reportsStatSavingsRateLabel.
  ///
  /// In vi, this message translates to:
  /// **'Tỷ lệ tiết kiệm'**
  String get reportsStatSavingsRateLabel;

  /// No description provided for @reportsPieCardTitle.
  ///
  /// In vi, this message translates to:
  /// **'Theo danh mục'**
  String get reportsPieCardTitle;

  /// No description provided for @reportsChartTitleWeek.
  ///
  /// In vi, this message translates to:
  /// **'Chi tiêu theo ngày'**
  String get reportsChartTitleWeek;

  /// No description provided for @reportsChartTitleMonth.
  ///
  /// In vi, this message translates to:
  /// **'Chi tiêu theo tuần'**
  String get reportsChartTitleMonth;

  /// No description provided for @reportsChartTitleYear.
  ///
  /// In vi, this message translates to:
  /// **'Chi tiêu theo quý'**
  String get reportsChartTitleYear;

  /// No description provided for @reportsComparisonIncomeLabel.
  ///
  /// In vi, this message translates to:
  /// **'Thu nhập'**
  String get reportsComparisonIncomeLabel;

  /// No description provided for @reportsComparisonExpenseLabel.
  ///
  /// In vi, this message translates to:
  /// **'Chi tiêu'**
  String get reportsComparisonExpenseLabel;

  /// No description provided for @reportsComparisonVsPrevious.
  ///
  /// In vi, this message translates to:
  /// **'{delta} so với kỳ trước'**
  String reportsComparisonVsPrevious(String delta);

  /// No description provided for @reportsComparisonNoPreviousData.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có dữ liệu kỳ trước'**
  String get reportsComparisonNoPreviousData;

  /// No description provided for @reportsComparisonUsedPercent.
  ///
  /// In vi, this message translates to:
  /// **'Đã dùng {percent}% thu nhập'**
  String reportsComparisonUsedPercent(String percent);

  /// No description provided for @reportsComparisonSavings.
  ///
  /// In vi, this message translates to:
  /// **'Tiết kiệm {amount}'**
  String reportsComparisonSavings(String amount);

  /// No description provided for @budgetAddSavedSnackbar.
  ///
  /// In vi, this message translates to:
  /// **'Đã lưu ngân sách'**
  String get budgetAddSavedSnackbar;

  /// No description provided for @budgetAddPageTitle.
  ///
  /// In vi, this message translates to:
  /// **'Thêm ngân sách'**
  String get budgetAddPageTitle;

  /// No description provided for @budgetAddCategoryLabel.
  ///
  /// In vi, this message translates to:
  /// **'Danh mục'**
  String get budgetAddCategoryLabel;

  /// No description provided for @budgetAddMonthlyLimitLabel.
  ///
  /// In vi, this message translates to:
  /// **'Hạn mức tháng'**
  String get budgetAddMonthlyLimitLabel;

  /// No description provided for @budgetAddSaveButton.
  ///
  /// In vi, this message translates to:
  /// **'Lưu ngân sách'**
  String get budgetAddSaveButton;

  /// No description provided for @budgetPageTitle.
  ///
  /// In vi, this message translates to:
  /// **'Ngân sách'**
  String get budgetPageTitle;

  /// No description provided for @budgetEmptyMessage.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có ngân sách nào.\nNhấn + để thiết lập ngân sách đầu tiên.'**
  String get budgetEmptyMessage;

  /// No description provided for @budgetSummaryLine.
  ///
  /// In vi, this message translates to:
  /// **'Tổng ngân sách: {totalBudget} · Đã dùng {usedPercent}%'**
  String budgetSummaryLine(String totalBudget, String usedPercent);

  /// No description provided for @budgetItemOfTotal.
  ///
  /// In vi, this message translates to:
  /// **'/ {amount}'**
  String budgetItemOfTotal(String amount);

  /// No description provided for @editBudgetPageTitle.
  ///
  /// In vi, this message translates to:
  /// **'Sửa ngân sách'**
  String get editBudgetPageTitle;

  /// No description provided for @editBudgetUsedLabel.
  ///
  /// In vi, this message translates to:
  /// **'Đã chi {amount}'**
  String editBudgetUsedLabel(String amount);

  /// No description provided for @editBudgetTooLowWarning.
  ///
  /// In vi, this message translates to:
  /// **'Hạn mức thấp hơn số đã chi — danh mục sẽ báo vượt'**
  String get editBudgetTooLowWarning;

  /// No description provided for @editBudgetSaveButton.
  ///
  /// In vi, this message translates to:
  /// **'Cập nhật'**
  String get editBudgetSaveButton;

  /// No description provided for @editBudgetDeleteButton.
  ///
  /// In vi, this message translates to:
  /// **'Xóa ngân sách này'**
  String get editBudgetDeleteButton;

  /// No description provided for @editBudgetUpdatedSnackbar.
  ///
  /// In vi, this message translates to:
  /// **'Đã cập nhật ngân sách'**
  String get editBudgetUpdatedSnackbar;

  /// No description provided for @editBudgetDeletedSnackbar.
  ///
  /// In vi, this message translates to:
  /// **'Đã xóa ngân sách'**
  String get editBudgetDeletedSnackbar;

  /// No description provided for @editBudgetDeleteConfirmTitle.
  ///
  /// In vi, this message translates to:
  /// **'Xóa ngân sách?'**
  String get editBudgetDeleteConfirmTitle;

  /// No description provided for @editBudgetDeleteConfirmDesc.
  ///
  /// In vi, this message translates to:
  /// **'Hành động này không thể hoàn tác. Ngân sách sẽ bị xóa vĩnh viễn.'**
  String get editBudgetDeleteConfirmDesc;

  /// No description provided for @budgetOverLimitBannerTitle.
  ///
  /// In vi, this message translates to:
  /// **'Vượt ngân sách'**
  String get budgetOverLimitBannerTitle;

  /// No description provided for @budgetOverLimitBannerDesc.
  ///
  /// In vi, this message translates to:
  /// **'Một số danh mục đã vượt hạn mức ngân sách tháng này.'**
  String get budgetOverLimitBannerDesc;

  /// No description provided for @recurringTransactionListPageTitle.
  ///
  /// In vi, this message translates to:
  /// **'Giao dịch định kỳ'**
  String get recurringTransactionListPageTitle;

  /// No description provided for @recurringTransactionListDescription.
  ///
  /// In vi, this message translates to:
  /// **'Các khoản chi/thu cố định lặp lại hàng tháng, như tiền nhà hay gói đăng ký.'**
  String get recurringTransactionListDescription;

  /// No description provided for @recurringTransactionEmptyTitle.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có giao dịch định kỳ'**
  String get recurringTransactionEmptyTitle;

  /// No description provided for @recurringTransactionEmptyMessage.
  ///
  /// In vi, this message translates to:
  /// **'Nhấn + để thêm tiền nhà, subscription...'**
  String get recurringTransactionEmptyMessage;

  /// No description provided for @recurringTransactionMonthlyOnDay.
  ///
  /// In vi, this message translates to:
  /// **'{category} · Hàng tháng · ngày {day}'**
  String recurringTransactionMonthlyOnDay(String category, String day);

  /// No description provided for @recurringTransactionStatusActive.
  ///
  /// In vi, this message translates to:
  /// **'Đang hoạt động'**
  String get recurringTransactionStatusActive;

  /// No description provided for @recurringTransactionStatusPaused.
  ///
  /// In vi, this message translates to:
  /// **'Đã tạm dừng'**
  String get recurringTransactionStatusPaused;

  /// No description provided for @recurringTransactionFormAddTitle.
  ///
  /// In vi, this message translates to:
  /// **'Thêm giao dịch định kỳ'**
  String get recurringTransactionFormAddTitle;

  /// No description provided for @recurringTransactionFormEditTitle.
  ///
  /// In vi, this message translates to:
  /// **'Sửa giao dịch định kỳ'**
  String get recurringTransactionFormEditTitle;

  /// No description provided for @recurringTransactionFormLabelField.
  ///
  /// In vi, this message translates to:
  /// **'Tên giao dịch định kỳ'**
  String get recurringTransactionFormLabelField;

  /// No description provided for @recurringTransactionFormLabelHint.
  ///
  /// In vi, this message translates to:
  /// **'VD: Tiền nhà, Netflix...'**
  String get recurringTransactionFormLabelHint;

  /// No description provided for @recurringTransactionFormCategoryLabel.
  ///
  /// In vi, this message translates to:
  /// **'Danh mục'**
  String get recurringTransactionFormCategoryLabel;

  /// No description provided for @recurringTransactionFormAmountLabel.
  ///
  /// In vi, this message translates to:
  /// **'Số tiền'**
  String get recurringTransactionFormAmountLabel;

  /// No description provided for @recurringTransactionFormDayLabel.
  ///
  /// In vi, this message translates to:
  /// **'Lặp lại vào ngày'**
  String get recurringTransactionFormDayLabel;

  /// No description provided for @recurringTransactionFormActiveTitle.
  ///
  /// In vi, this message translates to:
  /// **'Đang hoạt động'**
  String get recurringTransactionFormActiveTitle;

  /// No description provided for @recurringTransactionFormActiveSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Tự động tạo giao dịch mỗi tháng'**
  String get recurringTransactionFormActiveSubtitle;

  /// No description provided for @recurringTransactionFormSaveButton.
  ///
  /// In vi, this message translates to:
  /// **'Lưu'**
  String get recurringTransactionFormSaveButton;

  /// No description provided for @recurringTransactionFormDeleteButton.
  ///
  /// In vi, this message translates to:
  /// **'Xóa giao dịch định kỳ'**
  String get recurringTransactionFormDeleteButton;

  /// No description provided for @recurringTransactionDeleteConfirmTitle.
  ///
  /// In vi, this message translates to:
  /// **'Xóa giao dịch định kỳ?'**
  String get recurringTransactionDeleteConfirmTitle;

  /// No description provided for @recurringTransactionDeleteConfirmDesc.
  ///
  /// In vi, this message translates to:
  /// **'Khoản này sẽ không còn tự động tạo giao dịch mỗi tháng nữa.'**
  String get recurringTransactionDeleteConfirmDesc;

  /// No description provided for @recurringTransactionSavedSnackbar.
  ///
  /// In vi, this message translates to:
  /// **'Đã lưu giao dịch định kỳ'**
  String get recurringTransactionSavedSnackbar;

  /// No description provided for @recurringTransactionDeletedSnackbar.
  ///
  /// In vi, this message translates to:
  /// **'Đã xóa giao dịch định kỳ'**
  String get recurringTransactionDeletedSnackbar;

  /// No description provided for @notificationCenterPageTitle.
  ///
  /// In vi, this message translates to:
  /// **'Thông báo & Nhắc nhở'**
  String get notificationCenterPageTitle;

  /// No description provided for @notificationCenterRecentTitle.
  ///
  /// In vi, this message translates to:
  /// **'Gần đây'**
  String get notificationCenterRecentTitle;

  /// No description provided for @notificationCenterMarkAllRead.
  ///
  /// In vi, this message translates to:
  /// **'Đánh dấu đã đọc'**
  String get notificationCenterMarkAllRead;

  /// No description provided for @notificationCenterEmptyMessage.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có thông báo nào'**
  String get notificationCenterEmptyMessage;

  /// No description provided for @notificationCenterReminderSettingsTitle.
  ///
  /// In vi, this message translates to:
  /// **'Cài đặt nhắc nhở'**
  String get notificationCenterReminderSettingsTitle;

  /// No description provided for @notificationReminderDailyExpenseLabel.
  ///
  /// In vi, this message translates to:
  /// **'Nhắc nhập chi tiêu hàng ngày'**
  String get notificationReminderDailyExpenseLabel;

  /// No description provided for @notificationReminderDailyExpenseDesc.
  ///
  /// In vi, this message translates to:
  /// **'Nhắc bạn ghi lại chi tiêu nếu chưa nhập gì trong ngày.'**
  String get notificationReminderDailyExpenseDesc;

  /// No description provided for @notificationReminderBudgetAlertLabel.
  ///
  /// In vi, this message translates to:
  /// **'Cảnh báo gần vượt ngân sách'**
  String get notificationReminderBudgetAlertLabel;

  /// No description provided for @notificationReminderBudgetAlertDesc.
  ///
  /// In vi, this message translates to:
  /// **'Báo khi một danh mục đã dùng trên 80% hạn mức.'**
  String get notificationReminderBudgetAlertDesc;

  /// No description provided for @notificationReminderRecurringAlertLabel.
  ///
  /// In vi, this message translates to:
  /// **'Nhắc giao dịch định kỳ'**
  String get notificationReminderRecurringAlertLabel;

  /// No description provided for @notificationReminderRecurringAlertDesc.
  ///
  /// In vi, this message translates to:
  /// **'Báo khi hệ thống vừa tự động tạo một giao dịch định kỳ.'**
  String get notificationReminderRecurringAlertDesc;

  /// No description provided for @notificationDailyReminderTimeLabel.
  ///
  /// In vi, this message translates to:
  /// **'Giờ nhắc hàng ngày'**
  String get notificationDailyReminderTimeLabel;

  /// No description provided for @notificationTimeJustNow.
  ///
  /// In vi, this message translates to:
  /// **'Vừa xong'**
  String get notificationTimeJustNow;

  /// No description provided for @notificationTimeMinutesAgo.
  ///
  /// In vi, this message translates to:
  /// **'{minutes} phút trước'**
  String notificationTimeMinutesAgo(String minutes);

  /// No description provided for @notificationTimeHoursAgo.
  ///
  /// In vi, this message translates to:
  /// **'{hours} giờ trước'**
  String notificationTimeHoursAgo(String hours);

  /// No description provided for @notificationTimeYesterday.
  ///
  /// In vi, this message translates to:
  /// **'Hôm qua'**
  String get notificationTimeYesterday;

  /// No description provided for @notificationTimeDaysAgo.
  ///
  /// In vi, this message translates to:
  /// **'{days} ngày trước'**
  String notificationTimeDaysAgo(String days);

  /// No description provided for @savingsGoalFormPageTitle.
  ///
  /// In vi, this message translates to:
  /// **'Thiết lập mục tiêu'**
  String get savingsGoalFormPageTitle;

  /// No description provided for @savingsGoalFormNameLabel.
  ///
  /// In vi, this message translates to:
  /// **'Tên mục tiêu'**
  String get savingsGoalFormNameLabel;

  /// No description provided for @savingsGoalFormNameHint.
  ///
  /// In vi, this message translates to:
  /// **'VD: Mục tiêu tiết kiệm 2026'**
  String get savingsGoalFormNameHint;

  /// No description provided for @savingsGoalFormTargetLabel.
  ///
  /// In vi, this message translates to:
  /// **'Số tiền mục tiêu'**
  String get savingsGoalFormTargetLabel;

  /// No description provided for @savingsGoalFormDeadlineLabel.
  ///
  /// In vi, this message translates to:
  /// **'Hạn hoàn thành'**
  String get savingsGoalFormDeadlineLabel;

  /// No description provided for @savingsGoalFormInitialLabel.
  ///
  /// In vi, this message translates to:
  /// **'Đã tiết kiệm (tuỳ chọn)'**
  String get savingsGoalFormInitialLabel;

  /// No description provided for @savingsGoalFormSaveButton.
  ///
  /// In vi, this message translates to:
  /// **'Lưu mục tiêu'**
  String get savingsGoalFormSaveButton;

  /// No description provided for @savingsGoalFormDeleteButton.
  ///
  /// In vi, this message translates to:
  /// **'Xóa mục tiêu này'**
  String get savingsGoalFormDeleteButton;

  /// No description provided for @savingsGoalFormSavedSnackbar.
  ///
  /// In vi, this message translates to:
  /// **'Đã lưu mục tiêu tiết kiệm'**
  String get savingsGoalFormSavedSnackbar;

  /// No description provided for @savingsGoalFormDeletedSnackbar.
  ///
  /// In vi, this message translates to:
  /// **'Đã xóa mục tiêu tiết kiệm'**
  String get savingsGoalFormDeletedSnackbar;

  /// No description provided for @savingsGoalDeleteConfirmTitle.
  ///
  /// In vi, this message translates to:
  /// **'Xóa mục tiêu tiết kiệm?'**
  String get savingsGoalDeleteConfirmTitle;

  /// No description provided for @savingsGoalDeleteConfirmDesc.
  ///
  /// In vi, this message translates to:
  /// **'Hành động này không thể hoàn tác. Mục tiêu sẽ bị xóa vĩnh viễn.'**
  String get savingsGoalDeleteConfirmDesc;

  /// No description provided for @incomeManagementTitle.
  ///
  /// In vi, this message translates to:
  /// **'Thu nhập'**
  String get incomeManagementTitle;

  /// No description provided for @incomeManagementEmptyMessage.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có khoản thu nào trong tháng này.'**
  String get incomeManagementEmptyMessage;

  /// No description provided for @historyTitle.
  ///
  /// In vi, this message translates to:
  /// **'Lịch sử giao dịch'**
  String get historyTitle;

  /// No description provided for @historyNoResultsMessage.
  ///
  /// In vi, this message translates to:
  /// **'Không tìm thấy giao dịch'**
  String get historyNoResultsMessage;

  /// No description provided for @historyEmptyMessage.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có giao dịch nào'**
  String get historyEmptyMessage;

  /// No description provided for @historyFilterDateRangeLabel.
  ///
  /// In vi, this message translates to:
  /// **'Khoảng thời gian'**
  String get historyFilterDateRangeLabel;

  /// No description provided for @historyFilterFromLabel.
  ///
  /// In vi, this message translates to:
  /// **'Từ ngày'**
  String get historyFilterFromLabel;

  /// No description provided for @historyFilterToLabel.
  ///
  /// In vi, this message translates to:
  /// **'Đến ngày'**
  String get historyFilterToLabel;

  /// No description provided for @historyFilterQuickLabel.
  ///
  /// In vi, this message translates to:
  /// **'Lọc nhanh'**
  String get historyFilterQuickLabel;

  /// No description provided for @historyFilterChipOver500k.
  ///
  /// In vi, this message translates to:
  /// **'Trên 500K'**
  String get historyFilterChipOver500k;

  /// No description provided for @historyFilterChipExpenseOnly.
  ///
  /// In vi, this message translates to:
  /// **'Chỉ chi tiêu'**
  String get historyFilterChipExpenseOnly;

  /// No description provided for @historyFilterChipIncomeOnly.
  ///
  /// In vi, this message translates to:
  /// **'Chỉ thu nhập'**
  String get historyFilterChipIncomeOnly;

  /// No description provided for @historyClearFiltersButton.
  ///
  /// In vi, this message translates to:
  /// **'Xóa bộ lọc'**
  String get historyClearFiltersButton;

  /// No description provided for @historySearchHint.
  ///
  /// In vi, this message translates to:
  /// **'Tìm giao dịch...'**
  String get historySearchHint;

  /// No description provided for @historyFilterCategoryLabel.
  ///
  /// In vi, this message translates to:
  /// **'Danh mục'**
  String get historyFilterCategoryLabel;

  /// No description provided for @historyTabList.
  ///
  /// In vi, this message translates to:
  /// **'Danh sách'**
  String get historyTabList;

  /// No description provided for @historyTabChart.
  ///
  /// In vi, this message translates to:
  /// **'Biểu đồ'**
  String get historyTabChart;

  /// No description provided for @historyChartEmptyMessage.
  ///
  /// In vi, this message translates to:
  /// **'Không có dữ liệu để thống kê'**
  String get historyChartEmptyMessage;

  /// No description provided for @historyChartIncomeLabel.
  ///
  /// In vi, this message translates to:
  /// **'Thu'**
  String get historyChartIncomeLabel;

  /// No description provided for @historyChartExpenseLabel.
  ///
  /// In vi, this message translates to:
  /// **'Chi'**
  String get historyChartExpenseLabel;

  /// No description provided for @historyChartNetLabel.
  ///
  /// In vi, this message translates to:
  /// **'Ròng'**
  String get historyChartNetLabel;

  /// No description provided for @historyChartCategoryCardTitle.
  ///
  /// In vi, this message translates to:
  /// **'Chi tiêu theo danh mục'**
  String get historyChartCategoryCardTitle;

  /// No description provided for @historyChartRecentCardTitle.
  ///
  /// In vi, this message translates to:
  /// **'{count} giao dịch gần nhất'**
  String historyChartRecentCardTitle(String count);

  /// No description provided for @profilePageTitle.
  ///
  /// In vi, this message translates to:
  /// **'Hồ sơ'**
  String get profilePageTitle;

  /// No description provided for @profileDarkModeLabel.
  ///
  /// In vi, this message translates to:
  /// **'Chế độ tối'**
  String get profileDarkModeLabel;

  /// No description provided for @profileNotificationsLabel.
  ///
  /// In vi, this message translates to:
  /// **'Thông báo'**
  String get profileNotificationsLabel;

  /// No description provided for @profileNotificationsValueOn.
  ///
  /// In vi, this message translates to:
  /// **'Bật'**
  String get profileNotificationsValueOn;

  /// No description provided for @profileCurrencyLabel.
  ///
  /// In vi, this message translates to:
  /// **'Đơn vị tiền tệ'**
  String get profileCurrencyLabel;

  /// No description provided for @profileCurrencyValueVnd.
  ///
  /// In vi, this message translates to:
  /// **'VNĐ'**
  String get profileCurrencyValueVnd;

  /// No description provided for @profileLanguageLabel.
  ///
  /// In vi, this message translates to:
  /// **'Ngôn ngữ'**
  String get profileLanguageLabel;

  /// No description provided for @profileLanguageValueVietnamese.
  ///
  /// In vi, this message translates to:
  /// **'Tiếng Việt'**
  String get profileLanguageValueVietnamese;

  /// No description provided for @profileLanguageValueEnglish.
  ///
  /// In vi, this message translates to:
  /// **'English'**
  String get profileLanguageValueEnglish;

  /// No description provided for @profileBudgetLabel.
  ///
  /// In vi, this message translates to:
  /// **'Ngân sách'**
  String get profileBudgetLabel;

  /// No description provided for @profileIncomeManagementLabel.
  ///
  /// In vi, this message translates to:
  /// **'Quản lý thu nhập'**
  String get profileIncomeManagementLabel;

  /// No description provided for @profileRecurringTransactionLabel.
  ///
  /// In vi, this message translates to:
  /// **'Giao dịch định kỳ'**
  String get profileRecurringTransactionLabel;

  /// No description provided for @profileNotificationCenterLabel.
  ///
  /// In vi, this message translates to:
  /// **'Thông báo & Nhắc nhở'**
  String get profileNotificationCenterLabel;

  /// No description provided for @profileCategoryManagementLabel.
  ///
  /// In vi, this message translates to:
  /// **'Danh mục'**
  String get profileCategoryManagementLabel;

  /// No description provided for @profileSettingsLabel.
  ///
  /// In vi, this message translates to:
  /// **'Cài đặt'**
  String get profileSettingsLabel;

  /// No description provided for @profileLogoutButton.
  ///
  /// In vi, this message translates to:
  /// **'Đăng xuất'**
  String get profileLogoutButton;

  /// No description provided for @editProfilePageTitle.
  ///
  /// In vi, this message translates to:
  /// **'Chỉnh sửa hồ sơ'**
  String get editProfilePageTitle;

  /// No description provided for @editProfileAvatarChangeLabel.
  ///
  /// In vi, this message translates to:
  /// **'Đổi ảnh đại diện'**
  String get editProfileAvatarChangeLabel;

  /// No description provided for @editProfileFirstNameLabel.
  ///
  /// In vi, this message translates to:
  /// **'Họ'**
  String get editProfileFirstNameLabel;

  /// No description provided for @editProfileLastNameLabel.
  ///
  /// In vi, this message translates to:
  /// **'Tên'**
  String get editProfileLastNameLabel;

  /// No description provided for @editProfilePhoneLabel.
  ///
  /// In vi, this message translates to:
  /// **'Số điện thoại'**
  String get editProfilePhoneLabel;

  /// No description provided for @editProfilePhoneHint.
  ///
  /// In vi, this message translates to:
  /// **'09xx xxx xxx'**
  String get editProfilePhoneHint;

  /// No description provided for @editProfileEmailLabel.
  ///
  /// In vi, this message translates to:
  /// **'Email'**
  String get editProfileEmailLabel;

  /// No description provided for @editProfileEmailHint.
  ///
  /// In vi, this message translates to:
  /// **'you@email.com'**
  String get editProfileEmailHint;

  /// No description provided for @editProfileAddressLabel.
  ///
  /// In vi, this message translates to:
  /// **'Địa chỉ (không bắt buộc)'**
  String get editProfileAddressLabel;

  /// No description provided for @editProfileAddressHint.
  ///
  /// In vi, this message translates to:
  /// **'Số nhà, đường, quận/huyện, tỉnh/thành'**
  String get editProfileAddressHint;

  /// No description provided for @editProfileSaveButton.
  ///
  /// In vi, this message translates to:
  /// **'Lưu thay đổi'**
  String get editProfileSaveButton;

  /// No description provided for @editProfileUpdatedSnackbar.
  ///
  /// In vi, this message translates to:
  /// **'Đã cập nhật hồ sơ'**
  String get editProfileUpdatedSnackbar;

  /// No description provided for @settingsPageTitle.
  ///
  /// In vi, this message translates to:
  /// **'Cài đặt'**
  String get settingsPageTitle;

  /// No description provided for @settingsSectionGeneral.
  ///
  /// In vi, this message translates to:
  /// **'Chung'**
  String get settingsSectionGeneral;

  /// No description provided for @settingsSectionData.
  ///
  /// In vi, this message translates to:
  /// **'Dữ liệu'**
  String get settingsSectionData;

  /// No description provided for @settingsSectionSupport.
  ///
  /// In vi, this message translates to:
  /// **'Hỗ trợ'**
  String get settingsSectionSupport;

  /// No description provided for @settingsThemeLabel.
  ///
  /// In vi, this message translates to:
  /// **'Giao diện'**
  String get settingsThemeLabel;

  /// No description provided for @settingsThemeValueDark.
  ///
  /// In vi, this message translates to:
  /// **'Tối'**
  String get settingsThemeValueDark;

  /// No description provided for @settingsThemeValueLight.
  ///
  /// In vi, this message translates to:
  /// **'Sáng'**
  String get settingsThemeValueLight;

  /// No description provided for @settingsLanguageLabel.
  ///
  /// In vi, this message translates to:
  /// **'Ngôn ngữ'**
  String get settingsLanguageLabel;

  /// No description provided for @settingsLanguageValueVietnamese.
  ///
  /// In vi, this message translates to:
  /// **'Tiếng Việt'**
  String get settingsLanguageValueVietnamese;

  /// No description provided for @settingsLanguageValueEnglish.
  ///
  /// In vi, this message translates to:
  /// **'English'**
  String get settingsLanguageValueEnglish;

  /// No description provided for @settingsBackupDataLabel.
  ///
  /// In vi, this message translates to:
  /// **'Sao lưu dữ liệu'**
  String get settingsBackupDataLabel;

  /// No description provided for @settingsPrivacyLabel.
  ///
  /// In vi, this message translates to:
  /// **'Quyền riêng tư'**
  String get settingsPrivacyLabel;

  /// No description provided for @settingsAboutAppLabel.
  ///
  /// In vi, this message translates to:
  /// **'Về ứng dụng'**
  String get settingsAboutAppLabel;

  /// No description provided for @settingsFeedbackLabel.
  ///
  /// In vi, this message translates to:
  /// **'Góp ý'**
  String get settingsFeedbackLabel;

  /// No description provided for @settingsTermsLabel.
  ///
  /// In vi, this message translates to:
  /// **'Điều khoản'**
  String get settingsTermsLabel;

  /// No description provided for @settingsFeedbackKitLabel.
  ///
  /// In vi, this message translates to:
  /// **'Feedback Kit'**
  String get settingsFeedbackKitLabel;

  /// No description provided for @feedbackKitPageTitle.
  ///
  /// In vi, this message translates to:
  /// **'Messages & Feedback'**
  String get feedbackKitPageTitle;

  /// No description provided for @feedbackKitPushNotificationSection.
  ///
  /// In vi, this message translates to:
  /// **'Push Notification'**
  String get feedbackKitPushNotificationSection;

  /// No description provided for @feedbackKitPushAppName.
  ///
  /// In vi, this message translates to:
  /// **'Spendly'**
  String get feedbackKitPushAppName;

  /// No description provided for @feedbackKitPushTimestamp.
  ///
  /// In vi, this message translates to:
  /// **'bây giờ'**
  String get feedbackKitPushTimestamp;

  /// No description provided for @feedbackKitPushTitle.
  ///
  /// In vi, this message translates to:
  /// **'Cảnh báo ngân sách'**
  String get feedbackKitPushTitle;

  /// No description provided for @feedbackKitPushBody.
  ///
  /// In vi, this message translates to:
  /// **'Bạn đã dùng 90% ngân sách Ăn uống tháng này.'**
  String get feedbackKitPushBody;

  /// No description provided for @feedbackKitSnackbarSection.
  ///
  /// In vi, this message translates to:
  /// **'Snackbar / Toast'**
  String get feedbackKitSnackbarSection;

  /// No description provided for @feedbackKitSnackbarSuccess.
  ///
  /// In vi, this message translates to:
  /// **'Đã lưu giao dịch thành công'**
  String get feedbackKitSnackbarSuccess;

  /// No description provided for @feedbackKitSnackbarError.
  ///
  /// In vi, this message translates to:
  /// **'Không thể lưu giao dịch. Vui lòng thử lại.'**
  String get feedbackKitSnackbarError;

  /// No description provided for @feedbackKitSnackbarWarning.
  ///
  /// In vi, this message translates to:
  /// **'Bạn đã dùng 90% ngân sách tháng này'**
  String get feedbackKitSnackbarWarning;

  /// No description provided for @feedbackKitSnackbarInfo.
  ///
  /// In vi, this message translates to:
  /// **'Dữ liệu đã được đồng bộ'**
  String get feedbackKitSnackbarInfo;

  /// No description provided for @feedbackKitAlertBannerSection.
  ///
  /// In vi, this message translates to:
  /// **'Alert Banner'**
  String get feedbackKitAlertBannerSection;

  /// No description provided for @feedbackKitAlertBannerSuccessTitle.
  ///
  /// In vi, this message translates to:
  /// **'Thêm ngân sách thành công'**
  String get feedbackKitAlertBannerSuccessTitle;

  /// No description provided for @feedbackKitAlertBannerSuccessDesc.
  ///
  /// In vi, this message translates to:
  /// **'Ngân sách cho Ăn uống đã được tạo.'**
  String get feedbackKitAlertBannerSuccessDesc;

  /// No description provided for @feedbackKitAlertBannerErrorTitle.
  ///
  /// In vi, this message translates to:
  /// **'Vượt ngân sách'**
  String get feedbackKitAlertBannerErrorTitle;

  /// No description provided for @feedbackKitAlertBannerErrorDesc.
  ///
  /// In vi, this message translates to:
  /// **'Bạn đã chi vượt 13% ngân sách Giải trí.'**
  String get feedbackKitAlertBannerErrorDesc;

  /// No description provided for @feedbackKitAlertBannerWarningTitle.
  ///
  /// In vi, this message translates to:
  /// **'Gần đạt hạn mức'**
  String get feedbackKitAlertBannerWarningTitle;

  /// No description provided for @feedbackKitAlertBannerWarningDesc.
  ///
  /// In vi, this message translates to:
  /// **'Đã dùng 90% ngân sách Ăn uống tháng này.'**
  String get feedbackKitAlertBannerWarningDesc;

  /// No description provided for @feedbackKitAlertBannerInfoTitle.
  ///
  /// In vi, this message translates to:
  /// **'Có bản cập nhật mới'**
  String get feedbackKitAlertBannerInfoTitle;

  /// No description provided for @feedbackKitAlertBannerInfoDesc.
  ///
  /// In vi, this message translates to:
  /// **'Cập nhật Spendly 1.1.0 đã sẵn sàng.'**
  String get feedbackKitAlertBannerInfoDesc;

  /// No description provided for @feedbackKitValidationSection.
  ///
  /// In vi, this message translates to:
  /// **'Validation Messages'**
  String get feedbackKitValidationSection;

  /// No description provided for @feedbackKitValidationAmountLabel.
  ///
  /// In vi, this message translates to:
  /// **'Số tiền'**
  String get feedbackKitValidationAmountLabel;

  /// No description provided for @feedbackKitValidationAmountValue.
  ///
  /// In vi, this message translates to:
  /// **'0'**
  String get feedbackKitValidationAmountValue;

  /// No description provided for @feedbackKitValidationAmountError.
  ///
  /// In vi, this message translates to:
  /// **'Số tiền phải lớn hơn 0'**
  String get feedbackKitValidationAmountError;

  /// No description provided for @feedbackKitValidationEmailLabel.
  ///
  /// In vi, this message translates to:
  /// **'Email'**
  String get feedbackKitValidationEmailLabel;

  /// No description provided for @feedbackKitValidationEmailValue.
  ///
  /// In vi, this message translates to:
  /// **'minhanh@email.com'**
  String get feedbackKitValidationEmailValue;

  /// No description provided for @feedbackKitValidationEmailSuccess.
  ///
  /// In vi, this message translates to:
  /// **'Email hợp lệ'**
  String get feedbackKitValidationEmailSuccess;

  /// No description provided for @feedbackKitConfirmDialogSection.
  ///
  /// In vi, this message translates to:
  /// **'Confirmation Dialog'**
  String get feedbackKitConfirmDialogSection;

  /// No description provided for @feedbackKitConfirmDialogDesc.
  ///
  /// In vi, this message translates to:
  /// **'Hành động này không thể hoàn tác. Giao dịch sẽ bị xóa vĩnh viễn.'**
  String get feedbackKitConfirmDialogDesc;

  /// No description provided for @feedbackKitNotificationCenterSection.
  ///
  /// In vi, this message translates to:
  /// **'Notification Center'**
  String get feedbackKitNotificationCenterSection;

  /// No description provided for @feedbackKitNotificationCenterItem1Title.
  ///
  /// In vi, this message translates to:
  /// **'Ngân sách Ăn uống đã đạt 90%'**
  String get feedbackKitNotificationCenterItem1Title;

  /// No description provided for @feedbackKitNotificationCenterItem1Time.
  ///
  /// In vi, this message translates to:
  /// **'2 giờ trước'**
  String get feedbackKitNotificationCenterItem1Time;

  /// No description provided for @feedbackKitNotificationCenterItem2Title.
  ///
  /// In vi, this message translates to:
  /// **'Giao dịch mới: -85.000 ₫ tại Bún chả Hương Liên'**
  String get feedbackKitNotificationCenterItem2Title;

  /// No description provided for @feedbackKitNotificationCenterItem2Time.
  ///
  /// In vi, this message translates to:
  /// **'Hôm nay, 09:12'**
  String get feedbackKitNotificationCenterItem2Time;

  /// No description provided for @feedbackKitNotificationCenterItem3Title.
  ///
  /// In vi, this message translates to:
  /// **'Sao lưu dữ liệu thành công'**
  String get feedbackKitNotificationCenterItem3Title;

  /// No description provided for @feedbackKitNotificationCenterItem3Time.
  ///
  /// In vi, this message translates to:
  /// **'Hôm qua'**
  String get feedbackKitNotificationCenterItem3Time;

  /// No description provided for @feedbackKitButtonStatesSection.
  ///
  /// In vi, this message translates to:
  /// **'Button Feedback States'**
  String get feedbackKitButtonStatesSection;

  /// No description provided for @feedbackKitButtonLoading.
  ///
  /// In vi, this message translates to:
  /// **'Đang lưu...'**
  String get feedbackKitButtonLoading;

  /// No description provided for @feedbackKitButtonSuccess.
  ///
  /// In vi, this message translates to:
  /// **'Đã lưu'**
  String get feedbackKitButtonSuccess;

  /// No description provided for @categoryListPageTitle.
  ///
  /// In vi, this message translates to:
  /// **'Danh mục'**
  String get categoryListPageTitle;

  /// No description provided for @categoryCountLabel.
  ///
  /// In vi, this message translates to:
  /// **'{count} danh mục chi tiêu · chạm để sửa'**
  String categoryCountLabel(int count);

  /// No description provided for @categoryUsageCount.
  ///
  /// In vi, this message translates to:
  /// **'{count} giao dịch tháng này'**
  String categoryUsageCount(int count);

  /// No description provided for @categoryUsageNone.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có giao dịch'**
  String get categoryUsageNone;

  /// No description provided for @categoryAddNewButton.
  ///
  /// In vi, this message translates to:
  /// **'Thêm danh mục mới'**
  String get categoryAddNewButton;

  /// No description provided for @categoryListEmptyMessage.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có danh mục nào.\nNhấn \"Thêm danh mục mới\" để tạo danh mục đầu tiên.'**
  String get categoryListEmptyMessage;

  /// No description provided for @categoryEditPageTitleCreate.
  ///
  /// In vi, this message translates to:
  /// **'Thêm danh mục'**
  String get categoryEditPageTitleCreate;

  /// No description provided for @categoryEditPageTitleEdit.
  ///
  /// In vi, this message translates to:
  /// **'Sửa danh mục'**
  String get categoryEditPageTitleEdit;

  /// No description provided for @categoryPreviewLabel.
  ///
  /// In vi, this message translates to:
  /// **'Xem trước'**
  String get categoryPreviewLabel;

  /// No description provided for @categoryPreviewPlaceholder.
  ///
  /// In vi, this message translates to:
  /// **'Danh mục mới'**
  String get categoryPreviewPlaceholder;

  /// No description provided for @categoryNameLabel.
  ///
  /// In vi, this message translates to:
  /// **'Tên danh mục'**
  String get categoryNameLabel;

  /// No description provided for @categoryNameHint.
  ///
  /// In vi, this message translates to:
  /// **'Ví dụ: Cà phê'**
  String get categoryNameHint;

  /// No description provided for @categoryNameDuplicateError.
  ///
  /// In vi, this message translates to:
  /// **'Tên danh mục này đã tồn tại'**
  String get categoryNameDuplicateError;

  /// No description provided for @categoryColorLabel.
  ///
  /// In vi, this message translates to:
  /// **'Màu nhận diện'**
  String get categoryColorLabel;

  /// No description provided for @categoryIconLabel.
  ///
  /// In vi, this message translates to:
  /// **'Biểu tượng'**
  String get categoryIconLabel;

  /// No description provided for @categoryIconCountLabel.
  ///
  /// In vi, this message translates to:
  /// **'{count} biểu tượng'**
  String categoryIconCountLabel(int count);

  /// No description provided for @categoryIconGroupFood.
  ///
  /// In vi, this message translates to:
  /// **'Ăn uống'**
  String get categoryIconGroupFood;

  /// No description provided for @categoryIconGroupShopping.
  ///
  /// In vi, this message translates to:
  /// **'Mua sắm'**
  String get categoryIconGroupShopping;

  /// No description provided for @categoryIconGroupTransport.
  ///
  /// In vi, this message translates to:
  /// **'Di chuyển'**
  String get categoryIconGroupTransport;

  /// No description provided for @categoryIconGroupHome.
  ///
  /// In vi, this message translates to:
  /// **'Sinh hoạt'**
  String get categoryIconGroupHome;

  /// No description provided for @categoryIconGroupOther.
  ///
  /// In vi, this message translates to:
  /// **'Khác'**
  String get categoryIconGroupOther;

  /// No description provided for @categorySaveButtonCreate.
  ///
  /// In vi, this message translates to:
  /// **'Tạo danh mục'**
  String get categorySaveButtonCreate;

  /// No description provided for @categorySaveButtonUpdate.
  ///
  /// In vi, this message translates to:
  /// **'Cập nhật'**
  String get categorySaveButtonUpdate;

  /// No description provided for @categoryDeleteButton.
  ///
  /// In vi, this message translates to:
  /// **'Xóa danh mục này'**
  String get categoryDeleteButton;

  /// No description provided for @categoryDeleteConfirmTitle.
  ///
  /// In vi, this message translates to:
  /// **'Xóa danh mục?'**
  String get categoryDeleteConfirmTitle;

  /// No description provided for @categoryDeleteConfirmDesc.
  ///
  /// In vi, this message translates to:
  /// **'Hành động này không thể hoàn tác. Danh mục sẽ bị xóa vĩnh viễn.'**
  String get categoryDeleteConfirmDesc;

  /// No description provided for @categoryCreatedSnackbar.
  ///
  /// In vi, this message translates to:
  /// **'Đã thêm danh mục mới'**
  String get categoryCreatedSnackbar;

  /// No description provided for @categoryUpdatedSnackbar.
  ///
  /// In vi, this message translates to:
  /// **'Đã cập nhật danh mục'**
  String get categoryUpdatedSnackbar;

  /// No description provided for @categoryDeletedSnackbar.
  ///
  /// In vi, this message translates to:
  /// **'Đã xóa danh mục'**
  String get categoryDeletedSnackbar;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'vi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'vi':
      return AppLocalizationsVi();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
