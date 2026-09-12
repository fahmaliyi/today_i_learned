import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:today_i_learned/core/providers/providers.dart';

const _kDynamicColorKey = 'til_dynamic_color';

class DynamicColorNotifier extends Notifier<bool> {
  @override
  bool build() {
    final prefs = ref.read(sharedPreferencesProvider);
    // Default to true or false? Let's default to false for predictable design, or true for native feel. Let's do false.
    return prefs.getBool(_kDynamicColorKey) ?? false;
  }

  Future<void> setDynamicColor(bool value) async {
    state = value;
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setBool(_kDynamicColorKey, value);
  }
}
