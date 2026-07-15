import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../services/history_service.dart';
import 'security_settings_page.dart';
import 'domain_config_page.dart';
import 'about_version_page.dart';
import 'about_flags_page.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nova Settings')),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.security),
            title: const Text('Security & Privacy'),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SecuritySettingsPage())),
          ),
          ListTile(
            leading: const Icon(Icons.dns),
            title: const Text('Free Domains & Routing'),
            subtitle: const Text('Configure custom domain providers'),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const DomainConfigPage())),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.history),
            title: const Text('Clear Browsing History'),
            onTap: () async {
              await HistoryService().clearHistory();
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('History cleared!')));
            },
          ),
          ListTile(
            leading: const Icon(Icons.cookie_outlined),
            title: const Text('Clear Cookies & Site Data'),
            onTap: () async {
              await WebViewCookieManager().clearCookies();
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Cookies cleared!')));
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.flag),
            title: const Text('Experimental Flags'),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AboutFlagsPage())),
          ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('About Nova Browser'),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AboutVersionPage())),
          ),
          ListTile(
            leading: const Icon(Icons.gavel),
            title: const Text('Open Source Licenses'),
            onTap: () => showLicensePage(context: context, applicationName: 'Nova Browser'),
          ),
        ],
      ),
    );
  }
}
