import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:noor_e_quran/app/config/app_colors.dart';
import 'package:noor_e_quran/app/controllers/app_theme_switch_controller.dart';
import 'package:noor_e_quran/app/modules/additional/views/prophet_miracle_detail_screen.dart';
import 'package:noor_e_quran/app/widgets/custom_text.dart';
import 'package:noor_e_quran/app/widgets/pdf_viewer.dart';

import '../../../config/app_sizedbox.dart';
import '../../../widgets/custom_card.dart';
import '../../home/controllers/app_home_screen_controller.dart';

class ProphetMiraclesScreen extends StatelessWidget {
  final AppHomeScreenController homeScreenController = Get.find<AppHomeScreenController>();
  final AppThemeSwitchController themeController = Get.find<AppThemeSwitchController>();

  final List<Map<String, String>> list = [
    {'en': 'Miracles', 'route': 'miracles'},
    {'en': 'Seerah', 'route': 'seerah'},
  ];


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
          firstText: "Prophetic",
          secondText: " Muhammad",
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
      ),
      body: Padding(
        padding: EdgeInsets.only(left: 10.w, right: 10.w, bottom: 5.h),
        child: Column(
          children: [
            CustomCard(
              title: "The Prophets' Marvels & Life",
              subtitle: 'Extraordinary signs and biography of the Messengers',
              imageUrl: isDarkMode ? 'assets/images/theme_dark_bg.jpg' : 'assets/images/desert_bg.png',
              mergeWithGradientImage: true,
              gradientColors: [
                AppColors.black.withOpacity(0.4),
                AppColors.transparent,
                AppColors.black.withOpacity(0.4),
              ],
            ),
            AppSizedBox.space10h,
            Expanded(
              child: ListView.builder(
                itemCount: list.length,
                itemBuilder: (context, index) {
                  final item = list[index];
                  return Container(
                    margin: EdgeInsets.only(bottom: 5.h, top: 5.h, left: 5.w, right: 5.w),
                    padding: EdgeInsets.all(10.h),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.r),
                      color: (index % 2 == 1)
                          ? AppColors.primary.withOpacity(0.29)
                          : AppColors.primary.withOpacity(0.1),
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      dense: false,
                      onTap: () {
                        if (item['route'] == 'miracles') {
                          Get.to(ProphetMiracleDetailScreen(
                            prophetName: item['en']!,
                          ));
                        } else if (item['route'] == 'seerah') {
                          Get.to(PdfViewer(
                              assetPath: "assets/pdf/seerah.pdf",
                              firstTitle: "Prophet",
                              secondTitle: " Seerah",
                          ));
                        }
                      },
                      leading: CustomText(
                        title:'${index + 1}',
                        fontSize: 15.sp,
                        textColor:isDarkMode ? AppColors.white : AppColors.black,
                        fontWeight: FontWeight.w500,
                        textOverflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        textAlign: TextAlign.start,
                      ),
                      title: CustomText(
                        title: "Prophet " + item['en']!,
                        fontSize: 15.sp,
                        textColor: isDarkMode ? AppColors.white : AppColors.black,
                        fontWeight: FontWeight.w500,
                        textOverflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        textAlign: TextAlign.start,
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        size: 12.h,
                        color: isDarkMode ? AppColors.white : AppColors.black,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Create a new screen for Seerah (as a placeholder for now)
class SeerahScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Get.find<AppThemeSwitchController>().isDarkMode.value;
    return Scaffold(
      backgroundColor: isDarkMode ? AppColors.black : AppColors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: isDarkMode ? AppColors.black : AppColors.white,
        surfaceTintColor: AppColors.transparent,
        foregroundColor: AppColors.transparent,
        title: CustomText(
          title: "Seerah of Prophet Muhammad",
          fontSize: 18.sp,
          textColor: isDarkMode ? AppColors.white : AppColors.black,
        ),
        centerTitle: false,
        leading: InkWell(
          onTap: () {
            Get.back();
          },
          child: Icon(
            Icons.west,
            color: isDarkMode ? AppColors.white : AppColors.black,
          ),
        ),
      ),
      body: Center(
        child: CustomText(
          title: "Seerah Content Will Be Here",
          fontSize: 16.sp,
          textColor: isDarkMode ? AppColors.white : AppColors.black,
        ),
      ),
    );
  }
}