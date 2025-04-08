
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:noor_e_quran/app/controllers/app_home_screen_controller.dart';
import 'package:noor_e_quran/app/controllers/connectivity_controller.dart';
import 'app/controllers/app_theme_switch_controller.dart';
import 'app/controllers/onboarding_controller.dart'; // Import OnboardingController
import 'app/controllers/quran_saved_ayat_bookmark_controller.dart';
import 'app/views/onboarding/onboarding_screen.dart';
import 'app/views/onboarding/user_permission_screen.dart';
import 'app/views/home/home_screen_bottom_navigation.dart'; // Import BottomNavigationHomeScreen

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  Get.put(AppThemeSwitchController());
  Get.put(OnboardingScreenController()); // Initialize OnboardingController
  Get.put(ConnectivitiyController());
  Get.put(AppHomeScreenController());

  final box = GetStorage();
  final hasSeenOnboarding = box.read('hasSeenOnboarding') ?? false;

  runApp(MyApp(hasSeenOnboarding: hasSeenOnboarding));
}

class MyApp extends StatelessWidget {
  final bool hasSeenOnboarding;

  MyApp({required this.hasSeenOnboarding});

  @override
  Widget build(BuildContext context) {
    final AppThemeSwitchController _themeController = Get.find<AppThemeSwitchController>(); //Use Get.find

    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          themeMode: _themeController.currentTheme,
          home: child,
        );
      },
      child: hasSeenOnboarding ? BottomNavigationHomeScreen() : OnBoardingScreen(), // Conditional rendering
    );
  }
}
