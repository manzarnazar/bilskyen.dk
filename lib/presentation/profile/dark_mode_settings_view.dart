import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../utils/app_colors.dart';
import '../../controllers/app_controller/app_controller.dart';

class DarkModeSettingsView extends StatelessWidget {
  const DarkModeSettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final appController = Get.find<AppController>();

    return Obx(() {
      final isDark = appController.isDarkMode.value;
      final currentThemeMode = appController.themeMode.value;

      return Scaffold(
        backgroundColor: isDark
            ? AppColors.backgroundDark
            : AppColors.backgroundLight,
        appBar: AppBar(
          title: const Text(
            'Dark Mode',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.5,
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: isDark ? AppColors.textDark : AppColors.textLight,
            ),
            onPressed: () => Get.back(),
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                // Options List
                Container(
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.cardDark : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isDark ? AppColors.borderDark : AppColors.borderLight,
                    ),
                  ),
                  child: Column(
                    children: [
                      _ThemeOption(
                        title: 'System Default',
                        subtitle: 'Follow system theme',
                        icon: Icons.phone_android,
                        isSelected: currentThemeMode == ThemeMode.system,
                        onTap: () {
                          appController.setThemeMode(ThemeMode.system);
                        },
                      ),
                      _Divider(isDark: isDark),
                      _ThemeOption(
                        title: 'Light',
                        subtitle: 'Always use light theme',
                        icon: Icons.light_mode,
                        isSelected: currentThemeMode == ThemeMode.light,
                        onTap: () {
                          appController.setThemeMode(ThemeMode.light);
                        },
                      ),
                      _Divider(isDark: isDark),
                      _ThemeOption(
                        title: 'Dark',
                        subtitle: 'Always use dark theme',
                        icon: Icons.dark_mode,
                        isSelected: currentThemeMode == ThemeMode.dark,
                        onTap: () {
                          appController.setThemeMode(ThemeMode.dark);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}

class _ThemeOption extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _ThemeOption({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final appController = Get.find<AppController>();
    
    return Obx(() {
      final isDark = appController.isDarkMode.value;

      return InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.gray800
                      : AppColors.gray200,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: isDark
                      ? AppColors.mutedDark
                      : AppColors.mutedLight,
                  size: 20,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark
                            ? AppColors.mutedDark
                            : AppColors.mutedLight,
                      ),
                    ),
                  ],
                ),
              ),
              if (isSelected)
                Icon(
                  Icons.check_circle,
                  color: AppColors.primary,
                  size: 24,
                )
              else
                Icon(
                  Icons.circle_outlined,
                  color: isDark
                      ? AppColors.mutedDark
                      : AppColors.mutedLight,
                  size: 24,
                ),
            ],
          ),
        ),
      );
    });
  }
}

class _Divider extends StatelessWidget {
  final bool isDark;

  const _Divider({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      color: isDark ? AppColors.borderDark : AppColors.borderLight,
    );
  }
}

