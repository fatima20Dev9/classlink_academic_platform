import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/settings_controller.dart';
import '../../auth/controllers/auth_controller.dart';
import '../../auth/controllers/session_controller.dart';
import '../../../widgets/user_avatar.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SettingsController());
    final session = Get.find<SessionController>();

    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final cardColor = theme.cardTheme.color ?? scheme.surface;
    final borderColor = theme.dividerColor;
    final iconBg = scheme.primary.withValues(alpha: 0.10);

    return Scaffold(
      appBar: AppBar(
        title: Text('settings.title'.tr),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // ================= USER CARD =================
            Obx(() {
  final user = session.currentUser.value;

  return Container(
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(
      color: cardColor,
      borderRadius: BorderRadius.circular(18),
      border: Border.all(color: borderColor),
    ),
    child: Row(
      children: [
        UserAvatar(
          name: user?.name ?? '',
          photoUrl: user?.photoUrl ?? '',
          radius: 32,
        ),

        const SizedBox(width: 16),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                user?.name ?? '',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 4),

              Text(
                user?.email ?? '',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: scheme.onSurface.withOpacity(.6),
                ),
              ),

              const SizedBox(height: 8),

              Chip(
                label: Text(
                  user?.role.name.toUpperCase() ?? '',
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}),

            const SizedBox(height: 25),

            // ================= GENERAL =================
            Text(
              'settings.general'.tr,
              style: theme.textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            // Dark mode toggle
            _tileShell(
              cardColor: cardColor,
              borderColor: borderColor,
              child: Obx(() => SwitchListTile(
                    value: controller.isDarkMode.value,
                    onChanged: controller.setDarkMode,
                    secondary: _leadingIcon(
                        Icons.dark_mode_outlined, iconBg, scheme.primary),
                    title: Text('settings.darkMode'.tr,
                        style: const TextStyle(fontWeight: FontWeight.w600)),
                    subtitle: Text('settings.darkMode.subtitle'.tr),
                  )),
            ),

            // Language picker
            _tileShell(
              cardColor: cardColor,
              borderColor: borderColor,
              child: Obx(() => ListTile(
                    leading:
                        _leadingIcon(Icons.language, iconBg, scheme.primary),
                    title: Text('settings.language'.tr,
                        style: const TextStyle(fontWeight: FontWeight.w600)),
                    subtitle: Text('settings.language.subtitle'.tr),
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: scheme.primary.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        controller.currentLanguage.value,
                        style: TextStyle(
                            color: scheme.primary,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    onTap: () => _showLanguageSheet(context, controller),
                  )),
            ),

            _settingsTile(
              context: context,
              icon: Icons.notifications_none_outlined,
              title: 'settings.notifications'.tr,
              subtitle: 'settings.notifications.subtitle'.tr,
              onTap: () {},
            ),

            const SizedBox(height: 25),

            // ================= ABOUT =================
            Text(
              'settings.about'.tr,
              style: theme.textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            _settingsTile(
              context: context,
              icon: Icons.info_outline,
              title: 'settings.version'.tr,
              subtitle: '1.0.0',
              onTap: () {},
            ),
            _settingsTile(
              context: context,
              icon: Icons.description_outlined,
              title: 'settings.aboutApp'.tr,
              subtitle: 'settings.aboutApp.subtitle'.tr,
              onTap: () {},
            ),
            _settingsTile(
              context: context,
              icon: Icons.support_agent,
              title: 'settings.support'.tr,
              subtitle: 'settings.support.subtitle'.tr,
              onTap: () {},
            ),

            const SizedBox(height: 35),

            // ================= LOGOUT =================
            SizedBox(
              height: 55,
              child: ElevatedButton.icon(
                onPressed: () => _showLogoutDialog(context),
                icon: const Icon(Icons.logout),
                label: Text(
                  'settings.logout'.tr,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: scheme.error,
                  foregroundColor: scheme.onError,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // ----- helpers -----

  void _showLanguageSheet(BuildContext context, SettingsController c) {
    showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.language),
              title: Text('settings.language.en'.tr),
              onTap: () {
                c.setLanguage('en');
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.language),
              title: Text('settings.language.ar'.tr),
              onTap: () {
                c.setLanguage('ar');
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('settings.logout'.tr),
        content: Text('settings.logout.confirm'.tr),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('common.cancel'.tr),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Theme.of(context).colorScheme.onError,
            ),
            onPressed: () async {
              Navigator.pop(context);
              final auth = Get.isRegistered<AuthController>()
                  ? Get.find<AuthController>()
                  : Get.put(AuthController(), permanent: true);
              await auth.logout();
            },
            child: Text('settings.logout'.tr),
          ),
        ],
      ),
    );
  }

  Widget _tileShell({
    required Color cardColor,
    required Color borderColor,
    required Widget child,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: borderColor),
      ),
      child: child,
    );
  }

  Widget _leadingIcon(IconData icon, Color bg, Color fg) {
    return Container(
      width: 42,
      height: 42,
      decoration:
          BoxDecoration(color: bg, borderRadius: BorderRadius.circular(12)),
      child: Icon(icon, color: fg),
    );
  }

  Widget _settingsTile({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return _tileShell(
      cardColor: theme.cardTheme.color ?? scheme.surface,
      borderColor: theme.dividerColor,
      child: ListTile(
        leading: _leadingIcon(
            icon, scheme.primary.withValues(alpha: 0.10), scheme.primary),
        title: Text(title,
            style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}
