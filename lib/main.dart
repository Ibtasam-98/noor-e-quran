import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

// Controllers
import 'app/controllers/connectivity_controller.dart';
import 'app/controllers/app_home_screen_controller.dart';
import 'app/controllers/app_theme_switch_controller.dart';
import 'app/controllers/onboarding_controller.dart';
import 'app/controllers/user_location_premission_controller.dart';

// Views
import 'app/views/onboarding/onboarding_screen.dart';
import 'app/views/home/home_screen_bottom_navigation.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Get Storage for local data persistence.
  await GetStorage.init();

  // Device orientations to portrait only.
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Initialize and put global controllers.
  Get.put(AppThemeSwitchController());
  Get.put(OnboardingScreenController());
  Get.put(ConnectivityController());

  // Initialize and lazily put controllers that might not be immediately needed.
  Get.lazyPut(() => AppHomeScreenController());
  Get.lazyPut(() => UserPermissionController());

  final box = GetStorage();
  final hasSeenOnboarding = box.read<bool>('hasSeenOnboarding') ?? false;

  runApp(MyApp(hasSeenOnboarding: hasSeenOnboarding));
}

class MyApp extends StatelessWidget {

  final bool hasSeenOnboarding;

  const MyApp({super.key, required this.hasSeenOnboarding});

  @override
  Widget build(BuildContext context) {
    final AppThemeSwitchController themeController = Get.find<AppThemeSwitchController>();

    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          themeMode: themeController.currentTheme,
          home: child,
        );
      },
      child: hasSeenOnboarding ? BottomNavigationHomeScreen() : OnBoardingScreen(),
    );
  }
}