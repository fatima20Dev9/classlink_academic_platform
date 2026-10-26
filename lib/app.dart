import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';

import 'bindings/app_bindings.dart';
import 'core/localization/app_translations.dart';
import 'core/localization/locale_service.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_service.dart';
import 'routes/app_pages.dart';
import 'routes/app_routes.dart';

class ClassLinkApp extends StatelessWidget {
  const ClassLinkApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeService = ThemeService.instance;
    final localeService = LocaleService.instance;

    return Obx(() => GetMaterialApp(
          title: 'ClassLink',
          debugShowCheckedModeBanner: false,

          // ===== Theme =====
          themeMode: ThemeMode.light,

          theme: AppTheme.light(),
          darkTheme: AppTheme.dark(),

          // ===== Localization =====
          translations: AppTranslations(),
          locale: localeService.locale,
          fallbackLocale: LocaleService.fallbackLocale,
          supportedLocales: LocaleService.supportedLocales,
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],

          // ===== Routing =====
          initialRoute: AppRoutes.splash,
          initialBinding: AppBindings(),
          getPages: AppPages.pages,
        ));
  }
}
