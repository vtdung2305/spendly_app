// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get commonCancel => 'Cancel';

  @override
  String get commonDelete => 'Delete';

  @override
  String get commonRetry => 'Retry';

  @override
  String get weekdayMon => 'Mon';

  @override
  String get weekdayTue => 'Tue';

  @override
  String get weekdayWed => 'Wed';

  @override
  String get weekdayThu => 'Thu';

  @override
  String get weekdayFri => 'Fri';

  @override
  String get weekdaySat => 'Sat';

  @override
  String get weekdaySun => 'Sun';

  @override
  String get categoryFood => 'Food & Drink';

  @override
  String get categoryShopping => 'Shopping';

  @override
  String get categoryTransport => 'Transport';

  @override
  String get categoryEntertainment => 'Entertainment';

  @override
  String get categoryFamily => 'Family';

  @override
  String get categoryOther => 'Other';

  @override
  String get categoryHealth => 'Health';

  @override
  String get categoryTravel => 'Travel';

  @override
  String get categoryPets => 'Pets';

  @override
  String get incomeSourceSalary => 'Salary';

  @override
  String get incomeSourceFreelance => 'Freelance';

  @override
  String get incomeSourceBonus => 'Bonus';

  @override
  String get reportPeriodWeek => 'Week';

  @override
  String get reportPeriodMonth => 'Month';

  @override
  String get reportPeriodYear => 'Year';

  @override
  String get navHomeTab => 'Home';

  @override
  String get navCalendarTab => 'Calendar';

  @override
  String get navBudgetTab => 'Budget';

  @override
  String get navReportsTab => 'Reports';

  @override
  String get navProfileTab => 'Profile';

  @override
  String percentValue(String percent) {
    return '$percent%';
  }

  @override
  String monthYearHeader(String month, String year) {
    return 'Month $month, $year';
  }

  @override
  String get splashAppName => 'Spendly';

  @override
  String get splashTagline => 'Smart expense management';

  @override
  String get splashServerErrorMessage =>
      'Unable to connect to the server. Please try again.';

  @override
  String get splashOfflineMessage =>
      'No network connection. Check your Wi-Fi or mobile data.';

  @override
  String get loginFeatureInDevelopmentSnackbar =>
      'This feature is under development';

  @override
  String get loginTitle => 'Welcome back';

  @override
  String get loginSubtitle => 'Sign in to continue managing your expenses';

  @override
  String get loginEmailLabel => 'Email';

  @override
  String get loginEmailHint => 'you@email.com';

  @override
  String get loginPasswordLabel => 'Password';

  @override
  String get loginPasswordHint => 'Password';

  @override
  String get loginForgotPasswordLink => 'Forgot password?';

  @override
  String get loginSubmitButton => 'Log in';

  @override
  String get loginOrDivider => 'or';

  @override
  String get loginContinueWithGoogleButton => 'Continue with Google';

  @override
  String get loginContinueWithFacebookButton => 'Log in with Facebook';

  @override
  String get loginNoAccountPrefix => 'Don\'t have an account? ';

  @override
  String get loginRegisterLink => 'Sign up';

  @override
  String get registerTitle => 'Create account';

  @override
  String get registerSubtitle => 'Start managing your finances';

  @override
  String get registerEmailLabel => 'Email';

  @override
  String get registerEmailHint => 'you@email.com';

  @override
  String get registerPasswordLabel => 'Password';

  @override
  String get registerPasswordHint => 'Password';

  @override
  String get registerConfirmPasswordLabel => 'Confirm password';

  @override
  String get registerConfirmPasswordHint => 'Confirm password';

  @override
  String get registerSubmitButton => 'Sign up';

  @override
  String get registerHasAccountPrefix => 'Already have an account? ';

  @override
  String get registerLoginLink => 'Log in';

  @override
  String get forgotPasswordSuccessSnackbar => 'Password reset link sent';

  @override
  String get forgotPasswordTitle => 'Forgot password?';

  @override
  String get forgotPasswordSubtitle =>
      'Enter your email to receive a password reset link';

  @override
  String get forgotPasswordEmailLabel => 'Email';

  @override
  String get forgotPasswordEmailHint => 'you@email.com';

  @override
  String get forgotPasswordSubmitButton => 'Send reset link';

  @override
  String get forgotPasswordRememberedPrefix => 'Remembered your password? ';

  @override
  String get forgotPasswordLoginLink => 'Log in';

  @override
  String get verifyOtpTitle => 'Verify email';

  @override
  String get verifyOtpSubtitle => 'We sent a 6-digit code to';

  @override
  String get verifyOtpCodeInvalidError => 'Incorrect or expired code';

  @override
  String get verifyOtpTooManyAttemptsError =>
      'Too many incorrect attempts. Please request a new code.';

  @override
  String verifyOtpExpiresInLabel(String time) {
    return 'Code expires in $time';
  }

  @override
  String get verifyOtpSubmitButton => 'Verify';

  @override
  String get verifyOtpResendPrompt => 'Didn\'t receive a code?';

  @override
  String get verifyOtpResendLink => 'Resend';

  @override
  String get verifyOtpChangeEmailLink => 'Use a different email';

  @override
  String get verifyOtpResentSnackbar => 'A new code has been sent';

  @override
  String get verifyOtpVerifiedSnackbar => 'Verified successfully';

  @override
  String get authInvalidEmail => 'Invalid email';

  @override
  String get authPasswordTooShort => 'Password must be at least 6 characters';

  @override
  String get authPasswordMismatch => 'Confirmation password does not match';

  @override
  String get authSignInFailed => 'Sign in failed, please try again';

  @override
  String get authGoogleSignInUnsupported =>
      'Google sign in is not supported in this version';

  @override
  String get authRegisterFailed => 'Registration failed, please try again';

  @override
  String get authConfirmEmailRequired =>
      'Please check your email to confirm your account, then log in again. (Or disable \"Confirm email\" in Supabase Auth settings to skip this step.)';

  @override
  String get dashboardEmptyMessage =>
      'No transactions yet.\nTap the + button to add your first one.';

  @override
  String get dashboardGreeting => 'Hello 👋';

  @override
  String get dashboardBudgetCardTitle => 'Monthly budget';

  @override
  String dashboardBudgetUsedSummary(String percent, String remaining) {
    return 'Used $percent% · $remaining left';
  }

  @override
  String get dashboardDailySpendTitle => 'Daily spending';

  @override
  String get dashboardRecentTransactionsTitle => 'Recent transactions';

  @override
  String get dashboardSeeAllButton => 'See all';

  @override
  String get dashboardSavingsCardTitle => 'SAVINGS THIS MONTH';

  @override
  String get dashboardIncomeLabel => 'Income';

  @override
  String get dashboardExpenseLabel => 'Expense';

  @override
  String get dashboardCategoryPieTitle => 'Spending by category';

  @override
  String get dashboardCategoryPieCenterLabel => 'total spent';

  @override
  String get dashboardOverBudgetSubtitle =>
      'Review the limit for this category';

  @override
  String dashboardOverBudgetText(String category, String percent) {
    return '$category is over budget by $percent%';
  }

  @override
  String get dashboardQuickActionExpense => 'Add expense';

  @override
  String get dashboardQuickActionIncome => 'Add income';

  @override
  String get dashboardQuickActionHistory => 'History';

  @override
  String dashboardSavingsGoalTitle(String year) {
    return 'Savings goal $year';
  }

  @override
  String get savingsGoalDetailPageTitle => 'Savings goal';

  @override
  String savingsGoalDetailOfTarget(String target) {
    return 'of the $target target';
  }

  @override
  String savingsGoalDetailPercentComplete(String percent) {
    return '$percent% complete';
  }

  @override
  String savingsGoalDetailRemaining(String amount) {
    return '$amount left';
  }

  @override
  String get savingsGoalDetailDeadlineLabel => 'Target date';

  @override
  String get savingsGoalDetailAvgPerMonthLabel => 'Avg per month';

  @override
  String get savingsGoalDetailHistoryTitle => 'Contribution history';

  @override
  String savingsGoalDetailHistoryCount(String count) {
    return '$count entries';
  }

  @override
  String savingsGoalDetailContributionMonth(String month) {
    return 'Contribution for month $month';
  }

  @override
  String get savingsGoalDetailEmptyMessage => 'No contribution history yet';

  @override
  String get addTransactionSavedExpenseSnackbar => 'Expense saved';

  @override
  String get addTransactionSavedIncomeSnackbar => 'Income saved';

  @override
  String get addTransactionPageTitle => 'Add transaction';

  @override
  String get addTransactionAmountLabel => 'Amount';

  @override
  String get addTransactionNoteLabel => 'Note';

  @override
  String get addTransactionNoteHint => 'Add a note (optional)';

  @override
  String get addTransactionSaveButton => 'Save transaction';

  @override
  String get addTransactionCategoryLabel => 'Category';

  @override
  String get addTransactionIncomeSourceLabel => 'Income source';

  @override
  String get addTransactionDatePickerTitle => 'Select date';

  @override
  String get addTransactionDateLabel => 'Date';

  @override
  String addTransactionDateTodayLabel(String date) {
    return 'Today, $date';
  }

  @override
  String get addTransactionTypeExpense => 'Expense';

  @override
  String get addTransactionTypeIncome => 'Income';

  @override
  String get addTransactionCategoryUnselectedLabel => 'Not selected';

  @override
  String get addTransactionAddCategoryTile => 'Add';

  @override
  String get addTransactionHintChooseCategory =>
      'Choose a category and enter an amount to save';

  @override
  String get addTransactionHintChooseSource =>
      'Choose an income source and enter an amount to save';

  @override
  String get addTransactionHintEnterAmount => 'Enter an amount to save';

  @override
  String get editTransactionPageTitle => 'Edit transaction';

  @override
  String get editTransactionSaveButton => 'Update transaction';

  @override
  String get transactionUpdatedSnackbar => 'Transaction updated';

  @override
  String get transactionDeletedSnackbar => 'Transaction deleted';

  @override
  String get transactionDeleteConfirmTitle => 'Delete transaction?';

  @override
  String calendarTotalExpenseLabel(String amount) {
    return 'Total spent: $amount';
  }

  @override
  String get calendarLegendHighSpend => 'High spend';

  @override
  String get calendarLegendMidSpend => 'Average';

  @override
  String get calendarLegendLowSpend => 'Low spend';

  @override
  String get calendarUpdatedTransactionSnackbar => 'Transaction updated';

  @override
  String get calendarDeleteConfirmTitle => 'Delete transaction?';

  @override
  String get calendarDeletedTransactionSnackbar => 'Transaction deleted';

  @override
  String calendarDayTransactionsTitle(String day, String month) {
    return 'Transactions on $day/$month';
  }

  @override
  String get calendarDayEmptyMessage => 'No transactions on this day';

  @override
  String get calendarDayEmptySubtitle => 'Add an expense for this day';

  @override
  String calendarDaySheetTitle(String day, String month, String year) {
    return '$day/$month/$year';
  }

  @override
  String calendarDaySheetSummary(String count) {
    return '$count transactions ·';
  }

  @override
  String calendarDaySheetEditHint(String count) {
    return 'Tap to edit · $count items';
  }

  @override
  String get calendarAvgPerDayLabel => 'Average/day';

  @override
  String get calendarMaxSpendDayLabel => 'Highest spend day';

  @override
  String calendarMaxSpendDayValue(String day, String amount) {
    return '$day, $amount';
  }

  @override
  String get calendarTopSpendingDaysTitle => 'TOP SPENDING DAYS';

  @override
  String calendarTopSpendingDayLabel(String day, String month) {
    return 'Day $day/$month';
  }

  @override
  String calendarEditAmountLabel(String label) {
    return '$label · Edit amount';
  }

  @override
  String get commonSave => 'Save';

  @override
  String get reportsTitle => 'Reports';

  @override
  String get reportsStatTopCategoryLabel => 'Top category';

  @override
  String get reportsStatAvgPerDayLabel => 'Avg per day';

  @override
  String get reportsStatMaxSpendDayLabel => 'Highest spending day';

  @override
  String get reportsStatSavingsRateLabel => 'Savings rate';

  @override
  String get reportsPieCardTitle => 'By category';

  @override
  String get reportsChartTitleWeek => 'Spending by day';

  @override
  String get reportsChartTitleMonth => 'Spending by week';

  @override
  String get reportsChartTitleYear => 'Spending by quarter';

  @override
  String get reportsComparisonIncomeLabel => 'Income';

  @override
  String get reportsComparisonExpenseLabel => 'Expense';

  @override
  String reportsComparisonVsPrevious(String delta) {
    return '$delta vs previous period';
  }

  @override
  String get reportsComparisonNoPreviousData =>
      'No data for the previous period';

  @override
  String reportsComparisonUsedPercent(String percent) {
    return '$percent% of income used';
  }

  @override
  String reportsComparisonSavings(String amount) {
    return 'Saved $amount';
  }

  @override
  String get budgetAddSavedSnackbar => 'Budget saved';

  @override
  String get budgetAddPageTitle => 'Add budget';

  @override
  String get budgetAddCategoryLabel => 'Category';

  @override
  String get budgetAddMonthlyLimitLabel => 'Monthly limit';

  @override
  String get budgetAddSaveButton => 'Save budget';

  @override
  String get budgetPageTitle => 'Budget';

  @override
  String get budgetEmptyMessage =>
      'No budgets yet.\nTap + to set up your first budget.';

  @override
  String budgetSummaryLine(String totalBudget, String usedPercent) {
    return 'Total budget: $totalBudget · Used $usedPercent%';
  }

  @override
  String budgetItemOfTotal(String amount) {
    return '/ $amount';
  }

  @override
  String get editBudgetPageTitle => 'Edit budget';

  @override
  String editBudgetUsedLabel(String amount) {
    return 'Spent $amount';
  }

  @override
  String get editBudgetTooLowWarning =>
      'Limit is lower than the amount spent — this category will show as over budget';

  @override
  String get editBudgetSaveButton => 'Update';

  @override
  String get editBudgetDeleteButton => 'Delete this budget';

  @override
  String get editBudgetUpdatedSnackbar => 'Budget updated';

  @override
  String get editBudgetDeletedSnackbar => 'Budget deleted';

  @override
  String get editBudgetDeleteConfirmTitle => 'Delete budget?';

  @override
  String get editBudgetDeleteConfirmDesc =>
      'This action can\'t be undone. The budget will be permanently deleted.';

  @override
  String get budgetOverLimitBannerTitle => 'Over budget';

  @override
  String get budgetOverLimitBannerDesc =>
      'Some categories have exceeded this month\'s budget limit.';

  @override
  String get recurringTransactionListPageTitle => 'Recurring transactions';

  @override
  String get recurringTransactionListDescription =>
      'Fixed monthly charges or deposits, like rent or a subscription.';

  @override
  String get recurringTransactionEmptyTitle => 'No recurring transactions yet';

  @override
  String get recurringTransactionEmptyMessage =>
      'Tap + to add rent, a subscription...';

  @override
  String recurringTransactionMonthlyOnDay(String category, String day) {
    return '$category · Monthly · day $day';
  }

  @override
  String get recurringTransactionStatusActive => 'Active';

  @override
  String get recurringTransactionStatusPaused => 'Paused';

  @override
  String get recurringTransactionFormAddTitle => 'Add recurring transaction';

  @override
  String get recurringTransactionFormEditTitle => 'Edit recurring transaction';

  @override
  String get recurringTransactionFormLabelField => 'Recurring transaction name';

  @override
  String get recurringTransactionFormLabelHint => 'e.g. Rent, Netflix...';

  @override
  String get recurringTransactionFormCategoryLabel => 'Category';

  @override
  String get recurringTransactionFormAmountLabel => 'Amount';

  @override
  String get recurringTransactionFormDayLabel => 'Repeats on day';

  @override
  String get recurringTransactionFormActiveTitle => 'Active';

  @override
  String get recurringTransactionFormActiveSubtitle =>
      'Automatically creates a transaction every month';

  @override
  String get recurringTransactionFormSaveButton => 'Save';

  @override
  String get recurringTransactionFormDeleteButton =>
      'Delete recurring transaction';

  @override
  String get recurringTransactionDeleteConfirmTitle =>
      'Delete recurring transaction?';

  @override
  String get recurringTransactionDeleteConfirmDesc =>
      'This will stop automatically creating a transaction every month.';

  @override
  String get recurringTransactionSavedSnackbar => 'Recurring transaction saved';

  @override
  String get recurringTransactionDeletedSnackbar =>
      'Recurring transaction deleted';

  @override
  String get notificationCenterPageTitle => 'Notifications & Reminders';

  @override
  String get notificationCenterRecentTitle => 'Recent';

  @override
  String get notificationCenterMarkAllRead => 'Mark all read';

  @override
  String get notificationCenterEmptyMessage => 'No notifications yet';

  @override
  String get notificationCenterReminderSettingsTitle => 'Reminder settings';

  @override
  String get notificationReminderDailyExpenseLabel => 'Daily expense reminder';

  @override
  String get notificationReminderDailyExpenseDesc =>
      'Reminds you to log an expense if you haven\'t entered anything today.';

  @override
  String get notificationReminderBudgetAlertLabel => 'Near-budget alert';

  @override
  String get notificationReminderBudgetAlertDesc =>
      'Alerts you when a category has used over 80% of its limit.';

  @override
  String get notificationReminderRecurringAlertLabel =>
      'Recurring transaction alert';

  @override
  String get notificationReminderRecurringAlertDesc =>
      'Alerts you when a recurring transaction was just auto-generated.';

  @override
  String get notificationDailyReminderTimeLabel => 'Daily reminder time';

  @override
  String get notificationTimeJustNow => 'Just now';

  @override
  String notificationTimeMinutesAgo(String minutes) {
    return '${minutes}m ago';
  }

  @override
  String notificationTimeHoursAgo(String hours) {
    return '${hours}h ago';
  }

  @override
  String get notificationTimeYesterday => 'Yesterday';

  @override
  String notificationTimeDaysAgo(String days) {
    return '${days}d ago';
  }

  @override
  String get savingsGoalFormPageTitle => 'Set up goal';

  @override
  String get savingsGoalFormNameLabel => 'Goal name';

  @override
  String get savingsGoalFormNameHint => 'e.g. Savings goal 2026';

  @override
  String get savingsGoalFormTargetLabel => 'Target amount';

  @override
  String get savingsGoalFormDeadlineLabel => 'Target date';

  @override
  String get savingsGoalFormInitialLabel => 'Already saved (optional)';

  @override
  String get savingsGoalFormSaveButton => 'Save goal';

  @override
  String get savingsGoalFormDeleteButton => 'Delete this goal';

  @override
  String get savingsGoalFormSavedSnackbar => 'Savings goal saved';

  @override
  String get savingsGoalFormDeletedSnackbar => 'Savings goal deleted';

  @override
  String get savingsGoalDeleteConfirmTitle => 'Delete savings goal?';

  @override
  String get savingsGoalDeleteConfirmDesc =>
      'This action can\'t be undone. The goal will be permanently deleted.';

  @override
  String get incomeManagementTitle => 'Income';

  @override
  String get incomeManagementEmptyMessage => 'No income entries this month.';

  @override
  String get historyTitle => 'Transaction history';

  @override
  String get historyNoResultsMessage => 'No transactions found';

  @override
  String get historyEmptyMessage => 'No transactions yet';

  @override
  String get historyFilterDateRangeLabel => 'Date range';

  @override
  String get historyFilterFromLabel => 'From date';

  @override
  String get historyFilterToLabel => 'To date';

  @override
  String get historyFilterQuickLabel => 'Quick filters';

  @override
  String get historyFilterChipOver500k => 'Over 500K';

  @override
  String get historyFilterChipExpenseOnly => 'Expenses only';

  @override
  String get historyFilterChipIncomeOnly => 'Income only';

  @override
  String get historyClearFiltersButton => 'Clear filters';

  @override
  String get historySearchHint => 'Search transactions...';

  @override
  String get profilePageTitle => 'Profile';

  @override
  String get profileDarkModeLabel => 'Dark mode';

  @override
  String get profileNotificationsLabel => 'Notifications';

  @override
  String get profileNotificationsValueOn => 'On';

  @override
  String get profileCurrencyLabel => 'Currency';

  @override
  String get profileCurrencyValueVnd => 'VND';

  @override
  String get profileLanguageLabel => 'Language';

  @override
  String get profileLanguageValueVietnamese => 'Tiếng Việt';

  @override
  String get profileLanguageValueEnglish => 'English';

  @override
  String get profileBudgetLabel => 'Budget';

  @override
  String get profileIncomeManagementLabel => 'Manage income';

  @override
  String get profileRecurringTransactionLabel => 'Recurring transactions';

  @override
  String get profileNotificationCenterLabel => 'Notifications & Reminders';

  @override
  String get profileCategoryManagementLabel => 'Categories';

  @override
  String get profileSettingsLabel => 'Settings';

  @override
  String get profileLogoutButton => 'Log out';

  @override
  String get editProfilePageTitle => 'Edit Profile';

  @override
  String get editProfileAvatarChangeLabel => 'Change avatar';

  @override
  String get editProfileFirstNameLabel => 'First name';

  @override
  String get editProfileLastNameLabel => 'Last name';

  @override
  String get editProfilePhoneLabel => 'Phone number';

  @override
  String get editProfilePhoneHint => '09xx xxx xxx';

  @override
  String get editProfileEmailLabel => 'Email';

  @override
  String get editProfileEmailHint => 'you@email.com';

  @override
  String get editProfileAddressLabel => 'Address (optional)';

  @override
  String get editProfileAddressHint => 'House no., street, district, city';

  @override
  String get editProfileSaveButton => 'Save changes';

  @override
  String get editProfileUpdatedSnackbar => 'Profile updated';

  @override
  String get settingsPageTitle => 'Settings';

  @override
  String get settingsSectionGeneral => 'General';

  @override
  String get settingsSectionData => 'Data';

  @override
  String get settingsSectionSupport => 'Support';

  @override
  String get settingsThemeLabel => 'Theme';

  @override
  String get settingsThemeValueDark => 'Dark';

  @override
  String get settingsThemeValueLight => 'Light';

  @override
  String get settingsLanguageLabel => 'Language';

  @override
  String get settingsLanguageValueVietnamese => 'Tiếng Việt';

  @override
  String get settingsLanguageValueEnglish => 'English';

  @override
  String get settingsBackupDataLabel => 'Back up data';

  @override
  String get settingsPrivacyLabel => 'Privacy';

  @override
  String get settingsAboutAppLabel => 'About the app';

  @override
  String get settingsFeedbackLabel => 'Feedback';

  @override
  String get settingsTermsLabel => 'Terms';

  @override
  String get settingsFeedbackKitLabel => 'Feedback Kit';

  @override
  String get feedbackKitPageTitle => 'Messages & Feedback';

  @override
  String get feedbackKitPushNotificationSection => 'Push Notification';

  @override
  String get feedbackKitPushAppName => 'Spendly';

  @override
  String get feedbackKitPushTimestamp => 'now';

  @override
  String get feedbackKitPushTitle => 'Budget alert';

  @override
  String get feedbackKitPushBody =>
      'You\'ve used 90% of this month\'s Food & Drink budget.';

  @override
  String get feedbackKitSnackbarSection => 'Snackbar / Toast';

  @override
  String get feedbackKitSnackbarSuccess => 'Transaction saved successfully';

  @override
  String get feedbackKitSnackbarError =>
      'Couldn\'t save the transaction. Please try again.';

  @override
  String get feedbackKitSnackbarWarning =>
      'You\'ve used 90% of this month\'s budget';

  @override
  String get feedbackKitSnackbarInfo => 'Data has been synced';

  @override
  String get feedbackKitAlertBannerSection => 'Alert Banner';

  @override
  String get feedbackKitAlertBannerSuccessTitle => 'Budget added successfully';

  @override
  String get feedbackKitAlertBannerSuccessDesc =>
      'Budget for Food & Drink has been created.';

  @override
  String get feedbackKitAlertBannerErrorTitle => 'Over budget';

  @override
  String get feedbackKitAlertBannerErrorDesc =>
      'You\'ve overspent your Entertainment budget by 13%.';

  @override
  String get feedbackKitAlertBannerWarningTitle => 'Nearing your limit';

  @override
  String get feedbackKitAlertBannerWarningDesc =>
      'You\'ve used 90% of this month\'s Food & Drink budget.';

  @override
  String get feedbackKitAlertBannerInfoTitle => 'New update available';

  @override
  String get feedbackKitAlertBannerInfoDesc => 'Spendly 1.1.0 update is ready.';

  @override
  String get feedbackKitValidationSection => 'Validation Messages';

  @override
  String get feedbackKitValidationAmountLabel => 'Amount';

  @override
  String get feedbackKitValidationAmountValue => '0';

  @override
  String get feedbackKitValidationAmountError =>
      'Amount must be greater than 0';

  @override
  String get feedbackKitValidationEmailLabel => 'Email';

  @override
  String get feedbackKitValidationEmailValue => 'minhanh@email.com';

  @override
  String get feedbackKitValidationEmailSuccess => 'Valid email';

  @override
  String get feedbackKitConfirmDialogSection => 'Confirmation Dialog';

  @override
  String get feedbackKitConfirmDialogDesc =>
      'This action cannot be undone. The transaction will be permanently deleted.';

  @override
  String get feedbackKitNotificationCenterSection => 'Notification Center';

  @override
  String get feedbackKitNotificationCenterItem1Title =>
      'Food & Drink budget reached 90%';

  @override
  String get feedbackKitNotificationCenterItem1Time => '2 hours ago';

  @override
  String get feedbackKitNotificationCenterItem2Title =>
      'New transaction: -85,000 ₫ at Bún chả Hương Liên';

  @override
  String get feedbackKitNotificationCenterItem2Time => 'Today, 09:12';

  @override
  String get feedbackKitNotificationCenterItem3Title =>
      'Data backup successful';

  @override
  String get feedbackKitNotificationCenterItem3Time => 'Yesterday';

  @override
  String get feedbackKitButtonStatesSection => 'Button Feedback States';

  @override
  String get feedbackKitButtonLoading => 'Saving...';

  @override
  String get feedbackKitButtonSuccess => 'Saved';

  @override
  String get categoryListPageTitle => 'Categories';

  @override
  String categoryCountLabel(int count) {
    return '$count expense categories · tap to edit';
  }

  @override
  String categoryUsageCount(int count) {
    return '$count transactions this month';
  }

  @override
  String get categoryUsageNone => 'No transactions yet';

  @override
  String get categoryAddNewButton => 'Add new category';

  @override
  String get categoryListEmptyMessage =>
      'No categories yet.\nTap \"Add new category\" to create your first one.';

  @override
  String get categoryEditPageTitleCreate => 'Add category';

  @override
  String get categoryEditPageTitleEdit => 'Edit category';

  @override
  String get categoryPreviewLabel => 'Preview';

  @override
  String get categoryPreviewPlaceholder => 'New category';

  @override
  String get categoryNameLabel => 'Category name';

  @override
  String get categoryNameHint => 'e.g. Coffee';

  @override
  String get categoryNameDuplicateError => 'This category name already exists';

  @override
  String get categoryColorLabel => 'Color';

  @override
  String get categoryIconLabel => 'Icon';

  @override
  String categoryIconCountLabel(int count) {
    return '$count icons';
  }

  @override
  String get categoryIconGroupFood => 'Food & Drink';

  @override
  String get categoryIconGroupShopping => 'Shopping';

  @override
  String get categoryIconGroupTransport => 'Transport';

  @override
  String get categoryIconGroupHome => 'Home';

  @override
  String get categoryIconGroupOther => 'Other';

  @override
  String get categorySaveButtonCreate => 'Create category';

  @override
  String get categorySaveButtonUpdate => 'Update';

  @override
  String get categoryDeleteButton => 'Delete this category';

  @override
  String get categoryDeleteConfirmTitle => 'Delete category?';

  @override
  String get categoryDeleteConfirmDesc =>
      'This action cannot be undone. The category will be permanently deleted.';

  @override
  String get categoryCreatedSnackbar => 'New category added';

  @override
  String get categoryUpdatedSnackbar => 'Category updated';

  @override
  String get categoryDeletedSnackbar => 'Category deleted';
}
