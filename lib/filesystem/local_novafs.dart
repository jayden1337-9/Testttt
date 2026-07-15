import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'novafs.dart';

/// Concrete implementation of NovaFS using local device storage.
class LocalNovaFS implements NovaFS {
  Future<Directory> _getRootDir() async {
    final dir = await getApplicationDocumentsDirectory();
    final novaDir = Directory('${dir.path}/NovaFS');
    if (!await novaDir.exists()) {
      await novaDir.create(recursive: true);
    }
    return novaDir;
  }

  /// Converts a novafs:// path to a physical device path
  Future<String> _resolvePath(String novafsPath) async {
    String cleanPath = novafsPath.replaceAll('novafs://', '');
    cleanPath = cleanPath.replaceAll(RegExp(r'\/+'), '/');
    
    final root = await _getRootDir();
    return '${root.path}/$cleanPath';
  }

  @override
  Future<String> read(String path) async {
    final physicalPath = await _resolvePath(path);
    final file = File(physicalPath);
    return await file.readAsString();
  }

  @override
  Future<void> write(String path, String content) async {
    final physicalPath = await _resolvePath(path);
    final file = File(physicalPath);
    final dir = file.parent;
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    await file.writeAsString(content);
  }

  @override
  Future<bool> exists(String path) async {
    final physicalPath = await _resolvePath(path);
    return await File(physicalPath).exists() || await Directory(physicalPath).exists();
  }

  @override
  Future<void> delete(String path, {bool recursive = false}) async {
    final physicalPath = await _resolvePath(path);
    final file = File(physicalPath);
    final dir = Directory(physicalPath);
    
    if (await file.exists()) {
      await file.delete();
    } else if (await dir.exists()) {
      await dir.delete(recursive: recursive);
    }
  }

  @override
  Future<void> copy(String from, String to) async {
    final fromPath = await _resolvePath(from);
    final toPath = await _resolvePath(to);
    await File(fromPath).copy(toPath);
  }

  @override
  Future<void> move(String from, String to) async {
    await copy(from, to);
    await delete(from);
  }

  @override
  Future<FileMetadata> metadata(String path) async {
    final physicalPath = await _resolvePath(path);
    final file = File(physicalPath);
    final dir = Directory(physicalPath);
    
    if (await file.exists()) {
      final stat = await file.stat();
      return FileMetadata(
        name: path.split('/').last,
        size: stat.size,
        modified: stat.modified,
        isDirectory: false,
      );
    } else if (await dir.exists()) {
      final stat = await dir.stat();
      return FileMetadata(
        name: path.split('/').last,
        size: 0,
        modified: stat.modified,
        isDirectory: true,
      );
    }
    throw Exception('Path does not exist: $path');
  }

  @override
  Future<List<String>> listDirectory(String path) async {
    final physicalPath = await _resolvePath(path);
    final dir = Directory(physicalPath);
    
    if (!await dir.exists()) {
      return [];
    }
    
    final contents = dir.listSync();
    return contents.map((entity) => 'novafs://${entity.path.split('NovaFS/').last}').toList();
  }
}
