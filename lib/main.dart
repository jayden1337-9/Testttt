import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/tab_manager.dart';
import 'services/download_manager.dart';
import 'ui/pages/browser_page.dart';

void main() {
  runApp(const NovaBrowserApp());
}

class NovaBrowserApp extends StatelessWidget {
  const NovaBrowserApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => TabManager()),
        ChangeNotifierProvider(create: (context) => DownloadManager()),
      ],
      child: MaterialApp(
        title: 'Nova Browser',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
          brightness: Brightness.light,
        ),
        darkTheme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple, brightness: Brightness.dark),
          useMaterial3: true,
        ),
        themeMode: ThemeMode.system,
        home: const BrowserPage(),
      ),
    );
  }
}
