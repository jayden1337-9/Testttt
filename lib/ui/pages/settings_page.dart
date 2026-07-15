import 'package:flutter/material.dart';
import '../services/history_service.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nova Settings'),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.history),
            title: const Text('Clear Browsing History'),
            subtitle: const Text('Removes all saved history from NovaFS'),
            onTap: () async {
              final historyService = HistoryService();
              await historyService.clearHistory();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('History cleared successfully!')),
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('About Nova Browser'),
            subtitle: const Text('Version 1.0.0 (Cycle 4)'),
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
