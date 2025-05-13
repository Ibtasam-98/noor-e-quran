import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:noor_e_quran/app/config/app_sizedbox.dart';
import 'package:noor_e_quran/app/controllers/app_theme_switch_controller.dart';
import 'package:noor_e_quran/app/modules/home/views/app_home_base_screen.dart';
import 'package:noor_e_quran/app/controllers/flying_bird_animation_controller.dart';
import 'package:noor_e_quran/app/modules/memorizer/views/quran_memorizer_surah_detail_screen.dart';
import 'package:noor_e_quran/app/widgets/custom_text.dart';
import '../../../config/app_colors.dart';
import '../../home/controllers/app_home_screen_controller.dart';
import '../../home/views/app_home_screen_header.dart';
import 'package:quran/quran.dart' as quran;
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';

class QuranMemorizerMainScreen extends StatefulWidget {
  final Map<String, dynamic>? userData;

  const QuranMemorizerMainScreen({super.key, this.userData});

  @override
  _QuranMemorizerMainScreenState createState() => _QuranMemorizerMainScreenState();
}

class _QuranMemorizerMainScreenState extends State<QuranMemorizerMainScreen> {
  final GetStorage _storage = GetStorage();
  final String _memorizedVersesKey = 'memorizedVerses';
  final String _lastAccessedTimeKey = 'lastAccessedTime';
  final String _lastAccessedSurahNumberKey = 'lastAccessedSurahNumber';
  final String _surahNameKey = 'surahName';
  final FlyingBirdAnimationController _hifzBirdController = Get.find<FlyingBirdAnimationController>();
  final AppHomeScreenController appHomeScreencontroller = Get.find<AppHomeScreenController>();
  final AppThemeSwitchController appThemeSwitchController = Get.find<AppThemeSwitchController>();

  int _getMemorizedVersesCount(int surahNumber) {
    final memorizedVerses = _storage.read(_memorizedVersesKey) ?? <String>[];
    int count = 0;
    for (var verseKey in memorizedVerses) {
      try {
        final parts = verseKey.split(':');
        final savedSurahNumber = int.parse(parts[0]);
        if (savedSurahNumber == surahNumber) {
          count++;
        }
      } catch (e) {
        debugPrint("Error parsing verse key: $verseKey. Error: $e");
      }
    }
    return count;
  }

  double _getMemorizationPercentage(int surahNumber) {
    final memorizedCount = _getMemorizedVersesCount(surahNumber);
    final totalVerses = quran.getVerseCount(surahNumber);
    return totalVerses > 0 ? (memorizedCount / totalVerses) : 0.0;
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = appThemeSwitchController.isDarkMode.value;
    final textColor = isDarkMode ? AppColors.white : AppColors.black;

    return AppHomeBaseScreen(
      titleFirstPart: "Noor e",
      titleSecondPart: " Quran",
      birdController: _hifzBirdController,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            HomeScreenHeader(birdController: _hifzBirdController),
            Obx(() => CustomText(
              title: "Holy Quran Memorizer",
              textColor: appHomeScreencontroller.themeController.isDarkMode.value
                  ? AppColors.white
                  : AppColors.black,
              fontSize: 14.sp,
              fontFamily: 'grenda',
              textAlign: TextAlign.start,
              maxLines: 1,
            ),
            ),
            AppSizedBox.space10h,
            Column(
              children: List.generate(quran.totalSurahCount, (index) {
                int surahNumber = index + 1;
                final memorizedPercentage = _getMemorizationPercentage(surahNumber);
                final memorizedCount = _getMemorizedVersesCount(surahNumber);
                final totalVerses = quran.getVerseCount(surahNumber);
                final lastAccessedTime = _storage.read<String?>(_lastAccessedTimeKey);
                final lastAccessedSurahNumber = _storage.read<int?>(_lastAccessedSurahNumberKey);
                final surahName = _storage.read<String?>('$_surahNameKey$surahNumber');

                return InkWell(
                  highlightColor: AppColors.transparent,
                  splashColor: AppColors.transparent,
                  onTap: () {
                    Get.to(() => QuranMemorizerSurahDetailScreen(surahNumber: surahNumber));
                  },
                  child: Container(
                    margin: EdgeInsets.only(bottom: 5.h, top: 5.h),
                    padding: EdgeInsets.all(5.h),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.r),
                      color: (index % 2 == 1)
                          ? AppColors.primary.withOpacity(0.29)
                          : AppColors.primary.withOpacity(0.1),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(8.h),
                      child: ListTile(
                        leading: Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              height: 30.h,
                              child: CircularProgressIndicator(
                                value: memorizedPercentage,
                                strokeWidth: 4.0,
                                backgroundColor: AppColors.grey.withOpacity(0.2),
                                valueColor:  AlwaysStoppedAnimation<Color>(Colors.orange),
                              ),
                            ),
                            Positioned(
                              child: CustomText(
                                title: "$memorizedCount/$totalVerses",
                                fontSize: 8.sp,
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
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              title: '${quran.getPlaceOfRevelation(surahNumber) == "Makkiyah"
                                  ? "Makkah"
                                  : "Madina"} | ${quran.getVerseCount(surahNumber)} Ayahs',
                              fontSize: 12.sp,
                              textColor: AppColors.primary,
                              textAlign: TextAlign.start,
                              textOverflow: TextOverflow.ellipsis,
                              fontWeight: FontWeight.w500,
                              maxLines: 1,
                            ),
                            if (lastAccessedTime != null && lastAccessedSurahNumber == surahNumber)
                              CustomText(
                                title: "Last Accessed: ${DateFormat('yyyy-MM-dd HH:mm').format(DateFormat('yyyy-MM-dd HH:mm:ss').parse(lastAccessedTime))}",
                                fontSize: 10.sp,
                                textColor: Colors.grey,
                                textAlign: TextAlign.start,
                                textOverflow: TextOverflow.ellipsis,
                                fontWeight: FontWeight.w500,
                                maxLines: 1,
                              ),
                          ],
                        ),
                        trailing: CustomText(
                          title: quran.getSurahNameArabic(surahNumber),
                          fontSize: 25.sp,
                          textColor: AppColors.primary,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

