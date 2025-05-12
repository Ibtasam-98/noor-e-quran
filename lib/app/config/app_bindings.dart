import 'package:get/get.dart';
import 'package:noor_e_quran/app/modules/home/controllers/view_all_prayer_screen_controller.dart';
import '../controllers/connectivity_controller.dart';
import '../controllers/app_theme_switch_controller.dart';
import '../controllers/flying_bird_animation_controller.dart';
import '../controllers/user_location_premission_controller.dart';
import '../modules/boarding/controllers/onboarding_controller.dart';
import '../modules/hadith/controllers/hadith_collectinon_screen_controller.dart';
import '../modules/home/controllers/app_home_screen_controller.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {

    // Initialize and put global controllers.
    Get.put(AppThemeSwitchController());
    Get.put(OnboardingScreenController());
    Get.put(ConnectivityController());

    // Initialize and lazily put controllers that might not be immediately needed.
    Get.lazyPut(() => AppHomeScreenController());
    Get.lazyPut(() => UserPermissionController());
    Get.lazyPut(() => NamazController());
    Get.lazyPut(() => FlyingBirdAnimationController());
    Get.lazyPut(() => HadithCollectionController());
  }
}