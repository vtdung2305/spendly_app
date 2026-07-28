import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:spendly_app/core/theme/app_colors.dart';
import 'package:spendly_app/core/theme/app_radius.dart';
import 'package:spendly_app/core/theme/app_typography.dart';
import 'package:spendly_app/core/utils/currency_formatter.dart';

/// Large amount field with live "." thousands separator and trailing "₫",
/// per Add Transaction layout ("Số tiền" label + Surface Alt bg, radius 16).
class AmountInput extends StatefulWidget {
  const AmountInput({required this.onChanged, super.key, this.initialAmount});

  final ValueChanged<double> onChanged;
  final double? initialAmount;

  @override
  State<AmountInput> createState() => _AmountInputState();
}

class _AmountInputState extends State<AmountInput> {
  late final _controller = TextEditingController(
    text: widget.initialAmount != null && widget.initialAmount! > 0
        ? CurrencyFormatter.formatPlain(widget.initialAmount!)
        : '',
  );

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
    widget.onChanged(amount);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: colors.surfaceAlt,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              onChanged: _handleChanged,
              strutStyle: const StrutStyle(fontSize: 22, height: 1.0),
              style: AppTypography.mono(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: colors.textPrimary,
              ),
              decoration: InputDecoration(
                hintText: '0',
                hintStyle: AppTypography.mono(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: colors.textTertiary,
                ),
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
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: colors.textTertiary,
            ),
          ),
        ],
      ),
    );
  }
}
