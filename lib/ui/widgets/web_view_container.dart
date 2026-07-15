import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:provider/provider.dart';
import '../services/tab_manager.dart';

/// Renders the WebView with a loading bar and pull-to-refresh.
class WebViewContainer extends StatelessWidget {
  final WebViewController controller;
  
  const WebViewContainer({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tabManager = context.watch<TabManager>();
    final tab = tabManager.currentTab;

    return Stack(
      children: [
        // Pull to refresh & WebView
        RefreshIndicator(
          onRefresh: () async {
            await controller.reload();
          },
          child: WebViewWidget(controller: controller),
        ),
        
        // Top Loading Progress Bar
        if (tab.isLoading)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: LinearProgressIndicator(
              backgroundColor: Colors.transparent,
              valueColor: AlwaysStoppedAnimation<Color>(
                Theme.of(context).colorScheme.primary,
              ),
              minHeight: 3,
            ),
          ),
      ],
    );
  }
}
