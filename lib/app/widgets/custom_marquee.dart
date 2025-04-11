import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marquee/marquee.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../config/app_colors.dart';
import '../controllers/app_home_screen_controller.dart';
import '../controllers/user_location_premission_controller.dart';


class CustomMarquee extends StatelessWidget {
  final UserPermissionController locationPermissionScreenController = Get.find<UserPermissionController>();
  final AppHomeScreenController homeScreenController = Get.find<AppHomeScreenController>();

  @override
  Widget build(BuildContext context) {
    return  Container(
      height: 40.h,
      margin: EdgeInsets.only(bottom: 15.h),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.15),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.w),
        child: Marquee(
          text: 'As of ${homeScreenController.getCurrentDate()}, in ${locationPermissionScreenController.cityName}, the Islamic date is ${homeScreenController.getIslamicDate()}',
          style: GoogleFonts.quicksand(
            color: AppColors.primary,
            fontSize: 14.sp,
            fontStyle: FontStyle.italic,
          ),
          scrollAxis: Axis.horizontal,
          blankSpace: 20.0,
          velocity: 30.0,
          pauseAfterRound: const Duration(seconds: 2),
          startPadding: 10.0,
          accelerationDuration: const Duration(seconds: 1),
          accelerationCurve: Curves.easeIn,
          decelerationDuration: const Duration(milliseconds: 100),
          decelerationCurve: Curves.easeOut,
        ),
      ),
    );
  }
}
