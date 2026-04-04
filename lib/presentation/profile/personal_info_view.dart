import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bilskyen/gen_l10n/app_localizations.dart';
import '../../utils/app_colors.dart';
import '../../controllers/app_controller/app_controller.dart';
import '../../controllers/auth_controller.dart';
import '../../main.dart';
import '../../models/auth_model/user_model.dart';

class PersonalInfoView extends StatefulWidget {
  const PersonalInfoView({super.key});

  @override
  State<PersonalInfoView> createState() => _PersonalInfoViewState();
}

class _PersonalInfoViewState extends State<PersonalInfoView> {
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  bool _isLoadingUser = true;

  @override
  void initState() {
    super.initState();
    if (!Get.isRegistered<AuthController>()) {
      Get.put(AuthController());
    }
    _fetchUserFromApi();
  }

  Future<void> _fetchUserFromApi() async {
    final authController = Get.find<AuthController>();
    final user = await authController.fetchCurrentUser();
    if (!mounted) return;
    if (user != null) {
      _fullNameController.text = user.name;
      _emailController.text = user.email;
      _phoneController.text = user.phone ?? '';
      _addressController.text = user.address ?? '';
    } else {
      _loadUserFromStorage();
    }
    setState(() => _isLoadingUser = false);
  }

  void _loadUserFromStorage() {
    final userJson = appStorage.read('user');
    if (userJson != null) {
      try {
        final user = UserModel.fromJson(
          jsonDecode(userJson.toString()) as Map<String, dynamic>,
        );
        _fullNameController.text = user.name;
        _emailController.text = user.email;
        _phoneController.text = user.phone ?? '';
        _addressController.text = user.address ?? '';
      } catch (_) {
        // Keep empty if parse fails
      }
    }
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appController = Get.find<AppController>();
    final l10n = AppLocalizations.of(context)!;

    return Obx(() {
      final isDark = appController.isDarkMode.value;

      return Scaffold(
        backgroundColor: isDark
            ? AppColors.backgroundDark
            : AppColors.backgroundLight,
        appBar: AppBar(
          title: Text(
            AppLocalizations.of(context)!.personalInfo,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.5,
            ),
          ),
          backgroundColor: isDark
              ? AppColors.backgroundDark
              : AppColors.backgroundLight,
          elevation: 0,
          scrolledUnderElevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: isDark ? AppColors.textDark : AppColors.textLight,
            ),
            onPressed: () => Get.back(),
          ),
          centerTitle: true,
        ),
        body: SafeArea(
          child: _isLoadingUser
              ? Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primary,
                  ),
                )
              : Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 32),
                      // Profile Picture Section
                      _buildProfilePictureSection(isDark),
                      const SizedBox(height: 24),
                      // Identity Section
                      _buildSectionTitle(l10n.identity.toUpperCase()),
                      const SizedBox(height: 12),
                      _buildIdentityCard(context, isDark),
                      const SizedBox(height: 24),
                      // Contact Details Section
                      _buildSectionTitle(l10n.contactDetails.toUpperCase()),
                      const SizedBox(height: 12),
                      _buildContactDetailsCard(context, isDark),
                      const SizedBox(height: 24),
                      // Location Section
                      _buildSectionTitle(l10n.locationSection.toUpperCase()),
                      const SizedBox(height: 12),
                      _buildLocationCard(context, isDark),
                      const SizedBox(height: 100), // Space for fixed button
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: _isLoadingUser ? null : _buildSaveButton(context, isDark),
      );
    });
  }

  Widget _buildProfilePictureSection(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(
          child: Stack(
            children: [
              Container(
                width: 112,
                height: 112,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isDark ? AppColors.backgroundDark : Colors.white,
                ),
                child: Stack(
                  children: [
                    Center(
                      child: Container(
                        width: 104,
                        height: 104,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isDark ? AppColors.gray700 : AppColors.gray300,
                        ),
                        child: Icon(
                          Icons.person,
                          size: 56,
                          color: isDark ? AppColors.gray400 : AppColors.gray600,
                        ),
                      ),
                    ),
                    CustomPaint(
                      size: const Size(112, 112),
                      painter: _DashedCirclePainter(
                        color: AppColors.gray400,
                        strokeWidth: 2,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
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

  Widget _buildIdentityCard(BuildContext context, bool isDark) {
    final l10n = AppLocalizations.of(context)!;
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
          // Full Name
          _buildInputField(
            icon: Icons.person,
            iconColor: Colors.blue,
            label: l10n.fullName,
            controller: _fullNameController,
            isDark: isDark,
            showEditIcon: true,
          ),
        ],
      ),
    );
  }

  Widget _buildContactDetailsCard(BuildContext context, bool isDark) {
    final l10n = AppLocalizations.of(context)!;
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
          // Email Address
          _buildInputField(
            icon: Icons.email,
            iconColor: Colors.orange,
            label: l10n.emailAddress,
            controller: _emailController,
            isDark: isDark,
            showVerifiedIcon: true,
          ),
          _buildDivider(isDark),
          // Phone Number
          _buildInputField(
            icon: Icons.phone,
            iconColor: Colors.green,
            label: l10n.phoneNumber,
            controller: _phoneController,
            isDark: isDark,
            showEditIcon: true,
          ),
        ],
      ),
    );
  }

  Widget _buildLocationCard(BuildContext context, bool isDark) {
    final l10n = AppLocalizations.of(context)!;
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
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.red.shade900.withOpacity(0.1)
                        : Colors.red.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.location_on,
                    color: isDark
                        ? Colors.red.shade400
                        : Colors.red.shade500,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.addressLabel.toUpperCase(),
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                          color: isDark
                              ? AppColors.mutedDark
                              : AppColors.mutedLight,
                        ),
                      ),
                      const SizedBox(height: 4),
                      TextField(
                        controller: _addressController,
                        maxLines: 2,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: isDark
                              ? AppColors.textDark
                              : AppColors.textLight,
                        ),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Icon(
                    Icons.edit,
                    size: 18,
                    color: isDark
                        ? AppColors.mutedDark
                        : AppColors.gray300,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField({
    required IconData icon,
    required Color iconColor,
    required String label,
    required TextEditingController controller,
    required bool isDark,
    bool showEditIcon = false,
    bool showVerifiedIcon = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isDark
                  ? _getDarkIconBg(iconColor)
                  : _getLightIconBg(iconColor),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                    color: isDark
                        ? AppColors.mutedDark
                        : AppColors.mutedLight,
                  ),
                ),
                const SizedBox(height: 4),
                TextField(
                  controller: controller,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: isDark
                        ? AppColors.textDark
                        : AppColors.textLight,
                  ),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ],
            ),
          ),
          if (showVerifiedIcon)
            Icon(
              Icons.verified,
              color: Colors.green.shade500,
              size: 20,
            )
          else if (showEditIcon)
            Icon(
              Icons.edit,
              size: 18,
              color: isDark
                  ? AppColors.mutedDark
                  : AppColors.gray300,
            ),
        ],
      ),
    );
  }

  Widget _buildDivider(bool isDark) {
    return Container(
      height: 1,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      color: isDark ? AppColors.borderDark : AppColors.borderLight,
    );
  }

  Widget _buildSaveButton(BuildContext context, bool isDark) {
    final l10n = AppLocalizations.of(context)!;
    final authController = Get.find<AuthController>();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : Colors.white,
        border: Border(
          top: BorderSide(
            color: isDark ? AppColors.borderDark : AppColors.borderLight,
          ),
        ),
      ),
      child: SafeArea(
        child: Obx(() {
          final loading = authController.isLoading.value;
          return SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: loading
                  ? null
                  : () {
                      authController.updateProfile(
                        name: _fullNameController.text.trim(),
                        phone: _phoneController.text.trim().isEmpty
                            ? null
                            : _phoneController.text.trim(),
                        address: _addressController.text.trim().isEmpty
                            ? null
                            : _addressController.text.trim(),
                      );
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.primaryForeground,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
              ),
              child: loading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(
                      l10n.saveChanges,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          );
        }),
      ),
    );
  }

  Color _getLightIconBg(Color iconColor) {
    if (iconColor == Colors.blue) return Colors.blue.shade50;
    if (iconColor == Colors.orange) return Colors.orange.shade50;
    if (iconColor == Colors.green) return Colors.green.shade50;
    if (iconColor == Colors.red) return Colors.red.shade50;
    if (iconColor == Colors.purple) return Colors.purple.shade50;
    return AppColors.gray200;
  }

  Color _getDarkIconBg(Color iconColor) {
    if (iconColor == Colors.blue) return Colors.blue.shade900.withOpacity(0.1);
    if (iconColor == Colors.orange) return Colors.orange.shade900.withOpacity(0.1);
    if (iconColor == Colors.green) return Colors.green.shade900.withOpacity(0.1);
    if (iconColor == Colors.red) return Colors.red.shade900.withOpacity(0.1);
    if (iconColor == Colors.purple) return Colors.purple.shade900.withOpacity(0.1);
    return AppColors.gray800;
  }
}

class _DashedCirclePainter extends CustomPainter {
  final Color color;
  final double strokeWidth;

  _DashedCirclePainter({
    required this.color,
    this.strokeWidth = 2.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    const dashWidth = 4.0;
    const dashSpace = 4.0;
    final circumference = 2 * 3.14159 * radius;
    final dashCount = (circumference / (dashWidth + dashSpace)).floor();
    final dashAngle = (2 * 3.14159) / dashCount;

    final path = Path();
    for (int i = 0; i < dashCount; i++) {
      final startAngle = i * dashAngle;
      final endAngle = startAngle + (dashAngle * dashWidth / (dashWidth + dashSpace));

      path.addArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        endAngle - startAngle,
      );
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

