import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/localization/locale_service.dart';
import '../../../core/theme/theme_service.dart';

/// Bridges UI to the global ThemeService + LocaleService so existing screens
/// using `SettingsController` keep working, while persistence and the actual
/// Theme/Locale switching happen in the services.
class SettingsController extends GetxController {
  final ThemeService _themeService = ThemeService.instance;
  final LocaleService _localeService = LocaleService.instance;

  // Backwards-compatible reactive fields used by older screens.
  late final RxBool isDarkMode;
  late final RxString currentLanguage;

  @override
  void onInit() {
    super.onInit();
    isDarkMode = _themeService.isDark.obs;
    currentLanguage =
        (_localeService.isArabic ? 'AR' : 'EN').obs;

    // Keep services in sync when UI mutates these directly.
    ever<bool>(isDarkMode, (v) => _themeService.setDark(v));
    ever<String>(currentLanguage,
        (v) => _localeService.setLocale(v.toLowerCase() == 'ar' ? 'ar' : 'en'));
  }

  // Preferred API
  Future<void> setDarkMode(bool enabled) async {
    isDarkMode.value = enabled;
    await _themeService.setDark(enabled);
  }

  Future<void> setLanguage(String code) async {
    final normalized = code.toLowerCase() == 'ar' ? 'ar' : 'en';
    currentLanguage.value = normalized.toUpperCase();
    await _localeService.setLocale(normalized);
  }

  ThemeMode get themeMode => _themeService.mode;
  Locale get locale => _localeService.locale;
}
