import 'dart:convert';
import '../filesystem/local_novafs.dart';

/// Manages browser history using NovaFS.
class HistoryService {
  final LocalNovaFS _fs = LocalNovaFS();
  final String _historyFile = 'novafs://Browser/history.json';

  Future<List<Map<String, String>>> getHistory() async {
    try {
      if (!await _fs.exists(_historyFile)) return [];
      final content = await _fs.read(_historyFile);
      final List<dynamic> data = jsonDecode(content);
      return data.map((e) => Map<String, String>.from(e)).toList();
    } catch (e) {
      return [];
    }
  }

  Future<void> addEntry(String url, String title) async {
    // Don't save internal pages
    if (url.startsWith('about:') || 
        url.startsWith('nova://') || 
        url.startsWith('browser://')) {
      return;
    }

    final history = await getHistory();
    history.insert(0, {
      'url': url,
      'title': title,
      'time': DateTime.now().toIso8601String(),
    });
    
    // Limit history to 100 items for performance
    if (history.length > 100) {
      history.removeLast();
    }
    
    await _fs.write(_historyFile, jsonEncode(history));
  }

  Future<void> clearHistory() async {
    if (await _fs.exists(_historyFile)) {
      await _fs.delete(_historyFile);
    }
  }
}
