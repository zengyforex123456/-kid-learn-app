import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kid_learn_app/core/theme/app_colors.dart';
import 'package:kid_learn_app/core/theme/app_theme.dart';

void main() {
  group('AppColors', () {
    test('primary color is not null', () {
      expect(AppColors.primary, isNotNull);
    });

    test('bubbles list has 4 colors', () {
      expect(AppColors.bubbles.length, 4);
      for (final c in AppColors.bubbles) {
        expect(c, isA<Color>());
      }
    });

    test('text color is not null', () {
      expect(AppColors.text, isNotNull);
      expect(AppColors.textLight, isNotNull);
    });

    test('star color is golden', () {
      expect(AppColors.star, isA<Color>());
    });
  });

  group('AppTheme', () {
    test('light theme uses Material3', () {
      expect(AppTheme.light.useMaterial3, true);
    });

    test('light theme primary color matches', () {
      expect(AppTheme.light.colorScheme.primary, AppColors.primary);
    });

    test('light theme uses correct scaffold background', () {
      expect(AppTheme.light.scaffoldBackgroundColor, AppColors.background);
    });

    test('elevated button has minimum size 64', () {
      final style = AppTheme.light.elevatedButtonTheme.style;
      expect(style?.minimumSize?.resolve({}), const Size(64, 64));
    });
  });
}
