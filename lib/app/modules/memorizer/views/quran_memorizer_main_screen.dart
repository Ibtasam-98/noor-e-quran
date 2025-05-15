import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
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
import '../controllers/quran_memorizer_main_screen_controller.dart';

class QuranMemorizerMainScreen extends StatelessWidget {
  final Map<String, dynamic>? userData;

  const QuranMemorizerMainScreen({super.key, this.userData});

  @override
  Widget build(BuildContext context) {
    final QuranMemorizerController controller = Get.put(QuranMemorizerController());
    final FlyingBirdAnimationController birdController = Get.find<FlyingBirdAnimationController>();
    final AppHomeScreenController appHomeScreenController = Get.find<AppHomeScreenController>();
    final AppThemeSwitchController themeController = Get.find<AppThemeSwitchController>();

    return AppHomeBaseScreen(
      titleFirstPart: "Noor e",
      titleSecondPart: " Quran",
      birdController: birdController,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            HomeScreenHeader(birdController: birdController),
            _buildHeaderRow(appHomeScreenController, themeController),
            AppSizedBox.space10h,
            _buildTabBar(controller, themeController),
            AppSizedBox.space10h,
            _buildTabView(context, controller, themeController),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderRow(AppHomeScreenController appHomeScreenController, AppThemeSwitchController themeController) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Obx(() => CustomText(
          title: "Holy Quran Memorize",
          textColor: appHomeScreenController.themeController.isDarkMode.value
              ? AppColors.white
              : AppColors.black,
          fontSize: 14.sp,
          fontFamily: 'grenda',
          textAlign: TextAlign.start,
          maxLines: 1,
        )),
        Expanded(
          child: InkWell(
            onTap: () => Get.to(() => MemorizationProgressScreen()),
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
    );
  }

  Widget _buildTabBar(QuranMemorizerController controller, AppThemeSwitchController themeController) {
    return Obx(() => TabBar(
      controller: controller.tabController,
      dividerColor: Colors.transparent,
      indicatorSize: TabBarIndicatorSize.tab,
      indicatorColor: AppColors.primary,
      labelColor: AppColors.primary,
      unselectedLabelColor: themeController.isDarkMode.value
          ? AppColors.white.withOpacity(0.7)
          : AppColors.black.withOpacity(0.7),
      labelStyle: GoogleFonts.quicksand(fontSize: 14.sp),
      indicator: BoxDecoration(
        border: Border.all(color: AppColors.primary, width: 1),
        borderRadius: BorderRadius.circular(50.r),
      ),
      onTap: (index) => controller.currentTabIndex.value = index,
      tabs: const [
        Tab(text: 'Surahs'),
        Tab(text: 'Juz'),
        Tab(text: 'Completed'),
      ],
    ));
  }

  Widget _buildTabView(BuildContext context, QuranMemorizerController controller, AppThemeSwitchController themeController) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.55,
      child: TabBarView(
        controller: controller.tabController,
        children: [
          _buildAllSurahsList(controller, themeController),
          _buildAllJuzList(controller, themeController),
          _buildCompletedSurahsList(controller, themeController),
        ],
      ),
    );
  }

