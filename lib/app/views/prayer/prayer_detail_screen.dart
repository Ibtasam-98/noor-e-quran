import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:noor_e_quran/app/views/prayer/prayer_tracker_screen.dart';
import 'package:noor_e_quran/app/views/prayer/specific_prayer_detail_screen.dart';

import '../../config/app_colors.dart';
import '../../config/app_sizedbox.dart';
import '../../config/prayer_enum.dart';
import '../../controllers/app_theme_switch_controller.dart';
import '../../widgets/custom_card.dart';
import '../../widgets/custom_text.dart';
import '../../widgets/pdf_viewer.dart';


class PrayerDetails extends StatelessWidget {
  final PrayerType prayerType;

  PrayerDetails(this.prayerType);

  @override
  Widget build(BuildContext context) {
    List<String> prayers = [];
    String title = '';
    Map<String, dynamic> subPrayers = {};

    switch (prayerType) {
      case PrayerType.obligatory:
        title = 'Obligatory Prayers';
        prayers = ['Fajr', 'Zuhr', 'Asr', 'Maghrib', 'Isha'];
        break;
      case PrayerType.sunnah:
        title = 'Sunnah Prayers';
        subPrayers = {
          'Tahajjud': 'Tahajjud',
          'Sunnah Muakkadah': 'Sunnah Muakkadah',
          'Sunnah Ghair Muakkadah': 'Sunnah Ghair Muakkadah',
          'Salat ul Tauba': 'Salat ul Tauba',
        };
        prayers = subPrayers.keys.toList();
        break;
      case PrayerType.eid:
        title = 'Eid Prayers';
        subPrayers = {
          'Eid ul Fitr': 'Eid ul Fitr',
          'Eid ul Adha': 'Eid ul Adha',
        };
        prayers = subPrayers.keys.toList();
        break;
      case PrayerType.friday:
        title = 'Friday Prayer';
        prayers = ['Friday'];
        break;
      case PrayerType.taraweeh:
        title = 'Taraweeh';
        prayers = ['Taraweeh'];
        break;
      case PrayerType.funeral:
        title = 'Funeral Prayer';
        prayers = ['Funeral'];
        break;
      case PrayerType.hajat:
        title = 'Salatul Hajat';
        prayers = ['Hajat'];
        break;
      case PrayerType.istikhara:
        title = 'Salatul Istikhara';
        prayers = ['Istikhara'];
        break;
      case PrayerType.tracker:
        title = 'Prayer Tracker';
        prayers = ['Tracker Details'];
        break;
      case PrayerType.guide:
        title = 'Prayer Guide';
        prayers = ['Guide Details'];
        break;
    }

    final AppThemeSwitchController themeController =
    Get.put(AppThemeSwitchController());
    bool isDarkMode = themeController.isDarkMode.value;
    final textColor = isDarkMode ? AppColors.white : AppColors.black;
    final iconColor = isDarkMode ? AppColors.white : AppColors.black;

    return Scaffold(
      backgroundColor: isDarkMode ? AppColors.black : AppColors.white,
      appBar: AppBar(
        surfaceTintColor: AppColors.transparent,
        foregroundColor: AppColors.transparent,
        centerTitle: false,
        title: CustomText(
          firstText: title,
          secondText: "",
          firstTextColor: isDarkMode ? AppColors.white : AppColors.black,
          secondTextColor: AppColors.primary,
          fontSize: 18.sp,
        ),
        backgroundColor: isDarkMode ? AppColors.black : AppColors.white,
        leading: IconButton(
          icon: Icon(
            Icons.west,
            color: iconColor,
          ),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(left: 10.w, right: 10.w),
        child: Column(
          children: [
            CustomCard(
              title: "Powerful Supplications",
              subtitle: "Inspiring Islamic Invocations",
              imageUrl: isDarkMode
                  ? 'assets/images/sajdah_bg_dark.jpg'
                  : 'assets/images/sajdah_dark_light.jpg',
              titleFontSize: 18.sp,
              subtitleFontSize: 12.sp,
              mergeWithGradientImage: true,
            ),
            AppSizedBox.space10h,
            Expanded(
              child: ListView.builder(
                itemCount: prayers.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.only(bottom: 5, top: 5.h),
                    padding: EdgeInsets.all(10.h),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.r),
                      color: (index % 2 == 1)
                          ? AppColors.primary.withOpacity(0.29)
                          : AppColors.primary.withOpacity(0.1),
                    ),
                    child: ListTile(
                      leading: CustomText(
                        title: (index + 1).toString(),
                        fontSize: 15.sp,
                        textColor: textColor,
                        fontWeight: FontWeight.w500,
                        textOverflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        textAlign: TextAlign.start,
                      ),
                      title: CustomText(
                        title: prayers[index],
                        fontSize: 15.sp,
                        textColor: textColor,
                        fontWeight: FontWeight.w500,
                        textOverflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        textAlign: TextAlign.start,
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        size: 12.h,
                        color: isDarkMode ? AppColors.white : AppColors.black,
                      ),
                      onTap: () {
                        print('Navigating to SpecificPrayerDetails:');
                        print('  prayerType: ${prayerType}');
                        print('  prayerName: ${prayers[index]}'); // Add this line

                        if (prayerType == PrayerType.tracker) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PrayerTrackerScreen(), // Replace with tracker details screen
                            ),
                          );
                        } else if(prayerType == PrayerType.guide){
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PdfViewer(
                                  assetPath: "assets/pdf/PrayerGuide.pdf",
                                  firstTitle: "Prayer",
                                  secondTitle: " Guide",
                                )
                            ),
                          );
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SpecificPrayerDetails(
                                  prayerType,
                                  subPrayers.containsKey(prayers[index])
                                      ? subPrayers[prayers[index]]
                                      : prayers[index]),
                            ),
                          );
                        }

                      },
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
