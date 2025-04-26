import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:noor_e_quran/app/controllers/app_theme_switch_controller.dart';
import 'package:noor_e_quran/app/controllers/connectivity_controller.dart'; // Import ConnectivityController

import '../../../config/app_colors.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_text.dart';

class AppHomeScreenBottomNavigationController extends GetxController {
  var selectedIndex = 0.obs;
  final ConnectivityController connectivityController = Get.put(ConnectivityController()); // Initialize ConnectivityController
  RxBool isDialogOpen = false.obs; // Track if the dialog is open

  int get currentIndex => selectedIndex.value;
  set currentIndex(int index) {
    selectedIndex.value = index;
  }

  void updateSelectedIndex(int index) {
    selectedIndex.value = index;
  }

  void onTabTapped(int index) {
    selectedIndex.value = index;
  }

  @override
  void onInit() {
    super.onInit();
    checkInitialInternetConnection();
  }

  Future<void> checkInitialInternetConnection() async {
    await connectivityController.checkConnectivity();
    if (!connectivityController.isConnected.value && !isDialogOpen.value) {
      _showNoInternetDialog();
    }
    // Optionally, you can add a listener to the connectivity status
    ever(connectivityController.isConnected, (isConnected) {
      if (isConnected && isDialogOpen.value) {
        Get.back(); // Close the dialog if connection is restored
        isDialogOpen.value = false;
      } else if (!isConnected && !isDialogOpen.value) {
        _showNoInternetDialog();
      }
    });
  }

  Future<void> _showNoInternetDialog() async {
    isDialogOpen.value = true;
    final AppThemeSwitchController themeController = Get.find<AppThemeSwitchController>();
    final isDarkMode = themeController.isDarkMode.value;
    final textColor = isDarkMode ? AppColors.white : AppColors.black;

    await Get.dialog(
      AlertDialog(
        backgroundColor: AppColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        title: CustomText(
          title: 'No Internet Connection',
          fontSize: 20.sp,
          textColor: AppColors.primary,
          textAlign: TextAlign.start,
          fontWeight: FontWeight.bold,
          fontFamily: 'grenda',
        ),
        content: CustomText(
          title: "Please connect to the internet to continue.",
          fontSize: 14.sp,
          textColor: AppColors.black,
          maxLines: 15,
          textAlign: TextAlign.start,
          textOverflow: TextOverflow.ellipsis,
        ),
        actions: <Widget>[
          Obx(() => InkWell(
            onTap: () async {
              await connectivityController.checkConnectivity();
              if (connectivityController.isConnected.value) {
                Get.back(); // Close the dialog if connection is now available
                isDialogOpen.value = false;
              }
            },
            child: CustomButton(
              height: 40.h,
              haveBgColor: true,
              borderRadius: 10,
              btnTitle: connectivityController.isLoading.value ? 'Checking...' : 'Check Now',
              btnTitleColor: AppColors.white,
              btnBorderColor: AppColors.primary,
              bgColor: AppColors.primary,
              gradient: LinearGradient(
                colors: [
                  AppColors.primary,
                  AppColors.secondry.withOpacity(0.9),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          )),
        ],
      ),
      barrierDismissible: false, // Prevent dismissing by tapping outside
    );
  }
}