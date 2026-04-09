import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:checkbank/theme/app_colors.dart';

// ---------------------------------------------------------------------------
// WCAG contrast ratio utilities
// ---------------------------------------------------------------------------

/// Calculates the relative luminance of a [Color] per WCAG 2.1 formula.
///
/// Formula: https://www.w3.org/TR/WCAG21/#dfn-relative-luminance
double _relativeLuminance(Color color) {
  double linearise(double component) {
    final c = component;
    return c <= 0.04045
        ? c / 12.92
        : math.pow((c + 0.055) / 1.055, 2.4).toDouble();
  }

  final r = linearise(color.r);
  final g = linearise(color.g);
  final b = linearise(color.b);
  return 0.2126 * r + 0.7152 * g + 0.0722 * b;
}

/// Returns the contrast ratio between two colours.
///
/// Formula: (L1 + 0.05) / (L2 + 0.05) where L1 >= L2.
double contrastRatio(Color a, Color b) {
  final l1 = _relativeLuminance(a);
  final l2 = _relativeLuminance(b);
  final lighter = math.max(l1, l2);
  final darker = math.min(l1, l2);
  return (lighter + 0.05) / (darker + 0.05);
}

// ---------------------------------------------------------------------------
// WCAG thresholds
// ---------------------------------------------------------------------------

/// WCAG AA minimum contrast ratio for normal text (< 18pt or < 14pt bold).
const double kWcagAANormal = 4.5;

/// WCAG AA minimum contrast ratio for large text (>= 18pt or >= 14pt bold).
const double kWcagAALarge = 3.0;

/// WCAG AAA enhanced contrast ratio for normal text.
const double kWcagAAA = 7.0;

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  group('CheckBank theme — WCAG AA contrast', () {
    test('primary on white meets AA for large text', () {
      final ratio = contrastRatio(AppColors.primary, AppColors.surface);
      expect(ratio, greaterThanOrEqualTo(kWcagAALarge),
          reason:
              'Primary (#00897B) on white: ${ratio.toStringAsFixed(2)}:1 — needs >= 3:1 for large text');
    });

    test('textPrimary on white meets AA for normal text', () {
      final ratio = contrastRatio(AppColors.textPrimary, AppColors.surface);
      expect(ratio, greaterThanOrEqualTo(kWcagAANormal),
          reason:
              'textPrimary (#212121) on white: ${ratio.toStringAsFixed(2)}:1');
    });

    test('textSecondary on white meets AA for normal text', () {
      final ratio = contrastRatio(AppColors.textSecondary, AppColors.surface);
      expect(ratio, greaterThanOrEqualTo(kWcagAANormal),
          reason:
              'textSecondary (#B0B0B0) on white: ${ratio.toStringAsFixed(2)}:1 — needs >= 4.5:1');
    });

    test('textDisabled on white meets AA for normal text', () {
      final ratio = contrastRatio(AppColors.textDisabled, AppColors.surface);
      expect(ratio, greaterThanOrEqualTo(kWcagAANormal),
          reason:
              'textDisabled (#D5D5D5) on white: ${ratio.toStringAsFixed(2)}:1 — needs >= 4.5:1');
    });

    test('error on white meets AA for large text', () {
      final ratio = contrastRatio(AppColors.error, AppColors.surface);
      expect(ratio, greaterThanOrEqualTo(kWcagAALarge),
          reason:
              'error (#D32F2F) on white: ${ratio.toStringAsFixed(2)}:1 — needs >= 3:1 for large text');
    });

    test('success on white meets AA for large text', () {
      final ratio = contrastRatio(AppColors.success, AppColors.surface);
      expect(ratio, greaterThanOrEqualTo(kWcagAALarge),
          reason:
              'success (#388E3C) on white: ${ratio.toStringAsFixed(2)}:1 — needs >= 3:1 for large text');
    });
  });

  group('Contrast ratio utility — sanity checks', () {
    test('identical colours have contrast ratio of 1:1', () {
      final ratio = contrastRatio(Colors.black, Colors.black);
      expect(ratio, closeTo(1.0, 0.001));
    });

    test('black on white has maximum contrast ratio (~21:1)', () {
      final ratio = contrastRatio(Colors.black, Colors.white);
      expect(ratio, greaterThan(20.0));
    });

    test('contrast ratio is symmetric (order does not matter)', () {
      final ab = contrastRatio(AppColors.primary, AppColors.surface);
      final ba = contrastRatio(AppColors.surface, AppColors.primary);
      expect(ab, closeTo(ba, 0.001));
    });
  });
}
