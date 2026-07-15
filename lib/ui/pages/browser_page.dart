import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:provider/provider.dart';
import '../services/tab_manager.dart';
import 'new_tab_page.dart';
import '../widgets/url_bar.dart';

/// The main browser shell that holds the URL bar, WebViews, and Tab Bar.
class BrowserPage extends StatefulWidget {
  const BrowserPage({Key? key}) : super(key: key);

  @override
  State<BrowserPage> createState() => _BrowserPageState();
}

class _BrowserPageState extends State<BrowserPage> {
  @override
  void initState() {
    super.initState();
    // Initialize Android WebView settings if needed
  }

  Widget _renderContent(String url) {
    // Handle Internal Pages
    if (url == 'about:newtab') {
      return const NewTabPage();
    }
    if (url == 'nova://settings') {
      return const Center(child: Text('Nova Settings (Coming in Cycle 4)'));
    }
    
    // Handle Standard Web Pages
    return WebViewWidget(
      controller: WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setNavigationDelegate(
          NavigationDelegate(
            onProgress: (progress) {
              // Update loading bar in Cycle 3
            },
          ),
        )
        ..loadRequest(Uri.parse(url)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tabManager = context.watch<TabManager>();
    final currentTab = tabManager.currentTab;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Top URL Bar
            UrlBar(),
            // Main Content Area
            Expanded(
              child: _renderContent(currentTab.url),
            ),
            // Bottom Tab Bar
            Container(
              height: 50,
              color: Theme.of(context).colorScheme.surface,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: tabManager.tabs.length,
                itemBuilder: (context, index) {
                  final tab = tabManager.tabs[index];
                  final isSelected = index == tabManager.currentIndex;
                  return GestureDetector(
                    onTap: () => tabManager.switchTab(index),
                    onLongPress: () => tabManager.closeTab(index),
                    child: Container(
                      width: 150,
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: isSelected ? Theme.of(context).colorScheme.primary : Colors.transparent,
                            width: 3,
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.public, size: 16),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              tab.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.small(
        onPressed: () => tabManager.addTab('about:newtab'),
        child: const Icon(Icons.add),
      ),
    );
  }
}
