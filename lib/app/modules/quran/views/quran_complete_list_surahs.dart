
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icons.dart';
import 'package:noor_e_quran/app/config/app_sizedbox.dart';
import 'package:noor_e_quran/app/modules/quran/views/quran_favrouite_surah_tab.dart';
import 'package:noor_e_quran/app/modules/quran/views/quran_juz_tab.dart';
import 'package:noor_e_quran/app/modules/quran/views/quran_surah_tab.dart';
import 'package:get/get.dart';
import '../../../config/app_colors.dart';
import '../../../controllers/app_theme_switch_controller.dart';
import '../../../widgets/custom_card.dart';
import '../../../widgets/custom_text.dart';
import '../controllers/navigate_explore_surah_controller.dart';

class QuranCompleteListSurahs extends StatelessWidget {
  final NavigteExploreSurahsController navigteExploreSurahsController = Get.put(NavigteExploreSurahsController());
  final AppThemeSwitchController themeController = Get.find();

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = themeController.isDarkMode.value;
    final iconColor = isDarkMode ? AppColors.white : AppColors.black;
    final textColor = isDarkMode ? AppColors.white : AppColors.black;

    return Scaffold(
      backgroundColor: themeController.isDarkMode.value ? AppColors.black : AppColors.white,
      appBar: AppBar(
        backgroundColor: themeController.isDarkMode.value ? AppColors.black : AppColors.white,
        surfaceTintColor: AppColors.transparent,
        foregroundColor: Colors.transparent,
        title: CustomText(
          firstText: "Divine ",
          secondText: "Revelation",
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
            color: iconColor,
          ),
        ),
        actions: [
          IconButton(
            splashColor: AppColors.transparent,
            highlightColor: AppColors.transparent,
            hoverColor: AppColors.transparent,
            icon: Icon(
              LineIcons.infoCircle,
              color: iconColor,
              size: 20.h,
            ),
            onPressed: () {
              navigteExploreSurahsController.showQuranInfoSheet(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.only(left: 10.w, right: 10.w),
        child: Column(
          children: [
            CustomCard(
              title: "The Holy Quran ",
              subtitle: "Discover the Surahs and Verses",
              imageUrl: isDarkMode ? "assets/images/quran_bg_dark.jpg" : "assets/images/quran_bg_light.jpg",
              mergeWithGradientImage: true,
              titleFontSize: 18.sp,
              subtitleFontSize: 12.sp,

            ),
            AppSizedBox.space10h,
            TabBar(
              dividerColor: Colors.transparent,
              indicatorSize: TabBarIndicatorSize.tab,
              indicatorColor: AppColors.primary,
              labelColor: isDarkMode ? AppColors.white : AppColors.black,
              unselectedLabelColor: textColor,
              labelStyle: GoogleFonts.quicksand(fontSize: 14.sp),
              indicator: BoxDecoration(
                border: Border.all(color: AppColors.primary, width: 1),
                borderRadius: BorderRadius.circular(50.r),
              ),
              controller: navigteExploreSurahsController.tabController,
              tabs: const[
                Tab(text: 'Surahs'),
                Tab(text: 'Juz'),
                Tab(text: 'Favrouites'),
              ],
            ),
            AppSizedBox.space10h,
            Expanded(
              child: TabBarView(
                controller: navigteExploreSurahsController.tabController,
                children: [
                  QuranSurahTab(),
                  QuranJuzTab(),
                  QuranFavrouiteSurahTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
