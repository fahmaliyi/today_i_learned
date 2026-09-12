import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:today_i_learned/core/models/entry.dart';
import 'package:today_i_learned/core/providers/providers.dart';

const _kEntriesKey = 'til_entries';

class EntriesNotifier extends AsyncNotifier<List<Entry>> {
  @override
  Future<List<Entry>> build() async {
    final prefs = ref.read(sharedPreferencesProvider);
    final raw = prefs.getString(_kEntriesKey);
    if (raw == null || raw.isEmpty) {
      return [];
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
