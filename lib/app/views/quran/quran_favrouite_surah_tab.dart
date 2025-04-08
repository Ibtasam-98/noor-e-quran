import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:noor_e_quran/app/views/quran/quran_surah_detail_screen.dart';
import 'package:quran/quran.dart' as quran;

import '../../config/app_colors.dart';
import '../../controllers/app_theme_switch_controller.dart';
import '../../controllers/quran_favrouitte_surah_tab_controller.dart';
import '../../widgets/custom_snackbar.dart';
import '../../widgets/custom_text.dart';

class QuranFavrouiteSurahTab extends StatelessWidget {
  final QuranFavrouiteSurahTabController controller = Get.put(QuranFavrouiteSurahTabController());
  final AppThemeSwitchController themeController = Get.find();

  @override
  Widget build(BuildContext context) {
    final textColor = themeController.isDarkMode.value ? AppColors.white : AppColors.black;

    return Scaffold(
      backgroundColor: themeController.isDarkMode.value ? AppColors.black : AppColors.white,
      body: Obx(() {
        if (controller.savedSurahs.isEmpty) {
          return Center(
            child: CustomText(
              title: "No saved surahs yet.",
              textColor: textColor,
              fontSize: 16.sp,
            ),
          );
        } else {
          return ListView.builder(
            itemCount: controller.savedSurahs.length,
            itemBuilder: (context, index) {
              final surahNumber = controller.savedSurahs[index];
              return Container(
                margin: EdgeInsets.only(bottom: 5, top: 5.h),
                padding: EdgeInsets.all(10.h),
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
                        width: 36.w,
                        height: 36.h,
                        fit: BoxFit.contain,
                      ),
                      Positioned(
                        child: CustomText(
                          title: "$surahNumber",
                          fontSize: 12.sp,
                          textColor: textColor,
                        ),
                      ),
                    ],
                  ),
                  title: CustomText(
                    title: quran.getSurahName(surahNumber),
                    fontSize: 15.sp,
                    textColor: textColor,
                    fontWeight: FontWeight.w500,
                    textOverflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    textAlign: TextAlign.start,
                  ),
                  subtitle: CustomText(
                    title:
                    '${quran.getPlaceOfRevelation(surahNumber) == "Makkiyah" ? "Makkah" : "Madina"} | ${quran.getVerseCount(surahNumber)} Ayahs',
                    fontSize: 12.sp,
                    textColor: AppColors.primary,
                    textAlign: TextAlign.start,
                    textOverflow: TextOverflow.ellipsis,
                    fontWeight: FontWeight.w500,
                    maxLines: 1,
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomText(
                        title: quran.getSurahNameArabic(surahNumber),
                        fontSize: 25.sp,
                        textColor: AppColors.primary,
                      ),
                      SizedBox(width: 8.w),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () => controller.deleteSurah(surahNumber),
                      ),
                    ],
                  ),
                  onTap: () {
                    Get.to(() => QuranSurahDetailScreen(surahNumber: surahNumber));
                  },
                ),
              );
            },
          );
        }
      }),
    );
  }
}
