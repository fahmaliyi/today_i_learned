import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TagsInputSection extends StatefulWidget {
  const TagsInputSection({
    super.key,
    required this.tags,
    required this.onChanged,
  });

  final List<String> tags;
  final ValueChanged<List<String>> onChanged;

  @override
  State<TagsInputSection> createState() => _TagsInputSectionState();
}

class _TagsInputSectionState extends State<TagsInputSection> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _commitCurrentInput() {
    final text = _controller.text.trim().replaceAll(',', '');
    if (text.isNotEmpty && !widget.tags.contains(text)) {
      widget.onChanged([...widget.tags, text]);
    }
    _controller.clear();
  }

  void _removeTag(String tag) {
    widget.onChanged(widget.tags.where((t) => t != tag).toList());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Add tags',
          style: textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),

        // Normal text field input
        KeyboardListener(
          focusNode: FocusNode(),
          onKeyEvent: (event) {
            if (event is KeyDownEvent &&
                (event.logicalKey == LogicalKeyboardKey.comma ||
                    event.logicalKey == LogicalKeyboardKey.enter)) {
              _commitCurrentInput();
            }
          },
          child: TextField(
            controller: _controller,
            focusNode: _focusNode,
            textCapitalization: TextCapitalization.words,
            style: textTheme.bodyMedium,
            decoration: InputDecoration(
              hintText: 'Flutter, Design...',
              hintStyle: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.35),
              ),
              isDense: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: colorScheme.outlineVariant.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: colorScheme.outlineVariant.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: colorScheme.outlineVariant.withValues(alpha: 0.6),
                  width: 1,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
            ),
            onChanged: (value) {
              if (value.endsWith(',')) {
                _commitCurrentInput();
              }
            },
            onSubmitted: (_) {
              _commitCurrentInput();
              _focusNode.requestFocus();
            },
          ),
        ),

        // Hint
        const SizedBox(height: 6),
        Text(
          'Press comma or Return to add',
          style: textTheme.labelSmall?.copyWith(
            color: colorScheme.onSurfaceVariant.withValues(alpha: 0.55),
          ),
        ),

        // Chips row — below the input
        if (widget.tags.isNotEmpty) ...[
          const SizedBox(height: 12),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: widget.tags.map((tag) {
              return InputChip(
                label: Text(tag),
                labelStyle: textTheme.labelMedium?.copyWith(
                  color: colorScheme.onSecondaryContainer,
                  fontWeight: FontWeight.w600,
                ),
                backgroundColor: colorScheme.secondaryContainer,
                deleteIconColor: colorScheme.onSecondaryContainer.withValues(
                  alpha: 0.7,
                ),
                side: BorderSide.none,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                onDeleted: () => _removeTag(tag),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity: VisualDensity.compact,
              );
            }).toList(),
          ),
        ],
      ],
    );
  }
}
