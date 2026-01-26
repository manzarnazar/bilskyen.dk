import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../utils/app_colors.dart';
import '../../controllers/app_controller/app_controller.dart';
import '../../controllers/search_controller.dart' as search_controller;

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  late final search_controller.SearchViewController searchController;

  @override
  void initState() {
    super.initState();
    if (Get.isRegistered<search_controller.SearchViewController>()) {
      searchController = Get.find<search_controller.SearchViewController>();
    } else {
      searchController = Get.put(search_controller.SearchViewController());
    }
  }

  @override
  Widget build(BuildContext context) {
    final appController = Get.find<AppController>();

    return Obx(() {
      final isDark = appController.isDarkMode.value;

      return SafeArea(
        child: Column(
          children: [
            // Search Bar
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              child: TextField(
                controller: searchController.searchTextController,
                focusNode: searchController.searchFocusNode,
                decoration: InputDecoration(
                  hintText: 'What are you looking for?',
                  hintStyle: TextStyle(
                    color: isDark
                        ? AppColors.mutedDark
                        : AppColors.mutedLight,
                    fontSize: 16,
                  ),
                  filled: true,
                  fillColor: isDark ? AppColors.cardDark : Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: isDark
                          ? AppColors.borderDark
                          : AppColors.borderLight,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: isDark
                          ? AppColors.borderDark
                          : AppColors.borderLight,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: AppColors.gray400,
                      width: 1,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: isDark
                        ? AppColors.mutedDark
                        : AppColors.mutedLight,
                    size: 24,
                  ),
                ),
              ),
            ),
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

