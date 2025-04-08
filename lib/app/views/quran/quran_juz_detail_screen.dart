
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:noor_e_quran/app/config/app_sizedbox.dart';
import 'package:noor_e_quran/app/views/quran/quran_surah_detail_screen.dart';
import 'package:quran/quran.dart' as quran;

import '../../config/app_colors.dart';
import '../../controllers/app_theme_switch_controller.dart';
import '../../widgets/custom_card.dart';
import '../../widgets/custom_text.dart';

class JuzDetailScreen extends StatelessWidget {
  final AppThemeSwitchController themeController = Get.put(AppThemeSwitchController());

  final int juzNumber;

  JuzDetailScreen({required this.juzNumber});

  @override
  Widget build(BuildContext context) {
    final juzData = quran.getSurahAndVersesFromJuz(juzNumber);
    bool isDarkMode = themeController.isDarkMode.value;
    final textColor = isDarkMode ? AppColors.white : AppColors.black;
    final iconColor = isDarkMode ? AppColors.white : AppColors.black;

    return Scaffold(
      backgroundColor: themeController.isDarkMode.value ? AppColors.black : AppColors.white,
      appBar: AppBar(
        backgroundColor: themeController.isDarkMode.value ? AppColors.black : AppColors.white,
        surfaceTintColor: AppColors.transparent,
        foregroundColor: Colors.transparent,  // Ensure transparency
        title: CustomText(
          firstText: "Juzz ",
          secondText: "${juzNumber}",
          firstTextColor: themeController.isDarkMode.value ? AppColors.white : AppColors.black,
          secondTextColor: AppColors.primary,
          fontSize: 18.sp,
        ),
        centerTitle: false,
        leading: InkWell(
          onTap: () {
            Get.back();
          },
          child: Icon(
            Icons.west,
            color: iconColor, // Ensure this is properly defined
          ),
        ),
      ),
      body: Padding(
        padding:  EdgeInsets.only(left:10.w,right: 10.w),
        child: Column(
          children: [
            CustomCard(
              title:"Illuminating the Quran",
              subtitle:"A Juz by Juz Exploration",
              imageUrl: isDarkMode ? "assets/images/quran_bg_dark.jpg" : "assets/images/quran_bg_light.jpg",
              mergeWithGradientImage: true,
              titleFontSize: 18.sp,
              subtitleFontSize: 12.sp,
              decorationColor: AppColors.red,
              addBoxShadow: true,
              useLinearGradient: true,
              gradientColors: [
                AppColors.black.withOpacity(0.4),
                AppColors.transparent,
                AppColors.black.withOpacity(0.4),
              ],
            ),
            AppSizedBox.space10h,
            Expanded(
              child: ListView.builder(
                itemCount: juzData.length,
                itemBuilder: (context, index) {
                  final surahNumber = juzData.keys.elementAt(index);
                  final verses = juzData[surahNumber];
                  return Container(
                    margin: EdgeInsets.only(bottom: 5, top: 5.h),
                    padding: EdgeInsets.all(6.h),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.r),
                      color: (index % 2 == 1)
                          ? AppColors.primary.withOpacity(0.29)
                          : AppColors.primary.withOpacity(0.1),
                    ),
                    child: ListTile(
                      leading: Stack(
                        alignment: Alignment.center,
                        children: [
                          Image.asset(
                            "assets/images/ayat_marker.png",
                            width: 36.w,  // Adjust as needed
                            height: 36.h,
                            fit: BoxFit.contain,
                          ),
                          Positioned(
                            child: CustomText(
                              title: "$juzNumber",
                              fontSize: 12.sp,
                              textColor: textColor,
                            ),
                          ),
                        ],
                      ),
                      title: CustomText(
                        title:quran.getSurahName(surahNumber),
                        fontSize: 15.sp,
                        textColor: textColor,
                        fontWeight: FontWeight.w500,
                        textOverflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        textAlign: TextAlign.start,
                      ),
                      subtitle: CustomText(
                        title: '${quran.getPlaceOfRevelation(surahNumber) == "Makkiyah" ? "Makkah" : "Madina"} | Ayat ${verses?.join(' - ')}',
                        fontSize: 12.sp,
                        textColor: AppColors.primary,
                        textAlign: TextAlign.start,
                        textOverflow: TextOverflow.ellipsis,
                        fontWeight: FontWeight.w500,
                        maxLines: 1,
                      ),
                      trailing: CustomText(
                        title: quran.getSurahNameArabic(surahNumber),
                        fontSize: 18.sp,
                        textColor: AppColors.primary,
                      ),
                      onTap: () {
                        Get.to(() => QuranSurahDetailScreen(surahNumber: surahNumber));
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        )
      ),
    );
  }
}
