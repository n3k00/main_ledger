import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/localization/app_language.dart';
import '../../../../shared/utils/sync_error_message.dart';
import '../../../../shared/widgets/app_drawer.dart';
import '../../../../shared/widgets/app_empty_state.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../../../shared/widgets/sync_action_button.dart';
import '../../domain/driver.dart';
import '../providers/driver_providers.dart';

class DriversPage extends ConsumerStatefulWidget {
  const DriversPage({super.key});

  @override
  ConsumerState<DriversPage> createState() => _DriversPageState();
}

class _DriversPageState extends ConsumerState<DriversPage> {
  bool _isSyncing = false;

  @override
  Widget build(BuildContext context) {
    final drivers = ref.watch(localDriversProvider);
    final strings = ref.watch(appStringsProvider);

    return Scaffold(
      drawer: const AppDrawer(
        selectedDestination: AppDrawerDestination.drivers,
      ),
      appBar: AppBar(
        title: Text(strings.drivers),
        centerTitle: false,
        actions: [
          SyncActionButton(
            isSyncing: _isSyncing,
            onPressed: _syncDrivers,
            tooltip: strings.syncDriversTooltip,
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: drivers.isEmpty
                    ? const _EmptyDriverState()
                    : ListView.builder(
                        itemCount: drivers.length,
                        itemBuilder: (context, index) {
                          final driver = drivers[index];
                          return _DriverTile(
                            driver: driver,
                            onEdit: () =>
                                _showDriverDialog(context, ref, driver: driver),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showDriverDialog(context, ref),
        icon: const Icon(Icons.person_add_alt_1),
        label: Text(strings.createDriver),
      ),
    );
  }

  Future<void> _syncDrivers() async {
    if (_isSyncing) return;
    setState(() => _isSyncing = true);
    final messenger = ScaffoldMessenger.of(context);
    final strings = ref.read(appStringsProvider);
    try {
      await ref.read(localDriversProvider.notifier).syncWithFirebase();
      if (!mounted) return;
      messenger.showSnackBar(SnackBar(content: Text(strings.driversSynced)));
    } catch (error) {
      if (!mounted) return;
      messenger.showSnackBar(SnackBar(content: Text(syncErrorMessage(error))));
    } finally {
      if (mounted) {
        setState(() => _isSyncing = false);
      }
    }
  }
}

class _DriverTile extends ConsumerWidget {
  const _DriverTile({required this.driver, required this.onEdit});

  final Driver driver;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = ref.watch(appStringsProvider);
    final subtitle = [
      if (driver.phone != null) driver.phone,
      if (driver.vehicleNumber != null) driver.vehicleNumber,
    ].join('  |  ');

    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: Colors.black.withAlpha(18)),
      ),
      child: ListTile(
        leading: const CircleAvatar(child: Icon(Icons.person_outline)),
        title: Text(
          driver.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        subtitle: subtitle.isEmpty
            ? null
            : Text(subtitle, maxLines: 1, overflow: TextOverflow.ellipsis),
        trailing: IconButton(
          onPressed: onEdit,
          tooltip: strings.editDriverTooltip,
          icon: const Icon(Icons.edit_outlined),
        ),
      ),
    );
  }
}

class _EmptyDriverState extends ConsumerWidget {
  const _EmptyDriverState();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = ref.watch(appStringsProvider);
    return AppEmptyState(
      icon: Icons.person_outline,
      title: strings.noDriversTitle,
      message: strings.noDriversMessage,
    );
  }
}

Future<void> _showDriverDialog(
  BuildContext context,
  WidgetRef ref, {
  Driver? driver,
}) async {
  final nameController = TextEditingController(text: driver?.name ?? '');
  final phoneController = TextEditingController(text: driver?.phone ?? '');
  final vehicleController = TextEditingController(
    text: driver?.vehicleNumber ?? '',
  );
  final isEditing = driver != null;
  final strings = ref.read(appStringsProvider);

  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    showDragHandle: true,
    builder: (sheetContext) {
      Future<void> saveDriver() async {
        if (nameController.text.trim().isEmpty) return;
        final notifier = ref.read(localDriversProvider.notifier);
        final messenger = ScaffoldMessenger.of(sheetContext);
        try {
          if (isEditing) {
            await notifier.updateDriver(
              id: driver.id,
              name: nameController.text,
              phone: phoneController.text,
              vehicleNumber: vehicleController.text,
            );
          } else {
            await notifier.createDriver(
              name: nameController.text,
              phone: phoneController.text,
              vehicleNumber: vehicleController.text,
            );
          }
          if (sheetContext.mounted) {
            Navigator.pop(sheetContext);
          }
        } catch (error) {
          messenger.showSnackBar(
            SnackBar(content: Text('Driver Firebase save failed: $error')),
          );
        }
      }

      final bottomInset = MediaQuery.viewInsetsOf(sheetContext).bottom;
      final screenHeight = MediaQuery.sizeOf(sheetContext).height;
      final availableHeight = screenHeight - bottomInset - 24;
      final sheetMaxHeight = availableHeight.clamp(220.0, screenHeight * 0.9);

      return AnimatedPadding(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        padding: EdgeInsets.only(bottom: bottomInset),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: 520,
              maxHeight: sheetMaxHeight,
            ),
            child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          isEditing ? strings.editDriver : strings.createDriver,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(sheetContext).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w800),
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(sheetContext),
                        tooltip: strings.close,
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  AppTextField(
                    controller: nameController,
                    labelText: strings.driverName,
                    prefixIcon: const Icon(Icons.person_outline),
                    autofocus: true,
                    textInputAction: TextInputAction.next,
                    scrollPadding: const EdgeInsets.only(bottom: 160),
                  ),
                  const SizedBox(height: 12),
                  AppTextField(
                    controller: phoneController,
                    labelText: strings.phone,
                    prefixIcon: const Icon(Icons.phone_outlined),
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.phone,
                    scrollPadding: const EdgeInsets.only(bottom: 160),
                  ),
                  const SizedBox(height: 12),
                  AppTextField(
                    controller: vehicleController,
                    labelText: strings.vehicleNumber,
                    prefixIcon: const Icon(Icons.local_shipping_outlined),
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) => unawaited(saveDriver()),
                    scrollPadding: const EdgeInsets.only(bottom: 160),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(sheetContext),
                        child: Text(strings.cancel),
                      ),
                      const SizedBox(width: 8),
                      FilledButton(
                        onPressed: () => unawaited(saveDriver()),
                        child: Text(isEditing ? strings.save : strings.create),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}
