class StorageException implements Exception {
  final String message;

  const StorageException([this.message = 'Storage error']);

  @override
  String toString() => message;
}
