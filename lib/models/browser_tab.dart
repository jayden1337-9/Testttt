import 'package:webview_flutter/webview_flutter.dart';

class BrowserTab {
  final String id;
  String url;
  String title;
  WebViewController? controller;
  bool isLoading;
  final bool isIncognito;
  bool isDesktopMode;
  bool isReaderMode;

  BrowserTab({
    required this.id,
    required this.url,
    this.title = 'New Tab',
    this.controller,
    this.isLoading = false,
    this.isIncognito = false,
    this.isDesktopMode = false,
    this.isReaderMode = false,
  });
}
