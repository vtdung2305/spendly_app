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
  String get dashboardSavingsGoalEditTitle => 'Set savings goal';

  @override
  String get dashboardSavingsGoalAmountHint => 'Enter target amount';

  @override
  String get dashboardSavingsGoalUpdatedSnackbar => 'Savings goal updated';

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
  String get reportsWeeklyBarCardTitle => 'Spending by week';

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
  String get historyFilterSectionLabel => 'Filter by';

  @override
  String get historyFilterChipThisWeek => 'This week';

  @override
  String get historyFilterChipFoodDrink => 'Food & drink';

  @override
  String get historyFilterChipOver500k => 'Over 500K';

  @override
  String get historyFilterChipExpenseOnly => 'Expenses only';

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
}
