import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:noor_e_quran/app/controllers/app_theme_switch_controller.dart';
import 'package:noor_e_quran/app/modules/home/views/app_home_base_screen.dart';
import 'package:noor_e_quran/app/controllers/flying_bird_animation_controller.dart';
import 'package:noor_e_quran/app/modules/memorizer/views/quran_memorization_visualization_screen.dart';
import 'package:noor_e_quran/app/modules/memorizer/views/quran_memorizer_juzz_detail_screen.dart';
import 'package:noor_e_quran/app/modules/memorizer/views/quran_memorizer_surah_detail_screen.dart';
import 'package:noor_e_quran/app/widgets/custom_text.dart';
import '../../../config/app_colors.dart';
import '../../../config/app_sizedbox.dart';
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

class _QuranMemorizerMainScreenState extends State<QuranMemorizerMainScreen> with SingleTickerProviderStateMixin {
  final GetStorage _storage = GetStorage();
  final String _memorizedVersesKey = 'memorizedVerses';
  final String _lastAccessedTimeKey = 'lastAccessedTime';
  final String _lastAccessedSurahNumberKey = 'lastAccessedSurahNumber';
  final String _surahNameKey = 'surahName';
  final FlyingBirdAnimationController _hifzBirdController = Get.find<FlyingBirdAnimationController>();
  final AppHomeScreenController appHomeScreencontroller = Get.find<AppHomeScreenController>();
  final AppThemeSwitchController appThemeSwitchController = Get.find<AppThemeSwitchController>();

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

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

  int _getTotalMemorizedVerses() {
    final memorizedVerses = _storage.read(_memorizedVersesKey) ?? <String>[];
    return memorizedVerses.length;
  }

  int _getTotalVersesInQuran() {
    return 6236;
  }


  int _getTotalJuzVersesMemorized() {
    final memorizedVerses = _storage.read(_memorizedVersesKey) ?? <String>[];
    int count = 0;
    for (int i = 1; i <= 30; i++) {
      final juzData = quran.getSurahAndVersesFromJuz(i);
      juzData.forEach((surahNumber, verseRange) {
        for (int verseNumber = verseRange[0]; verseNumber <= verseRange[1]; verseNumber++) {
          if (memorizedVerses.contains('$surahNumber:$verseNumber')) {
            count++;
          }
        }
      });
    }
    return count;
  }

  int _getTotalJuzVerses() {
    int count = 0;
    for (int i = 1; i <= 30; i++) {
      final juzData = quran.getSurahAndVersesFromJuz(i);
      juzData.forEach((surahNumber, verseRange) {
        count += (verseRange[1] - verseRange[0] + 1);
      });
    }
    return count;
  }


