import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:noor_e_quran/app/controllers/app_theme_switch_controller.dart';
import 'package:noor_e_quran/app/modules/home/views/app_home_base_screen.dart';
import 'package:noor_e_quran/app/modules/quran/views/quran_surah_detail_screen.dart';
import 'package:noor_e_quran/app/modules/quran/views/quran_verse_of_the_hour_screen.dart';
import 'package:quran/quran.dart' as quran;
import 'package:noor_e_quran/app/controllers/flying_bird_animation_controller.dart';
import '../../../config/app_colors.dart';
import '../../../config/app_sizedbox.dart';
import '../../../widgets/custom_frame.dart';
import '../../../widgets/custom_text.dart';
import '../../home/controllers/app_home_screen_controller.dart';
import '../../home/views/app_home_screen_header.dart';
import '../controllers/quran_main_screen_controller.dart';
import 'dart:math';

import 'last_access_surah_list_screen.dart';

class QuranMainScreen extends StatelessWidget {
  final Map<String, dynamic>? userData;
  final QuranMainScreenController quranMainScreenController = Get.put(QuranMainScreenController());

  QuranMainScreen({super.key, this.userData});

  @override
  Widget build(BuildContext context) {
    final FlyingBirdAnimationController _quranBirdController = Get.find<FlyingBirdAnimationController>();
    final AppHomeScreenController controller = Get.find<AppHomeScreenController>();
    final AppThemeSwitchController themeController = Get.find<AppThemeSwitchController>();
    final QuranMainScreenController quranMainScreenController = Get.find<QuranMainScreenController>();

    return AppHomeBaseScreen(
      titleFirstPart: "Noor e",
      titleSecondPart: " Quran",
      birdController: _quranBirdController,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HomeScreenHeader(birdController: _quranBirdController),
            CustomText(
              title: "Verse of the Hour",
              textColor: themeController.isDarkMode.value ? AppColors.white : AppColors.black,
              fontSize: 16.sp,
              fontFamily: 'grenda',
              textAlign: TextAlign.start,
              maxLines: 1,
              textOverflow: TextOverflow.ellipsis,
            ),
            AppSizedBox.space10h,
            InkWell(
              splashColor: AppColors.transparent,
              highlightColor: AppColors.transparent,
              onTap: () {
                Get.to(VerseOfHourScreen(
                  surahNumber: quranMainScreenController.randomVerse.value.surahNumber,
                  verseNumber: quranMainScreenController.randomVerse.value.verseNumber,
                  arabicText: quranMainScreenController.randomVerse.value.verse,
                  translation: quranMainScreenController.randomVerse.value.translation,
                  title: quran.getSurahName(quranMainScreenController.randomVerse.value.surahNumber),
                  surahArabicTitle: quran.getSurahNameArabic(quranMainScreenController.randomVerse.value.surahNumber),
                ));
              },
              child: Obx(() {
                final verse = quranMainScreenController.randomVerse.value;
                return Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                        themeController.isDarkMode.value
                            ? "assets/images/quran_bg_dark.jpg"
                            : "assets/images/quran_bg_light.jpg",
                      ),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(15.r),
                    boxShadow: [
                      BoxShadow(
                        color: themeController.isDarkMode.value
                            ? AppColors.primary.withOpacity(0.3)
                            : AppColors.transparent,
                        blurRadius: 2,
                      ),
                    ],
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.black.withOpacity(0.5),
                          AppColors.transparent,
                          AppColors.black.withOpacity(0.5),
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(15.r),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h).copyWith(right: 20.w),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          CustomText(
                            title: verse.verse,
                            textAlign: TextAlign.end,
                            textColor: AppColors.white,
                            fontSize: 18.sp,
                            maxLines: 1,
                            textStyle: GoogleFonts.amiri(),
                          ),
                          AppSizedBox.space5h,
                          Align(
                            alignment: Alignment.centerLeft,
                            child: CustomText(
                              title: verse.translation,
                              fontSize: 12.sp,
                              textColor: AppColors.white,
                              maxLines: 2,
                              fontWeight: FontWeight.w500,
                              textAlign: TextAlign.start,
                            ),
                          ),
                          AppSizedBox.space5h,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: CustomText(
                                  title: 'Surah ${quran.getSurahName(verse.surahNumber)} | Surah No. ${verse.surahNumber} | Verse No.${verse.verseNumber}',
                                  fontSize: 10.sp,
                                  textColor: AppColors.white,
                                  maxLines: 2,
                                  textAlign: TextAlign.start,
                                  fontWeight: FontWeight.bold,
                                  textStyle: const TextStyle(fontStyle: FontStyle.italic),
                                ),
                              ),
                              Icon(Icons.remove_red_eye, color: AppColors.white, size: 15.h),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
            AppSizedBox.space10h,
            AppSizedBox.space10h,
            if (quranMainScreenController.lastAccessedSurahs.isNotEmpty) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Obx(() => CustomText(
                      title: "Last Accessed Surah",
                      textColor: themeController.isDarkMode.value
                          ? AppColors.white
                          : AppColors.black,
                      fontSize: 16.sp,
                      fontFamily: 'grenda',
                      textAlign: TextAlign.start,
                      textOverflow: TextOverflow.ellipsis,
                    )),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () => Get.to(() => LastAccessSurahListScreen()),
                      child: CustomText(
                        title: "View All",
                        textColor: AppColors.primary,
                        fontSize: 12.sp,
                        fontFamily: 'quicksand',
                        textAlign: TextAlign.end,
                        fontWeight: FontWeight.w600,
                        textOverflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
              AppSizedBox.space10h,
              GetBuilder<AppHomeScreenController>(
                builder: (controller) {
                  if (quranMainScreenController.lastAccessedSurahs.isEmpty) {
                    return Center(child: Text('No recent activity.'));
                  }
                  final sortedSurahs = List<Map<String, dynamic>>.from(quranMainScreenController.lastAccessedSurahs)
                    ..sort((a, b) => quranMainScreenController.parseAccessTime(b['accessTime']).compareTo(quranMainScreenController.parseAccessTime(a['accessTime'])));
                  final latestSurahs = sortedSurahs.take(3).toList();
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: latestSurahs.map((surahData) {
                        final surahNumber = surahData['surahNumber'] as int;
                        final accessTime = quranMainScreenController.parseAccessTime(surahData['accessTime'] as String);
                        final formattedTime = DateFormat('yyyy-MM-dd HH:mm').format(accessTime);
                        final placeOfRevelation = quran.getPlaceOfRevelation(surahNumber);
                        final verseCount = quran.getVerseCount(surahNumber);
                        final surahName = quranMainScreenController.getSurahName(surahNumber);
                        final surahNameArabic = quranMainScreenController.getSurahNameArabic(surahNumber);
                        final isEvenIndex = latestSurahs.indexOf(surahData) % 2 == 0;
                        return Container(
                          width: 280.w,
                          margin: EdgeInsets.only(right: 8.w),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              padding: EdgeInsets.all(6.h),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15.r),
                                color: isEvenIndex ? AppColors.primary.withOpacity(0.1) : AppColors.primary.withOpacity(0.29),
                              ),
                              child: ListTile(
                                contentPadding: EdgeInsets.zero,
                                dense: true,
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Obx(()=>CustomText(
                                      title: surahName,
                                      fontSize: 15.sp,
                                      textColor: themeController.isDarkMode.value ? AppColors.white : AppColors.black,
                                      fontWeight: FontWeight.w500,
                                      textOverflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      textAlign: TextAlign.start,),
                                    ),
                                    CustomText(
                                      title: '${placeOfRevelation == 'Makkiyah' ? 'Makkah' : 'Madinah'} | $verseCount Verses',
                                      fontSize: 14.sp,
                                      textColor: AppColors.primary,
                                      textAlign: TextAlign.start,
                                      textOverflow: TextOverflow.ellipsis,
                                      fontWeight: FontWeight.w500,
                                      maxLines: 1,
                                    ),
                                    AppSizedBox.space5h,
                                  ],
                                ),
                                subtitle: Obx(()=>CustomText(
                                  title: 'Last Accessed $formattedTime',
                                  fontSize: 12.sp,
                                  textColor: themeController.isDarkMode.value  ? AppColors.grey : AppColors.black,
                                  fontWeight: FontWeight.w500,
                                  textOverflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  textAlign: TextAlign.start,),
                                ),
                                trailing: SizedBox(
                                  width: 80.w, // Adjust width as needed
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: CustomText(
                                      title: surahNameArabic,
                                      fontSize: 25.sp,
                                      textColor: AppColors.primary,
                                      maxLines: 1,
                                      textOverflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                                onTap: () => Get.to(() => QuranSurahDetailScreen(surahNumber: surahNumber)),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  );
                },
              ),
            ],
            AppSizedBox.space10h,
            Obx(()=>CustomText(
              title: "Quran Explorer",
              textColor: themeController.isDarkMode.value ? AppColors.white : AppColors.black,
              fontSize: 16.sp,
              fontFamily: 'grenda',
              textAlign: TextAlign.start,
              maxLines: 1,
              textOverflow: TextOverflow.ellipsis,
            ),),
            AppSizedBox.space10h,
            Column(
              children: [
                GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2,
                    childAspectRatio: 1,
                    crossAxisSpacing: 10,
                  ),
                  itemCount: quranMainScreenController.quranMenuGridItems.length,
                  itemBuilder: (context, index) {
                    final menuItem = quranMainScreenController.quranMenuGridItems[index];
                    return Obx(() => InkWell(
                      highlightColor: AppColors.transparent,
                      splashColor: AppColors.transparent,
                      onTap: () {

                        if (menuItem['destination'] != null) {
                          Get.to(menuItem['destination']());
                        }
                      },
                      child: Container(
                        margin: EdgeInsets.only(bottom: 10.h),
                        decoration: BoxDecoration(
                          color: controller.themeController.isDarkMode.value
                              ? AppColors.black
                              : AppColors.white,
                          borderRadius: BorderRadius.circular(10.r),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withOpacity(0.1),
                              spreadRadius: 1,
                              blurRadius: 2,
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              CustomFrame(
                                leftImageAsset: "assets/frames/topLeftFrame.png",
                                rightImageAsset: "assets/frames/topRightFrame.png",
                                imageHeight: 30.h,
                                imageWidth: 30.w,
                              ),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CustomText(
                                      title: menuItem['title'] ?? '', // Use null-aware operator
                                      fontSize: 16.sp,
                                      textColor: controller.themeController.isDarkMode.value
                                          ? AppColors.white
                                          : AppColors.black,
                                      fontWeight: FontWeight.normal,
                                      textOverflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.center,
                                      capitalize: true,
                                      maxLines: 2,
                                      fontFamily: 'grenda',
                                    ),
                                    CustomText(
                                      title: menuItem['subtitle'] ??
                                          '', // Use null-aware operator
                                      fontSize: 12.sp,
                                      textColor: AppColors.primary,
                                      fontWeight: FontWeight.w500,
                                      textAlign: TextAlign.center,
                                      textOverflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                    ),
                                  ],
                                ),
                              ),
                              CustomFrame(
                                leftImageAsset: "assets/frames/bottomLeftFrame.png",
                                rightImageAsset: "assets/frames/bottomRightFrame.png",
                                imageHeight: 30.h,
                                imageWidth: 30.w,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ));
                  },
                )
              ],
            ),
            AppSizedBox.space10h,
          ],
        ),
      ),
    );
  }
}
