import '../../domain/entities/expense_category.dart';
import '../../domain/entities/income_source.dart';
import '../../domain/entities/transaction.dart';
import '../models/transaction_model.dart';

/// Hand-authored dataset that reproduces the design handoff Dashboard exactly:
/// 45.000.000₫ income, 18.500.000₫ expense (32/22/16/12/12/6% category split
/// once grouped by [ExpenseCategory.chartGroup]), so the mock-backed UI can
/// be pixel-checked against the prototype.
abstract class TransactionSeedData {
  static List<TransactionModel> seed() {
    final month = DateTime(2026, 7);
    DateTime d(int day) => DateTime(month.year, month.month, day);

    return [
      TransactionModel(
        id: 't1', type: TransactionType.income, amount: 40000000, date: d(1),
        incomeSource: IncomeSource.luong, note: 'Lương tháng 7',
      ),
      TransactionModel(
        id: 't2', type: TransactionType.income, amount: 5000000, date: d(3),
        incomeSource: IncomeSource.freelance, note: 'Dự án freelance',
      ),
      // 32% — Ăn uống = 5.920.000
      TransactionModel(
        id: 't3', type: TransactionType.expense, amount: 5920000, date: d(20),
        expenseCategory: ExpenseCategory.anUong, note: 'Ăn uống trong tuần',
      ),
      // 22% — Shopping = 4.070.000
      TransactionModel(
        id: 't4', type: TransactionType.expense, amount: 4070000, date: d(19),
        expenseCategory: ExpenseCategory.shopping, note: 'Mua sắm cuối tuần',
      ),
      // 16% — Đi lại = 2.960.000
      TransactionModel(
        id: 't5', type: TransactionType.expense, amount: 2960000, date: d(18),
        expenseCategory: ExpenseCategory.diLai, note: 'Xăng xe, Grab',
      ),
      // 12% — Giải trí = 2.220.000
      TransactionModel(
        id: 't6', type: TransactionType.expense, amount: 2220000, date: d(17),
        expenseCategory: ExpenseCategory.giaiTri, note: 'Xem phim, game',
      ),
      // 12% — Gia đình = 2.220.000
      TransactionModel(
        id: 't7', type: TransactionType.expense, amount: 2220000, date: d(16),
        expenseCategory: ExpenseCategory.giaDinh, note: 'Chi tiêu gia đình',
      ),
      // 6% — Khác (Y tế) = 1.110.000
      TransactionModel(
        id: 't8', type: TransactionType.expense, amount: 1110000, date: d(15),
        expenseCategory: ExpenseCategory.yTe, note: 'Khám sức khỏe',
      ),
    ];
  }

  /// 14-day daily-spend series for the Dashboard bar card (color-coded by
  /// magnitude in the widget layer: green low / primary mid / red high).
  static List<double> dailySpend14Days() => const [
        180000, 620000, 250000, 1150000, 320000, 90000, 780000,
        420000, 1900000, 260000, 610000, 340000, 980000, 150000,
      ];

  /// Realistic transaction list (matches design handoff `txPool` verbatim)
  /// backing Transaction History and Income Management — a broader, more
  /// varied dataset than [seed], which is tuned to hit exact Dashboard
  /// percentages.
  static List<TransactionModel> historyPool() {
    final month = DateTime(2026, 7);
    DateTime d(int day) => DateTime(month.year, month.month, day);

    return [
      TransactionModel(id: 'h1', type: TransactionType.expense, amount: 85000, date: d(23), expenseCategory: ExpenseCategory.anUong, note: 'Bún chả Hương Liên'),
      TransactionModel(id: 'h2', type: TransactionType.income, amount: 45000000, date: d(22), incomeSource: IncomeSource.luong, note: 'Lương tháng 7'),
      TransactionModel(id: 'h3', type: TransactionType.expense, amount: 450000, date: d(21), expenseCategory: ExpenseCategory.shopping, note: 'Áo thun Uniqlo'),
      TransactionModel(id: 'h4', type: TransactionType.expense, amount: 65000, date: d(21), expenseCategory: ExpenseCategory.diLai, note: 'Grab về nhà'),
      TransactionModel(id: 'h5', type: TransactionType.expense, amount: 180000, date: d(20), expenseCategory: ExpenseCategory.giaiTri, note: 'Vé xem phim CGV'),
      TransactionModel(id: 'h6', type: TransactionType.expense, amount: 620000, date: d(19), expenseCategory: ExpenseCategory.giaDinh, note: 'Mua sắm siêu thị'),
      TransactionModel(id: 'h7', type: TransactionType.income, amount: 3200000, date: d(18), incomeSource: IncomeSource.freelance, note: 'Dự án Freelance'),
      TransactionModel(id: 'h8', type: TransactionType.expense, amount: 350000, date: d(17), expenseCategory: ExpenseCategory.yTe, note: 'Khám răng'),
      TransactionModel(id: 'h9', type: TransactionType.expense, amount: 1850000, date: d(15), expenseCategory: ExpenseCategory.duLich, note: 'Vé máy bay Đà Nẵng'),
      TransactionModel(id: 'h10', type: TransactionType.expense, amount: 45000, date: d(15), expenseCategory: ExpenseCategory.anUong, note: 'Cà phê sáng'),
      TransactionModel(id: 'h11', type: TransactionType.expense, amount: 1250000, date: d(12), expenseCategory: ExpenseCategory.shopping, note: 'Giày thể thao'),
      TransactionModel(id: 'h12', type: TransactionType.expense, amount: 110000, date: d(10), expenseCategory: ExpenseCategory.giaiTri, note: 'Netflix'),
      TransactionModel(id: 'h13', type: TransactionType.income, amount: 2000000, date: d(5), incomeSource: IncomeSource.bonus, note: 'Bonus Q2'),
    ];
  }

  /// One spend total per day of the month (matches design handoff
  /// `calendarAmounts` verbatim) backing the Calendar screen.
  static List<double> calendarAmounts() => const [
        250000, 0, 1200000, 560000, 0, 320000, 1450000, 90000, 0, 780000,
        210000, 0, 1900000, 340000, 60000, 0, 510000, 1250000, 0, 175000,
        890000, 40000, 0, 620000, 1050000, 0, 230000, 1420000, 80000, 0, 150000,
      ];

  /// Income Management's own list (matches design handoff `incomeListData`
  /// verbatim — a separate, hand-curated dataset from [historyPool]).
  static List<TransactionModel> incomeListSeed() => [
        TransactionModel(id: 'i1', type: TransactionType.income, amount: 45000000, date: DateTime(2026, 7, 22), incomeSource: IncomeSource.luong, note: 'Lương tháng 7'),
        TransactionModel(id: 'i2', type: TransactionType.income, amount: 3200000, date: DateTime(2026, 7, 18), incomeSource: IncomeSource.freelance, note: 'Dự án Freelance UI'),
        TransactionModel(id: 'i3', type: TransactionType.income, amount: 2000000, date: DateTime(2026, 7, 5), incomeSource: IncomeSource.bonus, note: 'Bonus dự án Q2'),
        TransactionModel(id: 'i4', type: TransactionType.income, amount: 45000000, date: DateTime(2026, 6, 22), incomeSource: IncomeSource.luong, note: 'Lương tháng 6'),
      ];
}
