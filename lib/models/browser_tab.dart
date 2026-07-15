import 'package:webview_flutter/webview_flutter.dart';

/// Represents a single browser tab state.
class BrowserTab {
  final String id;
  String url;
  String title;
  WebViewController? controller;
  bool isLoading;
  final bool isIncognito;

  BrowserTab({
    required this.id,
    required this.url,
    this.title = 'New Tab',
    this.controller,
    this.isLoading = false,
    this.isIncognito = false,
  });
}
