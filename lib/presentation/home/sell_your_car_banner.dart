import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../main.dart';
import '../../utils/app_colors.dart';

class SellYourCarBanner extends StatelessWidget {
  const SellYourCarBanner({super.key});

  bool get _isLoggedIn {
    try {
      final token = appStorage.read('token');
      return token != null && token.toString().isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  void _onStartSellingPressed(BuildContext context) {
    if (!_isLoggedIn) {
      _showLoginDialog(context);
      return;
    }
    Get.toNamed('/sell-your-car');
  }

  void _showLoginDialog(BuildContext context) {
    Get.dialog(
      AlertDialog(
        title: const Text('Login required'),
        content: const Text(
          'Please sign in to list your vehicle on the marketplace.',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              Get.toNamed('/login');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
            child: const Text('Log in'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: const Color(0xFF1E3A5F), // Dark blue color
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Sell your car hassle-free',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Get an instant offer or list it on the marketplace in minutes.',
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () => _onStartSellingPressed(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFF1E3A5F),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Start Selling',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
  }
}

