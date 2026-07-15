import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:provider/provider.dart';
import '../services/tab_manager.dart';
import 'find_in_page_bar.dart';

class WebViewContainer extends StatefulWidget {
  final WebViewController controller;
  const WebViewContainer({Key? key, required this.controller}) : super(key: key);

  @override
  State<WebViewContainer> createState() => _WebViewContainerState();
}

class _WebViewContainerState extends State<WebViewContainer> {
  bool _showFindBar = false;

  void _toggleFindBar() {
    setState(() {
      _showFindBar = !_showFindBar;
    });
  }

  @override
  Widget build(BuildContext context) {
    final tabManager = context.watch<TabManager>();
    final tab = tabManager.currentTab;

    return Stack(
      children: [
        RefreshIndicator(
          onRefresh: () async {
            await widget.controller.reload();
          },
          child: WebViewWidget(controller: widget.controller),
        ),
        if (tab.isLoading)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: LinearProgressIndicator(
              backgroundColor: Colors.transparent,
              valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).colorScheme.primary),
              minHeight: 3,
            ),
          ),
        if (_showFindBar)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: FindInPageBar(),
          ),
      ],
    );
  }
}
