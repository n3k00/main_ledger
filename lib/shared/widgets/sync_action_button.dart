import 'package:flutter/material.dart';

class SyncActionButton extends StatelessWidget {
  const SyncActionButton({
    super.key,
    required this.isSyncing,
    required this.onPressed,
    required this.tooltip,
  });

  final bool isSyncing;
  final VoidCallback onPressed;
  final String tooltip;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: isSyncing ? null : onPressed,
      tooltip: tooltip,
      icon: isSyncing
          ? const SizedBox.square(
              dimension: 20,
              child: CircularProgressIndicator(strokeWidth: 2.2),
            )
          : const Icon(Icons.sync),
    );
  }
}
