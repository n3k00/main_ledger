import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/date_formatter.dart';
import '../../../../core/utils/money_formatter.dart';
import '../../../../shared/utils/sync_error_message.dart';
import '../../../../shared/widgets/app_drawer.dart';
import '../../../../shared/widgets/app_empty_state.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../../../shared/widgets/sync_action_button.dart';
import '../../domain/parcel.dart';
import '../providers/parcel_providers.dart';
import 'parcel_detail_page.dart';

class ParcelsPage extends ConsumerStatefulWidget {
  const ParcelsPage({super.key});

  @override
  ConsumerState<ParcelsPage> createState() => _ParcelsPageState();
}

class _ParcelsPageState extends ConsumerState<ParcelsPage> {
  final _searchController = TextEditingController();
  bool _isSyncing = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final parcels = ref.watch(parcelsListProvider);

    return Scaffold(
      drawer: const AppDrawer(
        selectedDestination: AppDrawerDestination.parcels,
      ),
      appBar: AppBar(
        title: const Text('Parcels'),
        centerTitle: false,
        actions: [
          SyncActionButton(
            isSyncing: _isSyncing,
            onPressed: _syncParcels,
            tooltip: 'Sync parcels',
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppTextField(
                controller: _searchController,
                labelText: 'Search parcels',
                hintText: 'Tracking ID, receiver, phone, sender, town',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isEmpty
                    ? null
                    : IconButton(
                        onPressed: () {
                          _searchController.clear();
                          ref.read(parcelsListProvider.notifier).setQuery('');
                          setState(() {});
                        },
                        tooltip: 'Clear search',
                        icon: const Icon(Icons.close),
                      ),
                onChanged: (value) {
                  ref.read(parcelsListProvider.notifier).setQuery(value);
                  setState(() {});
                },
              ),
              const SizedBox(height: 12),
              Expanded(
                child: parcels.isEmpty
                    ? _EmptyParcelsState(
                        hasQuery: _searchController.text.trim().isNotEmpty,
                      )
                    : ListView.builder(
                        itemCount: parcels.length,
                        itemBuilder: (context, index) {
                          return _ParcelTile(parcel: parcels[index]);
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _syncParcels() async {
    if (_isSyncing) return;
    setState(() => _isSyncing = true);
    final messenger = ScaffoldMessenger.of(context);
    try {
      await ref.read(parcelsListProvider.notifier).syncTwoWay();
      if (!mounted) return;
      messenger.showSnackBar(const SnackBar(content: Text('Parcels synced.')));
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

class _ParcelTile extends StatelessWidget {
  const _ParcelTile({required this.parcel});

  final Parcel parcel;

  @override
  Widget build(BuildContext context) {
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
              builder: (context) => ParcelDetailPage(parcel: parcel),
            ),
          );
        },
        leading: const CircleAvatar(child: Icon(Icons.inventory_2_outlined)),
        title: Text(
          parcel.trackingId,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
        subtitle: Text(
          '${parcel.receiverName}  |  ${parcel.fromTown} to ${parcel.toTown}',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: SizedBox(
          width: 160,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('${formatMoney(parcel.totalCharges.round())} Ks'),
              Text(
                formatDate(parcel.updatedAt),
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: Colors.black54),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyParcelsState extends StatelessWidget {
  const _EmptyParcelsState({required this.hasQuery});

  final bool hasQuery;

  @override
  Widget build(BuildContext context) {
    return AppEmptyState(
      icon: Icons.inventory_2_outlined,
      title: hasQuery ? 'No matching parcels' : 'No parcels found',
      message: hasQuery
          ? 'Try another tracking ID, receiver, phone, sender, or town.'
          : 'Sync with Firebase to load parcels from group mobile.',
    );
  }
}
