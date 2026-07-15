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
    final currentTab = tabManager.currentTab;
    _controller.text = currentTab.url == 'about:newtab' ? '' : currentTab.url;

    return Container(
      color: currentTab.isIncognito ? Colors.grey[900] : null,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            if (currentTab.isIncognito)
              const Padding(
                padding: EdgeInsets.only(left: 8.0, right: 4.0),
                child: Icon(Icons.privacy_tip, color: Colors.white, size: 20),
              ),
            IconButton(
              icon: const Icon(Icons.history),
              onPressed: () => tabManager.updateUrl('browser://history'),
            ),
            Expanded(
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: currentTab.isIncognito ? 'Search privately' : 'Search or type URL',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  prefixIcon: const Icon(Icons.lock_outline, size: 20),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.refresh),
                    onPressed: () => tabManager.updateUrl(currentTab.url),
                  ),
                ),
                onSubmitted: (value) {
                  if (value.isNotEmpty) {
                    tabManager.updateUrl(_formatInput(value));
                  }
                },
              ),
            ),
            if (currentTab.url.startsWith('http') && !currentTab.isIncognito)
              FutureBuilder<bool>(
                future: BookmarksService().isBookmarked(currentTab.url),
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
            // Kebab menu for New Tab / New Incognito Tab
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert),
              onSelected: (value) {
                if (value == 'new_tab') tabManager.addTab('about:newtab');
                if (value == 'new_incognito') tabManager.addTab('about:newtab', isIncognito: true);
                if (value == 'settings') tabManager.updateUrl('nova://settings');
              },
              itemBuilder: (context) => [
                const PopupMenuItem(value: 'new_tab', child: Text('New Tab')),
                const PopupMenuItem(value: 'new_incognito', child: Text('New Incognito Tab')),
                const PopupMenuItem(value: 'settings', child: Text('Settings')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
