import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/localization/app_language.dart';
import '../../../../shared/widgets/app_drawer.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = ref.watch(appStringsProvider);
    final language = ref.watch(appLanguageProvider);

    return Scaffold(
      drawer: const AppDrawer(
        selectedDestination: AppDrawerDestination.settings,
      ),
      appBar: AppBar(title: Text(strings.settings), centerTitle: false),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black.withAlpha(18)),
                borderRadius: BorderRadius.circular(8),
                color: Theme.of(context).colorScheme.surface,
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      strings.languageLabel,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 12),
                    SegmentedButton<AppLanguage>(
                      segments: [
                        ButtonSegment(
                          value: AppLanguage.english,
                          label: Text(strings.english),
                        ),
                        ButtonSegment(
                          value: AppLanguage.burmese,
                          label: Text(strings.burmese),
                        ),
                      ],
                      selected: {language},
                      onSelectionChanged: (selection) {
                        ref
                            .read(appLanguageProvider.notifier)
                            .setLanguage(selection.single);
                      },
                    ),
                    const SizedBox(height: 8),
                    Text(
                      strings.displayLanguage,
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: Colors.black54),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
