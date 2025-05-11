import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icons.dart';
import 'package:noor_e_quran/app/config/app_colors.dart';
import 'package:noor_e_quran/app/config/app_sizedbox.dart';
import 'package:noor_e_quran/app/controllers/app_theme_switch_controller.dart';
import 'package:noor_e_quran/app/modules/home/views/prayer_calculation_method_settings_screen.dart';
import 'package:noor_e_quran/app/widgets/custom_text.dart';
import 'package:shimmer/shimmer.dart';
import '../../../controllers/user_location_premission_controller.dart';
import '../../../widgets/custom_card.dart';
import '../../../widgets/custom_shimmer.dart';
import '../controllers/view_all_prayer_screen_controller.dart';
import 'global_prayer_time_screen.dart';

class ViewAllPrayerScreen extends StatelessWidget {
  final NamazController namazController = Get.find<NamazController>();
  final AppThemeSwitchController themeController = Get.find<AppThemeSwitchController>();
  final UserPermissionController locationController = Get.find<UserPermissionController>();
  final RxBool showDropdown = false.obs;

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = themeController.isDarkMode.value;
    final iconColor = isDarkMode ? AppColors.white : AppColors.black;
    final is24HourFormat = MediaQuery.of(context).alwaysUse24HourFormat;

    return Scaffold(
      backgroundColor: isDarkMode ? AppColors.black : AppColors.white,
      appBar: AppBar(
        surfaceTintColor: AppColors.transparent,
        elevation: 0,
        centerTitle: false,
        backgroundColor: isDarkMode ? AppColors.black : AppColors.white,
        title: CustomText(
          firstText: "Prayer",
          secondText: " Timing",
          fontSize: 18.sp,
          firstTextColor: isDarkMode ? AppColors.white : AppColors.black,
          secondTextColor: AppColors.primary,
        ),
        leading: IconButton(
          icon: Icon(Icons.west, color: iconColor),
          onPressed: () => Get.back(),
        ),
        actions: [
          IconButton(
            icon: Icon(LineIcons.globe, color: iconColor,size: 22.h,),
            onPressed: () {
              Get.to(GlobalPrayerTimeScreen());
            },
          ),
          Padding(
            padding: EdgeInsets.only(right: 10),
            child: IconButton(
              icon: Icon(LineIcons.moon, color: iconColor,size: 22.h,),
              onPressed: () {
                Get.to(PrayerCalculationMethodSettingsScreen());
              },
            ),
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomCard( // Removed Obx here if formattedHijriDate isn't reactive
              title: namazController.formattedHijriDate(),
              subtitle: 'Date ${DateFormat('yyyy.MM.dd').format(DateTime.now())}\n${namazController.selectedMethodName.value}',
              imageUrl: isDarkMode ? 'assets/images/sajdah_bg_dark.jpg' : 'assets/images/sajdah_bg_light.jpg',
              mergeWithGradientImage: true,
              subtitleStyle: GoogleFonts.quicksand(),
              subtitleFontSize: 10.sp,
            ),
            AppSizedBox.space10h,
            Expanded(
              child: _buildPrayerTimesList(isDarkMode, iconColor, is24HourFormat),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrayerTimesList(bool isDarkMode, Color iconColor, bool is24HourFormat) {
    return Obx(() {
      if (namazController.isNamazLoading.value) {
        return Shimmer.fromColors(
          baseColor: themeController.isDarkMode.value
              ? AppColors.black.withOpacity(0.02)
              : AppColors.black.withOpacity(0.2),
          highlightColor: themeController.isDarkMode.value
              ? AppColors.lightGrey.withOpacity(0.1)
              : AppColors.grey.withOpacity(0.2),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (int i = 0; i <= namazController.namazTimes.length; i++)
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                      child: buildShimmerContainer(height: 50.h),
                    ),
                  ),
              ]),
        );
      }
      return ListView.separated(
        itemCount: namazController.namazTimes.length,
        separatorBuilder: (context, index) => AppSizedBox.space5h,
        itemBuilder: (context, index) {
          final namazName = namazController.namazTimes[index];
          final namazTime = namazController.namazTimings[namazName] ?? "--";
          final iconName = namazController.icons[index];
          final isNextNamaz = namazName == namazController.nextNamazName.value;

          return InkWell(
            onTap: () {
              namazController.addToCalendar(namazName, namazTime);
            },
            child: AnimatedBuilder(
              animation: namazController.animationController,
              builder: (BuildContext context, Widget? child) {
                return Transform.scale(
                  scale: isNextNamaz ? namazController.scaleAnimation.value : 1.0,
                  child: Container(
                    padding: EdgeInsets.all(20.h),
                    margin: EdgeInsets.only(top: 5.h),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.r),
                      color: (index % 2 == 1)
                          ? AppColors.primary.withOpacity(0.29)
                          : AppColors.primary.withOpacity(0.1),
                      boxShadow: [
                        BoxShadow(
                          color: isDarkMode ? AppColors.black.withOpacity(0.2) : AppColors.grey.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            SvgPicture.asset(
                              "assets/images/$iconName",
                              width: 14.w,
                              height: 14.h,
                              color: isNextNamaz
                                  ? AppColors.primary
                                  : (isDarkMode ? AppColors.white : AppColors.black),
                            ),
                            AppSizedBox.space15w,
                            _buildPrayerName(namazName, isNextNamaz, isDarkMode),
                          ],
                        ),
                        Obx(() => _buildPrayerTime(
                            namazController.formatTime(namazController.namazTimings[namazName] ?? "--", is24HourFormat),
                            isNextNamaz,
                            isDarkMode,
                            namazName,)
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      );
    });
  }

  Widget _buildPrayerName(String name, bool isNextNamaz, bool isDarkMode) {
    return CustomText(
      title: name,
      textColor: isNextNamaz ? AppColors.primary : (isDarkMode ? AppColors.white : AppColors.black),
      fontSize: 14.sp,
    );
  }

  Widget _buildPrayerTime(String time, bool isNextNamaz, bool isDarkMode, String name) {
    return Row(
      children: [
        CustomText(
         title:time,
          fontSize: 12.sp,
          textColor: isDarkMode ? AppColors.white : AppColors.black,
        ),
        AppSizedBox.space10w,
        Obx(() => InkWell(
          onTap: () async {
            await namazController.addToCalendar(name, time);
          },
          child: Icon(
            Icons.notifications,
            size: 16.h,
            color: namazController.reminderSet[name]?.value == true
                ? AppColors.green
                : (isDarkMode ? AppColors.white : AppColors.black),
          ),
        )),
      ],
    );
  }
}