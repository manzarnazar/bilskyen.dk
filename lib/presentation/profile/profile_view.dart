import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../utils/app_colors.dart';
import '../../controllers/app_controller/app_controller.dart';
import '../../controllers/profile_controller.dart';
import '../../controllers/auth_controller.dart';
import '../../models/user_model.dart';
import '../../main.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final appController = Get.find<AppController>();
    Get.put(ProfileController()); // Initialize profile controller
    // Initialize AuthController if not already initialized
    if (!Get.isRegistered<AuthController>()) {
      Get.put(AuthController());
    }

    return Obx(() {
      final isDark = appController.isDarkMode.value;

      return SafeArea(
        child: Column(
          children: [
            // Header
            Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  color: (isDark
                          ? AppColors.backgroundDark
                          : AppColors.backgroundLight)
                      .withValues(alpha: 0.95),
                  border: Border(
                    bottom: BorderSide(
                      color: isDark
                          ? AppColors.borderDark
                          : AppColors.borderLight,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Profile',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.5,
                      ),
                    ),
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.gray700
                            : AppColors.gray300,
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Text(
                          'BI',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 24),
                      // Profile Card
                      _buildProfileCard(isDark),
                      const SizedBox(height: 24),
                      // Account Settings
                      _buildSectionTitle('ACCOUNT SETTINGS'),
                      const SizedBox(height: 12),
                      _buildSettingsCard(
                        isDark,
                        [
                          _SettingsItem(
                            icon: Icons.person,
                            iconColor: Colors.blue,
                            title: 'Personal Information',
                            onTap: () {
                              Get.toNamed('/personal-info');
                            },
                          ),
                          _SettingsItem(
                            icon: Icons.directions_car,
                            iconColor: Colors.purple,
                            title: 'My Listings',
                            badge: '3 Active',
                            onTap: () {
                              Get.snackbar(
                                'Info',
                                'My Listings coming soon',
                                snackPosition: SnackPosition.TOP,
                              );
                            },
                          ),
                          _SettingsItem(
                            icon: Icons.favorite,
                            iconColor: Colors.amber,
                            title: 'Saved Vehicles',
                            onTap: () {
                              Get.snackbar(
                                'Info',
                                'Saved Vehicles coming soon',
                                snackPosition: SnackPosition.TOP,
                              );
                            },
                          ),
                         
                        ],
                      ),
                      const SizedBox(height: 24),
                      // Preferences
                      _buildSectionTitle('PREFERENCES'),
                      const SizedBox(height: 12),
                      _buildPreferencesCard(isDark),
                      const SizedBox(height: 24),
                      // Support & Legal
                      _buildSectionTitle('SUPPORT & LEGAL'),
                      const SizedBox(height: 12),
                      _buildSettingsCard(
                        isDark,
                        [
                          _SettingsItem(
                            icon: Icons.help,
                            iconColor: Colors.orange,
                            title: 'Help & Support',
                            onTap: () {
                              Get.snackbar(
                                'Info',
                                'Help & Support coming soon',
                                snackPosition: SnackPosition.TOP,
                              );
                            },
                          ),
                          _SettingsItem(
                            icon: Icons.privacy_tip,
                            iconColor: isDark
                                ? AppColors.mutedDark
                                : AppColors.mutedLight,
                            title: 'Privacy Policy',
                            onTap: () {
                              Get.snackbar(
                                'Info',
                                'Privacy Policy coming soon',
                                snackPosition: SnackPosition.TOP,
                              );
                            },
                          ),
                          _SettingsItem(
                            icon: Icons.description,
                            iconColor: isDark
                                ? AppColors.mutedDark
                                : AppColors.mutedLight,
                            title: 'Terms of Service',
                            onTap: () {
                              Get.snackbar(
                                'Info',
                                'Terms of Service coming soon',
                                snackPosition: SnackPosition.TOP,
                              );
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      // Log Out Button
                      _buildLogOutButton(isDark),
                      const SizedBox(height: 16),
                      // Version
                      Center(
                        child: Text(
                          'Version 0.1.0',
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark
                                ? AppColors.gray600
                                : AppColors.mutedLight,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
    });
  }

  Widget _buildProfileCard(bool isDark) {
    // Get user from storage
    UserModel? getUser() {
      try {
        final userJson = appStorage.read('user');
        if (userJson != null) {
          final userMap = jsonDecode(userJson.toString());
          return UserModel.fromJson(userMap as Map<String, dynamic>);
        }
      } catch (e) {
        // Handle parsing errors
      }
      return null;
    }

    // Get user initials for avatar
    String getInitials(UserModel? user) {
      if (user == null || user.name.isEmpty) return 'U';
      final parts = user.name.trim().split(' ');
      if (parts.length >= 2) {
        return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
      }
      return user.name.substring(0, user.name.length > 2 ? 2 : 1).toUpperCase();
    }

    // Get user name
    String getUserName(UserModel? user) {
      return user?.name ?? 'Guest User';
    }

    // Get user email
    String getUserEmail(UserModel? user) {
      return user?.email ?? 'No email';
    }

    // Check if email is verified
    bool isEmailVerified(UserModel? user) {
      return user?.emailVerified ?? false;
    }

    final user = getUser();

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
        ),
      ),
      child: Row(
        children: [
          // Avatar
          Stack(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isDark ? const Color(0xFF2C2C2C) : AppColors.gray200,
                    width: 4,
                  ),
                ),
                child: ClipOval(
                  child: Image.asset(
                    'assets/images/seller_profile.jpg',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: isDark ? AppColors.gray700 : AppColors.gray300,
                        child: Center(
                          child: Text(
                            getInitials(user),
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : Colors.black,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isDark ? AppColors.cardDark : Colors.white,
                      width: 2,
                    ),
                  ),
                  child: const Icon(
                    Icons.edit,
                    size: 14,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
          // Name and Email
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  getUserName(user),
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  getUserEmail(user),
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark
                        ? AppColors.mutedDark
                        : AppColors.mutedLight,
                  ),
                ),
                const SizedBox(height: 8),
                if (isEmailVerified(user))
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: isDark
                          ? Colors.green.withOpacity(0.3)
                          : Colors.green.shade100,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isDark
                            ? Colors.green.shade800
                            : Colors.green.shade200,
                      ),
                    ),
                    child: Text(
                      'Verified User',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: isDark
                            ? Colors.green.shade400
                            : Colors.green.shade700,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    final appController = Get.find<AppController>();
    return Obx(() {
      final isDark = appController.isDarkMode.value;
      return Padding(
        padding: const EdgeInsets.only(left: 8),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
            color: isDark
                ? AppColors.mutedDark
                : AppColors.mutedLight,
          ),
        ),
      );
    });
  }

  Widget _buildSettingsCard(bool isDark, List<_SettingsItem> items) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
        ),
      ),
      child: Column(
        children: items.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          final isLast = index == items.length - 1;

          return InkWell(
            onTap: item.onTap,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: isLast
                    ? null
                    : Border(
                        bottom: BorderSide(
                          color: isDark
                              ? AppColors.borderDark
                              : AppColors.borderLight,
                        ),
                      ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: isDark
                          ? _getDarkIconBg(item.iconColor)
                          : _getLightIconBg(item.iconColor),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      item.icon,
                      color: item.iconColor,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      item.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  if (item.badge != null) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.gray700
                            : AppColors.gray200,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        item.badge!,
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark
                              ? AppColors.mutedDark
                              : AppColors.mutedLight,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],
                  Icon(
                    Icons.chevron_right,
                    color: isDark
                        ? AppColors.mutedDark
                        : AppColors.mutedLight,
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildPreferencesCard(bool isDark) {
    // final pushNotificationsEnabled = false.obs; // Reserved for future use

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
        ),
      ),
      child: Column(
        children: [
          // Push Notifications
          // Obx(() => Container(
          //       padding: const EdgeInsets.all(16),
          //       decoration: BoxDecoration(
          //         border: Border(
          //           bottom: BorderSide(
          //             color: isDark
          //                 ? AppColors.borderDark
          //                 : AppColors.borderLight,
          //           ),
          //         ),
          //       ),
          //       child: Row(
          //         children: [
          //           Container(
          //             padding: const EdgeInsets.all(8),
          //             decoration: BoxDecoration(
          //               color: isDark
          //                   ? AppColors.gray800
          //                   : AppColors.gray200,
          //               borderRadius: BorderRadius.circular(8),
          //             ),
          //             child: Icon(
          //               Icons.notifications,
          //               color: isDark
          //                   ? AppColors.mutedDark
          //                   : AppColors.mutedLight,
          //               size: 20,
          //             ),
          //           ),
          //           const SizedBox(width: 16),
          //           const Expanded(
          //             child: Text(
          //               'Push Notifications',
          //               style: TextStyle(
          //                 fontSize: 16,
          //                 fontWeight: FontWeight.w500,
          //               ),
          //             ),
          //           ),
          //           Switch(
          //             value: pushNotificationsEnabled.value,
          //             onChanged: (value) {
          //               pushNotificationsEnabled.value = value;
          //             },
          //             activeColor: AppColors.primaryLight,
          //             activeTrackColor: AppColors.primaryLight,
          //           ),
          //         ],
          //       ),
          //     )),
          // Dark Mode
          InkWell(
            onTap: () {
              Get.toNamed('/dark-mode-settings');
            },
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: isDark
                        ? AppColors.borderDark
                        : AppColors.borderLight,
                  ),
                ),
              ),
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
                      Icons.dark_mode,
                      color: isDark
                          ? AppColors.mutedDark
                          : AppColors.mutedLight,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Text(
                      'Dark Mode',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Obx(() {
                    final appController = Get.find<AppController>();
                    String modeText;
                    switch (appController.themeMode.value) {
                      case ThemeMode.system:
                        modeText = 'System';
                        break;
                      case ThemeMode.dark:
                        modeText = 'Dark';
                        break;
                      case ThemeMode.light:
                        modeText = 'Light';
                        break;
                    }
                    return Row(
                      children: [
                        Text(
                          modeText,
                          style: TextStyle(
                            fontSize: 14,
                            color: isDark
                                ? AppColors.mutedDark
                                : AppColors.mutedLight,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          Icons.chevron_right,
                          color: isDark
                              ? AppColors.mutedDark
                              : AppColors.mutedLight,
                        ),
                      ],
                    );
                  }),
                ],
              ),
            ),
          ),
          // Language
          InkWell(
            onTap: () {
              Get.snackbar(
                'Info',
                'Language selection coming soon',
                snackPosition: SnackPosition.TOP,
              );
            },
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
                      Icons.translate,
                      color: isDark
                          ? AppColors.mutedDark
                          : AppColors.mutedLight,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Text(
                      'Language',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Text(
                    'English',
                    style: TextStyle(
                      fontSize: 14,
                      color: isDark
                          ? AppColors.mutedDark
                          : AppColors.mutedLight,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    Icons.chevron_right,
                    color: isDark
                        ? AppColors.mutedDark
                        : AppColors.mutedLight,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogOutButton(bool isDark) {
    final authController = Get.find<AuthController>();
    
    return SizedBox(
      width: double.infinity,
      child: Obx(() => OutlinedButton(
        onPressed: authController.isLoading.value
            ? null
            : () async {
                // Show confirmation dialog
                final confirmed = await Get.dialog<bool>(
                  AlertDialog(
                    title: const Text('Sign Out'),
                    content: const Text('Are you sure you want to sign out?'),
                    actions: [
                      TextButton(
                        onPressed: () => Get.back(result: false),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () => Get.back(result: true),
                        child: const Text('Sign Out'),
                      ),
                    ],
                  ),
                );

                if (confirmed == true) {
                  await authController.signOut();
                }
              },
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          side: BorderSide(
            color: isDark
                ? Colors.red.shade900.withOpacity(0.3)
                : Colors.red.shade200,
          ),
          backgroundColor: isDark
              ? AppColors.cardDark
              : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.logout,
              color: isDark
                  ? Colors.red.shade400
                  : Colors.red.shade500,
            ),
            const SizedBox(width: 8),
            Text(
              'Log Out',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: isDark
                    ? Colors.red.shade400
                    : Colors.red.shade500,
              ),
            ),
          ],
        ),
      )),
    );
  }

  Color _getLightIconBg(Color iconColor) {
    if (iconColor == Colors.blue) return Colors.blue.shade100;
    if (iconColor == Colors.purple) return Colors.purple.shade100;
    if (iconColor == Colors.amber) return Colors.amber.shade100;
    if (iconColor == Colors.teal) return Colors.teal.shade100;
    if (iconColor == Colors.orange) return Colors.orange.shade100;
    return AppColors.gray200;
  }

  Color _getDarkIconBg(Color iconColor) {
    if (iconColor == Colors.blue) return Colors.blue.shade900.withOpacity(0.2);
    if (iconColor == Colors.purple) return Colors.purple.shade900.withOpacity(0.2);
    if (iconColor == Colors.amber) return Colors.amber.shade900.withOpacity(0.2);
    if (iconColor == Colors.teal) return Colors.teal.shade900.withOpacity(0.2);
    if (iconColor == Colors.orange) return Colors.orange.shade900.withOpacity(0.2);
    return AppColors.gray800;
  }
}

class _SettingsItem {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String? badge;
  final VoidCallback onTap;

  _SettingsItem({
    required this.icon,
    required this.iconColor,
    required this.title,
    this.badge,
    required this.onTap,
  });
}

