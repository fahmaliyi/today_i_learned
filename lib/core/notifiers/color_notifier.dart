import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:today_i_learned/core/providers/providers.dart';
import 'package:today_i_learned/core/theme/theme.dart';

const _kColorKey = 'til_theme_color_index';

class ColorNotifier extends Notifier<Color> {
  @override
  Color build() {
    final prefs = ref.read(sharedPreferencesProvider);
    final storedIndex = prefs.getInt(_kColorKey);
    if (storedIndex == null || storedIndex < 0 || storedIndex >= AppTheme.seedColors.length) {
      return AppTheme.seedColors[0].$2; // Default to the first color (Indigo)
    }
    return AppTheme.seedColors[storedIndex].$2;
  }

  Future<void> setColor(Color color) async {
    state = color;
    final index = AppTheme.seedColors.indexWhere((c) => c.$2 == color);
    if (index != -1) {
      final prefs = ref.read(sharedPreferencesProvider);
      await prefs.setInt(_kColorKey, index);
    }
  }
}
