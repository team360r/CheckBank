import 'package:flutter/material.dart';

/// CheckBank colour palette.
///
/// BUG: Several secondary colours fail WCAG AA contrast against white.
/// Chapter 3 will write tests that catch these.
class AppColors {
  AppColors._();

  // Primary brand — teal (passes WCAG AA)
  static const primary = Color(0xFF00897B);
  static const primaryDark = Color(0xFF005B4F);
  static const primaryLight = Color(0xFF4DB6AC);

  // Surfaces
  static const surface = Colors.white;
  static const surfaceDark = Color(0xFF121212);
  static const background = Color(0xFFF5F5F5);

  // Text
  static const textPrimary = Color(0xFF212121);

  // BUG: This grey is too light — fails WCAG AA (ratio ~2.8:1 on white)
  static const textSecondary = Color(0xFFB0B0B0);

  // BUG: Disabled state is barely visible (ratio ~1.9:1 on white)
  static const textDisabled = Color(0xFFD5D5D5);

  // Semantic colours
  static const error = Color(0xFFD32F2F);
  static const success = Color(0xFF388E3C);

  // BUG: Credit/debit indicators rely on colour only (green/red)
  static const creditGreen = Color(0xFF2E7D32);
  static const debitRed = Color(0xFFC62828);
}
