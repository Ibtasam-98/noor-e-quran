import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:get/get.dart';
import 'package:noor_e_quran/app/modules/home/controllers/view_all_prayer_screen_controller.dart';
import '../../../config/app_contants.dart';
import '../../../controllers/user_location_premission_controller.dart';
import '../../../controllers/app_theme_switch_controller.dart';

class AppHomeScreenController extends GetxController with GetSingleTickerProviderStateMixin {
  final AppThemeSwitchController themeController = Get.put(AppThemeSwitchController());
  final UserPermissionController locationController = Get.put(UserPermissionController());
  final NamazController namazController = Get.put(NamazController());
  var city = "Locating...".obs;
  final isLoading = false.obs;
  bool isIconOpen = false;
  late AnimationController animationController;
  late Animation<double> scaleAnimation;
  final advancedDrawerController = AdvancedDrawerController();
  final PageController pageController = PageController();
  final RxInt currentPage = 0.obs;
  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
    scaleAnimation = Tween<double>(begin: 0.9, end: 1.0).animate(
      CurvedAnimation(parent: animationController, curve: Curves.easeInOut),
    );
    _initialize();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startAutoScroll();
    });
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (pageController.hasClients) {
        if (currentPage.value < AppConstants.sliderItems.length - 1) {
          currentPage.value++;
        } else {
          currentPage.value = 0;
        }

        pageController.animateToPage(
          currentPage.value,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void onClose() {
    animationController.dispose();
    _timer?.cancel();
    pageController.dispose();
    super.onClose();
  }

  Future<void> _initialize() async {
    await getLocationPermissionAndFetchNamazTimes();
  }

  void handleMenuButtonPressed() {
    advancedDrawerController.showDrawer();
  }

  Future<void> getLocationPermissionAndFetchNamazTimes() async {
    await locationController.accessLocation();
    if (locationController.locationAccessed.value) {
      await namazController.getNamazTimings(
        locationController.latitude.value,
        locationController.longitude.value,
        method: namazController.selectedCalculationMethod.value,
      );
      city.value = locationController.cityName.value;
    } else {
      city.value = "Location Permission Denied";
    }
  }

  final List<Map<String, dynamic>> menuItems = [
    {"title": "Daily", "subtitle": "Daily Duas", "destination": () => const Placeholder()},
    {"title": "Tasbeeh", "subtitle": "Zikr Counter", "destination": () => const Placeholder()},
    {"title": "Prayers", "subtitle": "Salat Guide", "destination": () => const Placeholder()},
    {"title": "Islamic", "subtitle": "Hijri Calendar", "destination": () => const Placeholder()},
  ];
}