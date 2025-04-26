import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:intl/intl.dart';
import 'package:noor_e_quran/app/config/app_colors.dart';
import 'package:noor_e_quran/app/controllers/app_theme_switch_controller.dart';
import 'package:noor_e_quran/app/widgets/custom_text.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../config/app_sizedbox.dart';
import '../../../widgets/custom_card.dart';
import '../controllers/app_home_screen_controller.dart';

class ViewAllNamazScreen extends StatelessWidget {
  final AppHomeScreenController homeScreenController = Get.find<AppHomeScreenController>();
  final AppThemeSwitchController themeController = Get.find<AppThemeSwitchController>();

  @override
  Widget build(BuildContext context) {

    String formattedHijriDate() {
      HijriCalendar hijri = HijriCalendar.now();
      String monthName = hijri.longMonthName;
      int day = hijri.hDay;
      int year = hijri.hYear;
      return "$monthName, $day. $year";
    }
    bool isDarkMode = themeController.isDarkMode.value;
    final iconColor = isDarkMode ? AppColors.white : AppColors.black;
    final textColor = isDarkMode ? AppColors.white : AppColors.black;

    return Scaffold(
      backgroundColor: isDarkMode ? AppColors.black : AppColors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: isDarkMode ? AppColors.black : AppColors.white,
        surfaceTintColor: AppColors.transparent,
        foregroundColor: AppColors.transparent,
        title: CustomText(
          firstText: "Prayer",
          secondText: " Timing",
          fontSize:18.sp,
          firstTextColor: isDarkMode ? AppColors.white : AppColors.black,
          secondTextColor: AppColors.primary,
        ),
        centerTitle: false,
        leading: InkWell(
          onTap: () {
            Get.back();
          },
          child: Icon(
            Icons.west,
            color: iconColor,
          ),
        ),

      ),
      body: Padding(
        padding: EdgeInsets.only(left: 10.w,right: 10.w,bottom: 5.h),
        child: Column(
          children: [
            CustomCard(
              title: formattedHijriDate(),
              subtitle: 'Date ${DateFormat('yyyy.MM.dd').format(DateTime.now())}',
              imageUrl:  isDarkMode ? 'assets/images/sajdah_bg_dark.jpg' : 'assets/images/sajdah_dark_light.jpg',
              mergeWithGradientImage: true,

            ),
            AppSizedBox.space10h,
            Expanded(
              child: Obx(
                    () => homeScreenController.isNamazLoading.value
                    ? Center(child: CircularProgressIndicator())
                    : ListView.builder(
                  itemCount: homeScreenController.namazTimes.length,
                  itemBuilder: (context, index) {
                    String namazName = homeScreenController.namazTimes[index];
                    String namazTime = homeScreenController.namazTimings[namazName] ?? "--/--";
                    String formattedTime = homeScreenController.formatTime(namazTime, homeScreenController.is24HourFormat);
                    String iconName = homeScreenController.icons[index];
                    bool isNextNamaz = namazName == homeScreenController.nextNamazName.value;

                    return AnimatedBuilder(
                        animation: homeScreenController.animationController,
                        builder: (context, child){
                          return Transform.scale(
                            scale: isNextNamaz ? homeScreenController.scaleAnimation.value : 1.0,
                            alignment: Alignment.center,
                            child:  Container(
                              margin: EdgeInsets.only(top: 5.h,bottom: 5.h),
                              padding: EdgeInsets.all(15.h),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15.r),
                                color: (index % 2 == 1)
                                    ? AppColors.primary.withOpacity(0.29)
                                    : AppColors.primary.withOpacity(0.1),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      SvgPicture.asset(
                                        "assets/images/$iconName",
                                        height: 20.h,
                                        width: 20.w,
                                        color: isNextNamaz
                                            ? (isDarkMode ? AppColors.white : AppColors.primary)
                                            : (isDarkMode ? AppColors.white : AppColors.black),
                                      ),
                                      AppSizedBox.space15w,
                                      CustomText(
                                        title: namazName,
                                        fontSize: 16.sp,
                                        fontWeight: isNextNamaz ? FontWeight.bold : FontWeight.normal,
                                        textColor: isNextNamaz ? AppColors.primary : isDarkMode ? AppColors.white : AppColors.black,
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      CustomText(
                                        title: formattedTime,
                                        fontSize: 16.sp,
                                        fontWeight: isNextNamaz ? FontWeight.bold : FontWeight.normal,
                                        textColor: isDarkMode ? AppColors.grey : AppColors.black,
                                      ),
                                      AppSizedBox.space10w,
                                      if (isNextNamaz)
                                        Container(
                                          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                                          decoration: BoxDecoration(
                                            color: AppColors.primary,
                                            borderRadius: BorderRadius.circular(8.r),
                                          ),
                                          child: CustomText(
                                            title: "Now",
                                            textColor: AppColors.white,
                                            fontSize: 12.sp,
                                          ),
                                        ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          );
                        });
                  },
                ),
              ),
            )
          ],
        ),
      )
    );
  }
}