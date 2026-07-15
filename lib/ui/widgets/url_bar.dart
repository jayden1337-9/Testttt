import 'package:flutter/material.dart';
import '../services/tab_manager.dart';
import '../services/bookmarks_service.dart';
import 'package:provider/provider.dart';

class UrlBar extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  UrlBar({Key? key}) : super(key: key);

  String _formatInput(String input) {
    if (input.startsWith('about:') || 
        input.startsWith('nova://') || 
        input.startsWith('browser://') || 
        input.startsWith('novafs://')) {
      return input;
    }
    
    if (input.contains('.') && !input.contains(' ')) {
      if (!input.startsWith('http://') && !input.startsWith('https://')) {
        return 'https://$input';
      }
      return input;
    }
    
    return 'https://duckduckgo.com/?q=${Uri.encodeComponent(input)}';
  }

  @override
  Widget build(BuildContext context) {
    final tabManager = context.watch<TabManager>();
    final currentUrl = tabManager.currentTab.url;
    _controller.text = currentUrl == 'about:newtab' ? '' : currentUrl;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () => tabManager.updateUrl('browser://history'),
          ),
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Search or type URL',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                prefixIcon: const Icon(Icons.lock_outline, size: 20),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: () => tabManager.updateUrl(currentUrl),
                ),
              ),
              onSubmitted: (value) {
                if (value.isNotEmpty) {
                  tabManager.updateUrl(_formatInput(value));
                }
              },
            ),
          ),
          // Bookmark Button (Dynamic Icon)
          if (currentUrl.startsWith('http'))
            FutureBuilder<bool>(
              future: BookmarksService().isBookmarked(currentUrl),
              builder: (context, snapshot) {
                final isBookmarked = snapshot.data ?? false;
                return IconButton(
                  icon: Icon(isBookmarked ? Icons.star : Icons.star_border),
                  onPressed: () => tabManager.toggleBookmark(),
                );
              },
            ),
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () => tabManager.updateUrl('about:downloads'),
          ),
          IconButton(
            icon: const Icon(Icons.folder_open),
            onPressed: () => tabManager.updateUrl('novafs://'),
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => tabManager.updateUrl('nova://settings'),
          ),
        ],
      ),
    );
  }
}
