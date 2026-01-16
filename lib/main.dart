import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'utils/app_theme.dart';
import 'utils/token_storage.dart';
import 'viewmodels/auth_controller.dart';
import 'views/home_view.dart';
import 'views/register_view.dart';
import 'views/login_view.dart';
import 'views/profile_view.dart';
import 'views/dark_mode_settings_view.dart';
import 'views/personal_info_view.dart';
import 'views/messages_view.dart';
import 'views/favorites_view.dart';
import 'views/search_view.dart';
import 'views/brands_selection_view.dart';
import 'views/sell_your_car_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize token storage
  await TokenStorage.init();
  
  // Initialize AuthController early to restore session
  Get.put(AuthController());
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();
    
    return Obx(() {
      // Show loading screen while initializing
      if (authController.isInitializing.value) {
        return MaterialApp(
          title: 'BILSKYEN - Car Marketplace',
          debugShowCheckedModeBanner: false,
          home: Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          ),
        );
      }
      
      // Determine initial route based on authentication status
      final initialRoute = authController.isAuthenticated ? '/home' : '/login';
      
      return GetMaterialApp(
        title: 'BILSKYEN - Car Marketplace',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.light, // Default to light theme
        initialRoute: initialRoute,
        getPages: [
          GetPage(name: '/register', page: () => const RegisterView()),
          GetPage(name: '/login', page: () => const LoginView()),
          GetPage(name: '/home', page: () => const HomeView()),
          GetPage(name: '/profile', page: () => const ProfileView()),
          GetPage(name: '/dark-mode-settings', page: () => const DarkModeSettingsView()),
          GetPage(name: '/personal-info', page: () => const PersonalInfoView()),
          GetPage(name: '/messages', page: () => const MessagesView()),
          GetPage(name: '/favorites', page: () => const FavoritesView()),
          GetPage(name: '/search', page: () => const SearchView()),
          GetPage(name: '/brands-selection', page: () => const BrandsSelectionView()),
          GetPage(name: '/sell-your-car', page: () => const SellYourCarView()),
        ],
      );
    });
  }
}
