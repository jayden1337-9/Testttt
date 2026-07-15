import 'dart:io';

/// Defines the contract for the NovaFS virtual filesystem.
abstract class NovaFS {
  Future<String> read(String path);
  Future<void> write(String path, String content);
  Future<void> move(String from, String to);
  Future<void> copy(String from, String to);
  Future<void> delete(String path, {bool recursive = false});
  Future<bool> exists(String path);
  Future<FileMetadata> metadata(String path);
  Future<List<String>> listDirectory(String path);
}

class FileMetadata {
  final String name;
  final int size;
  final DateTime modified;
  final bool isDirectory;

  FileMetadata({
    required this.name,
    required this.size,
    required this.modified,
    required this.isDirectory,
  });
}
