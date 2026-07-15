import 'package:flutter/material.dart';

class AboutFlagsPage extends StatefulWidget {
  const AboutFlagsPage({Key? key}) : super(key: key);

  @override
  State<AboutFlagsPage> createState() => _AboutFlagsPageState();
}

class _AboutFlagsPageState extends State<AboutFlagsPage> {
  bool _forceDarkMode = false;
  bool _aggressiveCache = true;
  bool _experimentalJs = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('about:flags')),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Force Dark Mode on All Sites'),
            subtitle: const Text('Injects CSS to force dark backgrounds (Experimental).'),
            value: _forceDarkMode,
            onChanged: (val) => setState(() => _forceDarkMode = val),
          ),
          SwitchListTile(
            title: const Text('Aggressive Caching'),
            subtitle: const Text('Ignores cache-control headers to save data.'),
            value: _aggressiveCache,
            onChanged: (val) => setState(() => _aggressiveCache = val),
          ),
          SwitchListTile(
            title: const Text('Experimental JavaScript Engine'),
            subtitle: const Text('Enables upcoming WebView JS features (Unstable).'),
            value: _experimentalJs,
            onChanged: (val) => setState(() => _experimentalJs = val),
          ),
        ],
      ),
    );
  }
}
