import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'app/config/app_bindings.dart';
import 'app/controllers/app_theme_switch_controller.dart';
import 'app/modules/boarding/views/onboarding_screen.dart';
import 'app/modules/home/views/home_screen_bottom_navigation.dart';
import 'app/modules/home/controllers/app_home_screen_bottom_navigation_controller.dart'; // Import the missing controller

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Get Storage for local data persistence.
  await GetStorage.init();

  // Device orientations to portrait only.
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  final box = GetStorage();
  final hasSeenOnboarding = box.read<bool>('hasSeenOnboarding') ?? false;

  // Initialize the AppThemeSwitchController here
  final themeController = AppThemeSwitchController();
  Get.put(themeController);

  // Initialize the AppHomeScreenBottomNavigationController
  Get.put(AppHomeScreenBottomNavigationController()); // Add this line

  runApp(MyApp(hasSeenOnboarding: hasSeenOnboarding));
}

class MyApp extends StatelessWidget {
  final bool hasSeenOnboarding;

  const MyApp({super.key, required this.hasSeenOnboarding});

  @override
  Widget build(BuildContext context) {
    final AppThemeSwitchController themeController = Get.find<AppThemeSwitchController>();
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    const baseDesignWidth = 360.0;
    const baseDesignHeight = 690.0;

    final bool isTablet = screenWidth > 600;

    double designWidth = baseDesignWidth;
    double designHeight = baseDesignHeight;

    if (isTablet) {
      designWidth = 768.0;
      designHeight = 1024.0;
    }

    return ScreenUtilInit(
      designSize: Size(designWidth, designHeight),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          initialBinding: AppBinding(),
          debugShowCheckedModeBanner: false,
          themeMode: themeController.currentTheme,
          home: child,
        );
      },
      child: hasSeenOnboarding ? AppHomeScreenBottomNavigation() : OnBoardingScreen(),
    );
  }
}
