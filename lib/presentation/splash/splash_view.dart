import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../utils/app_colors.dart';
import '../../controllers/app_controller/app_controller.dart';
import '../../main.dart';
import '../../models/auth_model/user_model.dart';
import '../../repositories/auth/auth_repository.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    ));

    _animationController.forward();

    // Check if user is logged in and navigate accordingly
    // Small delay to ensure storage is ready
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        _checkAuthAndNavigate();
      }
    });
  }

  Future<void> _checkAuthAndNavigate() async {
    try {
      // Check if user data and token exist
      final userJson = appStorage.read('user');
      final token = appStorage.read('token');
      
      // Debug: Print what we found
      debugPrint('Splash: Checking auth - User: ${userJson != null}, Token: ${token != null && token.toString().isNotEmpty}');
      
      // If both user and token exist, verify token is still valid
      if (userJson != null && token != null && token.toString().isNotEmpty) {
        // Verify user data can be parsed
        try {
          final userMap = jsonDecode(userJson.toString());
          final user = UserModel.fromJson(userMap as Map<String, dynamic>);
          
          // If user is banned, redirect to login
          if (user.banned) {
            debugPrint('Splash: User is banned, redirecting to login');
            Get.offAllNamed('/login');
            return;
          }
          
          // Try to validate token by calling /auth/me endpoint
          // This ensures the token is still valid
          try {
            final authRepository = AuthRepository();
            final result = await authRepository.me();
            
            result.fold(
              (error) {
                // Token is invalid or expired, clear storage and go to login
                debugPrint('Splash: Token validation failed: $error');
                appStorage.remove('user');
                appStorage.remove('token');
                appStorage.remove('refreshToken');
                Get.offAllNamed('/login');
              },
              (validUser) {
                // Token is valid, user is logged in, go to main
                debugPrint('Splash: Token is valid, user is logged in, redirecting to main');
                Get.offAllNamed('/main');
              },
            );
          } catch (e) {
            // Error validating token, assume it's invalid and go to login
            debugPrint('Splash: Error validating token: $e');
            appStorage.remove('user');
            appStorage.remove('token');
            appStorage.remove('refreshToken');
            Get.offAllNamed('/login');
          }
        } catch (e) {
          // Invalid user data, go to login
          debugPrint('Splash: Error parsing user data: $e');
          Get.offAllNamed('/login');
        }
      } else {
        // No user data or token, go to login
        debugPrint('Splash: No user or token found, redirecting to login');
        Get.offAllNamed('/login');
      }
    } catch (e) {
      // Error checking auth, go to login
      debugPrint('Splash: Error checking auth: $e');
      Get.offAllNamed('/login');
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appController = Get.find<AppController>();

    return Obx(() {
      final isDark = appController.isDarkMode.value;

      return Scaffold(
        backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
        body: Center(
          child: AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return Opacity(
                opacity: _fadeAnimation.value,
                child: Transform.scale(
                  scale: _scaleAnimation.value,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Brand Logo
                      Image.asset(
                        isDark ? 'assets/images/logo_white.png' : 'assets/images/logo.png',
                        height: 120,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              color: isDark ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.05),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.directions_car,
                              size: 64,
                              color: isDark ? Colors.white : Colors.black,
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 48),
                      // Loading Indicator
                      SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      );
    });
  }
}

