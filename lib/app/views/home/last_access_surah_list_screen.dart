import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:noor_e_quran/app/config/app_colors.dart';
import 'package:noor_e_quran/app/controllers/app_home_screen_controller.dart';
import 'package:noor_e_quran/app/controllers/app_theme_switch_controller.dart';
import 'package:noor_e_quran/app/views/quran/quran_surah_detail_screen.dart';
import 'package:noor_e_quran/app/widgets/custom_text.dart';
import 'package:quran/quran.dart' as quran;

import '../../config/app_sizedbox.dart';
import '../../controllers/last_access_surah_list_controller.dart';
import '../../widgets/custom_card.dart';

class LastAccessListScreen extends StatelessWidget {
  final LastAccessSurahListController lastAccessSurahListController = Get.put(LastAccessSurahListController());

  LastAccessListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AppThemeSwitchController themeController = Get.find<AppThemeSwitchController>();
    bool isDarkMode = themeController.isDarkMode.value;
    return Scaffold(
      backgroundColor: isDarkMode ? AppColors.black : AppColors.white,
      appBar: AppBar(
        backgroundColor: isDarkMode ? AppColors.black : AppColors.white,
        surfaceTintColor: AppColors.transparent,
        centerTitle: false,
        title: CustomText(
          firstText: "Recent ",
          secondText: "Accessed",
          firstTextColor: isDarkMode ? AppColors.white : AppColors.black,
          secondTextColor: AppColors.primary,
          fontSize: 18.sp,
        ),
        leading: InkWell(
          onTap: () => Get.back(),
          child: Icon(Icons.west, color: isDarkMode ? AppColors.white : AppColors.black),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(left:10.w,right:10.w),
        child: Column(
          children: [
            CustomCard(
              title: "Recently Accessed Surahs",
              subtitle: "Surahs You've Recently Opened",
              imageUrl: isDarkMode
                  ? "assets/images/quran_bg_dark.jpg"
                  : "assets/images/quran_bg_light.jpg",
              titleFontSize: 18.sp,
              subtitleFontSize: 12.sp,
              mergeWithGradientImage: true,
              useLinearGradient: true,
              gradientColors: [
                AppColors.black.withOpacity(0.6),
                AppColors.transparent,
                AppColors.black.withOpacity(0.6),
              ],
            ),
            AppSizedBox.space10h,
            Expanded(
              child: Obx(() {
                if (lastAccessSurahListController.lastAccessedSurahs.isEmpty) {
                  return const Center(child: Text('No recent activity.'));
                }
                final sortedSurahs = List<Map<String, dynamic>>.from(lastAccessSurahListController.lastAccessedSurahs)
                  ..sort((a, b) => lastAccessSurahListController.parseAccessTime(b['accessTime']).compareTo(lastAccessSurahListController.parseAccessTime(a['accessTime'])));

                return ListView.builder(
                  itemCount: sortedSurahs.length,
                  itemBuilder: (context, index) {
                    final surahData = sortedSurahs[index];
                    final surahNumber = surahData['surahNumber'] as int;
                    final accessTime = lastAccessSurahListController.parseAccessTime(surahData['accessTime'] as String);
                    final formattedTime = DateFormat('yyyy-MM-dd HH:mm').format(accessTime);
                    final placeOfRevelation = quran.getPlaceOfRevelation(surahNumber);

                    return Container(
                      margin: EdgeInsets.only(bottom: 5, top: 5.h),
                      padding: EdgeInsets.all(12.h),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.r),
                        color: (index % 2 == 1)
                            ? AppColors.primary.withOpacity(0.1)
                            : AppColors.primary.withOpacity(0.29),
                      ),
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        // leading: CustomText(
                        //   title: '${index + 1}',
                        //   fontSize: 15.sp,
                        //   textColor: isDarkMode ? AppColors.white : AppColors.black,
                        //   fontWeight: FontWeight.w500,
                        //   textOverflow: TextOverflow.ellipsis,
                        //   maxLines: 1,
                        //   textAlign: TextAlign.start,
                        // ),
                        title: CustomText(
                          title: lastAccessSurahListController.getSurahName(surahNumber),
                          fontSize: 16.sp,
                          textColor: isDarkMode ? AppColors.white : AppColors.black,
                          fontWeight: FontWeight.w500,
                          textOverflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          textAlign: TextAlign.start,
                        ),
                        trailing: CustomText(
                          title: lastAccessSurahListController.getSurahNameArabic(surahNumber),
                          fontSize: 22.sp,
                          textColor: AppColors.primary,
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              title: '${placeOfRevelation == 'Makkiyah' ? 'Makkah' : 'Madinah'} | ${quran.getVerseCount(surahNumber)} Ayahs',
                              fontSize: 14.sp,
                              textColor: AppColors.primary,
                              textAlign: TextAlign.start,
                              textOverflow: TextOverflow.ellipsis,
                              fontWeight: FontWeight.w500,
                              maxLines: 1,
                            ),
                            CustomText(
                              title: 'Last Accessed: $formattedTime',
                              fontSize: 10.sp,
                              textAlign: TextAlign.start,
                              textColor: isDarkMode ? AppColors.white : AppColors.black,
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
              }),
            ),
          ],
        ),
      ),
    );
  }
}
