import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'app.dart';
import 'core/localization/locale_service.dart';
import 'core/theme/theme_service.dart';
import 'firebase_options.dart';
//check this one
//kjhgkhjg
//jhgf
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize persisted services (theme + locale) BEFORE runApp so that
  // GetMaterialApp picks up the saved values on first frame.
  await Get.putAsync<ThemeService>(() => ThemeService().init(), permanent: true);
  await Get.putAsync<LocaleService>(() => LocaleService().init(), permanent: true);

  runApp(const ClassLinkApp());
}
