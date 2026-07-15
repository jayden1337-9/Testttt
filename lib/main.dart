import 'package:flutter/material.dart';
import 'ui/pages/new_tab_page.dart';

void main() {
  runApp(const NovaBrowserApp());
}

class NovaBrowserApp extends StatelessWidget {
  const NovaBrowserApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
      home: const BrowserShell(),
    );
  }
}

class BrowserShell extends StatelessWidget {
  const BrowserShell({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const NewTabPage();
  }
}
