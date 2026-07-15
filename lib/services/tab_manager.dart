import 'package:flutter/foundation.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/browser_tab.dart';
import 'history_service.dart';
import 'bookmarks_service.dart';
import 'download_manager.dart';

class TabManager extends ChangeNotifier {
  final List<BrowserTab> _tabs = [];
  int _currentIndex = 0;
  final HistoryService _historyService = HistoryService();
  final BookmarksService _bookmarksService = BookmarksService();
  final DownloadManager _downloadManager = DownloadManager();

  List<BrowserTab> get tabs => List.unmodifiable(_tabs);
  int get currentIndex => _currentIndex;
  BrowserTab get currentTab => _tabs[_currentIndex];

  TabManager() {
    addTab('about:newtab');
  }

  void addTab(String url, {bool isIncognito = false}) {
    final tab = BrowserTab(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      url: url,
      isIncognito: isIncognito,
    );
    
    if (_isWebUrl(url)) {
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
    
    if (_isWebUrl(url)) {
      if (tab.controller == null) {
        tab.controller = _initController(tab, url);
      } else {
        tab.controller!.loadRequest(Uri.parse(url));
      }
    } else {
      tab.controller = null; 
    }
    notifyListeners();
  }

  Future<bool> goBack() async {
    final tab = currentTab;
    if (tab.controller != null && await tab.controller!.canGoBack()) {
      await tab.controller!.goBack();
      return true;
    }
    return false;
  }

  Future<void> toggleBookmark() async {
    final tab = currentTab;
    if (tab.url.startsWith('http') && !tab.isIncognito) {
      final isBookmarked = await _bookmarksService.isBookmarked(tab.url);
      if (isBookmarked) {
        await _bookmarksService.removeBookmark(tab.url);
      } else {
        await _bookmarksService.addBookmark(tab.url, tab.title);
      }
      notifyListeners();
    }
  }

  Future<void> toggleDesktopMode() async {
    final tab = currentTab;
    if (tab.controller == null) return;

    tab.isDesktopMode = !tab.isDesktopMode;
    if (tab.isDesktopMode) {
      await tab.controller!.setUserAgent(
        'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/114.0.0.0 Safari/537.36'
      );
    } else {
      await tab.controller!.setUserAgent('');
    }
    tab.controller!.reload();
    notifyListeners();
  }

  Future<void> toggleReaderMode() async {
    final tab = currentTab;
    if (tab.controller == null) return;

    tab.isReaderMode = !tab.isReaderMode;
    if (tab.isReaderMode) {
      await tab.controller!.runJavaScript('''
        document.body.style.backgroundColor = '#fdf6e3';
        document.body.style.color = '#333';
        document.querySelectorAll('img, iframe, video, ad').forEach(e => e.style.display = 'none');
      ''');
    } else {
      tab.controller!.reload();
    }
    notifyListeners();
  }

  Future<void> findInPage(String query) async {
    final tab = currentTab;
    if (tab.controller == null || query.isEmpty) return;
    await tab.controller!.runJavaScript('window.find("$query", false, false, true, false, true, false)');
  }

  // Helper to check if URL should render a WebView
  bool _isWebUrl(String url) {
    return url.startsWith('http') || url.startsWith('https');
  }

  WebViewController _initController(BrowserTab tab, String initialUrl) {
    final controller = WebViewController()
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
          onPageFinished: (url) async {
            tab.url = url;
            tab.isLoading = false;
            final title = await tab.controller!.getTitle();
            tab.title = title ?? 'Untitled';
            if (!tab.isIncognito) {
              _historyService.addEntry(url, tab.title);
            }
            notifyListeners();
          },
          // Intercept navigation requests (PDFs & External Apps)
          onNavigationRequest: (request) async {
            final url = request.url;
            
            // 1. Open External Apps (mailto:, tel:, intent:, geo:)
            if (url.startsWith('mailto:') || url.startsWith('tel:') || url.startsWith('intent:') || url.startsWith('geo:')) {
              if (await canLaunchUrl(Uri.parse(url))) {
                await launchUrl(Uri.parse(url));
              }
              return NavigationDecision.prevent;
            }

            // 2. Built-in PDF Viewer
            if (url.endsWith('.pdf')) {
              final pdfViewerUrl = 'https://docs.google.com/gview?embedded=true&url=$url';
              tab.controller!.loadRequest(Uri.parse(pdfViewerUrl));
              return NavigationDecision.prevent;
            }

            return NavigationDecision.navigate;
          },
        ),
      )
      ..setOnDownloadPermissionRequest((request) async {
        final url = request.url.toString();
        final filename = url.split('/').last.split('?').first;
        await _downloadManager.startDownload(url, filename);
        return DownloadPermissionResponse.allow;
      })
      ..loadRequest(Uri.parse(initialUrl));

    return controller;
  }
}
