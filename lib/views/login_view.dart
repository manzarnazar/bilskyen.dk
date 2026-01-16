import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/app_colors.dart';
import '../viewmodels/auth_controller.dart';
import 'register_view.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final AuthController _authController = Get.put(AuthController());
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isDark = _authController.isDarkMode.value;

      return Scaffold(
        backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with back button and dark mode toggle
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () => Get.back(),
                      color: isDark ? Colors.white : Colors.black,
                      style: IconButton.styleFrom(
                        backgroundColor: isDark
                            ? Colors.white.withOpacity(0.1)
                            : AppColors.surfaceLight,
                        padding: const EdgeInsets.all(8),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                // Brand name
                Text(
                  'BILSKYEN',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2.0,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
                const SizedBox(height: 16),
                // Title
                Text(
                  'Welcome Back',
                  style: GoogleFonts.inter(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 12),
                // Subtitle
                Text(
                  'Sign in to continue exploring amazing cars.',
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
                        hintText: 'Enter your password',
                        isDark: isDark,
                        isVisible: _authController.isLoginPasswordVisible.value,
                        onToggleVisibility: () =>
                            _authController.toggleLoginPasswordVisibility(),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Forgot Password Link
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          Get.snackbar(
                            'Info',
                            'Forgot password feature coming soon',
                            snackPosition: SnackPosition.TOP,
                          );
                        },
                        child: Text(
                          'Forgot Password?',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: isDark ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Login Button
                    Obx(() => SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _authController.isLoading.value
                            ? null
                            : () {
                                if (_formKey.currentState!.validate()) {
                                  _authController.login(
                                    email: _emailController.text,
                                    password: _passwordController.text,
                                  );
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isDark ? Colors.white : Colors.black,
                          foregroundColor: isDark ? Colors.black : Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 0,
                          disabledBackgroundColor: isDark
                              ? Colors.white.withOpacity(0.5)
                              : Colors.black.withOpacity(0.5),
                        ),
                        child: _authController.isLoading.value
                            ? SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    isDark ? Colors.black : Colors.white,
                                  ),
                                ),
                              )
                            : Text(
                                'Log In',
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
              // Divider with "Or login with"
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
                      'Or login with',
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
              // Register Link
              Center(
                child: RichText(
                  text: TextSpan(
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: isDark ? AppColors.mutedDark : AppColors.mutedLight,
                    ),
                    children: [
                      const TextSpan(text: "Don't have an account? "),
                      WidgetSpan(
                        child: GestureDetector(
                          onTap: () => Get.to(() => const RegisterView()),
                          child: Text(
                            'Register',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : Colors.black,
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
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: isDark
                ? Colors.white.withOpacity(0.1)
                : Colors.transparent,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: isDark
                ? Colors.white.withOpacity(0.1)
                : Colors.transparent,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: isDark ? Colors.white : Colors.black,
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
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: isDark
                ? Colors.white.withOpacity(0.1)
                : Colors.transparent,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: isDark
                ? Colors.white.withOpacity(0.1)
                : Colors.transparent,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: isDark ? Colors.white : Colors.black,
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

