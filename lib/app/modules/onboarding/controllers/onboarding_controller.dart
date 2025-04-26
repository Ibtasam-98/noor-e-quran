import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/app_theme_switch_controller.dart';

class OnboardingScreenController extends GetxController with SingleGetTickerProviderMixin {
  final AppThemeSwitchController themeController = Get.find();
  final PageController pageController = PageController(initialPage: 0);
  RxInt currentPage = 0.obs;

  late AnimationController animationController;
  late Animation<Offset> slideAnimation;
  var showGuestButton = false.obs;

  @override
  void onInit() {
    super.onInit();

    animationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: const Offset(0, 0),
    ).animate(CurvedAnimation(
      parent: animationController,
      curve: Curves.easeOut,
    ));

    Future.delayed(const Duration(seconds: 3), () {
      showGuestButton.value = true;
      animationController.forward(); // Start the sliding animation
    });
  }

  @override
  void onClose() {
    animationController.dispose();
    pageController.dispose();
    super.onClose();
  }

  void toggleTheme(bool isDarkMode) {
    if (themeController.isDarkMode.value != isDarkMode) {
      themeController.toggleTheme();
    }
  }
}