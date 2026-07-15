import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/app_settings_service.dart';

class AboutFlagsPage extends StatelessWidget {
  const AboutFlagsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<AppSettingsService>();

    return Scaffold(
      appBar: AppBar(title: const Text('about:flags')),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Force Dark Mode on All Sites'),
            subtitle: const Text('Injects CSS to force dark backgrounds (Experimental).'),
            value: settings.forceDarkMode,
            onChanged: (val) => settings.setForceDarkMode(val),
          ),
          SwitchListTile(
            title: const Text('Aggressive Caching'),
            subtitle: const Text('Ignores cache-control headers to save data.'),
            value: settings.aggressiveCache,
            onChanged: (val) => settings.setAggressiveCache(val),
          ),
        ],
      ),
    );
  }
}
