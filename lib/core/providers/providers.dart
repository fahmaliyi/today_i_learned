import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:today_i_learned/core/models/entry.dart';
import 'package:today_i_learned/core/notifiers/entries_notifier.dart';
import 'package:today_i_learned/core/notifiers/theme_notifier.dart';
import 'package:today_i_learned/core/notifiers/color_notifier.dart';
import 'package:today_i_learned/core/notifiers/dynamic_color_notifier.dart';

// ---------------------------------------------------------------------------
// Infrastructure
// ---------------------------------------------------------------------------

/// Overridden in main() with a real SharedPreferences instance.
final sharedPreferencesProvider = Provider<SharedPreferences>(
  (ref) => throw UnimplementedError('SharedPreferences not initialised'),
);

// ---------------------------------------------------------------------------
// Feature providers
// ---------------------------------------------------------------------------

final entriesNotifierProvider =
    AsyncNotifierProvider<EntriesNotifier, List<Entry>>(EntriesNotifier.new);

final themeNotifierProvider = NotifierProvider<ThemeNotifier, ThemeMode>(
  ThemeNotifier.new,
);

final colorNotifierProvider = NotifierProvider<ColorNotifier, Color>(
  ColorNotifier.new,
);

final dynamicColorNotifierProvider =
    NotifierProvider<DynamicColorNotifier, bool>(DynamicColorNotifier.new);

// ---------------------------------------------------------------------------
// Derived / UI providers
// ---------------------------------------------------------------------------

/// Current search query string (owned by the entries screen).
final searchQueryProvider = StateProvider<String>((ref) => '');

/// The currently selected tag filter (''All'' means no filter).
final selectedTagProvider = StateProvider<String>((ref) => 'All');

/// All unique tags from the current entry list, sorted, with ''All'' prepended.
final allTagsProvider = Provider<List<String>>((ref) {
  final entries = ref.watch(entriesNotifierProvider).valueOrNull ?? [];
  final tags = entries.expand((e) => e.tags).toSet().toList()..sort();
  return ['All', ...tags];
});

/// Entries after applying the active search query and tag filter.
final filteredEntriesProvider = Provider<List<Entry>>((ref) {
  final entries = ref.watch(entriesNotifierProvider).valueOrNull ?? [];
  final query = ref.watch(searchQueryProvider).toLowerCase();
  final tag = ref.watch(selectedTagProvider);

  return entries.where((entry) {
    final tagMatch = tag == 'All' || entry.tags.contains(tag);
    final queryMatch =
        query.isEmpty ||
        entry.title.toLowerCase().contains(query) ||
        entry.body.toLowerCase().contains(query) ||
        entry.tags.any((t) => t.toLowerCase().contains(query));
    return tagMatch && queryMatch;
  }).toList();
});
