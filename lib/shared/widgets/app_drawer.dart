import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/auth_strings.dart';
import '../../core/localization/app_language.dart';
import '../../features/auth/presentation/providers/auth_providers.dart';
import '../../features/drivers/presentation/pages/drivers_page.dart';
import '../../features/parcels/presentation/pages/parcels_page.dart';
import '../../features/settings/presentation/pages/settings_page.dart';

enum AppDrawerDestination {
  ledger,
  drivers,
  parcels,
  commissions,
  settings,
  about,
}

class AppDrawer extends ConsumerWidget {
  const AppDrawer({super.key, required this.selectedDestination});

  final AppDrawerDestination selectedDestination;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(authStateChangesProvider).value;
    final strings = ref.watch(appStringsProvider);

    return Drawer(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DrawerHeader(
              margin: EdgeInsets.zero,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(
                    Icons.account_balance_wallet_outlined,
                    color: Theme.of(context).colorScheme.primary,
                    size: 36,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    strings.appName,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  if (currentUser != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      currentUser.phoneNumber,
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: Colors.black54),
                    ),
                  ],
                ],
              ),
            ),
            ListTile(
              selected: selectedDestination == AppDrawerDestination.ledger,
              leading: const Icon(Icons.receipt_long_outlined),
              title: Text(strings.ledger),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
            ),
            ListTile(
              selected: selectedDestination == AppDrawerDestination.drivers,
              leading: const Icon(Icons.people_outline),
              title: Text(strings.drivers),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (context) => const DriversPage(),
                  ),
                );
              },
            ),
            ListTile(
              selected: selectedDestination == AppDrawerDestination.parcels,
              leading: const Icon(Icons.local_shipping_outlined),
              title: Text(strings.parcels),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (context) => const ParcelsPage(),
                  ),
                );
              },
            ),
            ListTile(
              selected: selectedDestination == AppDrawerDestination.commissions,
              leading: const Icon(Icons.payments_outlined),
              title: Text(strings.commissions),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              selected: selectedDestination == AppDrawerDestination.settings,
              leading: const Icon(Icons.settings_outlined),
              title: Text(strings.settings),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (context) => const SettingsPage(),
                  ),
                );
              },
            ),
            const Spacer(),
            const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.logout),
              title: Text(strings.logout),
              onTap: () async {
                Navigator.pop(context);
                await ref.read(authServiceProvider).signOut();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text(AuthStrings.loggedOutMessage)),
                  );
                }
              },
            ),
            ListTile(
              selected: selectedDestination == AppDrawerDestination.about,
              leading: const Icon(Icons.info_outline),
              title: Text(strings.about),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }
}
