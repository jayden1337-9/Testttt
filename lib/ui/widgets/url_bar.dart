import 'package:flutter/material.dart';
import '../services/tab_manager.dart';
import 'package:provider/provider.dart';

/// The main search/URL input field.
class UrlBar extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  UrlBar({Key? key}) : super(key: key);

  String _formatInput(String input) {
    // If it's an internal protocol, leave it alone
    if (input.startsWith('about:') || 
        input.startsWith('nova://') || 
        input.startsWith('browser://') || 
        input.startsWith('novafs://')) {
      return input;
    }
    
    // If it looks like a URL, add https://
    if (input.contains('.') && !input.contains(' ')) {
      if (!input.startsWith('http://') && !input.startsWith('https://')) {
        return 'https://$input';
      }
      return input;
    }
    
    // Otherwise, treat it as a search query (using DuckDuckGo for privacy)
    return 'https://duckduckgo.com/?q=${Uri.encodeComponent(input)}';
  }

  @override
  Widget build(BuildContext context) {
    final tabManager = context.watch<TabManager>();
    _controller.text = tabManager.currentTab.url == 'about:newtab' ? '' : tabManager.currentTab.url;

    return Padding(
      padding: const EdgeInsets.all(8.0),
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
            onPressed: () {
              // Simple hack to force refresh: trigger notifyListeners
              // In Cycle 3 we will hook this directly to the WebViewController
              tabManager.updateUrl(tabManager.currentTab.url);
            },
          ),
        ),
        onSubmitted: (value) {
          if (value.isNotEmpty) {
            tabManager.updateUrl(_formatInput(value));
          }
        },
      ),
    );
  }
}
