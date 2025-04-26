import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:noor_e_quran/app/controllers/app_theme_switch_controller.dart';

import '../../../config/app_colors.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_text.dart';


class AppHomeScreenBottomNavigationController extends GetxController {
  var selectedIndex = 0.obs;
  final InternetConnectionChecker internetConnectionChecker = InternetConnectionChecker.createInstance();

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
    checkInternetConnection();
  }

  Future<void> checkInternetConnection() async {
    final AppThemeSwitchController themeController = Get.put(AppThemeSwitchController());
    final isDarkMode = themeController.isDarkMode.value;
    final textColor = isDarkMode ? AppColors.white : AppColors.black;
    bool hasConnection = await internetConnectionChecker.hasConnection;
    if (!hasConnection) {
      Get.dialog(
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
            title: "Please connect to the internet and restart the app.",
            fontSize: 14.sp,
            textColor: textColor,
            maxLines: 15,
            textAlign: TextAlign.start,
            textOverflow: TextOverflow.ellipsis,
          ),
          actions: <Widget>[
            InkWell(
              onTap:() async{
                Get.back();
              },child:CustomButton(
              height: 40.h,
              haveBgColor: true,
              borderRadius: 10,
              btnTitle: 'Got It',
              btnTitleColor: AppColors.white,
              btnBorderColor: AppColors.primary,
              bgColor: AppColors.primary,
            ),
            )
          ],
        ),
        barrierDismissible: false, // Prevent dismissing by tapping outside
      );
    }
  }
}