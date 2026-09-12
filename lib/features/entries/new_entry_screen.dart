import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:today_i_learned/core/models/entry.dart';
import 'package:today_i_learned/core/providers/providers.dart';
import 'package:today_i_learned/features/entries/tags_input_section.dart';

class NewEntryScreen extends ConsumerStatefulWidget {
  const NewEntryScreen({super.key});

  @override
  ConsumerState<NewEntryScreen> createState() => _NewEntryScreenState();
}

class _NewEntryScreenState extends ConsumerState<NewEntryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();
  List<String> _tags = [];
  bool _isSaving = false;

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _isSaving = true);

    final entry = Entry(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: _titleController.text.trim(),
      body: _bodyController.text.trim(),
      tags: _tags,
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
          // --- AppBar ---
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

          // --- Form ---
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

                      // --- Title ---
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

                      const SizedBox(height: 40),

                      // --- Tags ---
                      // --- Tags ---
                      TagsInputSection(
                        tags: _tags,
                        onChanged: (tags) => setState(() => _tags = tags),
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
