import 'dart:convert';
import '../filesystem/local_novafs.dart';

/// Manages bookmarks using NovaFS.
class BookmarksService {
  final LocalNovaFS _fs = LocalNovaFS();
  final String _bookmarksFile = 'novafs://Browser/bookmarks.json';

  Future<List<Map<String, String>>> getBookmarks() async {
    try {
      if (!await _fs.exists(_bookmarksFile)) return [];
      final content = await _fs.read(_bookmarksFile);
      final List<dynamic> data = jsonDecode(content);
      return data.map((e) => Map<String, String>.from(e)).toList();
    } catch (e) {
      return [];
    }
  }

  Future<void> addBookmark(String url, String title) async {
    final bookmarks = await getBookmarks();
    
    // Prevent duplicates
    if (bookmarks.any((b) => b['url'] == url)) return;

    bookmarks.add({
      'url': url,
      'title': title,
    });
    
    await _fs.write(_bookmarksFile, jsonEncode(bookmarks));
  }

  Future<void> removeBookmark(String url) async {
    final bookmarks = await getBookmarks();
    bookmarks.removeWhere((b) => b['url'] == url);
    await _fs.write(_bookmarksFile, jsonEncode(bookmarks));
  }

  Future<bool> isBookmarked(String url) async {
    final bookmarks = await getBookmarks();
    return bookmarks.any((b) => b['url'] == url);
  }
}
