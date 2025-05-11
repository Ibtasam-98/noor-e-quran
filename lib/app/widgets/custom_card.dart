import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../config/app_colors.dart';
import '../controllers/app_theme_switch_controller.dart';
import 'custom_text.dart';

class CustomCard extends StatelessWidget {
  final String? title;
  final String? subtitle;
  final String? imageUrl;
  final bool mergeWithGradientImage;
  final TextStyle? titleStyle;
  final TextStyle? subtitleStyle;
  final EdgeInsetsGeometry? padding;
  final bool addPadding;
  final int? titleMaxLines;
  final int? subtitleMaxLines;
  final double titleFontSize; // Added
  final double subtitleFontSize; // Added

  const CustomCard({
    super.key,
    this.title,
    this.subtitle,
    this.imageUrl,
    this.mergeWithGradientImage = false,
    this.titleStyle,
    this.subtitleStyle,
    this.padding,
    this.addPadding = true,
    this.titleMaxLines,
    this.subtitleMaxLines,
    this.titleFontSize = 16.0, // Default value
    this.subtitleFontSize = 14.0, // Default value
  });

  @override
  Widget build(BuildContext context) {
    final AppThemeSwitchController themeController = Get.find<AppThemeSwitchController>();
    bool isDarkMode = themeController.isDarkMode.value;

    if (mergeWithGradientImage && imageUrl != null) {
      return Stack(
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(imageUrl!),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(15.r),
            ),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.black.withOpacity(0.7),
                    AppColors.transparent,
                    AppColors.black.withOpacity(0.7),
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(15.r),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: addPadding ? 25.h : 0,
                  horizontal: 10.w,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (title != null)
                      CustomText(
                        textColor: AppColors.white,
                        title: title!,
                        textAlign: TextAlign.start,
                        fontFamily: 'grenda',
                        textStyle: titleStyle,
                        maxLines: titleMaxLines,
                        fontSize: titleFontSize.sp, // Added fontSize
                      ),
                    if (subtitle != null)
                      CustomText(
                        textColor: AppColors.white.withOpacity(0.7),
                        title: subtitle!,
                        textAlign: TextAlign.start,
                        textStyle: subtitleStyle ?? const TextStyle(fontStyle: FontStyle.italic),
                        maxLines: subtitleMaxLines,
                        fontSize: subtitleFontSize.sp, // Added fontSize
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    } else {
      return Center(
        child: Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.r),
          ),
          child: Container(
            padding: padding ?? EdgeInsets.all(12.h),
            decoration: BoxDecoration(
              color: isDarkMode ? AppColors.black : AppColors.white,
              borderRadius: BorderRadius.circular(15.r),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.3),
                  blurRadius: 5,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (title != null)
                  CustomText(
                    title: title!,
                    textColor: AppColors.primary,
                    textOverflow: TextOverflow.ellipsis,
                    textStyle: titleStyle,
                    maxLines: titleMaxLines ?? 1,
                    fontSize: titleFontSize.sp, // Added fontSize
                  ),
                if (subtitle != null)
                  CustomText(
                    title: subtitle!,
                    textOverflow: TextOverflow.ellipsis,
                    maxLines: subtitleMaxLines ?? 3,
                    textStyle: subtitleStyle ??
                        GoogleFonts.quicksand(
                          textStyle: TextStyle(
                            color: isDarkMode ? AppColors.white : AppColors.black,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                    fontSize: subtitleFontSize.sp, // Added fontSize
                  ),
              ],
            ),
          ),
        ),
      );
    }
  }
}