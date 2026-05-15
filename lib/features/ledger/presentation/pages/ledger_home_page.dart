import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/localization/app_language.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../shared/utils/sync_error_message.dart';
import '../../../../shared/widgets/app_drawer.dart';
import '../../../../shared/widgets/app_empty_state.dart';
import '../../../../shared/widgets/sync_action_button.dart';
import '../../../drivers/domain/driver.dart';
import '../../../drivers/presentation/providers/driver_providers.dart';
import '../../domain/ledger_main.dart';
import 'ledger_detail_page.dart';
import '../providers/ledger_providers.dart';

class LedgerHomePage extends ConsumerStatefulWidget {
  const LedgerHomePage({super.key});

  @override
  ConsumerState<LedgerHomePage> createState() => _LedgerHomePageState();
}

class _LedgerHomePageState extends ConsumerState<LedgerHomePage> {
  bool _isSyncing = false;

  @override
  Widget build(BuildContext context) {
    final drivers = ref.watch(localDriversProvider);
    final ledgers = ref.watch(localLedgerMainsProvider);
    final strings = ref.watch(appStringsProvider);

    return Scaffold(
      drawer: const AppDrawer(selectedDestination: AppDrawerDestination.ledger),
      appBar: AppBar(
        title: Text(strings.ledgerTitle),
        centerTitle: false,
        actions: [
          SyncActionButton(
            isSyncing: _isSyncing,
            onPressed: _syncLedgers,
            tooltip: strings.syncLedgerTooltip,
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: _LedgerPanel(drivers: drivers, ledgers: ledgers),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: drivers.isEmpty
            ? null
            : () => _showCreateLedgerDialog(context, ref, drivers),
        icon: const Icon(Icons.add),
        label: Text(strings.createLedger),
      ),
    );
  }

  Future<void> _syncLedgers() async {
    if (_isSyncing) return;
    setState(() => _isSyncing = true);
    final messenger = ScaffoldMessenger.of(context);
    final strings = ref.read(appStringsProvider);
    try {
      await ref.read(localLedgerMainsProvider.notifier).syncWithFirebase();
      if (!mounted) return;
      messenger.showSnackBar(SnackBar(content: Text(strings.ledgerSynced)));
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

class _LedgerPanel extends ConsumerWidget {
  const _LedgerPanel({required this.drivers, required this.ledgers});

  final List<Driver> drivers;
  final List<LedgerMain> ledgers;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = ref.watch(appStringsProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: ledgers.isEmpty
              ? AppEmptyState(
                  icon: Icons.receipt_long_outlined,
                  title: strings.noLedgersTitle,
                  message: strings.noLedgersMessage,
                )
              : ListView.builder(
                  itemCount: ledgers.length,
                  itemBuilder: (context, index) {
                    return _LedgerTile(
                      ledger: ledgers[index],
                      driver: _driverFor(drivers, ledgers[index].driverId),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Driver? _driverFor(List<Driver> drivers, String driverId) {
    for (final driver in drivers) {
      if (driver.id == driverId) return driver;
    }
    return null;
  }
}

class _LedgerTile extends ConsumerWidget {
  const _LedgerTile({required this.ledger, required this.driver});

  final LedgerMain ledger;
  final Driver? driver;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = ref.watch(appStringsProvider);
    final resolvedDriver =
        driver ??
        Driver(
          id: ledger.driverId,
          name: 'Unknown Driver',
          createdAt: ledger.createdAt,
          updatedAt: ledger.updatedAt,
        );

    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: Colors.black.withAlpha(18)),
      ),
      child: ListTile(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute<void>(
              builder: (context) {
                return LedgerDetailPage(ledger: ledger, driver: resolvedDriver);
              },
            ),
          );
        },
        leading: const CircleAvatar(child: Icon(Icons.receipt_long_outlined)),
        title: Text(
          resolvedDriver.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        subtitle: Text(
          '${strings.dispatchDate}: ${formatDate(ledger.dispatchDate)}',
        ),
        trailing: Text(
          strings.statusValue(ledger.status.value),
          style: Theme.of(context).textTheme.labelLarge,
        ),
      ),
    );
  }
}

Future<void> _showCreateLedgerDialog(
  BuildContext context,
  WidgetRef ref,
  List<Driver> drivers,
) async {
  var selectedDriverId = drivers.first.id;
  var dispatchDate = DateTime.now();
  final strings = ref.read(appStringsProvider);

  await showDialog<void>(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            title: Text(strings.createLedger),
            content: SizedBox(
              width: 420,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  DropdownButtonFormField<String>(
                    initialValue: selectedDriverId,
                    decoration: InputDecoration(labelText: strings.driver),
                    items: [
                      for (final driver in drivers)
                        DropdownMenuItem(
                          value: driver.id,
                          child: Text(driver.name),
                        ),
                    ],
                    onChanged: (value) {
                      if (value == null) return;
                      setDialogState(() => selectedDriverId = value);
                    },
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    onPressed: () async {
                      final pickedDate = await showDatePicker(
                        context: context,
                        initialDate: dispatchDate,
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2100),
                      );
                      if (pickedDate == null) return;
                      setDialogState(() => dispatchDate = pickedDate);
                    },
                    icon: const Icon(Icons.calendar_month_outlined),
                    label: Text(formatDate(dispatchDate)),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(strings.cancel),
              ),
              FilledButton(
                onPressed: () async {
                  final ledger = await ref
                      .read(localLedgerMainsProvider.notifier)
                      .createLedger(
                        driverId: selectedDriverId,
                        dispatchDate: dispatchDate,
                      );
                  ref.read(selectedLedgerIdProvider.notifier).select(ledger.id);
                  if (context.mounted) {
                    Navigator.pop(context);
                  }
                },
                child: Text(strings.createLedgerShort),
              ),
            ],
          );
        },
      );
    },
  );
}
