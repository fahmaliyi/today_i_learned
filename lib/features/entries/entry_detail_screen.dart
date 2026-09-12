import 'dart:async';

import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import 'package:today_i_learned/core/models/entry.dart';
import 'package:today_i_learned/core/providers/providers.dart';
import 'package:today_i_learned/features/entries/tags_input_section.dart';

class EntryDetailScreen extends ConsumerStatefulWidget {
  const EntryDetailScreen({super.key, required this.entry});

  final Entry entry;

  @override
  ConsumerState<EntryDetailScreen> createState() => _EntryDetailScreenState();
}

class _EntryDetailScreenState extends ConsumerState<EntryDetailScreen> {
  late Entry _currentEntry;
  late final TextEditingController _titleController;
  late final TextEditingController _bodyController;
  late List<String> _tags;
  final _formKey = GlobalKey<FormState>();

  bool _isCopied = false;
  Timer? _copyTimer;

  bool _isDirty = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _currentEntry = widget.entry;
    _titleController = TextEditingController(text: _currentEntry.title);
    _bodyController = TextEditingController(text: _currentEntry.body);
    _tags = List.from(_currentEntry.tags);

    _titleController.addListener(_checkDirty);
    _bodyController.addListener(_checkDirty);
  }

  bool get _hasChanges {
    if (_titleController.text.trim() != _currentEntry.title) return true;
    if (_bodyController.text.trim() != _currentEntry.body) return true;
    if (_tags.length != _currentEntry.tags.length) return true;
    for (int i = 0; i < _tags.length; i++) {
      if (_tags[i] != _currentEntry.tags[i]) return true;
    }
    return false;
  }

  void _checkDirty() {
    final isDirty = _hasChanges;
    if (isDirty != _isDirty) {
      setState(() => _isDirty = isDirty);
    }
  }

  Future<void> _saveNow() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _isSaving = true);

    final updated = _currentEntry.copyWith(
      title: _titleController.text.trim(),
      body: _bodyController.text.trim(),
      tags: _tags,
    );

    await ref.read(entriesNotifierProvider.notifier).edit(updated);

    if (mounted) {
      setState(() {
        _currentEntry = updated;
        _isDirty = false;
        _isSaving = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Changes saved')));
    }
  }

  @override
  void dispose() {
    _copyTimer?.cancel();
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  void _handleCopy() {
    final text = '${_titleController.text}\n\n${_bodyController.text}';
    Clipboard.setData(ClipboardData(text: text));

    setState(() => _isCopied = true);

    _copyTimer?.cancel();
    _copyTimer = Timer(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() => _isCopied = false);
      }
    });
  }

  void _updateTags(List<String> newTags) {
    setState(() => _tags = newTags);
    _checkDirty();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;
    final formattedDate = DateFormat(
      'EEEE, MMMM d, y',
    ).format(widget.entry.createdAt);

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
              if (_isDirty)
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: _isSaving
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : FilledButton(
                          onPressed: _saveNow,
                          style: FilledButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            minimumSize: const Size(0, 36),
                            shape: const StadiumBorder(),
                          ),
                          child: const Text('Save'),
                        ),
                ),
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

                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // --- Title ---
                      TextFormField(
                        controller: _titleController,
                        textCapitalization: TextCapitalization.sentences,
                        style: textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.3,
                          height: 1.2,
                        ),
                        decoration: InputDecoration(
                          hintText: 'What did you learn?',
                          hintStyle: textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.3,
                            height: 1.2,
                            color: colorScheme.onSurface.withValues(alpha: 0.3),
                          ),
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                        ),
                        validator: (v) =>
                            (v == null || v.trim().isEmpty) ? 'Required' : null,
                        maxLines: null,
                      ),

                      const SizedBox(height: 24),

                      // --- Tags ---
                      TagsInputSection(tags: _tags, onChanged: _updateTags),

                      const SizedBox(height: 32),

                      // --- Body ---
                      TextFormField(
                        controller: _bodyController,
                        textCapitalization: TextCapitalization.sentences,
                        style: textTheme.bodyLarge?.copyWith(
                          color: colorScheme.onSurface,
                          height: 1.75,
                          letterSpacing: 0.1,
                        ),
                        decoration: InputDecoration(
                          hintText:
                              'Write what you learned in as much detail as you like...',
                          hintStyle: textTheme.bodyLarge?.copyWith(
                            color: colorScheme.onSurface.withValues(alpha: 0.3),
                            height: 1.75,
                          ),
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                        ),
                        validator: (v) =>
                            (v == null || v.trim().isEmpty) ? 'Required' : null,
                        maxLines: null,
                        minLines: 6,
                      ),
                    ],
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
                onPressed: _handleCopy,
                icon: Icon(
                  _isCopied ? Icons.check_rounded : Icons.copy_outlined,
                ),
                label: Text(_isCopied ? 'Copied' : 'Copy'),
                style: _isCopied
                    ? FilledButton.styleFrom(
                        backgroundColor: colorScheme.primaryContainer,
                        foregroundColor: colorScheme.onPrimaryContainer,
                      )
                    : null,
              ),
              const SizedBox(width: 12),
              FilledButton.tonalIcon(
                onPressed: () {
                  final text =
                      '${_titleController.text}\n\n${_bodyController.text}';
                  SharePlus.instance.share(ShareParams(text: text));
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
      await ref.read(entriesNotifierProvider.notifier).delete(widget.entry.id);
      if (context.mounted) Navigator.of(context).pop();
    }
  }
}
