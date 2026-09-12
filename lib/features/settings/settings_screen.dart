import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:today_i_learned/core/providers/providers.dart';
import 'package:today_i_learned/core/ui/expressive_list.dart';

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

    final themeModes = [
      (ThemeMode.system, Icons.brightness_auto_rounded, 'System default'),
      (ThemeMode.light, Icons.light_mode_outlined, 'Light'),
      (ThemeMode.dark, Icons.dark_mode_outlined, 'Dark'),
    ];

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // --- AppBar ---
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
              0,
              8,
              0,
              MediaQuery.paddingOf(context).bottom + 32,
            ),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // --- Appearance ---
                _SectionHeader(label: 'Appearance'),
                ExpressiveList(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: themeModes.length,
                  itemBuilder: (context, index, borderRadius) {
                    final (mode, icon, label) = themeModes[index];
                    final isSelected = currentTheme == mode;
                    return ExpressiveListTile(
                      borderRadius: borderRadius,
                      leading: Icon(
                        icon,
                        color: isSelected
                            ? colorScheme.primary
                            : colorScheme.onSurfaceVariant,
                      ),
                      title: Text(label),
                      trailing: isSelected
                          ? Icon(
                              Icons.check_rounded,
                              color: colorScheme.primary,
                            )
                          : null,
                      onTap: () => ref
                          .read(themeNotifierProvider.notifier)
                          .setThemeMode(mode),
                    );
                  },
                ),

                const SizedBox(height: 32),

                // --- Data ---
                _SectionHeader(label: 'Data'),
                ExpressiveList(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 1,
                  itemBuilder: (context, index, borderRadius) {
                    return ExpressiveListTile(
                      borderRadius: borderRadius,
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
                    );
                  },
                ),

                const SizedBox(height: 32),

                // --- About ---
                _SectionHeader(label: 'About'),
                ExpressiveList(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 2,
                  itemBuilder: (context, index, borderRadius) {
                    if (index == 0) {
                      return ExpressiveListTile(
                        borderRadius: borderRadius,
                        leading: Icon(
                          Icons.auto_stories_rounded,
                          color: colorScheme.primary,
                        ),
                        title: const Text('Today I Learned'),
                        subtitle: const Text('Your personal knowledge log'),
                      );
                    }
                    return ExpressiveListTile(
                      borderRadius: borderRadius,
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
                    );
                  },
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
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 6),
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
