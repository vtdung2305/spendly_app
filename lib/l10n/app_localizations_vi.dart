// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get commonCancel => 'Hủy';

  @override
  String get commonDelete => 'Xóa';

  @override
  String get commonRetry => 'Thử lại';

  @override
  String get weekdayMon => 'T2';

  @override
  String get weekdayTue => 'T3';

  @override
  String get weekdayWed => 'T4';

  @override
  String get weekdayThu => 'T5';

  @override
  String get weekdayFri => 'T6';

  @override
  String get weekdaySat => 'T7';

  @override
  String get weekdaySun => 'CN';

  @override
  String get historyGroupWeekdayMon => 'Thứ 2';

  @override
  String get historyGroupWeekdayTue => 'Thứ 3';

  @override
  String get historyGroupWeekdayWed => 'Thứ 4';

  @override
  String get historyGroupWeekdayThu => 'Thứ 5';

  @override
  String get historyGroupWeekdayFri => 'Thứ 6';

  @override
  String get historyGroupWeekdaySat => 'Thứ 7';

  @override
  String get historyGroupWeekdaySun => 'Chủ Nhật';

  @override
  String get categoryFood => 'Ăn uống';

  @override
  String get categoryShopping => 'Shopping';

  @override
  String get categoryTransport => 'Đi lại';

  @override
  String get categoryEntertainment => 'Giải trí';

  @override
  String get categoryFamily => 'Gia đình';

  @override
  String get categoryOther => 'Khác';

  @override
  String get categoryHealth => 'Y tế';

  @override
  String get categoryTravel => 'Du lịch';

  @override
  String get categoryPets => 'Thú cưng';

  @override
  String get incomeSourceSalary => 'Lương';

  @override
  String get incomeSourceFreelance => 'Freelance';

  @override
  String get incomeSourceBonus => 'Bonus';

  @override
  String get reportPeriodWeek => 'Tuần';

  @override
  String get reportPeriodMonth => 'Tháng';

  @override
  String get reportPeriodYear => 'Năm';

  @override
  String get navHomeTab => 'Trang chủ';

  @override
  String get navCalendarTab => 'Lịch';

  @override
  String get navBudgetTab => 'Ngân sách';

  @override
  String get navReportsTab => 'Báo cáo';

  @override
  String get navProfileTab => 'Cá nhân';

  @override
  String percentValue(String percent) {
    return '$percent%';
  }

  @override
  String monthYearHeader(String month, String year) {
    return 'Tháng $month, $year';
  }

  @override
  String get splashAppName => 'Spendly';

  @override
  String get splashTagline => 'Quản lý chi tiêu thông minh';

  @override
  String get splashServerErrorMessage =>
      'Không thể kết nối máy chủ. Vui lòng thử lại.';

  @override
  String get splashOfflineMessage =>
      'Mất kết nối mạng. Kiểm tra Wi-Fi hoặc dữ liệu di động.';

  @override
  String get onboardingSkipButton => 'Bỏ qua';

  @override
  String get onboardingContinueButton => 'Tiếp tục';

  @override
  String get onboardingStartButton => 'Bắt đầu ngay';

  @override
  String get onboardingSlide1Title => 'Theo dõi mọi khoản chi';

  @override
  String get onboardingSlide1Desc =>
      'Ghi lại thu nhập và chi tiêu chỉ trong vài giây, mọi lúc mọi nơi.';

  @override
  String get onboardingSlide2Title => 'Thấu hiểu dòng tiền';

  @override
  String get onboardingSlide2Desc =>
      'Biểu đồ trực quan giúp bạn biết tiền đi đâu, về đâu mỗi tháng.';

  @override
  String get onboardingSlide3Title => 'Đạt mục tiêu tiết kiệm';

  @override
  String get onboardingSlide3Desc =>
      'Đặt ngân sách, theo dõi tiến độ và tiết kiệm nhiều hơn mỗi ngày.';

  @override
  String get loginFeatureInDevelopmentSnackbar =>
      'Tính năng đang được phát triển';

  @override
  String get loginTitle => 'Chào bạn trở lại';

  @override
  String get loginSubtitle => 'Đăng nhập để tiếp tục quản lý chi tiêu';

  @override
  String get loginEmailLabel => 'Email';

  @override
  String get loginEmailHint => 'you@email.com';

  @override
  String get loginPasswordLabel => 'Mật khẩu';

  @override
  String get loginPasswordHint => 'Mật khẩu';

  @override
  String get loginForgotPasswordLink => 'Quên mật khẩu?';

  @override
  String get loginSubmitButton => 'Đăng nhập';

  @override
  String get loginOrDivider => 'hoặc';

  @override
  String get loginContinueWithGoogleButton => 'Tiếp tục với Google';

  @override
  String get loginContinueWithFacebookButton => 'Đăng nhập với Facebook';

  @override
  String get loginNoAccountPrefix => 'Chưa có tài khoản? ';

  @override
  String get loginRegisterLink => 'Đăng ký';

  @override
  String get registerTitle => 'Tạo tài khoản';

  @override
  String get registerSubtitle => 'Bắt đầu quản lý tài chính của bạn';

  @override
  String get registerEmailLabel => 'Email';

  @override
  String get registerEmailHint => 'you@email.com';

  @override
  String get registerPasswordLabel => 'Mật khẩu';

  @override
  String get registerPasswordHint => 'Mật khẩu';

  @override
  String get registerConfirmPasswordLabel => 'Xác nhận mật khẩu';

  @override
  String get registerConfirmPasswordHint => 'Xác nhận mật khẩu';

  @override
  String get registerSubmitButton => 'Đăng ký';

  @override
  String get registerHasAccountPrefix => 'Đã có tài khoản? ';

  @override
  String get registerLoginLink => 'Đăng nhập';

  @override
  String get forgotPasswordSuccessSnackbar =>
      'Đã gửi liên kết đặt lại mật khẩu';

  @override
  String get forgotPasswordTitle => 'Quên mật khẩu?';

  @override
  String get forgotPasswordSubtitle =>
      'Nhập email để nhận liên kết đặt lại mật khẩu';

  @override
  String get forgotPasswordEmailLabel => 'Email';

  @override
  String get forgotPasswordEmailHint => 'you@email.com';

  @override
  String get forgotPasswordSubmitButton => 'Gửi liên kết đặt lại';

  @override
  String get forgotPasswordRememberedPrefix => 'Đã nhớ mật khẩu? ';

  @override
  String get forgotPasswordLoginLink => 'Đăng nhập';

  @override
  String get verifyOtpTitle => 'Xác thực email';

  @override
  String get verifyOtpSubtitle => 'Chúng tôi đã gửi mã 6 số đến';

  @override
  String get verifyOtpCodeInvalidError =>
      'Mã xác thực không đúng hoặc đã hết hạn';

  @override
  String get verifyOtpTooManyAttemptsError =>
      'Bạn đã nhập sai quá nhiều lần. Vui lòng gửi lại mã mới.';

  @override
  String verifyOtpExpiresInLabel(String time) {
    return 'Mã hết hạn sau $time';
  }

  @override
  String get verifyOtpSubmitButton => 'Xác thực';

  @override
  String get verifyOtpResendPrompt => 'Không nhận được mã?';

  @override
  String get verifyOtpResendLink => 'Gửi lại';

  @override
  String get verifyOtpChangeEmailLink => 'Đổi email khác';

  @override
  String get verifyOtpResentSnackbar => 'Đã gửi lại mã xác thực';

  @override
  String get verifyOtpVerifiedSnackbar => 'Xác thực thành công';

  @override
  String get authInvalidEmail => 'Email không hợp lệ';

  @override
  String get authPasswordTooShort => 'Mật khẩu phải có ít nhất 6 ký tự';

  @override
  String get authPasswordMismatch => 'Mật khẩu xác nhận không khớp';

  @override
  String get authSignInFailed => 'Đăng nhập thất bại, vui lòng thử lại';

  @override
  String get authGoogleSignInUnsupported =>
      'Đăng nhập Google chưa được hỗ trợ trong phiên bản này';

  @override
  String get authRegisterFailed => 'Đăng ký thất bại, vui lòng thử lại';

  @override
  String get authConfirmEmailRequired =>
      'Vui lòng kiểm tra email để xác nhận tài khoản, sau đó đăng nhập lại. (Hoặc tắt \"Confirm email\" trong Supabase Auth settings để bỏ qua bước này.)';

  @override
  String get dashboardEmptyMessage =>
      'Chưa có giao dịch nào.\nNhấn nút + để thêm giao dịch đầu tiên.';

  @override
  String get dashboardGreeting => 'Xin chào 👋';

  @override
  String get dashboardBudgetCardTitle => 'Ngân sách tháng';

  @override
  String dashboardBudgetUsedSummary(String percent, String remaining) {
    return 'Đã dùng $percent% · còn $remaining';
  }

  @override
  String get dashboardDailySpendTitle => 'Chi tiêu theo ngày';

  @override
  String get dashboardRecentTransactionsTitle => 'Giao dịch gần đây';

  @override
  String get dashboardSeeAllButton => 'Xem tất cả';

  @override
  String get dashboardSavingsCardTitle => 'TIẾT KIỆM THÁNG NÀY';

  @override
  String get dashboardIncomeLabel => 'Thu nhập';

  @override
  String get dashboardExpenseLabel => 'Chi tiêu';

  @override
  String get dashboardCategoryPieTitle => 'Chi tiêu theo danh mục';

  @override
  String get dashboardCategoryPieCenterLabel => 'tổng chi';

  @override
  String get dashboardOverBudgetSubtitle => 'Xem lại hạn mức cho danh mục này';

  @override
  String dashboardOverBudgetText(String category, String percent) {
    return '$category đã vượt ngân sách $percent%';
  }

  @override
  String get dashboardQuickActionExpense => 'Ghi chi';

  @override
  String get dashboardQuickActionIncome => 'Ghi thu';

  @override
  String get dashboardQuickActionHistory => 'Lịch sử';

  @override
  String dashboardSavingsGoalTitle(String year) {
    return 'Mục tiêu tiết kiệm $year';
  }

  @override
  String get savingsGoalDetailPageTitle => 'Mục tiêu tiết kiệm';

  @override
  String savingsGoalDetailOfTarget(String target) {
    return 'trong tổng mục tiêu $target';
  }

  @override
  String savingsGoalDetailPercentComplete(String percent) {
    return '$percent% hoàn thành';
  }

  @override
  String savingsGoalDetailRemaining(String amount) {
    return 'còn $amount';
  }

  @override
  String get savingsGoalDetailDeadlineLabel => 'Hạn mục tiêu';

  @override
  String get savingsGoalDetailAvgPerMonthLabel => 'TB mỗi tháng';

  @override
  String get savingsGoalDetailHistoryTitle => 'Lịch sử đóng góp';

  @override
  String savingsGoalDetailHistoryCount(String count) {
    return '$count lần';
  }

  @override
  String savingsGoalDetailContributionMonth(String month) {
    return 'Đóng góp tháng $month';
  }

  @override
  String get savingsGoalDetailEmptyMessage => 'Chưa có lịch sử đóng góp';

  @override
  String get addTransactionSavedExpenseSnackbar => 'Đã lưu khoản chi';

  @override
  String get addTransactionSavedIncomeSnackbar => 'Đã lưu khoản thu';

  @override
  String get addTransactionPageTitle => 'Thêm giao dịch';

  @override
  String get addTransactionAmountLabel => 'Số tiền';

  @override
  String get addTransactionNoteLabel => 'Ghi chú';

  @override
  String get addTransactionNoteHint => 'Thêm ghi chú (không bắt buộc)';

  @override
  String get addTransactionSaveButton => 'Lưu giao dịch';

  @override
  String get addTransactionCategoryLabel => 'Danh mục';

  @override
  String get addTransactionIncomeSourceLabel => 'Nguồn thu';

  @override
  String get addTransactionDatePickerTitle => 'Chọn ngày';

  @override
  String get addTransactionDateLabel => 'Ngày';

  @override
  String addTransactionDateTodayLabel(String date) {
    return 'Hôm nay, $date';
  }

  @override
  String get addTransactionTypeExpense => 'Chi tiêu';

  @override
  String get addTransactionTypeIncome => 'Thu nhập';

  @override
  String get addTransactionCategoryUnselectedLabel => 'Chưa chọn';

  @override
  String get addTransactionAddCategoryTile => 'Thêm';

  @override
  String get addTransactionHintChooseCategory =>
      'Chọn danh mục và nhập số tiền để lưu';

  @override
  String get addTransactionHintChooseSource =>
      'Chọn nguồn thu và nhập số tiền để lưu';

  @override
  String get addTransactionHintEnterAmount => 'Nhập số tiền để lưu';

  @override
  String get editTransactionPageTitle => 'Sửa giao dịch';

  @override
  String get editTransactionSaveButton => 'Cập nhật giao dịch';

  @override
  String get transactionUpdatedSnackbar => 'Đã cập nhật giao dịch';

  @override
  String get transactionDeletedSnackbar => 'Đã xóa giao dịch';

  @override
  String get transactionDeleteConfirmTitle => 'Xóa giao dịch?';

  @override
  String calendarTotalExpenseLabel(String amount) {
    return 'Tổng chi: $amount';
  }

  @override
  String get calendarLegendHighSpend => 'Chi nhiều';

  @override
  String get calendarLegendMidSpend => 'Trung bình';

  @override
  String get calendarLegendLowSpend => 'Chi ít';

  @override
  String get calendarUpdatedTransactionSnackbar => 'Đã cập nhật giao dịch';

  @override
  String get calendarDeleteConfirmTitle => 'Xóa giao dịch?';

  @override
  String get calendarDeletedTransactionSnackbar => 'Đã xóa giao dịch';

  @override
  String calendarDayTransactionsTitle(String day, String month) {
    return 'Giao dịch ngày $day/$month';
  }

  @override
  String get calendarDayEmptyMessage => 'Không có giao dịch ngày này';

  @override
  String get calendarDayEmptySubtitle => 'Thêm một khoản chi cho ngày này';

  @override
  String calendarDaySheetTitle(String day, String month, String year) {
    return 'Ngày $day/$month/$year';
  }

  @override
  String calendarDaySheetSummary(String count) {
    return '$count giao dịch ·';
  }

  @override
  String calendarDaySheetEditHint(String count) {
    return 'Chạm để sửa · $count mục';
  }

  @override
  String get calendarAvgPerDayLabel => 'Trung bình/ngày';

  @override
  String get calendarMaxSpendDayLabel => 'Ngày chi nhiều nhất';

  @override
  String calendarMaxSpendDayValue(String day, String amount) {
    return '$day, $amount';
  }

  @override
  String get calendarTopSpendingDaysTitle => 'TOP NGÀY CHI TIÊU';

  @override
  String calendarTopSpendingDayLabel(String day, String month) {
    return 'Ngày $day/$month';
  }

  @override
  String calendarEditAmountLabel(String label) {
    return '$label · Sửa số tiền';
  }

  @override
  String get commonSave => 'Lưu';

  @override
  String get reportsTitle => 'Báo cáo';

  @override
  String get reportsStatTopCategoryLabel => 'Top danh mục';

  @override
  String get reportsStatAvgPerDayLabel => 'TB mỗi ngày';

  @override
  String get reportsStatMaxSpendDayLabel => 'Ngày chi nhiều nhất';

  @override
  String get reportsStatSavingsRateLabel => 'Tỷ lệ tiết kiệm';

  @override
  String get reportsPieCardTitle => 'Theo danh mục';

  @override
  String get reportsChartTitleWeek => 'Chi tiêu theo ngày';

  @override
  String get reportsChartTitleMonth => 'Chi tiêu theo tuần';

  @override
  String get reportsChartTitleYear => 'Chi tiêu theo quý';

  @override
  String get reportsComparisonIncomeLabel => 'Thu nhập';

  @override
  String get reportsComparisonExpenseLabel => 'Chi tiêu';

  @override
  String reportsComparisonVsPrevious(String delta) {
    return '$delta so với kỳ trước';
  }

  @override
  String get reportsComparisonNoPreviousData => 'Chưa có dữ liệu kỳ trước';

  @override
  String reportsComparisonUsedPercent(String percent) {
    return 'Đã dùng $percent% thu nhập';
  }

  @override
  String reportsComparisonSavings(String amount) {
    return 'Tiết kiệm $amount';
  }

  @override
  String get budgetAddSavedSnackbar => 'Đã lưu ngân sách';

  @override
  String get budgetAddPageTitle => 'Thêm ngân sách';

  @override
  String get budgetAddCategoryLabel => 'Danh mục';

  @override
  String get budgetAddMonthlyLimitLabel => 'Hạn mức tháng';

  @override
  String get budgetAddSaveButton => 'Lưu ngân sách';

  @override
  String get budgetPageTitle => 'Ngân sách';

  @override
  String get budgetEmptyMessage =>
      'Chưa có ngân sách nào.\nNhấn + để thiết lập ngân sách đầu tiên.';

  @override
  String budgetSummaryLine(String totalBudget, String usedPercent) {
    return 'Tổng ngân sách: $totalBudget · Đã dùng $usedPercent%';
  }

  @override
  String budgetItemOfTotal(String amount) {
    return '/ $amount';
  }

  @override
  String get editBudgetPageTitle => 'Sửa ngân sách';

  @override
  String editBudgetUsedLabel(String amount) {
    return 'Đã chi $amount';
  }

  @override
  String get editBudgetTooLowWarning =>
      'Hạn mức thấp hơn số đã chi — danh mục sẽ báo vượt';

  @override
  String get editBudgetSaveButton => 'Cập nhật';

  @override
  String get editBudgetDeleteButton => 'Xóa ngân sách này';

  @override
  String get editBudgetUpdatedSnackbar => 'Đã cập nhật ngân sách';

  @override
  String get editBudgetDeletedSnackbar => 'Đã xóa ngân sách';

  @override
  String get editBudgetDeleteConfirmTitle => 'Xóa ngân sách?';

  @override
  String get editBudgetDeleteConfirmDesc =>
      'Hành động này không thể hoàn tác. Ngân sách sẽ bị xóa vĩnh viễn.';

  @override
  String get budgetOverLimitBannerTitle => 'Vượt ngân sách';

  @override
  String get budgetOverLimitBannerDesc =>
      'Một số danh mục đã vượt hạn mức ngân sách tháng này.';

  @override
  String get recurringTransactionListPageTitle => 'Giao dịch định kỳ';

  @override
  String get recurringTransactionListDescription =>
      'Các khoản chi/thu cố định lặp lại hàng tháng, như tiền nhà hay gói đăng ký.';

  @override
  String get recurringTransactionEmptyTitle => 'Chưa có giao dịch định kỳ';

  @override
  String get recurringTransactionEmptyMessage =>
      'Nhấn + để thêm tiền nhà, subscription...';

  @override
  String recurringTransactionMonthlyOnDay(String category, String day) {
    return '$category · Hàng tháng · ngày $day';
  }

  @override
  String get recurringTransactionStatusActive => 'Đang hoạt động';

  @override
  String get recurringTransactionStatusPaused => 'Đã tạm dừng';

  @override
  String get recurringTransactionFormAddTitle => 'Thêm giao dịch định kỳ';

  @override
  String get recurringTransactionFormEditTitle => 'Sửa giao dịch định kỳ';

  @override
  String get recurringTransactionFormLabelField => 'Tên giao dịch định kỳ';

  @override
  String get recurringTransactionFormLabelHint => 'VD: Tiền nhà, Netflix...';

  @override
  String get recurringTransactionFormCategoryLabel => 'Danh mục';

  @override
  String get recurringTransactionFormAmountLabel => 'Số tiền';

  @override
  String get recurringTransactionFormDayLabel => 'Lặp lại vào ngày';

  @override
  String get recurringTransactionFormActiveTitle => 'Đang hoạt động';

  @override
  String get recurringTransactionFormActiveSubtitle =>
      'Tự động tạo giao dịch mỗi tháng';

  @override
  String get recurringTransactionFormSaveButton => 'Lưu';

  @override
  String get recurringTransactionFormDeleteButton => 'Xóa giao dịch định kỳ';

  @override
  String get recurringTransactionDeleteConfirmTitle => 'Xóa giao dịch định kỳ?';

  @override
  String get recurringTransactionDeleteConfirmDesc =>
      'Khoản này sẽ không còn tự động tạo giao dịch mỗi tháng nữa.';

  @override
  String get recurringTransactionSavedSnackbar => 'Đã lưu giao dịch định kỳ';

  @override
  String get recurringTransactionDeletedSnackbar => 'Đã xóa giao dịch định kỳ';

  @override
  String get notificationCenterPageTitle => 'Thông báo & Nhắc nhở';

  @override
  String get notificationCenterRecentTitle => 'Gần đây';

  @override
  String get notificationCenterMarkAllRead => 'Đánh dấu đã đọc';

  @override
  String get notificationCenterEmptyMessage => 'Chưa có thông báo nào';

  @override
  String get notificationCenterReminderSettingsTitle => 'Cài đặt nhắc nhở';

  @override
  String get notificationReminderDailyExpenseLabel =>
      'Nhắc nhập chi tiêu hàng ngày';

  @override
  String get notificationReminderDailyExpenseDesc =>
      'Nhắc bạn ghi lại chi tiêu nếu chưa nhập gì trong ngày.';

  @override
  String get notificationReminderBudgetAlertLabel =>
      'Cảnh báo gần vượt ngân sách';

  @override
  String get notificationReminderBudgetAlertDesc =>
      'Báo khi một danh mục đã dùng trên 80% hạn mức.';

  @override
  String get notificationReminderRecurringAlertLabel =>
      'Nhắc giao dịch định kỳ';

  @override
  String get notificationReminderRecurringAlertDesc =>
      'Báo khi hệ thống vừa tự động tạo một giao dịch định kỳ.';

  @override
  String get notificationDailyReminderTimeLabel => 'Giờ nhắc hàng ngày';

  @override
  String get notificationTimeJustNow => 'Vừa xong';

  @override
  String notificationTimeMinutesAgo(String minutes) {
    return '$minutes phút trước';
  }

  @override
  String notificationTimeHoursAgo(String hours) {
    return '$hours giờ trước';
  }

  @override
  String get notificationTimeYesterday => 'Hôm qua';

  @override
  String notificationTimeDaysAgo(String days) {
    return '$days ngày trước';
  }

  @override
  String get savingsGoalFormPageTitle => 'Thiết lập mục tiêu';

  @override
  String get savingsGoalFormNameLabel => 'Tên mục tiêu';

  @override
  String get savingsGoalFormNameHint => 'VD: Mục tiêu tiết kiệm 2026';

  @override
  String get savingsGoalFormTargetLabel => 'Số tiền mục tiêu';

  @override
  String get savingsGoalFormDeadlineLabel => 'Hạn hoàn thành';

  @override
  String get savingsGoalFormInitialLabel => 'Đã tiết kiệm (tuỳ chọn)';

  @override
  String get savingsGoalFormSaveButton => 'Lưu mục tiêu';

  @override
  String get savingsGoalFormDeleteButton => 'Xóa mục tiêu này';

  @override
  String get savingsGoalFormSavedSnackbar => 'Đã lưu mục tiêu tiết kiệm';

  @override
  String get savingsGoalFormDeletedSnackbar => 'Đã xóa mục tiêu tiết kiệm';

  @override
  String get savingsGoalDeleteConfirmTitle => 'Xóa mục tiêu tiết kiệm?';

  @override
  String get savingsGoalDeleteConfirmDesc =>
      'Hành động này không thể hoàn tác. Mục tiêu sẽ bị xóa vĩnh viễn.';

  @override
  String get incomeManagementTitle => 'Thu nhập';

  @override
  String get incomeManagementEmptyMessage =>
      'Chưa có khoản thu nào trong tháng này.';

  @override
  String get historyTitle => 'Lịch sử giao dịch';

  @override
  String get historyNoResultsMessage => 'Không tìm thấy giao dịch';

  @override
  String get historyEmptyMessage => 'Chưa có giao dịch nào';

  @override
  String get historyFilterDateRangeLabel => 'Khoảng thời gian';

  @override
  String get historyFilterFromLabel => 'Từ ngày';

  @override
  String get historyFilterToLabel => 'Đến ngày';

  @override
  String get historyFilterQuickLabel => 'Lọc nhanh';

  @override
  String get historyFilterChipOver500k => 'Trên 500K';

  @override
  String get historyFilterChipExpenseOnly => 'Chỉ chi tiêu';

  @override
  String get historyFilterChipIncomeOnly => 'Chỉ thu nhập';

  @override
  String get historyClearFiltersButton => 'Xóa bộ lọc';

  @override
  String get historySearchHint => 'Tìm giao dịch...';

  @override
  String get historyFilterCategoryLabel => 'Danh mục';

  @override
  String get historyTabList => 'Danh sách';

  @override
  String get historyTabChart => 'Biểu đồ';

  @override
  String get historyChartEmptyMessage => 'Không có dữ liệu để thống kê';

  @override
  String get historyChartIncomeLabel => 'Thu';

  @override
  String get historyChartExpenseLabel => 'Chi';

  @override
  String get historyChartNetLabel => 'Ròng';

  @override
  String get historyChartCategoryCardTitle => 'Chi tiêu theo danh mục';

  @override
  String historyChartRecentCardTitle(String count) {
    return '$count giao dịch gần nhất';
  }

  @override
  String get profilePageTitle => 'Hồ sơ';

  @override
  String get profileDarkModeLabel => 'Chế độ tối';

  @override
  String get profileNotificationsLabel => 'Thông báo';

  @override
  String get profileNotificationsValueOn => 'Bật';

  @override
  String get profileCurrencyLabel => 'Đơn vị tiền tệ';

  @override
  String get profileCurrencyValueVnd => 'VNĐ';

  @override
  String get profileLanguageLabel => 'Ngôn ngữ';

  @override
  String get profileLanguageValueVietnamese => 'Tiếng Việt';

  @override
  String get profileLanguageValueEnglish => 'English';

  @override
  String get profileBudgetLabel => 'Ngân sách';

  @override
  String get profileIncomeManagementLabel => 'Quản lý thu nhập';

  @override
  String get profileRecurringTransactionLabel => 'Giao dịch định kỳ';

  @override
  String get profileNotificationCenterLabel => 'Thông báo & Nhắc nhở';

  @override
  String get profileCategoryManagementLabel => 'Danh mục';

  @override
  String get profileSettingsLabel => 'Cài đặt';

  @override
  String get profileLogoutButton => 'Đăng xuất';

  @override
  String get editProfilePageTitle => 'Chỉnh sửa hồ sơ';

  @override
  String get editProfileAvatarChangeLabel => 'Đổi ảnh đại diện';

  @override
  String get editProfileFirstNameLabel => 'Họ';

  @override
  String get editProfileLastNameLabel => 'Tên';

  @override
  String get editProfilePhoneLabel => 'Số điện thoại';

  @override
  String get editProfilePhoneHint => '09xx xxx xxx';

  @override
  String get editProfileEmailLabel => 'Email';

  @override
  String get editProfileEmailHint => 'you@email.com';

  @override
  String get editProfileAddressLabel => 'Địa chỉ (không bắt buộc)';

  @override
  String get editProfileAddressHint => 'Số nhà, đường, quận/huyện, tỉnh/thành';

  @override
  String get editProfileSaveButton => 'Lưu thay đổi';

  @override
  String get editProfileUpdatedSnackbar => 'Đã cập nhật hồ sơ';

  @override
  String get settingsPageTitle => 'Cài đặt';

  @override
  String get settingsSectionGeneral => 'Chung';

  @override
  String get settingsSectionData => 'Dữ liệu';

  @override
  String get settingsSectionSupport => 'Hỗ trợ';

  @override
  String get settingsThemeLabel => 'Giao diện';

  @override
  String get settingsThemeValueDark => 'Tối';

  @override
  String get settingsThemeValueLight => 'Sáng';

  @override
  String get settingsLanguageLabel => 'Ngôn ngữ';

  @override
  String get settingsLanguageValueVietnamese => 'Tiếng Việt';

  @override
  String get settingsLanguageValueEnglish => 'English';

  @override
  String get settingsBackupDataLabel => 'Sao lưu dữ liệu';

  @override
  String get settingsPrivacyLabel => 'Quyền riêng tư';

  @override
  String get settingsAboutAppLabel => 'Về ứng dụng';

  @override
  String get settingsFeedbackLabel => 'Góp ý';

  @override
  String get settingsTermsLabel => 'Điều khoản';

  @override
  String get settingsFeedbackKitLabel => 'Feedback Kit';

  @override
  String get feedbackKitPageTitle => 'Messages & Feedback';

  @override
  String get feedbackKitPushNotificationSection => 'Push Notification';

  @override
  String get feedbackKitPushAppName => 'Spendly';

  @override
  String get feedbackKitPushTimestamp => 'bây giờ';

  @override
  String get feedbackKitPushTitle => 'Cảnh báo ngân sách';

  @override
  String get feedbackKitPushBody =>
      'Bạn đã dùng 90% ngân sách Ăn uống tháng này.';

  @override
  String get feedbackKitSnackbarSection => 'Snackbar / Toast';

  @override
  String get feedbackKitSnackbarSuccess => 'Đã lưu giao dịch thành công';

  @override
  String get feedbackKitSnackbarError =>
      'Không thể lưu giao dịch. Vui lòng thử lại.';

  @override
  String get feedbackKitSnackbarWarning =>
      'Bạn đã dùng 90% ngân sách tháng này';

  @override
  String get feedbackKitSnackbarInfo => 'Dữ liệu đã được đồng bộ';

  @override
  String get feedbackKitAlertBannerSection => 'Alert Banner';

  @override
  String get feedbackKitAlertBannerSuccessTitle => 'Thêm ngân sách thành công';

  @override
  String get feedbackKitAlertBannerSuccessDesc =>
      'Ngân sách cho Ăn uống đã được tạo.';

  @override
  String get feedbackKitAlertBannerErrorTitle => 'Vượt ngân sách';

  @override
  String get feedbackKitAlertBannerErrorDesc =>
      'Bạn đã chi vượt 13% ngân sách Giải trí.';

  @override
  String get feedbackKitAlertBannerWarningTitle => 'Gần đạt hạn mức';

  @override
  String get feedbackKitAlertBannerWarningDesc =>
      'Đã dùng 90% ngân sách Ăn uống tháng này.';

  @override
  String get feedbackKitAlertBannerInfoTitle => 'Có bản cập nhật mới';

  @override
  String get feedbackKitAlertBannerInfoDesc =>
      'Cập nhật Spendly 1.1.0 đã sẵn sàng.';

  @override
  String get feedbackKitValidationSection => 'Validation Messages';

  @override
  String get feedbackKitValidationAmountLabel => 'Số tiền';

  @override
  String get feedbackKitValidationAmountValue => '0';

  @override
  String get feedbackKitValidationAmountError => 'Số tiền phải lớn hơn 0';

  @override
  String get feedbackKitValidationEmailLabel => 'Email';

  @override
  String get feedbackKitValidationEmailValue => 'minhanh@email.com';

  @override
  String get feedbackKitValidationEmailSuccess => 'Email hợp lệ';

  @override
  String get feedbackKitConfirmDialogSection => 'Confirmation Dialog';

  @override
  String get feedbackKitConfirmDialogDesc =>
      'Hành động này không thể hoàn tác. Giao dịch sẽ bị xóa vĩnh viễn.';

  @override
  String get feedbackKitNotificationCenterSection => 'Notification Center';

  @override
  String get feedbackKitNotificationCenterItem1Title =>
      'Ngân sách Ăn uống đã đạt 90%';

  @override
  String get feedbackKitNotificationCenterItem1Time => '2 giờ trước';

  @override
  String get feedbackKitNotificationCenterItem2Title =>
      'Giao dịch mới: -85.000 ₫ tại Bún chả Hương Liên';

  @override
  String get feedbackKitNotificationCenterItem2Time => 'Hôm nay, 09:12';

  @override
  String get feedbackKitNotificationCenterItem3Title =>
      'Sao lưu dữ liệu thành công';

  @override
  String get feedbackKitNotificationCenterItem3Time => 'Hôm qua';

  @override
  String get feedbackKitButtonStatesSection => 'Button Feedback States';

  @override
  String get feedbackKitButtonLoading => 'Đang lưu...';

  @override
  String get feedbackKitButtonSuccess => 'Đã lưu';

  @override
  String get categoryListPageTitle => 'Danh mục';

  @override
  String categoryCountLabel(int count) {
    return '$count danh mục chi tiêu · chạm để sửa';
  }

  @override
  String categoryUsageCount(int count) {
    return '$count giao dịch tháng này';
  }

  @override
  String get categoryUsageNone => 'Chưa có giao dịch';

  @override
  String get categoryAddNewButton => 'Thêm danh mục mới';

  @override
  String get categoryListEmptyMessage =>
      'Chưa có danh mục nào.\nNhấn \"Thêm danh mục mới\" để tạo danh mục đầu tiên.';

  @override
  String get categoryEditPageTitleCreate => 'Thêm danh mục';

  @override
  String get categoryEditPageTitleEdit => 'Sửa danh mục';

  @override
  String get categoryPreviewLabel => 'Xem trước';

  @override
  String get categoryPreviewPlaceholder => 'Danh mục mới';

  @override
  String get categoryNameLabel => 'Tên danh mục';

  @override
  String get categoryNameHint => 'Ví dụ: Cà phê';

  @override
  String get categoryNameDuplicateError => 'Tên danh mục này đã tồn tại';

  @override
  String get categoryColorLabel => 'Màu nhận diện';

  @override
  String get categoryIconLabel => 'Biểu tượng';

  @override
  String categoryIconCountLabel(int count) {
    return '$count biểu tượng';
  }

  @override
  String get categoryIconGroupFood => 'Ăn uống';

  @override
  String get categoryIconGroupShopping => 'Mua sắm';

  @override
  String get categoryIconGroupTransport => 'Di chuyển';

  @override
  String get categoryIconGroupHome => 'Sinh hoạt';

  @override
  String get categoryIconGroupOther => 'Khác';

  @override
  String get categorySaveButtonCreate => 'Tạo danh mục';

  @override
  String get categorySaveButtonUpdate => 'Cập nhật';

  @override
  String get categoryDeleteButton => 'Xóa danh mục này';

  @override
  String get categoryDeleteConfirmTitle => 'Xóa danh mục?';

  @override
  String get categoryDeleteConfirmDesc =>
      'Hành động này không thể hoàn tác. Danh mục sẽ bị xóa vĩnh viễn.';

  @override
  String get categoryCreatedSnackbar => 'Đã thêm danh mục mới';

  @override
  String get categoryUpdatedSnackbar => 'Đã cập nhật danh mục';

  @override
  String get categoryDeletedSnackbar => 'Đã xóa danh mục';
}
