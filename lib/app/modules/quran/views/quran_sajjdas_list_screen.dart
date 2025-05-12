

// views/quran_sajdah_list_screen.dart
import 'package:flutter/material.dart';
import 'package:noor_e_quran/app/modules/quran/views/quran_surah_detail_screen.dart';
import 'package:quran/quran.dart' as quran;
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../config/app_colors.dart';
import '../../../config/app_sizedbox.dart';
import '../../../controllers/app_theme_switch_controller.dart';
import '../../../widgets/custom_card.dart';
import '../../../widgets/custom_text.dart';
import '../controllers/quran_sajdaas_list_controller.dart';

class QuranSajdahListScreen extends StatelessWidget {
  final QuranSajdahListController controller =  Get.put(QuranSajdahListController());

  @override
  Widget build(BuildContext context) {
    final AppThemeSwitchController themeController =
    Get.find<AppThemeSwitchController>();
    bool isDarkMode = themeController.isDarkMode.value;
    final textColor = isDarkMode ? AppColors.white : AppColors.black;

    return Scaffold(
      backgroundColor: isDarkMode ? AppColors.black : AppColors.white,
      appBar: AppBar(
        surfaceTintColor: AppColors.transparent,
        foregroundColor: AppColors.transparent,
        centerTitle: false,
        title: CustomText(
          firstText: "Sajdaas",
          secondText: " Verses",
          firstTextColor: isDarkMode ? AppColors.white : AppColors.black,
          secondTextColor: AppColors.primary,
          fontSize: 18.sp,
        ),
        leading: IconButton(
          icon: Icon(
            Icons.west,
            color: themeController.isDarkMode.value
                ? AppColors.white
                : AppColors.black,
          ),
          onPressed: () {
            Get.back();
          },
        ),
        backgroundColor: isDarkMode ? AppColors.black : AppColors.white,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(4.h),
          child: Obx(() => Padding(
            padding: EdgeInsets.only(left: 10.w, right: 10.w),
            child: LinearProgressIndicator(
              value: controller.scrollProgress.value,
              backgroundColor: Colors.grey.withOpacity(0.3),
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
          )),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(left: 10.w, right: 10.w),
        child: Column(
          children: [
            AppSizedBox.space10h,
            CustomCard(
              title: "Sajdaas",
              subtitle: 'Discover the Sadjaas Verses and Their Significance',
              imageUrl: isDarkMode
                  ? 'assets/images/sajdah_bg_dark.jpg'
                  : 'assets/images/sajdah_dark_light.jpg',
              mergeWithGradientImage: true,
            ),
            Expanded(
              child: Obx(() => ListView.builder(
                controller: controller.scrollController,
                itemCount: controller.sajdahVerses.length,
                itemBuilder: (context, index) {
                  final surahNumber = controller.sajdahVerses[index]['surahNumber'];
                  final verseNumber = controller.sajdahVerses[index]['verseNumber'];
                  return Container(
                    margin: EdgeInsets.only(bottom: 5, top: 10.h),
                    padding: EdgeInsets.all(18.h),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.r),
                      color: (index % 2 == 1)
                          ? AppColors.primary.withOpacity(0.29)
                          : AppColors.primary.withOpacity(0.1),

                    ),
                    child: ListTile(
                      onTap: () {
                        Get.to(QuranSurahDetailScreen(
                          surahNumber: surahNumber,
                          ayatNumber: verseNumber,
                        ));
                      },
                      contentPadding: EdgeInsets.zero,
                      dense: true,
                      leading: IntrinsicWidth(
                        child: Row(
                          children: [
                            Stack(
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
                                    title: verseNumber.toString(),
                                    fontSize: 10.sp,
                                    textColor: textColor,
                                  ),
                                ),
                              ],
                            ),
                            AppSizedBox.space10w,
                          ],
                        ),
                      ),
                      subtitle: CustomText(
                        title: "Surah " + quran.getSurahName(surahNumber) + " | " + '${quran.getPlaceOfRevelation(surahNumber) == "Makkiyah" ? "Makkah" : "Madina"} | ${quran.getVerseCount(surahNumber)} Ayahs',
                        fontSize: 13.sp,
                        textColor: AppColors.primary,
                        textAlign: TextAlign.end,
                        textOverflow: TextOverflow.ellipsis,
                        fontWeight: FontWeight.w500,
                        maxLines: 1,
                      ),
                      title: CustomText(
                        title: quran.getVerse(surahNumber, verseNumber),
                        fontSize: 22.sp,
                        textColor: textColor,
                        fontWeight: FontWeight.w500,
                        textOverflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        textAlign: TextAlign.end,
                      ),
                    ),
                  );
                },
              )),
            )
          ],
        ),
      ),
    );
  }
}