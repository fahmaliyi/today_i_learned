import 'package:flutter/material.dart';
import 'package:today_i_learned/core/ui/entry_card.dart';

class EntriesScreen extends StatefulWidget {
  const EntriesScreen({super.key});

  @override
  State<EntriesScreen> createState() => _EntriesScreenState();
}

class _EntriesScreenState extends State<EntriesScreen> {
  int _selectedFilterIndex = 0;
  final TextEditingController _searchController = TextEditingController();
  final List<String> _filters = ['All', 'Insights', 'Architecture', 'Flutter'];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        elevation: 0,
        tooltip: 'New Entry',
        shape: const CircleBorder(),
        child: const Icon(Icons.add),
      ),
      body: CustomScrollView(
        slivers: [
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
                  onPressed: () {},
                  tooltip: 'Settings',
                  icon: const Icon(Icons.settings),
                ),
              ),
            ],
          ),

          // --- Search Section ---
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 12, 8, 20),
              child: SearchBar(
                controller: _searchController,
                constraints: const BoxConstraints(minHeight: 48, maxHeight: 48),
                hintText: 'Search your entries...',
                hintStyle: WidgetStatePropertyAll(
                  theme.textTheme.bodyMedium?.copyWith(
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
                    builder: (context, value, child) {
                      final bool hasText = value.text.isNotEmpty;

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
                            onPressed: () {
                              _searchController.clear();
                              // Optionally remove focus (hide keyboard) when cleared:
                              // FocusScope.of(context).unfocus();
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),

          // --- Filter Section ---
          SliverToBoxAdapter(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: List.generate(_filters.length, (index) {
                  final isSelected = _selectedFilterIndex == index;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(_filters[index]),
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
                      onSelected: (bool selected) {
                        setState(() {
                          _selectedFilterIndex = index;
                        });
                      },
                    ),
                  );
                }),
              ),
            ),
          ),

          // --- Entries List ---
          SliverPadding(
            padding: EdgeInsets.fromLTRB(
              8,
              24,
              8,
              MediaQuery.paddingOf(context).bottom + 100,
            ),
            sliver: SliverList.separated(
              itemCount: 4,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                return EntryCard(index: index);
              },
            ),
          ),
        ],
      ),
    );
  }
}
