import 'package:flutter/foundation.dart';
import '../models/browser_tab.dart';

/// Manages the state of all open browser tabs.
class TabManager extends ChangeNotifier {
  final List<BrowserTab> _tabs = [];
  int _currentIndex = 0;

  List<BrowserTab> get tabs => List.unmodifiable(_tabs);
  int get currentIndex => _currentIndex;
  BrowserTab get currentTab => _tabs[_currentIndex];

  TabManager() {
    // Start with one initial tab
    addTab('about:newtab');
  }

  void addTab(String url) {
    final tab = BrowserTab(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      url: url,
    );
    _tabs.add(tab);
    _currentIndex = _tabs.length - 1;
    notifyListeners();
  }

  void closeTab(int index) {
    if (_tabs.length == 1) {
      // If closing the last tab, replace with a new tab
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
    currentTab.url = url;
    notifyListeners();
  }
}
