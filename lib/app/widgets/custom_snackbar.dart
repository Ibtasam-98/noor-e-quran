

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:noor_e_quran/app/config/app_colors.dart';

class CustomSnackbar {
  static void show({
    required String title,
    required String subtitle,
    required Icon icon,
    Color backgroundColor = AppColors.black,
    Color textColor = AppColors.white,
    Color iconColor = AppColors.white,
  }) {
    Get.snackbar(
      "", "",
      backgroundColor: backgroundColor,
      colorText: textColor,
      snackPosition: SnackPosition.BOTTOM,
      icon: Icon(
        icon.icon,
        color: iconColor,
        size: 20.h,
      ),
      messageText: Text(
        subtitle,
        style: GoogleFonts.quicksand(
          fontSize: 14,
          color: textColor,
        ),
        textAlign: TextAlign.start,
      ),
      titleText: Text(
        title,
        style: GoogleFonts.quicksand(
          fontSize: 18.sp,
          color: textColor,
          fontWeight: FontWeight.w900,
        ),
        textAlign: TextAlign.start,
      ),
    );
  }
}
