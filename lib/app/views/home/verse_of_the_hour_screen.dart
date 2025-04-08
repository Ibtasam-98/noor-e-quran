
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:glowy_borders/glowy_borders.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:noor_e_quran/app/config/app_colors.dart';
import 'package:noor_e_quran/app/config/app_sizedbox.dart';
import 'package:noor_e_quran/app/controllers/app_theme_switch_controller.dart';
import 'package:quran/quran.dart' as quran;
import 'package:share_plus/share_plus.dart';
import '../../controllers/verse_of_hour_controller.dart';
import '../../widgets/custom_formated_text.dart';
import '../../widgets/custom_frame.dart';
import '../../widgets/custom_snackbar.dart';
import '../../widgets/custom_text.dart';
import '../quran/quran_ayat_tafsir_detail_screen.dart';

class VerseOfHourScreen extends StatelessWidget {
  final String title;
  final String arabicText;
  final String translation;
  final int verseNumber;
  final int surahNumber;
  final String surahArabicTitle;

  const VerseOfHourScreen({
    Key? key,
    required this.title,
    required this.arabicText,
    required this.translation,
    required this.verseNumber,
    required this.surahNumber,
    required this.surahArabicTitle
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final VerseOfHourController controller = Get.put(VerseOfHourController(
        surahNumber: surahNumber, verseNumber: verseNumber));
    final AppThemeSwitchController themeController = Get.put(
        AppThemeSwitchController());
    bool isDarkMode = themeController.isDarkMode.value;

    return Scaffold(
      backgroundColor: isDarkMode ? AppColors.black : AppColors.white,
      appBar: AppBar(
        surfaceTintColor: AppColors.transparent,
        backgroundColor: isDarkMode ? AppColors.black : AppColors.white,
        centerTitle: false,
        title: CustomText(
          firstText: "Verse",
          secondText: " Detail",
          firstTextColor: isDarkMode ? AppColors.white : AppColors.black,
          secondTextColor: AppColors.primary,
          fontSize: 18.sp,
        ),
        leading: InkWell(
          onTap: () => Get.back(),
          child: Icon(Icons.west,
              color: isDarkMode ? AppColors.white : AppColors.black),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 10.w),
            child: InkWell(
              onTap: () {
                Share.share("Check out verse of the hour: ${arabicText}\n\n${translation}\nSurah Number ${surahNumber} \nAyat Number ${verseNumber} \n\nShare from Noor e Quran App",);
              },
              child: Icon(Icons.share,
                  color: isDarkMode ? AppColors.white : AppColors.black,
                  size: 17.h),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                decoration: BoxDecoration(
                  color: isDarkMode ? AppColors.black : AppColors.white,
                  borderRadius: BorderRadius.circular(1.r),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.5),
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomFrame(
                      leftImageAsset: "assets/frames/topLeftFrame.png",
                      rightImageAsset: "assets/frames/topRightFrame.png",
                      imageHeight: 65.h,
                      imageWidth: 65.w,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10.w, right: 10.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomText(
                                    textColor: isDarkMode ? AppColors.white : AppColors.black,
                                    fontSize: 20.sp,
                                    title: title,
                                    fontFamily: 'grenda',
                                  ),
                                  CustomText(
                                    textColor: AppColors.primary,
                                    fontSize: 13.sp,
                                    title: 'Surah No. $surahNumber | Verse No. $verseNumber',
                                    fontFamily: 'grenda',
                                    fontWeight: FontWeight.bold,
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  CustomText(
                                    textColor: isDarkMode ? AppColors.white : AppColors.black,
                                    fontSize: 18.sp,
                                    title: surahArabicTitle,
                                    fontFamily: 'grenda',
                                    capitalize: true,
                                  ),
                                  InkWell(
                                    onTap: (){
                                      Get.to(QuranAyatTafsirDetailScreen(
                                        ayahNumber: verseNumber,
                                        surahNumber: surahNumber,
                                        ayat: arabicText,
                                        surahArabicName: quran.getSurahNameArabic(surahNumber),
                                        surahName: quran.getSurahNameEnglish(surahNumber),
                                      ));
                                    },
                                    child: CustomText(
                                      textColor: AppColors.primary,
                                      fontSize: 15.sp,
                                      title: "View Tafseer",
                                      fontFamily: 'quicksand',
                                      capitalize: true,
                                      fontWeight: FontWeight.bold,
                                      textAlign: TextAlign.end,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                          AppSizedBox.space10h,
                          Container(
                            padding: EdgeInsets.only(right: 10.w, top: 10.h, bottom: 10.h),
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.25),
                              borderRadius: BorderRadius.circular(15.r),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  AppSizedBox.space5w,
                                  Container(
                                    width: 32.w,
                                    height: 32.h,
                                    decoration: const BoxDecoration(
                                      image: DecorationImage(
                                        image: AssetImage("assets/images/ayat_marker.png"),
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                    child: Center(
                                      child: Padding(
                                        padding: EdgeInsets.only(top: 3.h, bottom: 3.h),
                                        child: Text(
                                          verseNumber.toString(),
                                          style: TextStyle(
                                            fontSize: 13.sp,
                                            color:  isDarkMode ? AppColors.white : AppColors.black,
                                          ),
                                          textAlign: TextAlign.end,
                                        ),
                                      ),
                                    ),
                                  ),
                                  AppSizedBox.space5w,
                                  Expanded(
                                    child: InteractiveViewer(
                                      maxScale: 10.0,
                                      minScale: 1.0,
                                      child: InkWell(
                                        splashColor: AppColors.transparent,
                                        hoverColor: AppColors.transparent,
                                        highlightColor: AppColors.transparent,
                                        onLongPress: (){
                                          String arabic = arabicText;
                                          Clipboard.setData(ClipboardData(text: arabic));
                                          CustomSnackbar.show(
                                              title:"Success",
                                              subtitle: "Arabic Text copied to clipboard",
                                              icon: Icon(Icons.check),
                                              backgroundColor: AppColors.green,
                                              textColor: AppColors.white
                                          );
                                        },
                                        child: Text(
                                          arabicText,
                                          style: TextStyle(
                                            fontSize: controller.currentFontSize.value,
                                            color: isDarkMode ? AppColors.white : AppColors.black,
                                          ),
                                          textAlign: TextAlign.end,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          AppSizedBox.space10h,
                          CustomText(
                            textColor: AppColors.primary,
                            fontSize: controller.currentFontSize.value,
                            title: "Translation",
                            fontFamily: 'grenda',
                          ),
                          Obx((){
                            return CustomText(
                              textColor: isDarkMode ? AppColors.white : AppColors.black,
                              fontSize: controller.currentFontSize.value,
                              title: translation,
                              textAlign: TextAlign.start,
                            );
                          }),
                          AppSizedBox.space20h,
                          Obx((){
                            return Align(
                              alignment: Alignment.centerRight,
                              child: CustomText(
                                textColor: isDarkMode ? AppColors.white : AppColors.black,
                                fontSize: controller.currentFontSize.value,
                                title: quran.getVerseTranslation(
                                    surahNumber,
                                    verseNumber,
                                    translation: quran.Translation.urdu),
                                textAlign: TextAlign.end,
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                    CustomFrame(
                      leftImageAsset: "assets/frames/bottomLeftFrame.png",
                      rightImageAsset: "assets/frames/bottomRightFrame.png",
                      imageHeight: 65.h,
                      imageWidth: 65.w,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Stack(
              children: [
                // Background Image with Gradient Overlay
                Container(
                  height: 150.h,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(isDarkMode
                          ? 'assets/images/quran_bg_dark.jpg'
                          : 'assets/images/quran_bg_light.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: isDarkMode
                            ? [AppColors.black, AppColors.black.withOpacity(0.1)]
                            : [AppColors.white, AppColors.white.withOpacity(0.04)],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        stops: [0, 1],
                      ),
                    ),
                  ),
                ),
                Column(
                  children: [
                    AppSizedBox.space10h,

                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      child: Column(
                        children: [
                          // Slider
                          Obx(() => Slider(
                            value: controller.progress.value,
                            onChanged: controller.seekAudio,
                            activeColor: AppColors.primary,
                            inactiveColor: AppColors.primary.withOpacity(0.3),
                          )),
                          // Duration Labels
                          Obx(() => Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CustomText(
                                title: formatDuration(controller.currentPosition.value),
                                fontSize: 12.sp,
                                textColor: isDarkMode ? AppColors.white : AppColors.black,
                              ),
                              CustomText(
                                title: formatDuration(controller.audioDuration ?? Duration.zero),
                                fontSize: 12.sp,
                                textColor: isDarkMode ? AppColors.white : AppColors.black,
                              ),
                            ],
                          )),
                        ],
                      ),
                    ),
                    // Play/Pause Button with Animated Border
                    Center(
                      child: InkWell(
                        hoverColor: AppColors.transparent,
                        splashColor: AppColors.transparent,
                        highlightColor: AppColors.transparent,
                        onTap: controller.togglePlayPause,
                        child: Obx(() => AnimatedGradientBorder(
                          borderSize: controller.isPlaying.value ? 0.5 : 0.0,
                          glowSize: controller.isPlaying.value ? 0.5 : 0.0,
                          gradientColors: controller.isPlaying.value
                              ? [
                            Color(0xFFFFD700),
                            Color(0xFFFFA500),
                            Color(0xFFF4E2D8),
                            Color(0xFFE09F3E),
                            Color(0xFFB65D25),
                          ]
                              : [AppColors.primary], // Static color when not playing
                          borderRadius: BorderRadius.all(Radius.circular(555.r)),
                          child: Padding(
                            padding: EdgeInsets.all(8.w),
                            child: CircleAvatar(
                              backgroundColor: AppColors.primary,
                              radius: 35.r,
                              child: Icon(
                                controller.isPlaying.value ? Icons.pause : Icons.play_arrow,
                                size: 30.h,
                                color: AppColors.white,
                              ),
                            ),
                          ),
                        )),
                      ),
                    ),
                  ],
                )
              ],
            ),
          )


        ],
      ),
      bottomNavigationBar: BottomAppBar(
          color: themeController.isDarkMode.value ? AppColors.black : AppColors.white,
          child: Row(
            children: [
              CustomText(
                textColor: isDarkMode ? AppColors.white : AppColors.black,
                fontSize: 15.sp,
                title: "Font Size",
              ),

              Obx(() => Expanded(
                child: Slider(
                  value: controller.currentFontSize.value,
                  min: 12.0,
                  max: 60.0,
                  divisions: 14,
                  label: "${controller.currentFontSize.value.toStringAsFixed(1)}",
                  activeColor: AppColors.primary,
                  inactiveColor: AppColors.grey,
                  onChanged: (double value) {
                    controller.updateFontSize(value);
                  },
                ),
              )),
            ],
          )
      ),
    );
  }
}
