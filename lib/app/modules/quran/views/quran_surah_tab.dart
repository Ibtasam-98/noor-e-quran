import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:noor_e_quran/app/modules/quran/views/quran_surah_detail_screen.dart';
import 'package:quran/quran.dart' as quran;

import '../../../config/app_colors.dart';
import '../../../controllers/app_theme_switch_controller.dart';
import '../../../widgets/custom_text.dart';
import '../../home/controllers/app_home_screen_controller.dart';


class QuranSurahTab extends StatelessWidget {

  final AppThemeSwitchController themeController =
  Get.put(AppThemeSwitchController());
  final GetStorage _box = GetStorage();

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = themeController.isDarkMode.value;
    final textColor = isDarkMode ? AppColors.white : AppColors.black;

    return ListView.builder(
      itemCount: quran.totalSurahCount,
      itemBuilder: (context, index) {
        int surahNumber = index + 1;
        return Container(
          margin: EdgeInsets.only(bottom: 5, top: 5.h,left: 5.w,right: 5.w),
          padding: EdgeInsets.all(10.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.r),
            color: (index % 2 == 1)
                ? AppColors.primary.withOpacity(0.29)
                : AppColors.primary.withOpacity(0.1),
          ),
          child: ListTile(
            splashColor: AppColors.transparent,
            hoverColor: AppColors.transparent,
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
              title: '${quran.getPlaceOfRevelation(surahNumber) == "Makkiyah" ? "Makkah" : "Madina"} | ${quran.getVerseCount(surahNumber)} Ayahs',
              fontSize: 12.sp,
              textColor: AppColors.primary,
              textAlign: TextAlign.start,
              textOverflow: TextOverflow.ellipsis,
              fontWeight: FontWeight.w500,
              maxLines: 1,
            ),
            trailing: CustomText(
              title: quran.getSurahNameArabic(surahNumber),
              fontSize: 25.sp,
              textColor: AppColors.primary,
            ),
            onTap: () {
              addSurahToLastAccessed(surahNumber);
              Get.to(() => QuranSurahDetailScreen(surahNumber: surahNumber));
            },
          ),
        );
      },
    );
  }

  void addSurahToLastAccessed(int surahNumber) {
    final AppHomeScreenController controller = Get.find<AppHomeScreenController>();
    final now = DateTime.now().toIso8601String();
    final newSurah = {
      'surahNumber': surahNumber,
      'accessTime': now,
    };

    final existingIndex = controller.lastAccessedSurahs.indexWhere(
          (element) => element['surahNumber'] == surahNumber,
    );

    if (existingIndex != -1) {
      controller.lastAccessedSurahs[existingIndex] = newSurah;
    } else {
      controller.lastAccessedSurahs.add(newSurah);
    }

    GetStorage().write('lastAccessedSurahs', controller.lastAccessedSurahs); // Use GetStorage() directly
    controller.update();
  }

}