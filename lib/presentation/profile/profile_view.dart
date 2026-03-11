import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bilskyen/gen_l10n/app_localizations.dart';
import '../../utils/app_colors.dart';
import '../../controllers/app_controller/app_controller.dart';
import '../../controllers/app_controller/main_navigation_controller.dart';
import '../../controllers/profile_controller.dart';
import '../../controllers/auth_controller.dart';
import '../../models/auth_model/user_model.dart';
import '../../main.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final appController = Get.find<AppController>();
    final l10n = AppLocalizations.of(context)!;
    Get.put(ProfileController()); // Initialize profile controller
    // Initialize AuthController if not already initialized
    if (!Get.isRegistered<AuthController>()) {
      Get.put(AuthController());
    }

    return Obx(() {
      final isDark = appController.isDarkMode.value;
      final isLoggedIn = _isLoggedIn();

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
                  children: [
                    Text(
                      l10n.profile,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.5,
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
                      if (!isLoggedIn) ...[
                        _buildGuestProfile(context, isDark),
                      ] else ...[
                        // Profile Card (reactive so it updates after profile edit)
                        Obx(() {
                          final authController = Get.find<AuthController>();
                          final user = authController.currentUser.value ?? _getUserFromStorage();
                          return _buildProfileCard(context, isDark, user);
                        }),
                        const SizedBox(height: 24),
                        // Account Settings
                        _buildSectionTitle(l10n.accountSettings),
                        const SizedBox(height: 12),
                        _buildSettingsCard(
                          isDark,
                          [
                            _SettingsItem(
                              icon: Icons.person,
                              iconColor: Colors.blue,
                              title: l10n.personalInformation,
                              onTap: () {
                                Get.toNamed('/personal-info');
                              },
                            ),
                            _SettingsItem(
                              icon: Icons.directions_car,
                              iconColor: Colors.purple,
                              title: l10n.myListings,
                              onTap: () {
                                Get.find<MainNavigationController>().changeTab(3);
                              },
                            ),
                            _SettingsItem(
                              icon: Icons.favorite,
                              iconColor: Colors.amber,
                              title: l10n.savedVehicles,
                              onTap: () {
                                Get.find<MainNavigationController>().changeTab(1);
                              },
                            ),
                            _SettingsItem(
                              icon: Icons.lock_reset,
                              iconColor: Colors.teal,
                              title: l10n.resetPassword,
                              onTap: () => Get.toNamed('/change-password'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                      ],
                      // Preferences (shown for both guest and logged-in)
                      _buildSectionTitle(l10n.preferences),
                      const SizedBox(height: 12),
                      _buildPreferencesCard(context, isDark),
                      const SizedBox(height: 24),
                      // Support & Legal
                      _buildSectionTitle(l10n.supportAndLegal),
                      const SizedBox(height: 12),
                      _buildSettingsCard(
                        isDark,
                        [
                          // Help & Support hidden for now
                          _SettingsItem(
                            icon: Icons.privacy_tip,
                            iconColor: isDark
                                ? AppColors.mutedDark
                                : AppColors.mutedLight,
                            title: l10n.privacyPolicyTitle,
                            onTap: () {
                              Get.snackbar(
                                l10n.info,
                                l10n.privacyPolicyComingSoon,
                                snackPosition: SnackPosition.TOP,
                              );
                            },
                          ),
                          _SettingsItem(
                            icon: Icons.description,
                            iconColor: isDark
                                ? AppColors.mutedDark
                                : AppColors.mutedLight,
                            title: l10n.termsOfService,
                            onTap: () {
                              Get.snackbar(
                                l10n.info,
                                l10n.termsComingSoon,
                                snackPosition: SnackPosition.TOP,
                              );
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      // Log Out and Delete Account at bottom (logged-in only)
                      if (isLoggedIn) ...[
                        _buildLogOutButton(context, isDark),
                        const SizedBox(height: 12),
                        _buildDeleteAccountButton(context, isDark),
                        const SizedBox(height: 24),
                      ],
                      // Version
                      Center(
                        child: Text(
                          l10n.version,
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

  /// Returns true if user has a valid token (logged in).
  static bool _isLoggedIn() {
    try {
      final token = appStorage.read('token');
      return token != null && token.toString().isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  /// Profile content when user is not logged in: sign-in CTA and register link.
  Widget _buildGuestProfile(BuildContext context, bool isDark) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.person_outline,
            size: 64,
            color: isDark ? AppColors.mutedDark : AppColors.mutedLight,
          ),
          const SizedBox(height: 16),
          Text(
            l10n.signInToAccount,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.signInToManage,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: isDark ? AppColors.mutedDark : AppColors.mutedLight,
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Get.toNamed('/login'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(l10n.signIn),
            ),
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: () => Get.toNamed('/register'),
            child: Text(
              l10n.createAnAccount,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.primary,
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  /// Fallback when currentUser is null (e.g. before AuthController has loaded from storage).
  static UserModel? _getUserFromStorage() {
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

  Widget _buildProfileCard(BuildContext context, bool isDark, UserModel? user) {
    final l10n = AppLocalizations.of(context)!;
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
      return user?.name ?? l10n.guestUser;
    }

    // Get user email
    String getUserEmail(UserModel? user) {
      return user?.email ?? l10n.noEmail;
    }

    // Check if email is verified
    bool isEmailVerified(UserModel? user) {
      return user?.emailVerified ?? false;
    }

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
          // Avatar (placeholder)
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isDark ? AppColors.gray700 : AppColors.gray300,
              border: Border.all(
                color: isDark ? const Color(0xFF2C2C2C) : AppColors.gray200,
                width: 4,
              ),
            ),
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
                      l10n.verifiedUser,
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

  Widget _buildPreferencesCard(BuildContext context, bool isDark) {
    final l10n = AppLocalizations.of(context)!;
    final appController = Get.find<AppController>();

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
                  Expanded(
                    child: Text(
                      l10n.darkMode,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Obx(() {
                    String modeText;
                    switch (appController.themeMode.value) {
                      case ThemeMode.system:
                        modeText = l10n.system;
                        break;
                      case ThemeMode.dark:
                        modeText = l10n.dark;
                        break;
                      case ThemeMode.light:
                        modeText = l10n.light;
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
              showDialog<void>(
                context: context,
                builder: (ctx) {
                  final dialogL10n = AppLocalizations.of(ctx)!;
                  return AlertDialog(
                    backgroundColor: isDark ? AppColors.cardDark : Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    title: Text(
                      dialogL10n.language,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: isDark ? AppColors.textDark : AppColors.textLight,
                      ),
                    ),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        InkWell(
                          onTap: () {
                            appController.setLocale(const Locale('en'));
                            Navigator.of(ctx).pop();
                          },
                          borderRadius: BorderRadius.circular(12),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.asset(
                                    'assets/images/english_flag.png',
                                    width: 40,
                                    height: 28,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => Icon(
                                      Icons.language,
                                      size: 28,
                                      color: isDark ? AppColors.mutedDark : AppColors.mutedLight,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Text(
                                  dialogL10n.english,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: isDark ? AppColors.textDark : AppColors.textLight,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        InkWell(
                          onTap: () {
                            appController.setLocale(const Locale('da'));
                            Navigator.of(ctx).pop();
                          },
                          borderRadius: BorderRadius.circular(12),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.asset(
                                    'assets/images/danish-flag.png',
                                    width: 40,
                                    height: 28,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => Icon(
                                      Icons.language,
                                      size: 28,
                                      color: isDark ? AppColors.mutedDark : AppColors.mutedLight,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Text(
                                  dialogL10n.danish,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: isDark ? AppColors.textDark : AppColors.textLight,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
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
                  Expanded(
                    child: Text(
                      l10n.language,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Obx(() {
                    final currentLang = appController.locale.value.languageCode == 'da' ? l10n.danish : l10n.english;
                    return Text(
                      currentLang,
                      style: TextStyle(
                        fontSize: 14,
                        color: isDark
                            ? AppColors.mutedDark
                            : AppColors.mutedLight,
                      ),
                    );
                  }),
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

  Widget _buildLogOutButton(BuildContext context, bool isDark) {
    final authController = Get.find<AuthController>();
    final l10n = AppLocalizations.of(context)!;
    return SizedBox(
      width: double.infinity,
      child: Obx(() => OutlinedButton(
        onPressed: authController.isLoading.value
            ? null
            : () async {
                // Show confirmation dialog
                final confirmed = await Get.dialog<bool>(
                  AlertDialog(
                    title: Text(l10n.signOut),
                    content: Text(l10n.signOutConfirm),
                    actions: [
                      TextButton(
                        onPressed: () => Get.back(result: false),
                        child: Text(l10n.cancel),
                      ),
                      TextButton(
                        onPressed: () => Get.back(result: true),
                        child: Text(l10n.signOut),
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
              l10n.logOut,
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

  Widget _buildDeleteAccountButton(BuildContext context, bool isDark) {
    final authController = Get.find<AuthController>();
    final l10n = AppLocalizations.of(context)!;
    return SizedBox(
      width: double.infinity,
      child: Obx(() => OutlinedButton(
        onPressed: authController.isLoading.value
            ? null
            : () async {
                final passwordController = TextEditingController();
                final password = await Get.dialog<String>(
                  AlertDialog(
                    title: Text(l10n.deleteAccount),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.deleteAccountConfirm,
                          style: TextStyle(
                            fontSize: 14,
                            color: isDark
                                ? AppColors.mutedDark
                                : AppColors.mutedLight,
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: l10n.passwordLabel,
                            border: const OutlineInputBorder(),
                          ),
                          onSubmitted: (value) => Get.back(result: value),
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Get.back(result: null),
                        child: Text(l10n.cancel),
                      ),
                      TextButton(
                        onPressed: () {
                          final pwd = passwordController.text;
                          if (pwd.isNotEmpty) Get.back(result: pwd);
                        },
                        child: Text(
                          l10n.deleteAccount,
                          style: TextStyle(
                            color: Colors.red.shade700,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
                passwordController.dispose();
                if (password != null && password.isNotEmpty) {
                  await authController.deleteAccount(password: password);
                }
              },
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          side: BorderSide(
            color: isDark
                ? Colors.red.shade900.withOpacity(0.5)
                : Colors.red.shade300,
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
              Icons.delete_forever,
              color: isDark
                  ? Colors.red.shade400
                  : Colors.red.shade600,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              l10n.deleteAccount,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: isDark
                    ? Colors.red.shade400
                    : Colors.red.shade600,
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

