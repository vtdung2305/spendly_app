import 'package:flutter/widgets.dart';

import 'package:spendly_app/features/transactions/domain/entities/transaction.dart';
import 'expense_category_ui.dart';
import 'income_source_ui.dart';

/// Localized display label — mirrors [Transaction.displayLabel] but resolves
/// through the category/source UI mappers instead of the raw (Vietnamese)
/// domain enum field. [Transaction.displayLabel] itself stays as-is since
/// it's also used for context-free search matching in the data layer.
extension TransactionUi on Transaction {
  String displayLabelText(BuildContext context) =>
      type == TransactionType.expense
          ? expenseCategory!.labelText(context)
          : incomeSource!.labelText(context);
}
