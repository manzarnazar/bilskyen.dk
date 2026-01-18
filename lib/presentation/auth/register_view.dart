import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../utils/app_colors.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/app_controller/app_controller.dart';
import 'login_view.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final AuthController _authController = Get.put(AuthController());
  final AppController _appController = Get.find<AppController>();
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isDark = _appController.isDarkMode.value;

      return Scaffold(
        backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                // Brand Logo
                Center(
                  child: Image.asset(
                    isDark ? 'assets/images/logo_white.png' : 'assets/images/logo.png',
                    height: 60,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Text(
                        'BILSKYEN',
                        style: GoogleFonts.inter(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2.0,
                          color: AppColors.primary,
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 32),
                // Title
                Text(
                  'Create Account',
                  style: GoogleFonts.inter(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 8),
                // Subtitle
                Text(
                  'Sign up to start your journey with the ultimate car marketplace.',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    color: isDark ? AppColors.mutedDark : AppColors.mutedLight,
                    height: 1.5,
                  ),
                ),
              const SizedBox(height: 32),
              // Form
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Full Name Field
                    _buildLabel('FULL NAME', isDark),
                    const SizedBox(height: 8),
                    _buildTextField(
                      controller: _fullNameController,
                      hintText: 'Enter your full name',
                      icon: Icons.person,
                      isDark: isDark,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your full name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    // Email Field
                    _buildLabel('EMAIL ADDRESS', isDark),
                    const SizedBox(height: 8),
                    _buildTextField(
                      controller: _emailController,
                      hintText: 'name@example.com',
                      icon: Icons.mail,
                      isDark: isDark,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!GetUtils.isEmail(value)) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    // Password Field
                    _buildLabel('PASSWORD', isDark),
                    const SizedBox(height: 8),
                    Obx(
                      () => _buildPasswordField(
                        controller: _passwordController,
                        hintText: 'Create a password',
                        isDark: isDark,
                        isVisible: _authController.isPasswordVisible.value,
                        onToggleVisibility: () =>
                            _authController.togglePasswordVisibility(),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a password';
                          }
                          if (value.length < 6) {
                            return 'Password must be at least 6 characters';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Terms and Conditions
                    Obx(
                      () => Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Checkbox(
                            value: _authController.agreeToTerms.value,
                            onChanged: (_) =>
                                _authController.toggleTermsAgreement(),
                            activeColor: AppColors.primary,
                            checkColor: AppColors.primaryForeground,
                            side: BorderSide(
                              color: isDark
                                  ? Colors.white.withOpacity(0.2)
                                  : Colors.grey.shade300,
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 12),
                              child: RichText(
                                text: TextSpan(
                                  style: GoogleFonts.inter(
                                    fontSize: 14,
                                    color: isDark
                                        ? AppColors.mutedDark
                                        : AppColors.gray600,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  children: [
                                    const TextSpan(text: 'I agree to the '),
                                    TextSpan(
                                      text: 'Terms',
                                      style: GoogleFonts.inter(
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                    const TextSpan(text: ' and '),
                                    TextSpan(
                                      text: 'Privacy Policy',
                                      style: GoogleFonts.inter(
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    // Register Button
                    Obx(() => SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _authController.isLoading.value
                            ? null
                            : () {
                                if (_formKey.currentState!.validate()) {
                                  _authController.register(
                                    fullName: _fullNameController.text,
                                    email: _emailController.text,
                                    password: _passwordController.text,
                                  );
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: AppColors.primaryForeground,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 2,
                          disabledBackgroundColor: AppColors.primary.withOpacity(0.5),
                        ),
                        child: _authController.isLoading.value
                            ? SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    AppColors.primaryForeground,
                                  ),
                                ),
                              )
                            : Text(
                                'Register',
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    )),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              // Divider with "Or register with"
              Row(
                children: [
                  Expanded(
                    child: Divider(
                      color: isDark
                          ? Colors.white.withOpacity(0.1)
                          : Colors.grey.shade200,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Or register with',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: isDark ? AppColors.mutedDark : AppColors.mutedLight,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Divider(
                      color: isDark
                          ? Colors.white.withOpacity(0.1)
                          : Colors.grey.shade200,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // Social Login Buttons
              _buildSocialButton(
                icon: _buildGoogleIcon(isDark),
                label: 'Continue with Google',
                isDark: isDark,
                onPressed: () => _authController.signInWithGoogle(),
              ),
              const SizedBox(height: 32),
              // Login Link
              Center(
                child: RichText(
                  text: TextSpan(
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: isDark ? AppColors.mutedDark : AppColors.mutedLight,
                    ),
                    children: [
                      const TextSpan(text: 'Already have an account? '),
                      WidgetSpan(
                        child: GestureDetector(
                          onTap: () => Get.to(() => const LoginView()),
                          child: Text(
                            'Log in',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      );
    });
  }

  Widget _buildLabel(String label, bool isDark) {
    return Text(
      label,
      style: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: isDark ? AppColors.mutedDark : AppColors.mutedLight,
        letterSpacing: 1.2,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    required bool isDark,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      style: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: isDark ? Colors.white : Colors.black,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: GoogleFonts.inter(
          fontSize: 14,
          color: AppColors.gray400,
        ),
        prefixIcon: Icon(
          icon,
          size: 20,
          color: AppColors.gray400,
        ),
        filled: true,
        fillColor: isDark
            ? Colors.white.withOpacity(0.05)
            : AppColors.surfaceLight,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: isDark
                ? Colors.white.withOpacity(0.1)
                : AppColors.borderLight,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: isDark
                ? Colors.white.withOpacity(0.1)
                : AppColors.borderLight,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: AppColors.primary,
            width: 2,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String hintText,
    required bool isDark,
    required bool isVisible,
    required VoidCallback onToggleVisibility,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: !isVisible,
      validator: validator,
      style: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: isDark ? Colors.white : Colors.black,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: GoogleFonts.inter(
          fontSize: 14,
          color: AppColors.gray400,
        ),
        prefixIcon: Icon(
          Icons.lock,
          size: 20,
          color: AppColors.gray400,
        ),
        suffixIcon: IconButton(
          icon: Icon(
            isVisible ? Icons.visibility : Icons.visibility_off,
            size: 20,
            color: AppColors.gray400,
          ),
          onPressed: onToggleVisibility,
        ),
        filled: true,
        fillColor: isDark
            ? Colors.white.withOpacity(0.05)
            : AppColors.surfaceLight,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: isDark
                ? Colors.white.withOpacity(0.1)
                : AppColors.borderLight,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: isDark
                ? Colors.white.withOpacity(0.1)
                : AppColors.borderLight,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: AppColors.primary,
            width: 2,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
    );
  }

  Widget _buildSocialButton({
    required Widget icon,
    required String label,
    required bool isDark,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: isDark
              ? Colors.white.withOpacity(0.05)
              : const Color.fromARGB(255, 204, 206, 213), // Grey background
          foregroundColor: isDark ? Colors.white : const Color(0xFF3C4043), // Dark gray text
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
              color: isDark
                  ? Colors.white.withOpacity(0.1)
                  : Colors.transparent,
            ),
          ),
          side: BorderSide(
            color: isDark
                ? Colors.white.withOpacity(0.1)
                : Colors.transparent,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon,
            const SizedBox(width: 12),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: isDark ? Colors.white : const Color(0xFF3C4043),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGoogleIcon(bool isDark) {
    return Image.asset(
      'assets/images/google.png',
      width: 20,
      height: 20,
      errorBuilder: (context, error, stackTrace) {
        return Icon(
          Icons.g_mobiledata,
          size: 20,
          color: isDark ? Colors.white : const Color(0xFF3C4043),
        );
      },
    );
  }
}

