import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:spendly_app/core/localization/app_localizations_x.dart';
import 'package:spendly_app/core/theme/app_colors.dart';
import 'package:spendly_app/core/theme/app_radius.dart';
import 'package:spendly_app/core/theme/app_shadow.dart';
import 'package:spendly_app/core/theme/app_typography.dart';
import 'package:spendly_app/core/utils/currency_formatter.dart';
import 'package:spendly_app/features/transactions/domain/entities/transaction.dart';

const _kAmountPresets = [50000.0, 100000.0, 200000.0, 500000.0];

/// "Số tiền" card — its own bordered/shadowed card (not just a pill), with
/// a +/− sign that colors the whole amount by transaction type, and preset
/// amount chips below, per design handoff Add Expense/Add Income layout.
class TransactionAmountCard extends StatefulWidget {
  const TransactionAmountCard({
    required this.type,
    required this.onChanged,
    super.key,
    this.initialAmount,
  });

  final TransactionType type;
  final ValueChanged<double> onChanged;
  final double? initialAmount;

  @override
  State<TransactionAmountCard> createState() => _TransactionAmountCardState();
}

class _TransactionAmountCardState extends State<TransactionAmountCard> {
  late final _controller = TextEditingController(
    text: widget.initialAmount != null && widget.initialAmount! > 0
        ? CurrencyFormatter.formatPlain(widget.initialAmount!)
        : '',
  );
  late double _amount = widget.initialAmount ?? 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleChanged(String raw) {
    final digitsOnly = raw.replaceAll(RegExp(r'[^0-9]'), '');
    final amount = digitsOnly.isEmpty ? 0.0 : double.parse(digitsOnly);
    final formatted =
        digitsOnly.isEmpty ? '' : CurrencyFormatter.formatPlain(amount);
    _controller.value = TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
    setState(() => _amount = amount);
    widget.onChanged(amount);
  }

  void _selectPreset(double preset) {
    final formatted = CurrencyFormatter.formatPlain(preset);
    _controller.value = TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
    setState(() => _amount = preset);
    widget.onChanged(preset);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isExpense = widget.type == TransactionType.expense;
    final amountColor = _amount > 0
        ? (isExpense ? colors.danger : colors.success)
        : colors.textTertiary;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: colors.border),
        boxShadow: AppShadow.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.addTransactionAmountLabel.toUpperCase(),
            style: AppTypography.mono(
              fontSize: 10.5,
              fontWeight: FontWeight.w600,
              color: colors.textTertiary,
              letterSpacing: 0.06 * 10.5,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                isExpense ? '−' : '+',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: amountColor),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: _controller,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  onChanged: _handleChanged,
                  strutStyle: const StrutStyle(fontSize: 24, height: 1.0),
                  style: AppTypography.mono(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: amountColor),
                  decoration: InputDecoration(
                    hintText: '0',
                    hintStyle: AppTypography.mono(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: colors.textTertiary),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    filled: false,
                    isCollapsed: true,
                  ),
                ),
              ),
              const SizedBox(width: 6),
              Text(
                '₫',
                style: AppTypography.mono(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: colors.textTertiary),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              for (final preset in _kAmountPresets) ...[
                Expanded(
                  child: _PresetChip(
                    amount: preset,
                    selected: _amount == preset,
                    onTap: () => _selectPreset(preset),
                  ),
                ),
                if (preset != _kAmountPresets.last) const SizedBox(width: 6),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _PresetChip extends StatelessWidget {
  const _PresetChip(
      {required this.amount, required this.selected, required this.onTap});

  final double amount;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.sm),
      child: Container(
        height: 44,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? colors.primaryTint : colors.surfaceAlt,
          borderRadius: BorderRadius.circular(AppRadius.sm),
          border: Border.all(color: selected ? colors.primary : colors.border),
        ),
        child: Text(
          CurrencyFormatter.formatCompact(amount),
          style: AppTypography.mono(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: selected ? colors.primary : colors.textSecondary,
          ),
        ),
      ),
    );
  }
}
