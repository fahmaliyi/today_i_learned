import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

class EntryCard extends StatelessWidget {
  final int index;

  const EntryCard({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    final entryDate = DateTime(2026, 9, 12).subtract(Duration(days: index));
    final formattedDate = DateFormat(
      'EEE, MMM d',
    ).format(entryDate).toUpperCase();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // --- Section Header ---
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Text(
            formattedDate,
            style: textTheme.labelMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.2,
            ),
          ),
        ),

        // --- The Entry Container ---
        Card(
          margin: EdgeInsets.zero,
          elevation: 0,
          color: colorScheme.surfaceContainerLow,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Subtle States and Architecture',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    height: 1.2,
                    letterSpacing: -0.2,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'When you push UI elements toward the screen edges, the internal padding must compensate. It prevents the content from feeling trapped and maintains readability while keeping the design calm and professional.',
                  maxLines: 3, // Constrains long body text
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 24),

                // --- Tags Section ---
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _buildTag('Design', theme),
                    _buildTag('Architecture', theme),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTag(String label, ThemeData theme) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