  Widget _buildAllSurahsList(QuranMemorizerController controller, AppThemeSwitchController themeController) {
    final incompleteSurahs = controller.getIncompleteSurahs();

    return ListView.builder(
      shrinkWrap: true,
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: incompleteSurahs.length,
      itemBuilder: (context, index) {
        final surahNumber = incompleteSurahs[index];
        final memorizedPercentage = controller.getMemorizationPercentage(surahNumber);
        final memorizedCount = controller.getMemorizedVersesCount(surahNumber);
        final totalVerses = quran.getVerseCount(surahNumber);
        final lastAccessedTime = controller.getLastAccessedTime(surahNumber);
        final lastAccessedSurahNumber = controller.getLastAccessedSurahNumber();

        return _buildSurahItem(
          controller: controller,
          themeController: themeController,
          surahNumber: surahNumber,
          memorizedPercentage: memorizedPercentage,
          memorizedCount: memorizedCount,
          totalVerses: totalVerses,
          lastAccessedTime: lastAccessedTime,
          lastAccessedSurahNumber: lastAccessedSurahNumber,
          isCompleted: false, // Always false in this list
        );
      },
    );
  }
  }

  Widget _buildCompletedSurahsList(QuranMemorizerController controller, AppThemeSwitchController themeController) {
    final completedSurahs = controller.getCompletedSurahs();

    if (completedSurahs.isEmpty) {
      return Center(
        child: CustomText(
          title: "No completed Surahs yet",
          textColor: themeController.isDarkMode.value ? AppColors.white : AppColors.black,
          fontSize: 16.sp,
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: completedSurahs.length,
      itemBuilder: (context, index) {
        final surahNumber = completedSurahs[index];
        final memorizedCount = controller.getMemorizedVersesCount(surahNumber);
        final totalVerses = quran.getVerseCount(surahNumber);
        final lastAccessedTime = controller.getLastAccessedTime(surahNumber);
        final lastAccessedSurahNumber = controller.getLastAccessedSurahNumber();

        return _buildSurahItem(
          controller: controller,
          themeController: themeController,
          surahNumber: surahNumber,
          memorizedPercentage: 1.0,
          memorizedCount: memorizedCount,
          totalVerses: totalVerses,
          lastAccessedTime: lastAccessedTime,
          lastAccessedSurahNumber: lastAccessedSurahNumber,
          isCompleted: true,
        );
      },
    );
  }

  Widget _buildSurahItem({
    required QuranMemorizerController controller,
    required AppThemeSwitchController themeController,
    required int surahNumber,
    required double memorizedPercentage,
    required int memorizedCount,
    required int totalVerses,
    required String? lastAccessedTime,
    required int? lastAccessedSurahNumber,
    required bool isCompleted,
  }) {
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
          color: isCompleted
              ? AppColors.primary.withOpacity(0.1)
              : (surahNumber % 2 == 1)
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
                      valueColor: AlwaysStoppedAnimation<Color>(
                        isCompleted ? Colors.green : Colors.orange,
                      ),
                    ),
                  ),
                  Positioned(
                    child: Obx(() => CustomText(
                      title: "$memorizedCount/$totalVerses",
                      fontSize: 8.sp,
                      textColor: themeController.isDarkMode.value
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
                      textColor: themeController.isDarkMode.value
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
                        textColor: themeController.isDarkMode.value
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
              Obx(() => CustomText(
                title: quran.getSurahNameArabic(surahNumber),
                fontSize: 25.sp,
                textColor: themeController.isDarkMode.value
                    ? AppColors.primary
                    : AppColors.primary,
              )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAllJuzList(QuranMemorizerController controller, AppThemeSwitchController themeController) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      itemCount: 30,
      itemBuilder: (context, index) {
        final juzNumber = index + 1;
        final memorizedPercentage = controller.getJuzMemorizationPercentage(juzNumber);
        final memorizedCount = controller.getJuzMemorizedCount(juzNumber);
        final totalVerses = controller.getJuzTotalVerses(juzNumber);
        final lastAccessedTime = controller.getJuzLastAccessedTime(juzNumber);
        final surahsInJuz = controller.getJuzSurahsText(juzNumber);

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
                      value: memorizedPercentage,
                      backgroundColor: AppColors.grey.withOpacity(0.2),
                      valueColor: const AlwaysStoppedAnimation<Color>(Colors.orange),
                    ),
                    Positioned(
                      child: Obx(() => CustomText(
                        title: "$memorizedCount/$totalVerses",
                        fontSize: 8.sp,
                        textColor: themeController.isDarkMode.value
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
                        textColor: themeController.isDarkMode.value
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
                          textColor: themeController.isDarkMode.value
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
                  color: themeController.isDarkMode.value
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