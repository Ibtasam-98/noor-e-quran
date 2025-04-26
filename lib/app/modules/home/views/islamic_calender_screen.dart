import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:islamic_hijri_calendar/islamic_hijri_calendar.dart';
import 'package:get/get.dart';
import '../../../config/app_colors.dart';
import '../../../controllers/app_theme_switch_controller.dart';
import '../../../widgets/custom_text.dart';

class IslamicCalendarScreen extends StatelessWidget {

  IslamicCalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AppThemeSwitchController themeController =
    Get.find<AppThemeSwitchController>();
    bool isDarkMode = themeController.isDarkMode.value;

    return Scaffold(
      backgroundColor: isDarkMode ? AppColors.black : AppColors.white,
      appBar: AppBar(
        surfaceTintColor: AppColors.transparent,
        foregroundColor: AppColors.transparent,
        centerTitle: false,
        title: CustomText(
          firstText: "Islamic",
          secondText: " Calender",
          firstTextColor: isDarkMode ? AppColors.white : AppColors.black,
          secondTextColor: AppColors.primary,
          fontSize: 18.sp,
        ),
        backgroundColor: isDarkMode ? AppColors.black : AppColors.white,
        leading: InkWell(
          onTap: () => Get.back(),
          child:
          Icon(Icons.west, color: isDarkMode ? AppColors.white : AppColors.black),
        ),

      ),
      body: IslamicHijriCalendar(
        isHijriView: true,
        highlightBorder: AppColors.primary,
        defaultBorder: AppColors.secondry,
        highlightTextColor: AppColors.white,
        defaultTextColor: isDarkMode ? AppColors.white : AppColors.black,
        defaultBackColor: isDarkMode ? AppColors.black : AppColors.white,
        adjustmentValue: 0,
        isGoogleFont: true,
        fontFamilyName: "Lato",

        isDisablePreviousNextMonthDates: true,
      ),
    );
  }
}
