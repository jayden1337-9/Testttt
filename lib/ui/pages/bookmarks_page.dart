import 'package:flutter/material.dart';
import '../services/bookmarks_service.dart';
import '../services/tab_manager.dart';
import 'package:provider/provider.dart';

class BookmarksPage extends StatefulWidget {
  const BookmarksPage({Key? key}) : super(key: key);

  @override
  State<BookmarksPage> createState() => _BookmarksPageState();
}

class _BookmarksPageState extends State<BookmarksPage> {
  List<Map<String, String>> _bookmarks = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadBookmarks();
  }

  Future<void> _loadBookmarks() async {
    final bookmarksService = BookmarksService();
    final bookmarks = await bookmarksService.getBookmarks();
    setState(() {
      _bookmarks = bookmarks;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bookmarks')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _bookmarks.isEmpty
              ? const Center(child: Text('No bookmarks yet.'))
              : ListView.builder(
                  itemCount: _bookmarks.length,
                  itemBuilder: (context, index) {
                    final item = _bookmarks[index];
                    return ListTile(
                      leading: const Icon(Icons.star),
                      title: Text(item['title'] ?? 'Untitled'),
                      subtitle: Text(item['url'] ?? ''),
                      onTap: () {
                        context.read<TabManager>().updateUrl(item['url']!);
                        Navigator.pop(context);
                      },
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_outline),
                        onPressed: () async {
                          await BookmarksService().removeBookmark(item['url']!);
                          _loadBookmarks();
                        },
                      ),
                    );
                  },
                ),
    );
  }
}
