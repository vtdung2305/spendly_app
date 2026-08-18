import 'package:equatable/equatable.dart';

/// One of the three "Lọc nhanh" quick chips in the History filter panel.
enum HistoryQuickFilter { none, expenseOnly, incomeOnly, over500k }

const historyOver500kThreshold = 500000.0;

/// Date range + quick chip currently applied on the History screen, on top
/// of the free-text search query (kept separately in [HistoryLoaded]).
class HistoryFilter extends Equatable {
  const HistoryFilter({
    this.dateFrom,
    this.dateTo,
    this.quickFilter = HistoryQuickFilter.none,
    this.categoryId,
  });

  static const empty = HistoryFilter();

  final DateTime? dateFrom;
  final DateTime? dateTo;
  final HistoryQuickFilter quickFilter;
  final String? categoryId;

  bool get isActive =>
      dateFrom != null ||
      dateTo != null ||
      quickFilter != HistoryQuickFilter.none ||
      categoryId != null;

  HistoryFilter copyWith({
    DateTime? dateFrom,
    bool clearDateFrom = false,
    DateTime? dateTo,
    bool clearDateTo = false,
    HistoryQuickFilter? quickFilter,
    String? categoryId,
    bool clearCategoryId = false,
  }) {
    return HistoryFilter(
      dateFrom: clearDateFrom ? null : (dateFrom ?? this.dateFrom),
      dateTo: clearDateTo ? null : (dateTo ?? this.dateTo),
      quickFilter: quickFilter ?? this.quickFilter,
      categoryId: clearCategoryId ? null : (categoryId ?? this.categoryId),
    );
  }

  @override
  List<Object?> get props => [dateFrom, dateTo, quickFilter, categoryId];
}
