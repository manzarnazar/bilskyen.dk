import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../utils/app_colors.dart';
import '../../controllers/app_controller/app_controller.dart';

class PersonalInfoView extends StatefulWidget {
  const PersonalInfoView({super.key});

  @override
  State<PersonalInfoView> createState() => _PersonalInfoViewState();
}

class _PersonalInfoViewState extends State<PersonalInfoView> {
  final _fullNameController = TextEditingController(text: 'Berken Ilkin');
  final _emailController = TextEditingController(text: 'berkenilkin@example.com');
  final _phoneController = TextEditingController(text: '+1 (555) 012-3456');
  final _addressController = TextEditingController(
    text: '123 Market Street, Suite 400\nSan Francisco, CA 94103',
  );
  DateTime? _dateOfBirth;

  @override
  void initState() {
    super.initState();
    _dateOfBirth = DateTime(1990, 5, 15);
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dateOfBirth ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primary,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _dateOfBirth) {
      setState(() {
        _dateOfBirth = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final appController = Get.find<AppController>();

    return Obx(() {
      final isDark = appController.isDarkMode.value;

      return Scaffold(
        backgroundColor: isDark
            ? AppColors.backgroundDark
            : AppColors.backgroundLight,
        appBar: AppBar(
          title: const Text(
            'Personal Info',
            style: TextStyle(
              fontSize: 18,
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
          centerTitle: true,
        ),
        body: SafeArea(
          child: Column(
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
                      _buildSectionTitle('IDENTITY'),
                      const SizedBox(height: 12),
                      _buildIdentityCard(isDark),
                      const SizedBox(height: 24),
                      // Contact Details Section
                      _buildSectionTitle('CONTACT DETAILS'),
                      const SizedBox(height: 12),
                      _buildContactDetailsCard(isDark),
                      const SizedBox(height: 24),
                      // Location Section
                      _buildSectionTitle('LOCATION'),
                      const SizedBox(height: 12),
                      _buildLocationCard(isDark),
                      const SizedBox(height: 100), // Space for fixed button
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: _buildSaveButton(isDark),
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
                      child: ClipOval(
                        child: Image.asset(
                          'assets/images/seller_profile.jpg',
                          fit: BoxFit.cover,
                          width: 104,
                          height: 104,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: 104,
                              height: 104,
                              color: AppColors.gray300,
                              child: const Icon(Icons.person, size: 56),
                            );
                          },
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
              Positioned(
                bottom: 0,
                right: 4,
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: isDark ? Colors.white : Colors.black,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isDark ? AppColors.cardDark : Colors.white,
                      width: 2,
                    ),
                  ),
                  child: Icon(
                    Icons.camera_alt,
                    size: 18,
                    color: isDark ? Colors.black : Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Center(
          child: GestureDetector(
            onTap: () {
              Get.snackbar(
                'Info',
                'Edit photo functionality coming soon',
                snackPosition: SnackPosition.TOP,
              );
            },
            child: Text(
              'Edit Photo',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.blue.shade600,
              ),
            ),
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

  Widget _buildIdentityCard(bool isDark) {
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
            label: 'FULL NAME',
            controller: _fullNameController,
            isDark: isDark,
            showEditIcon: true,
          ),
          _buildDivider(isDark),
          // Date of Birth
          InkWell(
            onTap: () => _selectDate(context),
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: isDark
                          ? Colors.purple.shade900.withOpacity(0.1)
                          : Colors.purple.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.cake,
                      color: isDark
                          ? Colors.purple.shade400
                          : Colors.purple.shade500,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'DATE OF BIRTH',
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
                        Text(
                          _dateOfBirth != null
                              ? '${_dateOfBirth!.month.toString().padLeft(2, '0')}/${_dateOfBirth!.day.toString().padLeft(2, '0')}/${_dateOfBirth!.year}'
                              : 'Select date',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: isDark
                                ? AppColors.textDark
                                : AppColors.textLight,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.calendar_today,
                    size: 18,
                    color: isDark
                        ? AppColors.mutedDark
                        : AppColors.gray300,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactDetailsCard(bool isDark) {
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
            label: 'EMAIL ADDRESS',
            controller: _emailController,
            isDark: isDark,
            showVerifiedIcon: true,
          ),
          _buildDivider(isDark),
          // Phone Number
          _buildInputField(
            icon: Icons.phone,
            iconColor: Colors.green,
            label: 'PHONE NUMBER',
            controller: _phoneController,
            isDark: isDark,
            showEditIcon: true,
          ),
        ],
      ),
    );
  }

  Widget _buildLocationCard(bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
        ),
      ),
      child: Container(
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
                    'ADDRESS',
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

  Widget _buildSaveButton(bool isDark) {
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
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              Get.snackbar(
                'Success',
                'Changes saved successfully',
                snackPosition: SnackPosition.TOP,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: isDark ? Colors.white : Colors.black,
              foregroundColor: isDark ? Colors.black : Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
            ),
            child: const Text(
              'Save Changes',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
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

