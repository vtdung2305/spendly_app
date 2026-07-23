import 'package:flutter/material.dart';

/// Floating-card shadow — always paired with a 1px Border, per design handoff.
abstract class AppShadow {
  static const card = [
    BoxShadow(color: Color(0x1A0F172A), blurRadius: 44, offset: Offset(0, 20)),
  ];

  static const cardDark = [
    BoxShadow(color: Color(0x80000000), blurRadius: 44, offset: Offset(0, 20)),
  ];

  static const fab = [
    BoxShadow(color: Color(0x664F46E5), blurRadius: 20, offset: Offset(0, 8)),
  ];
}
