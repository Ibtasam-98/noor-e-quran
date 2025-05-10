import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icons.dart';
import 'package:quran/quran.dart' as quran;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../config/app_colors.dart';
import '../../../config/app_sizedbox.dart';
import '../../../controllers/app_theme_switch_controller.dart';
import '../../../widgets/custom_snackbar.dart';
import '../../../widgets/custom_text.dart';
import '../../common/views/audio_player_screen.dart';
import '../controllers/quran_surah_detail_screen_controller.dart';
import '../views/quran_surah_ayat_detail_screen.dart';
import '../views/quran_surah_setting_screen.dart';

class QuranSurahDetailScreen extends StatelessWidget {
  final int surahNumber;
  final int? ayatNumber;
  final QuranSurahDetailController controller = Get.put(QuranSurahDetailController());

  QuranSurahDetailScreen({required this.surahNumber, this.ayatNumber});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (ayatNumber != null) {
        controller.scrollToAyah(ayatNumber!, context);
      }
      controller.checkFavoriteStatus(surahNumber);
    });

    return Scaffold(
      backgroundColor: controller.isDarkMode.value ? AppColors.black : AppColors.white,
      appBar: AppBar(
        surfaceTintColor: AppColors.transparent,
        backgroundColor: controller.isDarkMode.value ? AppColors.black : AppColors.white,
        title: CustomText(
          title: "﷽",
          textColor: controller.isDarkMode.value ? AppColors.white : AppColors.black,
          fontSize: 20.sp,
          maxLines: 1,
          fontWeight: FontWeight.w400,
          textOverflow: TextOverflow.ellipsis,
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.west,
            color: controller.isDarkMode.value ? AppColors.white : AppColors.black,
          ),
        ),
        actions: [
          IconButton(
            icon: Obx(() => Icon(
              controller.isFavorite.value ? Icons.favorite : Icons.favorite_border,
              color: controller.isFavorite.value ? Colors.red :
              (controller.isDarkMode.value ? AppColors.white : AppColors.black),
            )),
            onPressed: () => controller.toggleFavorite(surahNumber),
          ),
          IconButton(
            icon: Icon(
              LineIcons.cog,
              color: controller.isDarkMode.value ? AppColors.white : AppColors.black,
            ),
            onPressed: () async {
              final settings = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => QuranSurahSettingScreen(
                    currentTranslation: controller.selectedTranslation.value,
                    isTranslationEnabled: controller.isTranslationEnabled.value,
                    currentFontSize: controller.arabicFontSize.value,
                    currentWordSpacing: controller.selectedWordSpacing.value,
                    currentArabicFontFamily: controller.selectedFontStyle.value,
                    currentTranslationFontFamily: controller.selectedTranslationFontFamily.value,
                  ),
                ),
              );
              if (settings != null) {
                controller.updateSettings(settings);
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        child: Column(
          children: [
            Obx(() => LinearProgressIndicator(
              value: controller.scrollProgress.value,
              backgroundColor: AppColors.grey.withOpacity(0.1),
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
            )),
            AppSizedBox.space10h,
            Column(
              children: [
                CustomText(
                  title: quran.getSurahNameArabic(surahNumber),
                  fontSize: 30.sp,
                  textColor: AppColors.primary,
                ),
                CustomText(
                  title: quran.getSurahNameEnglish(surahNumber),
                  fontSize: 16.sp,
                  textColor: controller.isDarkMode.value ? AppColors.white : AppColors.black,
                  fontFamily: 'quicksand',
                ),
              ],
            ),
            AppSizedBox.space10h,
            Expanded(
              child: ListView.builder(
                controller: controller.scrollController,
                itemCount: quran.getVerseCount(surahNumber),
                itemBuilder: (context, index) {
                  final verseNumber = index + 1;
                  String verseText = quran.getVerse(surahNumber, verseNumber, verseEndSymbol: false);
                  String? translationText;
                  if (controller.isTranslationEnabled.value) {
                    try {
                      translationText = quran.getVerseTranslation(
                        surahNumber,
                        verseNumber,
                        translation: controller.selectedTranslation.value,
                      );
                    } catch (e) {
                      translationText = "Translation not available.";
                    }
                  }

                  return InkWell(
                    splashColor: AppColors.transparent,
                    onTap: () {
                      Get.to(QuranSurahAyatDetailsScreen(
                        arabicText: verseText,
                        ayahIndex: verseNumber,
                        surahIndex: surahNumber,
                        surahLatinName: quran.getSurahNameEnglish(surahNumber),
                        translation: translationText,
                        surahArabicName: quran.getSurahNameArabic(surahNumber),
                        textAlign: controller.selectedTranslation.value == quran.Translation.urdu
                            ? TextAlign.end
                            : TextAlign.start,
                        surahName: '',
                      ));
                    },
                    onLongPress: () => controller.saveAyah(surahNumber, verseNumber, verseText),
                    child: Obx(() => AnimatedBuilder(
                      animation: controller.animationController,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: controller.highlightedAyah.value == verseNumber
                              ? controller.scaleAnimation.value
                              : 1.0,
                          child: child,
                        );
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 5.h),
                        padding: EdgeInsets.all(18.h),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.r),
                          color: (index % 2 == 1)
                              ? AppColors.primary.withOpacity(0.29)
                              : AppColors.primary.withOpacity(0.1),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Image.asset(
                                      "assets/images/ayat_marker.png",
                                      width: 26.w,
                                      height: 26.h,
                                    ),
                                    CustomText(
                                      title: verseNumber.toString(),
                                      fontSize: 10.sp,
                                      textColor: controller.isDarkMode.value ? AppColors.white : AppColors.black,
                                    ),
                                  ],
                                ),
                                Expanded(
                                  child: Text(
                                    verseText,
                                    textAlign: TextAlign.right,
                                    style: controller.getArabicTextStyle(
                                        controller.isDarkMode.value ? AppColors.white : AppColors.black),
                                  ),
                                ),
                              ],
                            ),
                            if (controller.isTranslationEnabled.value && translationText != null)
                              Padding(
                                padding: EdgeInsets.only(top: 8.h),
                                child: Text(
                                  translationText,
                                  style: controller.getTranslationTextStyle(
                                      controller.isDarkMode.value ? AppColors.white : AppColors.black),
                                ),
                              ),
                          ],
                        ),
                      ),
                    )),
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