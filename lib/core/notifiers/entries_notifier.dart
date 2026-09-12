import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:today_i_learned/core/models/entry.dart';
import 'package:today_i_learned/core/providers/providers.dart';

const _kEntriesKey = 'til_entries';

List<Entry> _seedEntries() {
  final now = DateTime.now();
  return [
    Entry(
      id: '1',
      title: 'Subtle States and Architecture',
      body:
          'When you push UI elements toward the screen edges, the internal padding must compensate. It prevents the content from feeling trapped and maintains readability while keeping the design calm and professional.\n\nThis small detail separates an amateur layout from a polished one. The eye naturally seeks breathing room, and when elements are compressed against boundaries, it creates a subconscious tension.',
      tags: ['Design', 'Architecture'],
      createdAt: now.subtract(const Duration(days: 1)),
    ),
    Entry(
      id: '2',
      title: 'ValueNotifier vs ChangeNotifier',
      body:
          'ValueNotifier<T> is a lightweight ChangeNotifier that holds a single value. It only notifies listeners when the value actually changes (using ==). For simple reactive state, it is often all you need and avoids the overhead of a full state management package.\n\nChangeNotifier is more flexible — you call notifyListeners() manually — but that also means you can forget to call it. Prefer ValueNotifier for single-value state.',
      tags: ['Flutter', 'State Management'],
      createdAt: now.subtract(const Duration(days: 3)),
    ),
    Entry(
      id: '3',
      title: 'The 60-30-10 Colour Rule',
      body:
          'A classic design principle: 60% dominant colour (backgrounds), 30% secondary colour (surfaces, sidebars), 10% accent colour (CTAs, highlights). Applying this consistently creates visual hierarchy without being heavy-handed.\n\nIn Material You, this maps roughly to surface, surfaceContainer, and primary/secondary roles.',
      tags: ['Design', 'UI'],
      createdAt: now.subtract(const Duration(days: 5)),
    ),
    Entry(
      id: '4',
      title: 'Dart Records for Lightweight Data',
      body:
          'Dart 3 records let you return multiple values without creating a class. `(String, int) pair = ("hello", 42);` Pattern-match with `var (name, age) = pair;`. For throwaway structured data inside a function, records are far cleaner than maps or ad-hoc classes.',
      tags: ['Dart', 'Flutter'],
      createdAt: now.subtract(const Duration(days: 8)),
    ),
    Entry(
      id: '5',
      title: 'Sliver Performance Insight',
      body:
          'Using SliverList instead of a Column inside a SingleChildScrollView gives you lazy rendering: only the visible items are built. For long lists this is critical. SliverList.builder is the go-to. SliverList.separated adds separators without extra widgets.',
      tags: ['Flutter', 'Performance'],
      createdAt: now.subtract(const Duration(days: 12)),
    ),
  ];
}

class EntriesNotifier extends AsyncNotifier<List<Entry>> {
  @override
  Future<List<Entry>> build() async {
    final prefs = ref.read(sharedPreferencesProvider);
    final raw = prefs.getString(_kEntriesKey);
    if (raw == null || raw.isEmpty) {
      final seeded = _seedEntries();
      await prefs.setString(_kEntriesKey, Entry.encodeList(seeded));
      return seeded;
    }
    return Entry.decodeList(raw);
  }

  Future<void> _persist(List<Entry> entries) async {
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setString(_kEntriesKey, Entry.encodeList(entries));
  }

  Future<void> add(Entry entry) async {
    final current = state.valueOrNull ?? [];
    final updated = [entry, ...current];
    state = AsyncValue.data(updated);
    await _persist(updated);
  }

  Future<void> delete(String id) async {
    final current = state.valueOrNull ?? [];
    final updated = current.where((e) => e.id != id).toList();
    state = AsyncValue.data(updated);
    await _persist(updated);
  }

  Future<void> edit(Entry entry) async {
    final current = state.valueOrNull ?? [];
    final updated = current.map((e) => e.id == entry.id ? entry : e).toList();
    state = AsyncValue.data(updated);
    await _persist(updated);
  }
}
