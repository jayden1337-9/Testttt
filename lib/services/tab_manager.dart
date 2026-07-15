import 'package:flutter/foundation.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../models/browser_tab.dart';

/// Manages the state of all open browser tabs.
class TabManager extends ChangeNotifier {
  final List<BrowserTab> _tabs = [];
  int _currentIndex = 0;

  List<BrowserTab> get tabs => List.unmodifiable(_tabs);
  int get currentIndex => _currentIndex;
  BrowserTab get currentTab => _tabs[_currentIndex];

  TabManager() {
    addTab('about:newtab');
  }

  void addTab(String url) {
    final tab = BrowserTab(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      url: url,
    );
    
    // Initialize WebViewController immediately if it's a web URL
    if (!url.startsWith('about:') && !url.startsWith('nova://')) {
      tab.controller = _initController(tab, url);
    }
    
    _tabs.add(tab);
    _currentIndex = _tabs.length - 1;
    notifyListeners();
  }

  void closeTab(int index) {
    if (_tabs.length == 1) {
      _tabs.clear();
      addTab('about:newtab');
      return;
    }
    
    _tabs.removeAt(index);
    if (_currentIndex >= _tabs.length) {
      _currentIndex = _tabs.length - 1;
    }
    notifyListeners();
  }

  void switchTab(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  void updateUrl(String url) {
    final tab = currentTab;
    tab.url = url;
    
    // If navigating to a new web URL, initialize or reload controller
    if (!url.startsWith('about:') && !url.startsWith('nova://')) {
      if (tab.controller == null) {
        tab.controller = _initController(tab, url);
      } else {
        tab.controller!.loadRequest(Uri.parse(url));
      }
    } else {
      tab.controller = null; // Internal page, no webview needed
    }
    
    notifyListeners();
  }

  Future<bool> goBack() async {
    final tab = currentTab;
    if (tab.controller != null && await tab.controller!.canGoBack()) {
      await tab.controller!.goBack();
      return true;
    }
    return false; // Can't go back further in webview, close app/tab
  }

  WebViewController _initController(BrowserTab tab, String initialUrl) {
    return WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (progress) {
            tab.isLoading = progress < 100;
            notifyListeners();
          },
          onPageStarted: (url) {
            tab.url = url;
            tab.isLoading = true;
            notifyListeners();
          },
          onPageFinished: (url) {
            tab.url = url;
            tab.isLoading = false;
            tab.controller!.getTitle().then((title) {
              tab.title = title ?? 'Untitled';
              notifyListeners();
            });
          },
        ),
      )
      ..loadRequest(Uri.parse(initialUrl));
  }
}
