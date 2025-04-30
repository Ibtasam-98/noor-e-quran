import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../config/app_colors.dart'; // Import your color and text styles
import '../controllers/app_theme_switch_controller.dart'; // Import the theme controller
import 'custom_text.dart'; // Import your CustomText widget

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  CustomAppBar({
    super.key,
    this.title,
    this.firstText,
    this.secondText,
    this.showBackButton = true,
    this.backgroundColor,
    this.titleFontSize,
    this.firstTextColor,
    this.secondTextColor,
    this.firstTextFontWeight,
    this.secondTextFontWeight,
    this.textAlign = TextAlign.start,
    this.addSpace = false, // New parameter: addSpace
  }) : assert(
  (title != null) ^ (firstText != null && secondText != null),
  'Provide either a single title or both firstText and secondText.',
  );

  final String? title;
  final String? firstText;
  final String? secondText;
  final bool showBackButton;
  final Color? backgroundColor;
  final double? titleFontSize;
  final Color? firstTextColor;
  final Color? secondTextColor;
  final FontWeight? firstTextFontWeight;
  final FontWeight? secondTextFontWeight;
  final TextAlign textAlign;
  final bool addSpace; // New parameter

  final AppThemeSwitchController themeSwitchController =
  Get.find<AppThemeSwitchController>(); // Find the theme controller

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final bool isDarkMode = themeSwitchController.isDarkMode.value;
      return AppBar(
        backgroundColor:
        backgroundColor ?? (isDarkMode ? AppColors.black : AppColors.white),
        centerTitle: false,
        title: CustomText(
          title: title,
          firstText:
          firstText,
          secondText: secondText != null && addSpace ? ' $secondText' : secondText,
          fontSize: titleFontSize ?? 18.sp,
          textColor: isDarkMode ? AppColors.white : AppColors.black,
          firstTextColor: firstTextColor,
          secondTextColor: secondTextColor,
          firstTextFontWeight: firstTextFontWeight,
          secondTextFontWeight: secondTextFontWeight,
          textOverflow: TextOverflow.ellipsis,
          maxLines: 1,
          textAlign: textAlign,
        ),
        leading: showBackButton
            ? IconButton(
          icon: Icon(
            LineIcons.arrowLeft,
            color: isDarkMode ? AppColors.white : AppColors.black,
            size: 18.h,
          ),
          onPressed: () => Get.back(),
        )
            : null,
      );
    });
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}