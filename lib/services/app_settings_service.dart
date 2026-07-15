import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../filesystem/local_novafs.dart';

class AppSettingsService extends ChangeNotifier {
  final LocalNovaFS _fs = LocalNovaFS();
  final String _settingsFile = 'novafs://Browser/settings.json';

  bool _forceDarkMode = false;
  bool _aggressiveCache = true;

  bool get forceDarkMode => _forceDarkMode;
  bool get aggressiveCache => _aggressiveCache;

  AppSettingsService() {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    try {
      if (await _fs.exists(_settingsFile)) {
        final content = await _fs.read(_settingsFile);
        final data = jsonDecode(content);
        _forceDarkMode = data['forceDarkMode'] ?? false;
        _aggressiveCache = data['aggressiveCache'] ?? true;
        notifyListeners();
      }
    } catch (e) {}
  }

  Future<void> setForceDarkMode(bool value) async {
    _forceDarkMode = value;
    notifyListeners();
    await _saveSettings();
  }

  Future<void> setAggressiveCache(bool value) async {
    _aggressiveCache = value;
    notifyListeners();
    await _saveSettings();
  }

  Future<void> _saveSettings() async {
    final data = {
      'forceDarkMode': _forceDarkMode,
      'aggressiveCache': _aggressiveCache,
    };
    await _fs.write(_settingsFile, jsonEncode(data));
  }
}