  @override
  Widget build(BuildContext context) {
    bool isDarkMode = appThemeSwitchController.isDarkMode.value;


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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Obx(() => CustomText(
                  title: "Holy Quran Memorize",
                  textColor: appHomeScreencontroller.themeController.isDarkMode.value
                      ? AppColors.white
                      : AppColors.black,
                  fontSize: 14.sp,
                  fontFamily: 'grenda',
                  textAlign: TextAlign.start,
                  maxLines: 1,
                )),
                Expanded(
                  child: InkWell(
                    onTap: (){Get.to(MemorizationProgressScreen());},
                    child: CustomText(
                      title: "View Progress",
                      textColor: AppColors.primary,
                      fontSize: 12.sp,
                      fontFamily: 'quicksand',
                      textAlign: TextAlign.end,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),

            AppSizedBox.space10h,
            Obx(() => TabBar(
              controller: _tabController,
              dividerColor: Colors.transparent,
              indicatorSize: TabBarIndicatorSize.tab,
              indicatorColor: AppColors.primary,
              labelColor: AppColors.primary,
              unselectedLabelColor: appThemeSwitchController.isDarkMode.value
                  ? AppColors.white.withOpacity(0.7)
                  : AppColors.black.withOpacity(0.7),
              labelStyle: GoogleFonts.quicksand(fontSize: 14.sp),
              indicator: BoxDecoration(
                border: Border.all(color: AppColors.primary, width: 1),
                borderRadius: BorderRadius.circular(50.r),
              ),
              tabs: const [
                Tab(text: 'Surahs'),
                Tab(text: 'Juz'),
              ],
            )),
            AppSizedBox.space10h,
            Container(
              height: MediaQuery.of(context).size.height * 0.55,
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildAllSurahsList(isDarkMode),
                  _buildAllJuzList(isDarkMode),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAllSurahsList(bool isDarkMode) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: quran.totalSurahCount,
      itemBuilder: (context, index) {
        int surahNumber = index + 1;
        final memorizedPercentage = _getMemorizationPercentage(surahNumber);
        final memorizedCount = _getMemorizedVersesCount(surahNumber);
        final totalVerses = quran.getVerseCount(surahNumber);
        final lastAccessedTime = _storage.read<String?>(_lastAccessedTimeKey);
        final lastAccessedSurahNumber = _storage.read<int?>(_lastAccessedSurahNumberKey);

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
              padding: EdgeInsets.only(left: 5.h, right: 5.h, top: 12.h, bottom: 12.h),
              child: Row(
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        height: 30.h,
                        width: 30.h,
                        child: CircularProgressIndicator(
                          value: memorizedPercentage,
                          strokeWidth: 4.0,
                          backgroundColor: AppColors.grey.withOpacity(0.2),
                          valueColor: const AlwaysStoppedAnimation<Color>(Colors.orange),
                        ),
                      ),
                      Positioned(
                        child: Obx(() => CustomText(
                          title: "$memorizedCount/$totalVerses",
                          fontSize: 8.sp,
                          textColor: appThemeSwitchController.isDarkMode.value
                              ? AppColors.white
                              : AppColors.black,
                        )),
                      ),
                    ],
                  ),
                  AppSizedBox.space10w,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Obx(() => CustomText(
                          title: quran.getSurahName(surahNumber),
                          fontSize: 15.sp,
                          textColor: appThemeSwitchController.isDarkMode.value
                              ? AppColors.white
                              : AppColors.black,
                          fontWeight: FontWeight.w500,
                          textOverflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          textAlign: TextAlign.start,
                        )),
                        CustomText(
                          title: '${quran.getPlaceOfRevelation(surahNumber) == "Makkiyah" ? "Makkah" : "Madina"} | ${quran.getVerseCount(surahNumber)} Ayahs',
                          fontSize: 12.sp,
                          textColor: AppColors.primary,
                          textAlign: TextAlign.start,
                          textOverflow: TextOverflow.ellipsis,
                          fontWeight: FontWeight.w500,
                          maxLines: 1,
                        ),
                        if (lastAccessedTime != null && lastAccessedSurahNumber == surahNumber)
                          Obx(() => CustomText(
                            title: "Last Accessed: ${DateFormat('yyyy-MM-dd HH:mm').format(DateFormat('yyyy-MM-dd HH:mm:ss').parse(lastAccessedTime))}",
                            fontSize: 10.sp,
                            textColor: appThemeSwitchController.isDarkMode.value
                                ? AppColors.lightGrey
                                : AppColors.grey,
                            textAlign: TextAlign.start,
                            textOverflow: TextOverflow.ellipsis,
                            fontWeight: FontWeight.w500,
                            maxLines: 1,
                          )),
                      ],
                    ),
                  ),
                  AppSizedBox.space10w,
                  Obx(() => CustomText(
                    title: quran.getSurahNameArabic(surahNumber),
                    fontSize: 25.sp,
                    textColor: appThemeSwitchController.isDarkMode.value
                        ? AppColors.primary
                        : AppColors.primary,
                  )),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAllJuzList(bool isDarkMode) {
    return ListView.builder(
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
    itemCount: 30, // 30 Juz in Quran
    itemBuilder: (context, index) {
    int juzNumber = index + 1;
    Map<int, List<int>> juzData = quran.getSurahAndVersesFromJuz(juzNumber);

    // Calculate memorization progress for this Juz
    final memorizedVerses = _storage.read(_memorizedVersesKey) ?? <String>[];
    int memorizedCount = 0;
    int totalVerses = 0;

    juzData.forEach((surahNumber, verseRange) {
    final startVerse = verseRange[0];
    final endVerse = verseRange[1];
    totalVerses += (endVerse - startVerse + 1);

    for (int verseNumber = startVerse; verseNumber <= endVerse; verseNumber++) {
    if (memorizedVerses.contains('$surahNumber:$verseNumber')) {
    memorizedCount++;
    }
    }
    });

    final memorizationPercentage = totalVerses > 0 ? memorizedCount / totalVerses : 0.0;
    final lastAccessedTime = _storage.read<String?>('${_lastAccessedTimeKey}Juz$juzNumber');

    String surahsInJuz = "";
    if (juzData.isNotEmpty) {
    List<int> surahNumbers = juzData.keys.toList()..sort();
    if (surahNumbers.length == 1) {
    surahsInJuz = "Surah ${surahNumbers.first}";
    } else if (surahNumbers.length > 1) {
      surahsInJuz = "Surah ${surahNumbers.first} - Surah ${surahNumbers.last}";
    }
    } else {
      surahsInJuz = "No surahs found";
    }

    return InkWell(
      onTap: () {
        Get.to(() => QuranMemorizerJuzDetailScreen(juzNumber: juzNumber));
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 5.h, top: 5.h, left: 8.w, right: 8.w),
        padding: EdgeInsets.all(17.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.r),
          color: (index % 2 == 1)
              ? AppColors.primary.withOpacity(0.29)
              : AppColors.primary.withOpacity(0.1),
        ),
        child: Row(
          children: [
           Stack(
             alignment: Alignment.center,
             children: [
               CircularProgressIndicator(
                 value: memorizationPercentage,
                 backgroundColor: AppColors.grey.withOpacity(0.2),
                 valueColor: const AlwaysStoppedAnimation<Color>(Colors.orange),
               ),
               Positioned(
                 child: Obx(() => CustomText(
                   title: "$memorizedCount/$totalVerses",
                   fontSize: 8.sp,
                   textColor: appThemeSwitchController.isDarkMode.value
                       ? AppColors.white
                       : AppColors.black,
                 )),
               ),
             ],
           ),

            AppSizedBox.space10w,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(() => CustomText(
                    title: 'Juz $juzNumber',
                    fontSize: 15.sp,
                    textColor: appThemeSwitchController.isDarkMode.value
                        ? AppColors.white
                        : AppColors.black,
                    fontWeight: FontWeight.w500,
                    textOverflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    textAlign: TextAlign.start,
                  )),
                  CustomText(
                    title: surahsInJuz,
                    fontSize: 12.sp,
                    textColor: AppColors.primary,
                    textOverflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                  if (lastAccessedTime != null)
                    Obx(() => CustomText(
                      title: "Last Accessed: ${DateFormat('yyyy-MM-dd HH:mm').format(DateFormat('yyyy-MM-dd HH:mm:ss').parse(lastAccessedTime))}",
                      fontSize: 10.sp,
                      textColor: appThemeSwitchController.isDarkMode.value
                          ? AppColors.lightGrey
                          : AppColors.grey,
                      textAlign: TextAlign.start,
                      textOverflow: TextOverflow.ellipsis,
                      fontWeight: FontWeight.w500,
                      maxLines: 1,
                    )),
                ],
              ),
            ),
            Obx(() => Icon(
              Icons.arrow_forward_ios,
              size: 12.sp,
              color: appThemeSwitchController.isDarkMode.value
                  ? AppColors.white
                  : AppColors.black,
            )),
          ],
        ),
      ),
    );
    },
    );
  }

  Widget _buildMemorizationCard({
    String? title,
    int? memorizedCount,
    int? totalCount,
    double? percentage,
    required Color textColor,
    required bool isDarkMode,
    required Color cardColor,
  }) {
    return Container(
      padding: EdgeInsets.all(16.0.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.r),
        color: cardColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (title != null)
            Obx(() => CustomText(
              title: title,
              fontSize: 14.sp,
              textColor: appThemeSwitchController.isDarkMode.value ? AppColors.white : AppColors.black,
              fontWeight: FontWeight.w500,
            )),
          AppSizedBox.space10h,
          if (memorizedCount != null && totalCount != null)
            CustomText(
              title: "$memorizedCount/$totalCount",
              fontSize: 20.sp,
              textColor: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          if (percentage != null)
            CustomText(
              title: "${(percentage * 100).toStringAsFixed(1)}%",
              fontSize: 20.sp,
              textColor: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          AppSizedBox.space10h,
          if (percentage != null)
            CircularProgressIndicator(
              value: percentage,
              backgroundColor: Colors.grey.withOpacity(0.3),
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
          if (memorizedCount != null && totalCount != null)
            CircularProgressIndicator(
              value: totalCount > 0 ? memorizedCount / totalCount : 0,
              backgroundColor: Colors.grey.withOpacity(0.3),
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
        ],
      ),
    );
  }
}