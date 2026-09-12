import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:today_i_learned/core/providers/providers.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    final currentTheme = ref.watch(themeNotifierProvider);
    final entryCount =
        ref.watch(entriesNotifierProvider).valueOrNull?.length ?? 0;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: false,
            pinned: true,
            backgroundColor: colorScheme.surface,
            scrolledUnderElevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: Text(
              'Settings',
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.fromLTRB(
              16,
              8,
              16,
              MediaQuery.paddingOf(context).bottom + 32,
            ),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // --- Appearance ---
                _SectionHeader(label: 'Appearance'),
                const SizedBox(height: 8),
                Card(
                  margin: EdgeInsets.zero,
                  elevation: 0,
                  color: colorScheme.surfaceContainerLow,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      _ThemeTile(
                        icon: Icons.brightness_auto_rounded,
                        label: 'System default',
                        mode: ThemeMode.system,
                        currentMode: currentTheme,
                        onTap: () => ref
                            .read(themeNotifierProvider.notifier)
                            .setThemeMode(ThemeMode.system),
                      ),
                      _Divider(),
                      _ThemeTile(
                        icon: Icons.light_mode_outlined,
                        label: 'Light',
                        mode: ThemeMode.light,
                        currentMode: currentTheme,
                        onTap: () => ref
                            .read(themeNotifierProvider.notifier)
                            .setThemeMode(ThemeMode.light),
                      ),
                      _Divider(),
                      _ThemeTile(
                        icon: Icons.dark_mode_outlined,
                        label: 'Dark',
                        mode: ThemeMode.dark,
                        currentMode: currentTheme,
                        onTap: () => ref
                            .read(themeNotifierProvider.notifier)
                            .setThemeMode(ThemeMode.dark),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // --- Data ---
                _SectionHeader(label: 'Data'),
                const SizedBox(height: 8),
                Card(
                  margin: EdgeInsets.zero,
                  elevation: 0,
                  color: colorScheme.surfaceContainerLow,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ListTile(
                    leading: Icon(
                      Icons.inventory_2_outlined,
                      color: colorScheme.onSurfaceVariant,
                    ),
                    title: const Text('Total entries'),
                    trailing: Text(
                      '$entryCount',
                      style: textTheme.titleMedium?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // --- About ---
                _SectionHeader(label: 'About'),
                const SizedBox(height: 8),
                Card(
                  margin: EdgeInsets.zero,
                  elevation: 0,
                  color: colorScheme.surfaceContainerLow,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      ListTile(
                        leading: Icon(
                          Icons.auto_stories_rounded,
                          color: colorScheme.primary,
                        ),
                        title: const Text('Today I Learned'),
                        subtitle: const Text('Your personal knowledge log'),
                      ),
                      _Divider(),
                      ListTile(
                        leading: Icon(
                          Icons.info_outline_rounded,
                          color: colorScheme.onSurfaceVariant,
                        ),
                        title: const Text('Version'),
                        trailing: Text(
                          '0.1.0',
                          style: textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 4),
      child: Text(
        label.toUpperCase(),
        style: theme.textTheme.labelSmall?.copyWith(
          color: theme.colorScheme.primary,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}

class _ThemeTile extends StatelessWidget {
  const _ThemeTile({
    required this.icon,
    required this.label,
    required this.mode,
    required this.currentMode,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final ThemeMode mode;
  final ThemeMode currentMode;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isSelected = mode == currentMode;

    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? colorScheme.primary : colorScheme.onSurfaceVariant,
      ),
      title: Text(label),
      trailing: isSelected
          ? Icon(Icons.check_rounded, color: colorScheme.primary)
          : null,
      onTap: onTap,
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1,
      indent: 56,
      color: Theme.of(
        context,
      ).colorScheme.outlineVariant.withValues(alpha: 0.4),
    );
  }
}
