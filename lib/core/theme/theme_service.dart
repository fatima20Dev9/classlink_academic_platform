import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Manages the app ThemeMode (light/dark/system) and persists the user choice.
class ThemeService extends GetxService {
  static ThemeService get instance => Get.find<ThemeService>();

  static const _kPrefsKey = 'app_theme_mode';

  final Rx<ThemeMode> _mode = ThemeMode.system.obs;
  ThemeMode get mode => _mode.value;
  bool get isDark =>
      _mode.value == ThemeMode.dark ||
      (_mode.value == ThemeMode.system &&
          Get.mediaQuery.platformBrightness == Brightness.dark);

  Future<ThemeService> init() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_kPrefsKey);
    _mode.value = _fromString(saved);
    return this;
  }

  Future<void> setMode(ThemeMode mode) async {
    if (mode == _mode.value) return;
    _mode.value = mode;
    Get.changeThemeMode(mode);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kPrefsKey, _toString(mode));
  }

  Future<void> setDark(bool enabled) =>
      setMode(enabled ? ThemeMode.dark : ThemeMode.light);

  Future<void> toggle() => setDark(!isDark);

  ThemeMode _fromString(String? v) {
    switch (v) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      case 'system':
      default:
        return ThemeMode.system;
    }
  }

  String _toString(ThemeMode m) {
    switch (m) {
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
      case ThemeMode.system:
        return 'system';
    }
  }
}
