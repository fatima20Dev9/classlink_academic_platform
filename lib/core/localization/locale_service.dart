import 'dart:ui';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Manages the app locale (ar/en) and persists the user's choice.
///
/// Usage:
///   await LocaleService.instance.init();
///   LocaleService.instance.setLocale('ar');
class LocaleService extends GetxService {
  static LocaleService get instance => Get.find<LocaleService>();

  static const _kPrefsKey = 'app_locale';
  static const Locale fallbackLocale = Locale('en', 'US');
  static const List<Locale> supportedLocales = [
    Locale('en', 'US'),
    Locale('ar', 'SA'),
  ];

  final Rx<Locale> _locale = const Locale('en', 'US').obs;
  Locale get locale => _locale.value;
  String get languageCode => _locale.value.languageCode;
  bool get isArabic => languageCode == 'ar';

  Future<LocaleService> init() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_kPrefsKey);
    if (saved != null) {
      _locale.value = _fromCode(saved);
    } else {
      // Use device locale if it matches a supported one, else fallback.
      final device = Get.deviceLocale;
      if (device != null &&
          supportedLocales.any((l) => l.languageCode == device.languageCode)) {
        _locale.value =
            supportedLocales.firstWhere((l) => l.languageCode == device.languageCode);
      } else {
        _locale.value = fallbackLocale;
      }
    }
    return this;
  }

  Future<void> setLocale(String code) async {
    final newLocale = _fromCode(code);
    if (newLocale == _locale.value) return;
    _locale.value = newLocale;
    await Get.updateLocale(newLocale);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kPrefsKey, code);
  }

  Future<void> toggle() => setLocale(isArabic ? 'en' : 'ar');

  Locale _fromCode(String code) {
    switch (code) {
      case 'ar':
        return const Locale('ar', 'SA');
      case 'en':
      default:
        return const Locale('en', 'US');
    }
  }
}
