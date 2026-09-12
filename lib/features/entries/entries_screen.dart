import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:today_i_learned/core/models/entry.dart';
import 'package:today_i_learned/core/providers/providers.dart';
import 'package:today_i_learned/core/ui/empty_state.dart';
import 'package:today_i_learned/core/ui/entry_card.dart';
import 'package:today_i_learned/features/entries/entry_detail_screen.dart';
import 'package:today_i_learned/features/entries/new_entry_screen.dart';
import 'package:today_i_learned/features/settings/settings_screen.dart';

class EntriesScreen extends ConsumerStatefulWidget {
  const EntriesScreen({super.key});

  @override
  ConsumerState<EntriesScreen> createState() => _EntriesScreenState();
}

class _EntriesScreenState extends ConsumerState<EntriesScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      ref.read(searchQueryProvider.notifier).state = _searchController.text;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openEntry(Entry entry) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => EntryDetailScreen(entry: entry)));
  }

  void _openNewEntry() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const NewEntryScreen()));
  }

  void _openSettings() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const SettingsScreen()));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    final entriesAsync = ref.watch(entriesNotifierProvider);
    final filtered = ref.watch(filteredEntriesProvider);
    final allTags = ref.watch(allTagsProvider);
    final selectedTag = ref.watch(selectedTagProvider);
    final isEmpty = entriesAsync.valueOrNull?.isEmpty ?? false;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: _openNewEntry,
        elevation: 0,
        tooltip: 'New Entry',
        shape: const CircleBorder(),
        child: const Icon(Icons.add),
      ),
      body: CustomScrollView(
        slivers: [
          // --- AppBar ---
          SliverAppBar(
            floating: true,
            snap: true,
            pinned: false,
            centerTitle: false,
            backgroundColor: colorScheme.surface,
            scrolledUnderElevation: 0,
            title: Padding(
              padding: const EdgeInsets.only(left: 4),
              child: Text(
                'I Learned Today',
                style: textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.7,
                  color: colorScheme.onSurface,
                ),
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: IconButton(
                  onPressed: _openSettings,
                  tooltip: 'Settings',
                  icon: const Icon(Icons.settings_outlined),
                ),
              ),
            ],
          ),

          // --- Search ---
          if (!isEmpty)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 12, 8, 20),
                child: SearchBar(
                  controller: _searchController,
                  constraints: const BoxConstraints(
                    minHeight: 48,
                    maxHeight: 48,
                  ),
                  hintText: 'Search your entries...',
                  hintStyle: WidgetStatePropertyAll(
                    textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      fontSize: 15,
                    ),
                  ),
                  leading: Padding(
                    padding: const EdgeInsets.only(left: 4),
                    child: Icon(
                      Icons.search_rounded,
                      size: 20,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  elevation: const WidgetStatePropertyAll(0),
                  backgroundColor: WidgetStatePropertyAll(
                    colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
                  ),
                  padding: const WidgetStatePropertyAll(
                    EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                  ),
                  trailing: [
                    ValueListenableBuilder<TextEditingValue>(
                      valueListenable: _searchController,
                      builder: (context, value, _) {
                        final hasText = value.text.isNotEmpty;
                        return AnimatedOpacity(
                          opacity: hasText ? 1.0 : 0.0,
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.easeOutCubic,
                          child: IgnorePointer(
                            ignoring: !hasText,
                            child: IconButton(
                              icon: const Icon(Icons.close_rounded, size: 20),
                              color: colorScheme.onSurfaceVariant,
                              tooltip: 'Clear',
                              onPressed: _searchController.clear,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),

          // --- Filter chips ---
          if (!isEmpty)
            SliverToBoxAdapter(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  children: allTags.map((tag) {
                    final isSelected = selectedTag == tag;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        label: Text(tag),
                        selected: isSelected,
                        showCheckmark: false,
                        elevation: 0,
                        pressElevation: 0,
                        backgroundColor: colorScheme.surfaceContainerHighest
                            .withValues(alpha: 0.3),
                        selectedColor: colorScheme.secondaryContainer,
                        labelStyle: textTheme.labelMedium?.copyWith(
                          color: isSelected
                              ? colorScheme.onSecondaryContainer
                              : colorScheme.onSurfaceVariant,
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.w500,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: const BorderSide(color: Colors.transparent),
                        ),
                        onSelected: (_) =>
                            ref.read(selectedTagProvider.notifier).state = tag,
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),

          // --- Entries or empty state ---
          entriesAsync.when(
            loading: () => const SliverFillRemaining(
              hasScrollBody: false,
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (e, _) => SliverFillRemaining(
              hasScrollBody: false,
              child: Center(child: Text('Error: $e')),
            ),
            data: (_) {
              if (filtered.isEmpty) {
                return SliverFillRemaining(
                  hasScrollBody: false,
                  child: EmptyState(
                    icon: isEmpty
                        ? Icons.menu_book_rounded
                        : Icons.search_off_rounded,
                    title: isEmpty ? 'No entries yet' : 'No results found',
                    message: isEmpty
                        ? 'Start documenting what you learn today and build your knowledge base.'
                        : 'We couldn\'t find any entries matching your current search and filters.',
                    ctaIcon: isEmpty
                        ? Icons.add_rounded
                        : Icons.clear_all_rounded,
                    ctaLabel: isEmpty ? 'Create First Entry' : 'Clear Filters',
                    onCtaPressed: isEmpty
                        ? _openNewEntry
                        : () {
                            _searchController.clear();
                            ref.read(selectedTagProvider.notifier).state =
                                'All';
                          },
                  ),
                );
              }

              return SliverPadding(
                padding: EdgeInsets.fromLTRB(
                  8,
                  24,
                  8,
                  MediaQuery.paddingOf(context).bottom + 100,
                ),
                sliver: SliverList.separated(
                  itemCount: filtered.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 28),
                  itemBuilder: (context, index) {
                    final entry = filtered[index];
                    return EntryCard(
                      key: ValueKey(entry.id),
                      entry: entry,
                      onTap: () => _openEntry(entry),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
