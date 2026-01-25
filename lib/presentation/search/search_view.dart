import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../utils/app_colors.dart';
import '../../controllers/app_controller/app_controller.dart';

class SearchView extends StatelessWidget {
  const SearchView({super.key});

  @override
  Widget build(BuildContext context) {
    final appController = Get.find<AppController>();

    return Obx(() {
      final isDark = appController.isDarkMode.value;

      return SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Text(
                  'Search',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: isDark ? AppColors.textDark : AppColors.textLight,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Get.toNamed('/search-vehicles');
                  },
                  child: const Text('Search Vehicles'),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}

