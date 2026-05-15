import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/auth/presentation/pages/login_page.dart';
import '../features/auth/presentation/providers/auth_providers.dart';
import '../features/ledger/presentation/pages/ledger_home_page.dart';
import 'theme.dart';

class MainLedgerApp extends ConsumerWidget {
  const MainLedgerApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateChangesProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Main Ledger',
      theme: buildAppTheme(),
      home: authState.when(
        data: (user) =>
            user == null ? const LoginPage() : const LedgerHomePage(),
        loading: () => const _AuthLoadingPage(),
        error: (error, _) => _AuthErrorPage(error: error),
      ),
    );
  }
}

class _AuthLoadingPage extends StatelessWidget {
  const _AuthLoadingPage();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}

class _AuthErrorPage extends StatelessWidget {
  const _AuthErrorPage({required this.error});

  final Object error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text('Auth error: $error', textAlign: TextAlign.center),
        ),
      ),
    );
  }
}
