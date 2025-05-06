import 'package:adhan/adhan.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:flutter_svg/flutter_svg.dart'; // Import the flutter_svg package


import '../../../config/app_colors.dart';
import '../../../config/app_sizedbox.dart';
import '../../../controllers/app_theme_switch_controller.dart';
import '../../../controllers/user_location_premission_controller.dart';
import '../../../widgets/custom_card.dart';
import '../../../widgets/custom_text.dart';
import '../controllers/app_home_screen_controller.dart';
import '../controllers/prayer_controller.dart';

class CalculationMethodDropdown extends StatelessWidget {
  final PrayerController prayerController = Get.find<PrayerController>();
  final AppThemeSwitchController themeController = Get.find<AppThemeSwitchController>();

  CalculationMethodDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.29),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Obx(
            () => DropdownButton<CalculationMethod>(
          value: prayerController.selectedMethod.value,
          items: CalculationMethod.values.map((method) {
            return DropdownMenuItem<CalculationMethod>(
              value: method,
              child: CustomText(
                title: _getMethodName(method),
                fontSize: 12.sp,
                capitalize: true,
                textAlign: TextAlign.start,
                textColor: themeController.isDarkMode.value
                    ? AppColors.black
                    : AppColors.black,
              ),
            );
          }).toList(),
          onChanged: (value) async {
            if (value != null) {
              prayerController.updateCalculationMethod(value);
              prayerController.startPrayerTimeLoading();
              await Future.delayed(const Duration(seconds: 2));
              prayerController.stopPrayerTimeLoading();
            }
          },
          underline: Container(),
          dropdownColor: AppColors.white,
          icon: Icon(
            Icons.arrow_drop_down,
            color: themeController.isDarkMode.value ? AppColors.white : AppColors.black,
          ),
          iconSize: 24,
          isExpanded: true,
          selectedItemBuilder: (BuildContext context) {
            return CalculationMethod.values.map<Widget>((CalculationMethod item) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: CustomText(
                    title: _getMethodName(item),
                    fontSize: 12.sp,
                    capitalize: true,
                    textAlign: TextAlign.center,
                    textColor: themeController.isDarkMode.value
                        ? AppColors.white
                        : AppColors.black,
                  ),
                ),
              );
            }).toList();
          },
        ),
      ),
    );
  }

  String _getMethodName(CalculationMethod method) {
    switch (method) {
      case CalculationMethod.muslim_world_league:
        return 'Muslim World League';
      case CalculationMethod.egyptian:
        return 'Egyptian General Authority of Survey';
      case CalculationMethod.karachi:
        return 'University of Islamic Sciences, Karachi';
      case CalculationMethod.umm_al_qura:
        return 'Umm al-Qura University, Makkah';
      case CalculationMethod.dubai:
        return 'Dubai';
      case CalculationMethod.qatar:
        return 'Qatar';
      case CalculationMethod.kuwait:
        return 'Kuwait';
      case CalculationMethod.moon_sighting_committee:
        return 'Moonsighting Committee';
      case CalculationMethod.singapore:
        return 'Singapore';
      case CalculationMethod.north_america:
        return 'North America (ISNA)';
      case CalculationMethod.turkey:
        return 'Turkey';
      case CalculationMethod.tehran:
        return 'Tehran';
      case CalculationMethod.other:
        return 'Other';
      default:
        return method.toString().split('.').last;
    }
  }
}

class ViewAllPrayerScreen extends StatelessWidget {
  final AppHomeScreenController homeScreenController = Get.find<AppHomeScreenController>();
  final AppThemeSwitchController themeController = Get.find<AppThemeSwitchController>();
  final prayerController = Get.find<PrayerController>();
  final userPermissionController = Get.find<UserPermissionController>();

  ViewAllPrayerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = themeController.isDarkMode.value;
    final iconColor = isDarkMode ? AppColors.white : AppColors.black;

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
          fontSize: 18.sp,
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
        actions: [],
      ),
      body: Padding(
        padding: EdgeInsets.only(left: 10.w, right: 10.w, bottom: 5.h),
        child: Column(
          children: [
            CustomCard(
              title: prayerController.formattedHijriDate(),
              subtitle: 'Date ${DateFormat('yyyy.MM.dd').format(DateTime.now())}',
              imageUrl: isDarkMode ? 'assets/images/sajdah_bg_dark.jpg' : 'assets/images/sajdah_bg_light.jpg',
              mergeWithGradientImage: true,
            ),
            AppSizedBox.space10h,
            Expanded(
              child: Obx(
                    () {
                  if (!userPermissionController.locationAccessed.value) {
                    return const Center(
                      child: Text('Please enable location access to view prayer times.'),
                    );
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CalculationMethodDropdown(),
                      AppSizedBox.space10h,
                      Expanded(
                        child: Obx(() {
                          final pt = prayerController.prayerTimes.value;
                          if (prayerController.isLoadingPrayerTimes.value) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,

                            );
                          } else if (pt != null) {
                            return  Container(
                              margin: EdgeInsets.only(top: 5.h, bottom: 5.h),
                              child: _buildPrayerTimeList(pt),
                            );
                          } else {
                            return const Text('Prayer times not available.');
                          }
                        }),
                      )
                    ],
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
  Widget _buildPrayerTimeList(PrayerTimes pt) {
    final themeController = Get.find<AppThemeSwitchController>();
    final List<Map<String, String>> prayerTimesList = [
      {'name': 'Fajr', 'time': prayerController.formatTime(pt.fajr), 'icon': 'assets/images/fajr.svg'},
      {'name': 'Sunrise', 'time': prayerController.formatTime(pt.sunrise), 'icon': 'assets/images/dhuhr.svg'},
      {'name': 'Dhuhr', 'time': prayerController.formatTime(pt.dhuhr), 'icon': 'assets/images/dhuhr.svg'},
      {'name': 'Asr', 'time': prayerController.formatTime(pt.asr), 'icon': 'assets/images/asr.svg'},
      {'name': 'Maghrib', 'time': prayerController.formatTime(pt.maghrib), 'icon': 'assets/images/maghrib.svg'},
      {'name': 'Isha', 'time': prayerController.formatTime(pt.isha), 'icon': 'assets/images/isha.svg'},
    ];

    return ListView.builder(
      shrinkWrap: true,
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: prayerTimesList.length,
      itemBuilder: (context, index) {
        final prayer = prayerTimesList[index];
        return Container(
          margin: EdgeInsets.only(top: 5.h, bottom: 5.h),
          padding: EdgeInsets.all(15.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.r),
            color: (index % 2 == 1)
                ? AppColors.primary.withOpacity(0.29)
                : AppColors.primary.withOpacity(0.1),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    // Use SvgPicture.asset for SVG rendering
                    SvgPicture.asset(
                      prayer['icon']!,
                      width: 18.w,
                      colorFilter: ColorFilter.mode( // Use colorFilter
                        themeController.isDarkMode.value ? Colors.white : Colors.black,
                        BlendMode.srcIn,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    CustomText(
                      title: prayer['name']!,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.normal,
                      textColor:  themeController.isDarkMode.value ? AppColors.white : AppColors.black,
                    ),
                  ],
                ),

                CustomText(
                  title: prayer['time']!,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.normal,
                  textColor: themeController.isDarkMode.value ? AppColors.grey : AppColors.black,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
