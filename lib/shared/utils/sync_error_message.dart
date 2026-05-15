String syncErrorMessage(Object error) {
  final raw = error.toString().trim();
  if (raw.isEmpty) {
    return 'Sync failed. Please try again.';
  }

  final lower = raw.toLowerCase();
  if (lower.contains('permission-denied') ||
      lower.contains('permission denied')) {
    return 'Sync failed. Please check Firebase rules and login again.';
  }
  if (lower.contains('network') ||
      lower.contains('unavailable') ||
      lower.contains('deadline-exceeded')) {
    return 'Sync failed. Please check the internet connection and try again.';
  }
  if (lower.contains('unauthenticated') || lower.contains('auth')) {
    return 'Sync failed. Please login again.';
  }

  return 'Sync failed. Please try again.';
}
