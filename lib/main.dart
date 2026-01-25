import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'utils/app_theme.dart';
import 'controllers/app_controller/app_controller.dart';
import 'presentation/splash/splash_view.dart';
import 'presentation/main_navigation_view.dart';
import 'presentation/auth/login_view.dart';
import 'presentation/auth/register_view.dart';
import 'presentation/profile/dark_mode_settings_view.dart';
import 'presentation/profile/personal_info_view.dart';
import 'presentation/search/vehicle_result_view.dart';
import 'presentation/vehicle/vehicle_detail_view.dart';


final appStorage = GetStorage();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize GetStorage
  await GetStorage.init();
  
  // Initialize controllers early
  Get.put(AppController());
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final appController = Get.find<AppController>();
    
    return Obx(() {
      return GetMaterialApp(
        title: 'BILSKYEN - Car Marketplace',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: appController.themeMode.value,
        initialRoute: '/splash',
        getPages: [
          GetPage(name: '/splash', page: () => const SplashView()),
          GetPage(name: '/login', page: () => const LoginView()),
          GetPage(name: '/register', page: () => const RegisterView()),
          GetPage(name: '/main', page: () => const MainNavigationView()),
          GetPage(name: '/dark-mode-settings', page: () => const DarkModeSettingsView()),
          GetPage(name: '/personal-info', page: () => const PersonalInfoView()),
          GetPage(name: '/search-vehicles', page: () => const VehicleResultView()),
          GetPage(name: '/vehicle-detail/:id', page: () => const VehicleDetailView()),
        ],
      );
    });
  }
}
