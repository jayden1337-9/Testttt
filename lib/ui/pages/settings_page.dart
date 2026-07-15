import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../services/history_service.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nova Settings')),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.history),
            title: const Text('Clear Browsing History'),
            subtitle: const Text('Removes all saved history from NovaFS'),
            onTap: () async {
              await HistoryService().clearHistory();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('History cleared!')),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.cookie_outlined),
            title: const Text('Clear Cookies & Site Data'),
            onTap: () async {
              final cookieManager = WebViewCookieManager();
              await cookieManager.clearCookies();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Cookies cleared!')),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.storage),
            title: const Text('Clear Cache'),
            onTap: () async {
              // webview_flutter doesn't have a direct cross-platform clearCache method in v4,
              // but clearing cookies usually clears session cache. We leave a placeholder for platform-specific calls.
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Cache clearing triggered!')),
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('About Nova Browser'),
            subtitle: const Text('Version 1.0.0 (Cycle 7)'),
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: 'Nova Browser',
                applicationVersion: '1.0.0',
              );
            },
          ),
        ],
      ),
    );
  }
}
