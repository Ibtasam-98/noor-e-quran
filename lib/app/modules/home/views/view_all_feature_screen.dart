import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../config/app_colors.dart';
import '../../../controllers/app_theme_switch_controller.dart';
import '../../../widgets/custom_text.dart';

class ViewAllFeatureScreen extends StatelessWidget {

  final AppThemeSwitchController themeController = Get.find<AppThemeSwitchController>();

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = themeController.isDarkMode.value;

    return Scaffold(
        backgroundColor: isDarkMode ? AppColors.black : AppColors.white,
        appBar: AppBar(
        centerTitle: false,
        title: CustomText(
        firstText: "Explore",
        secondText: " Features",
        fontSize: 18.sp,
        firstTextColor: isDarkMode ? AppColors.white : AppColors.black,
        secondTextColor: AppColors.primary,
        textColor: isDarkMode ? AppColors.white : AppColors.black,
    ),
    leading: IconButton(
    icon: Icon(Icons.west, color: isDarkMode ? AppColors.white : AppColors.black),
    onPressed: () => Get.back(),
    ),
    backgroundColor: isDarkMode ? AppColors.black : AppColors.white,
    elevation: 0,
    surfaceTintColor: AppColors.transparent,
    ),
    body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w),
    ),
    );
  }
}
