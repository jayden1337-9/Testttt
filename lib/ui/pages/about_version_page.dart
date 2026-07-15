import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AboutVersionPage extends StatefulWidget {
  const AboutVersionPage({Key? key}) : super(key: key);

  @override
  State<AboutVersionPage> createState() => _AboutVersionPageState();
}

class _AboutVersionPageState extends State<AboutVersionPage> {
  PackageInfo? _packageInfo;

  @override
  void initState() {
    super.initState();
    _loadPackageInfo();
  }

  Future<void> _loadPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() => _packageInfo = info);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('about:version')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.public, size: 64, color: Colors.deepPurple),
            const SizedBox(height: 16),
            const Text('Nova Browser', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('Version: ${_packageInfo?.version ?? '1.0.0'}'),
            Text('Build: ${_packageInfo?.buildNumber ?? '1'}'),
            const SizedBox(height: 24),
            const Text('Powered by Flutter & WebView', style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
