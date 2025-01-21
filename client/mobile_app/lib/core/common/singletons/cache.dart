import 'package:flutter/material.dart';

class Cache {
  Cache._internal();

  static final Cache instance = Cache._internal();

  String? _sessionToken;
  String? _userId;
  final themeModeNotifier = ValueNotifier(ThemeMode.system);

  String? get sessionToken => _sessionToken;

  String? get userId => _userId;

  void setSessionToken(String? newToken) {
    if (_sessionToken != newToken) _sessionToken = newToken;
  }

  void setUserId(String? userId) {
    if (_userId != userId) _userId = userId;
  }

  void setThemeMode(ThemeMode themeMode) {
    if (themeModeNotifier.value != themeMode) {
      themeModeNotifier.value = themeMode;
    }
  }

  void resetSession() {
    setSessionToken(null);
    setUserId(null);
  }
}
