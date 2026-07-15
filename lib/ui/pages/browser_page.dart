import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/tab_manager.dart';
import 'new_tab_page.dart';
import '../widgets/url_bar.dart';
import '../widgets/web_view_container.dart';

/// The main browser shell that holds the URL bar, WebViews, and Tab Bar.
class BrowserPage extends StatefulWidget {
  const BrowserPage({Key? key}) : super(key: key);

  @override
  State<BrowserPage> createState() => _BrowserPageState();
}

class _BrowserPageState extends State<BrowserPage> {
  DateTime? _lastBackPressed;

  @override
  Widget build(BuildContext context) {
    final tabManager = context.watch<TabManager>();
    final currentTab = tabManager.currentTab;

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) return;
        
        // Try to go back in webview history first
        final wentBack = await tabManager.goBack();
        if (!wentBack) {
          // If no webview history, close app (or close tab)
          Navigator.of(context).maybePop();
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              // Top URL Bar
              UrlBar(),
              // Main Content Area
              Expanded(
                child: _renderContent(currentTab),
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
                            Icon(
                              tab.isLoading ? Icons.hourglass_empty : Icons.public, 
                              size: 16
                            ),
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
      ),
    );
  }

  Widget _renderContent(BrowserTab tab) {
    // Handle Internal Pages
    if (tab.url == 'about:newtab') {
      return const NewTabPage();
    }
    if (tab.url == 'nova://settings') {
      return const Center(child: Text('Nova Settings (Coming in Cycle 4)'));
    }
    
    // Handle Standard Web Pages
    if (tab.controller != null) {
      return WebViewContainer(controller: tab.controller!);
    }
    
    // Fallback loading screen
    return const Center(child: CircularProgressIndicator());
  }
}
