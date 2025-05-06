import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:noor_e_quran/app/controllers/app_theme_switch_controller.dart';
import 'package:noor_e_quran/app/modules/home/views/app_home_base_screen.dart';
import 'package:noor_e_quran/app/modules/home/views/view_all_prayer_screen.dart';
import '../../../config/app_colors.dart';
import '../../../config/app_sizedbox.dart';
import '../../../widgets/custom_text.dart';
import '../controllers/app_home_screen_controller.dart';
import '../controllers/prayer_controller.dart';
import 'app_home_screen_header.dart';
import 'package:noor_e_quran/app/controllers/flying_bird_animation_controller.dart';
import 'package:noor_e_quran/app/controllers/user_location_premission_controller.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppHomeScreen extends StatelessWidget {
  final Map<String, dynamic>? userData;
  final FlyingBirdAnimationController _homeBirdController =
  Get.put(FlyingBirdAnimationController(), tag: 'home_bird');
  final AppHomeScreenController homeScreenController =
  Get.find<AppHomeScreenController>();
  final AppThemeSwitchController themeController =
  Get.find<AppThemeSwitchController>();
  final UserPermissionController locationPermissionController = Get.find<UserPermissionController>();
  final PrayerController prayerController = Get.put(PrayerController());

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
          const SizedBox(height: 20),
          AppSizedBox.space15h,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                  child: Obx(()=>CustomText(
                    title: "Upcoming Prayers",
                    textColor: themeController.isDarkMode.value ? AppColors.white : AppColors.black,
                    fontSize: 16.sp,
                    fontFamily: 'grenda',
                    textAlign: TextAlign.start,
                    textOverflow: TextOverflow.ellipsis,
                  ),)
              ),
              Expanded(
                child: InkWell(
                  onTap: (){
                    Get.to(ViewAllPrayerScreen());
                  },
                  child: CustomText(
                    title: "View All",
                    textColor:  AppColors.primary,
                    fontSize: 14.sp,
                    fontFamily: 'quicksand',
                    textAlign: TextAlign.end,
                    fontWeight: FontWeight.w600,
                    textOverflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
          Obx(() {
            if (!locationPermissionController.locationAccessed.value) {
              return const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text('Please enable location to see prayer times.'),
              );
            }
            if (prayerController.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }
            final prayerTimes = prayerController.prayerTimes.value;
            if (prayerTimes != null) {
              return SizedBox(
                height: 120, // Adjust height as needed
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  children: [
                    _buildNamazItem('Fajr', prayerController.formatTime(prayerTimes.fajr), 'assets/images/fajr.svg'),
                    _buildNamazItem('Dhuhr', prayerController.formatTime(prayerTimes.dhuhr), 'assets/images/dhuhr.svg'),
                    _buildNamazItem('Asr', prayerController.formatTime(prayerTimes.asr), 'assets/images/asr.svg'),
                    _buildNamazItem('Maghrib', prayerController.formatTime(prayerTimes.maghrib), 'assets/images/maghrib.svg'),
                    _buildNamazItem('Isha', prayerController.formatTime(prayerTimes.isha), 'assets/images/isha.svg'),
                  ],
                ),
              );
            } else {
              return const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text('Prayer times not available.'),
              );
            }
          }),
        ],
      ),
    );
  }
  Widget _buildNamazItem(String name, String time, String iconPath) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Column(
        children: [
          Text(
            name,
            style: Get.textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
          SvgPicture.asset(
            iconPath,
            height: 18,
            color: Get.textTheme.bodyLarge?.color, // Adjust color based on theme
          ),
          Text(
            time,
            style: Get.textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

}