import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:noor_e_quran/app/config/app_colors.dart';
import 'package:noor_e_quran/app/widgets/custom_text.dart';

import '../controllers/app_theme_switch_controller.dart';

class CustomCard extends StatelessWidget {
  final String? title;
  final String? subtitle;
  final IconData? icon;
  final String? imageUrl;
  final String? arabicTitle;
  final bool mergeWithGradientImage;
  final double titleFontSize;
  final double subtitleFontSize;
  final double arabicTitleFontSize;
  final double iconSize;
  final Alignment titleAlignment;
  final Alignment subtitleAlignment;
  final bool useIconInRow;
  final TextStyle? titleStyle;
  final TextStyle? subtitleStyle;
  final double? containerHeight;
  final EdgeInsetsGeometry? padding;
  final Color? iconColor;
  final Color? textColor;
  final Color? decorationColor;
  final bool addPadding;
  final bool addBoxShadow;
  final bool useLinearGradient;
  final List<Color>? gradientColors;
  final int? titleMaxLines; // Added titleMaxLines
  final int? subtitleMaxLines; // Added subtitleMaxLines

  const CustomCard({
    super.key,
    this.title,
    this.subtitle,
    this.icon,
    this.imageUrl,
    this.arabicTitle,
    this.mergeWithGradientImage = false,
    this.titleFontSize = 15.0,
    this.subtitleFontSize = 14.0,
    this.arabicTitleFontSize = 30.0,
    this.iconSize = 12.0,
    this.titleAlignment = Alignment.centerLeft,
    this.subtitleAlignment = Alignment.centerRight,
    this.useIconInRow = true,
    this.titleStyle,
    this.subtitleStyle,
    this.containerHeight,
    this.padding,
    this.iconColor,
    this.textColor,
    this.decorationColor,
    this.addPadding = true,
    this.addBoxShadow = true,
    this.useLinearGradient = true,
    this.gradientColors,
    this.titleMaxLines, // Initialize titleMaxLines
    this.subtitleMaxLines, // Initialize subtitleMaxLines
  });

  @override
  Widget build(BuildContext context) {
    final AppThemeSwitchController themeController = Get.put(AppThemeSwitchController());
    bool isDarkMode = themeController.isDarkMode.value;
    Color effectiveTitleColor = isDarkMode ? AppColors.primary : AppColors.primary;
    Color effectiveSubtitleColor = isDarkMode ? AppColors.white : AppColors.black;
    Color effectiveIconColor = isDarkMode ? AppColors.white : AppColors.black;

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
                gradient: useLinearGradient
                    ? LinearGradient(
                  colors: gradientColors ?? [
                    AppColors.black.withOpacity(0.9),
                    AppColors.transparent,
                    AppColors.black.withOpacity(0.9),
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                )
                    : null,
                borderRadius: BorderRadius.circular(15.r),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: addPadding ? 25.h : 0,
                  horizontal: 10.w,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (title != null)
                            CustomText(
                              textColor: AppColors.white,
                              fontSize: titleFontSize.sp,
                              title: title!,
                              textAlign: TextAlign.start,
                              fontFamily: 'grenda',
                              maxLines: titleMaxLines, // Apply titleMaxLines
                            ),
                          if (subtitle != null)
                            CustomText(
                              textColor: AppColors.white.withOpacity(0.7),
                              fontSize: subtitleFontSize.sp,
                              title: subtitle!,
                              textAlign: TextAlign.start,
                              textStyle: const TextStyle(fontStyle: FontStyle.italic),
                              maxLines: subtitleMaxLines, // Apply subtitleMaxLines
                            ),
                        ],
                      ),
                    ),
                    if (arabicTitle != null)
                      Padding(
                        padding: EdgeInsets.only(right: 5.w, top: 5.h),
                        child: CustomText(
                          textColor: AppColors.white,
                          fontSize: arabicTitleFontSize.sp,
                          title: arabicTitle!,
                          textAlign: TextAlign.end,
                        ),
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
            height: containerHeight,
            decoration: BoxDecoration(
              color: decorationColor ?? (isDarkMode ? AppColors.black : AppColors.white),
              borderRadius: BorderRadius.circular(15.r),
              boxShadow: addBoxShadow
                  ? [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.3),
                  blurRadius: 5,
                ),
              ]
                  : [],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (title != null && icon != null && useIconInRow)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Align(
                          alignment: titleAlignment,
                          child: Text(
                            title!,
                            style: titleStyle ??
                                TextStyle(
                                  color: effectiveTitleColor,
                                  fontSize: titleFontSize.sp,
                                  fontFamily: 'grenda',
                                ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: titleMaxLines ?? 1, // Apply titleMaxLines with default
                            softWrap: false,
                          ),
                        ),
                      ),
                      Icon(
                        icon!,
                        color: effectiveIconColor,
                        size: iconSize.h,
                      ),
                    ],
                  ),
                if (subtitle != null)
                  Align(
                    alignment: subtitleAlignment,
                    child: Text(
                      subtitle!,
                      overflow: TextOverflow.ellipsis,
                      maxLines: subtitleMaxLines ?? 3, // Apply subtitleMaxLines with default
                      style: subtitleStyle ??
                          GoogleFonts.quicksand(
                            textStyle: TextStyle(
                              color: effectiveSubtitleColor,
                              fontSize: subtitleFontSize.sp,
                            ),
                          ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      );
    }
  }
}