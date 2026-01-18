import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utils/app_colors.dart';
import '../controllers/app_controller/main_navigation_controller.dart';
import '../controllers/app_controller/app_controller.dart';
import '../shared/bottom_nav_bar.dart';
import 'home/home_view.dart';
import 'favorites/favorites_view.dart';
import 'search/search_view.dart';
import 'messages/messages_view.dart';
import 'profile/profile_view.dart';

class MainNavigationView extends StatelessWidget {
  const MainNavigationView({super.key});

  @override
  Widget build(BuildContext context) {
    final navController = Get.put(MainNavigationController());

    final appController = Get.find<AppController>();

    return Obx(() {
      final isDark = appController.isDarkMode.value;
      final currentIndex = navController.currentIndex.value;

      return Scaffold(
        backgroundColor: isDark
            ? AppColors.backgroundDark
            : AppColors.backgroundLight,
        body: IndexedStack(
          index: currentIndex,
          children: const [
            HomeView(),
            FavoritesView(),
            SearchView(),
            MessagesView(),
            ProfileView(),
          ],
        ),
        bottomNavigationBar: BottomNavBar(
          currentIndex: currentIndex,
          onTap: (index) => navController.changeTab(index),
        ),
      );
    });
  }
}

