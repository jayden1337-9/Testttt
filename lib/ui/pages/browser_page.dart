import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/tab_manager.dart';
import 'new_tab_page.dart';
import 'settings_page.dart';
import 'history_page.dart';
import 'bookmarks_page.dart';
import 'downloads_page.dart';
import 'file_manager_page.dart';
import '../widgets/url_bar.dart';
import '../widgets/web_view_container.dart';

class BrowserPage extends StatefulWidget {
  const BrowserPage({Key? key}) : super(key: key);

  @override
  State<BrowserPage> createState() => _BrowserPageState();
}

class _BrowserPageState extends State<BrowserPage> {
  @override
  Widget build(BuildContext context) {
    final tabManager = context.watch<TabManager>();
    final currentTab = tabManager.currentTab;

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) return;
        final wentBack = await tabManager.goBack();
        if (!wentBack) {
          Navigator.of(context).maybePop();
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              UrlBar(),
              Expanded(
                child: _renderContent(currentTab),
              ),
              _buildTabBar(context, tabManager),
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
    if (tab.url == 'about:newtab') return const NewTabPage();
    if (tab.url == 'nova://settings') return const SettingsPage();
    if (tab.url == 'browser://history') return const HistoryPage();
    if (tab.url == 'browser://bookmarks') return const BookmarksPage();
    if (tab.url == 'about:downloads') return const DownloadsPage();
    if (tab.url.startsWith('novafs://')) return FileManagerPage(initialPath: tab.url);
    
    if (tab.controller != null) {
      return WebViewContainer(controller: tab.controller!);
    }
    
    return const Center(child: CircularProgressIndicator());
  }

  Widget _buildTabBar(BuildContext context, TabManager tabManager) {
    return Container(
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
                  Icon(tab.isLoading ? Icons.hourglass_empty : Icons.public, size: 16),
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
    );
  }
}
