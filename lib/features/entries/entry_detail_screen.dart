import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:today_i_learned/core/models/entry.dart';
import 'package:today_i_learned/core/providers/providers.dart';

class EntryDetailScreen extends ConsumerWidget {
  const EntryDetailScreen({super.key, required this.entry});

  final Entry entry;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;
    final formattedDate = DateFormat('EEEE, MMMM d, y').format(entry.createdAt);

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
            actions: [
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert),
                tooltip: 'More options',
                onSelected: (value) {
                  if (value == 'delete') {
                    _confirmDelete(context, ref);
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete_outline, color: colorScheme.error),
                        const SizedBox(width: 12),
                        Text(
                          'Delete',
                          style: textTheme.bodyMedium?.copyWith(
                            color: colorScheme.error,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 4),
            ],
          ),
          SliverPadding(
            padding: EdgeInsets.fromLTRB(
              24,
              8,
              24,
              MediaQuery.paddingOf(context).bottom + 32,
            ),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Date
                Text(
                  formattedDate.toUpperCase(),
                  style: textTheme.labelSmall?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.4,
                  ),
                ),
                const SizedBox(height: 16),

                // Title
                Text(
                  entry.title,
                  style: textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.3,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 24),

                // Tags
                if (entry.tags.isNotEmpty) ...[
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: entry.tags
                        .map((tag) => _buildTag(tag, theme))
                        .toList(),
                  ),
                  const SizedBox(height: 32),
                ],

                const SizedBox(height: 12),

                // Body
                SelectableText(
                  entry.body,
                  style: textTheme.bodyLarge?.copyWith(
                    color: colorScheme.onSurface,
                    height: 1.75,
                    letterSpacing: 0.1,
                  ),
                ),
              ]),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: colorScheme.surface,
          border: Border(
            top: BorderSide(
              color: colorScheme.outlineVariant.withValues(alpha: 0.4),
              width: 1,
            ),
          ),
        ),
        padding: EdgeInsets.fromLTRB(
          16,
          12,
          16,
          MediaQuery.paddingOf(context).bottom + 12,
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              FilledButton.tonalIcon(
                onPressed: () {
                  // TODO: Implement Edit
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Edit coming soon')),
                  );
                },
                icon: const Icon(Icons.edit_outlined),
                label: const Text('Edit Entry'),
              ),
              const SizedBox(width: 12),
              FilledButton.tonalIcon(
                onPressed: () {
                  // TODO: Implement Share
                },
                icon: const Icon(Icons.share_outlined),
                label: const Text('Share'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTag(String label, ThemeData theme) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.colorScheme.secondaryContainer.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        child: Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSecondaryContainer,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete entry?'),
        content: const Text('This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(ctx).colorScheme.error,
              foregroundColor: Theme.of(ctx).colorScheme.onError,
            ),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      await ref.read(entriesNotifierProvider.notifier).delete(entry.id);
      if (context.mounted) Navigator.of(context).pop();
    }
  }
}
