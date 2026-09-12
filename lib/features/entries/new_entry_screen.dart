import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:today_i_learned/core/models/entry.dart';
import 'package:today_i_learned/core/providers/providers.dart';

class NewEntryScreen extends ConsumerStatefulWidget {
  const NewEntryScreen({super.key});

  @override
  ConsumerState<NewEntryScreen> createState() => _NewEntryScreenState();
}

class _NewEntryScreenState extends ConsumerState<NewEntryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();
  final _tagsController = TextEditingController();
  bool _isSaving = false;

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    _tagsController.dispose();
    super.dispose();
  }

  List<String> _parseTags(String raw) {
    return raw
        .split(',')
        .map((t) => t.trim())
        .where((t) => t.isNotEmpty)
        .toSet()
        .toList();
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _isSaving = true);

    final entry = Entry(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: _titleController.text.trim(),
      body: _bodyController.text.trim(),
      tags: _parseTags(_tagsController.text),
      createdAt: DateTime.now(),
    );

    await ref.read(entriesNotifierProvider.notifier).add(entry);

    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: false,
            pinned: true,
            backgroundColor: colorScheme.surface,
            scrolledUnderElevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.close),
              tooltip: 'Discard',
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: Text(
              'New Entry',
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: _isSaving
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : FilledButton(
                        onPressed: _save,
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          minimumSize: const Size(0, 36),
                          shape: const StadiumBorder(),
                        ),
                        child: const Text('Save'),
                      ),
              ),
            ],
          ),
          SliverPadding(
            padding: EdgeInsets.fromLTRB(
              20,
              8,
              20,
              MediaQuery.paddingOf(context).bottom + 32,
            ),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),

                      // Title
                      TextFormField(
                        controller: _titleController,
                        autofocus: true,
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

                      const SizedBox(height: 20),
                      Divider(
                        color: colorScheme.outlineVariant.withValues(
                          alpha: 0.5,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Body
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

                      const SizedBox(height: 32),
                      Divider(
                        color: colorScheme.outlineVariant.withValues(
                          alpha: 0.5,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Tags label
                      Text(
                        'TAGS',
                        style: textTheme.labelSmall?.copyWith(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.4,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Tags input
                      TextFormField(
                        controller: _tagsController,
                        textCapitalization: TextCapitalization.words,
                        style: textTheme.bodyMedium,
                        decoration: InputDecoration(
                          hintText: 'Flutter, Design, Architecture...',
                          hintStyle: textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurface.withValues(
                              alpha: 0.35,
                            ),
                          ),
                          helperText: 'Separate tags with commas',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: colorScheme.outlineVariant,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: colorScheme.outlineVariant,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: colorScheme.primary,
                              width: 2,
                            ),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
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
