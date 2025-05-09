import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:noor_e_quran/app/config/app_colors.dart';
import 'package:noor_e_quran/app/config/app_sizedbox.dart';
import 'package:noor_e_quran/app/controllers/app_theme_switch_controller.dart';
import 'package:noor_e_quran/app/modules/home/views/app_home_base_screen.dart';
import 'package:noor_e_quran/app/modules/home/views/view_all_prayer_screen.dart';
import 'package:noor_e_quran/app/widgets/custom_text.dart';

import '../../../controllers/flying_bird_animation_controller.dart';
import '../../../controllers/user_location_premission_controller.dart';
import '../controllers/view_all_prayer_screen_controller.dart';
import 'app_home_screen_header.dart';

class AppHomeScreen extends StatelessWidget {
  final Map<String, dynamic>? userData;
  final FlyingBirdAnimationController _homeBirdController = Get.put(FlyingBirdAnimationController(), tag: 'home_bird');
  final UserPermissionController locationController = Get.find<UserPermissionController>();
  final NamazController namazController = Get.find<NamazController>();
  final AppThemeSwitchController themeController = Get.find<AppThemeSwitchController>();

  AppHomeScreen({super.key, this.userData});

  @override
  Widget build(BuildContext context) {
    return AppHomeBaseScreen(
      titleFirstPart: "Noor e",
      titleSecondPart: " Quran",
      birdController: _homeBirdController,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HomeScreenHeader(birdController: _homeBirdController),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                  child: Obx(() => CustomText(
                    title: "Upcoming Prayers",
                    textColor: themeController.isDarkMode.value ? AppColors.white : AppColors.black,
                    fontSize: 16.sp,
                    fontFamily: 'grenda',
                    textAlign: TextAlign.start,
                  ))
              ),
              Expanded(
                child: InkWell(
                  onTap: () => Get.to(ViewAllPrayerScreen()),
                  child: CustomText(
                    title: "View All",
                    textColor: AppColors.primary,
                    fontSize: 14.sp,
                    fontFamily: 'quicksand',
                    textAlign: TextAlign.end,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          AppSizedBox.space15h,
          Obx(() => Container(
            decoration: BoxDecoration(
              color: AppColors.transparent,
              boxShadow: [
                BoxShadow(
                  color: themeController.isDarkMode.value
                      ? AppColors.primary.withOpacity(0.01)
                      : AppColors.primary.withOpacity(0.01),
                  blurRadius: 5,
                ),
              ],
            ),
            child: Column(
              children: [
                Stack(
                  children: [
                    Container(
                      height: 90.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16),
                        ),
                        image: DecorationImage(
                          image: AssetImage(themeController.isDarkMode.value
                              ? 'assets/images/mosque_bg_dark.png'
                              : 'assets/images/masjid_bg_light.jpg'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Obx(() => Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppColors.black.withOpacity(0.5),
                              AppColors.transparent,
                              AppColors.black.withOpacity(0.5),
                            ],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(16),
                            topRight: Radius.circular(16),
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              locationController.locationAccessed.value
                                  ? CustomText(
                                title: namazController.nextNamazName.value.isNotEmpty &&
                                    namazController.nextNamazTime.value != null
                                    ? '${namazController.nextNamazName.value} ${DateFormat('h:mm a').format(namazController.nextNamazTime.value!)}'
                                    : '--/--/--',
                                textColor: AppColors.white,
                                fontSize: 18.sp,
                                maxLines: 2,
                                textStyle: GoogleFonts.montserrat(),
                                fontWeight: FontWeight.bold,
                              )
                                  : CustomText(
                                title: "--/--",
                                textColor: AppColors.white,
                                fontSize: 18.sp,
                                maxLines: 2,
                              ),
                              Obx(() => CustomText(
                                textColor: AppColors.white,
                                fontSize: 24.sp,
                                title: namazController.timeRemaining.value,
                                fontFamily: 'grenda',
                                maxLines: 2,
                              )),
                            ],
                          ),
                        ),
                      ),
                    )),
                  ],
                ),
                Container(
                  height: 90.h,
                  width: Get.width,
                  decoration: BoxDecoration(
                    color: themeController.isDarkMode.value ? AppColors.black : AppColors.white,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(15.r),
                      bottomRight: Radius.circular(15.r),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.1),
                        blurRadius: 5,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Obx(() => ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: namazController.isNamazLoading.value ? 5 : namazController.namazTimes.length,
                      itemBuilder: (context, index) {
                        final namazName = namazController.namazTimes[index];
                        final namazTime = namazController.namazTimings[namazName] ?? "--/--";
                        final formattedTime = namazController.formatTime(
                            namazTime,
                            MediaQuery.of(context).alwaysUse24HourFormat
                        );
                        final iconName = namazController.icons[index];
                        final isNextNamaz = namazName == namazController.nextNamazName.value;

                        return Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.all(8.0),
                          margin: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CustomText(
                                title: namazName,
                                fontSize: 13.sp,
                                textColor: isNextNamaz ? AppColors.secondry
                                    : themeController.isDarkMode.value ? AppColors.white : AppColors.black,
                                textStyle: GoogleFonts.quicksand(),
                              ),
                              Stack(
                                alignment: Alignment.center,
                                children: [
                                  SvgPicture.asset(
                                    height: 20.h,
                                    "assets/images/$iconName",
                                    color: isNextNamaz
                                        ? (themeController.isDarkMode.value ? AppColors.white : AppColors.primary)
                                        : (themeController.isDarkMode.value ? AppColors.white : AppColors.black),
                                  ),
                                  if (isNextNamaz)
                                    Container(
                                      height: 25.h,
                                      width: 25.w,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(60.r),
                                        color: AppColors.transparent,
                                        boxShadow: [
                                          BoxShadow(
                                            color: AppColors.primary.withOpacity(0.4),
                                            spreadRadius: 5,
                                            blurRadius: 10,
                                          ),
                                        ],
                                      ),
                                    ),
                                ],
                              ),
                              CustomText(
                                title: formattedTime,
                                fontSize: 12.sp,
                                textColor: isNextNamaz
                                    ? AppColors.secondry
                                    : themeController.isDarkMode.value ? AppColors.white : AppColors.black,
                                textStyle: GoogleFonts.quicksand(),
                              ),
                            ],
                          ),
                        );
                      },
                    )),
                  ),
                )
              ],
            ),
          )),
        ],
      ),
    );
  }

}