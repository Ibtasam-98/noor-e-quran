import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:noor_e_quran/app/modules/prayer/views/prayer_detail_screen.dart';
import 'package:noor_e_quran/app/modules/prayer/views/prayer_tracker_screen.dart';
import 'package:noor_e_quran/app/modules/prayer/views/specific_prayer_detail_screen.dart';
import 'package:noor_e_quran/app/widgets/pdf_viewer.dart';
import '../../../config/app_colors.dart';
import '../../../config/app_sizedbox.dart';
import '../../../config/prayer_enum.dart';
import '../../../controllers/app_theme_switch_controller.dart';
import '../../../models/prayer_category_model.dart';
import '../../../widgets/custom_card.dart';
import '../../../widgets/custom_frame.dart';
import '../../../widgets/custom_text.dart';
import 'package:flutter/services.dart';


class PrayerMainScreen extends StatelessWidget {
  final List<PrayerCategory> prayerCategories = [
    PrayerCategory(
        title: 'Prayer Tracker',
        subtitle: 'Track your prayers',
        type: PrayerType.tracker),
    PrayerCategory(
        title: 'Prayer Guide',
        subtitle: 'How to Pray',
        type: PrayerType.guide),
    PrayerCategory(
        title: 'Obligatory Prayers',
        subtitle: 'Farz Prayers',
        type: PrayerType.obligatory),
    PrayerCategory(
        title: 'Sunnah Prayers',
        subtitle: 'Nafil Prayers',
        type: PrayerType.sunnah),
    PrayerCategory(
        title: 'Eid Prayers',
        subtitle: 'Eid ul Fitr & Adha',
        type: PrayerType.eid),
    PrayerCategory(
        title: 'Friday Prayer',
        subtitle: 'Jumu\'ah Prayer',
        type: PrayerType.friday),
    PrayerCategory(
        title: 'Taraweeh',
        subtitle: 'Ramadan Night Prayers',
        type: PrayerType.taraweeh),
    PrayerCategory(
        title: 'Funeral Prayer',
        subtitle: 'Salat al-Janazah',
        type: PrayerType.funeral),
    PrayerCategory(
        title: 'Salatul Hajat',
        subtitle: 'Prayer for Needs',
        type: PrayerType.hajat),
    PrayerCategory(
        title: 'Salatul Istikhara',
        subtitle: 'Prayer for Guidance',
        type: PrayerType.istikhara),
  ];

  @override
  Widget build(BuildContext context) {
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
          firstText: "Prayer",
          secondText: " Collection",
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
              title: "Prayer Collection",
              subtitle: "Browse different types of prayers",
              imageUrl: isDarkMode
                  ? "assets/images/quran_bg_dark.jpg"
                  : "assets/images/quran_bg_light.jpg",
              titleFontSize: 18.sp,
              subtitleFontSize: 12.sp,
              mergeWithGradientImage: true,

            ),
            AppSizedBox.space15h,
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2,
                  childAspectRatio: 1,
                  crossAxisSpacing: 10,
                ),
                itemCount: prayerCategories.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      if (prayerCategories[index].type == PrayerType.tracker) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PrayerTrackerScreen(),
                          ),
                        );
                      } else if (prayerCategories[index].type == PrayerType.guide) {
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
                      } else if (prayerCategories[index].type == PrayerType.friday ||
                          prayerCategories[index].type == PrayerType.taraweeh ||
                          prayerCategories[index].type == PrayerType.funeral ||
                          prayerCategories[index].type == PrayerType.hajat ||
                          prayerCategories[index].type == PrayerType.istikhara) {
                        String prayerName;
                        switch (prayerCategories[index].type) {
                          case PrayerType.friday:
                            prayerName = 'Friday';
                            break;
                          case PrayerType.taraweeh:
                            prayerName = 'Taraweeh';
                            break;
                          case PrayerType.funeral:
                            prayerName = 'Funeral';
                            break;
                          case PrayerType.hajat:
                            prayerName = 'Hajat';
                            break;
                          case PrayerType.istikhara:
                            prayerName = 'Istikhara';
                            break;
                          default:
                            prayerName = '';
                        }
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SpecificPrayerDetails(
                              prayerCategories[index].type,
                              prayerName,
                            ),
                          ),
                        );
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PrayerDetails(prayerCategories[index].type),
                          ),
                        );
                      }
                    },
                    child: Container(
                      margin: EdgeInsets.only(bottom: 10.h),
                      decoration: BoxDecoration(
                        color: themeController.isDarkMode.value
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
                        child: LayoutBuilder( // Wrap with LayoutBuilder
                          builder: (context, constraints) {
                            return Stack(
                              alignment: Alignment.center,
                              children: [
                                Positioned(
                                  top: 0,
                                  left: 0,
                                  right: 0,
                                  child: CustomFrame(
                                    leftImageAsset: "assets/frames/topLeftFrame.png",
                                    rightImageAsset: "assets/frames/topRightFrame.png",
                                    imageHeight: 30.h,
                                    imageWidth: 30.w,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 10.h), // Reduced vertical padding
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      CustomText(
                                        title: prayerCategories[index].title,
                                        fontSize: constraints.maxWidth * 0.1, // Responsive font size
                                        textColor: textColor,
                                        fontWeight: FontWeight.normal,
                                        textOverflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                        maxLines: 2,
                                        fontFamily: 'grenda',
                                      ),
                                      CustomText(
                                        title: prayerCategories[index].subtitle,
                                        fontSize: constraints.maxWidth * 0.08, // Responsive font size
                                        textColor: AppColors.primary,
                                        fontWeight: FontWeight.w500,
                                        textAlign: TextAlign.center,
                                        textOverflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                      ),
                                    ],
                                  ),
                                ),
                                Positioned(
                                  bottom: 0,
                                  left: 0,
                                  right: 0,
                                  child: CustomFrame(
                                    leftImageAsset: "assets/frames/bottomLeftFrame.png",
                                    rightImageAsset: "assets/frames/bottomRightFrame.png",
                                    imageHeight: 30.h,
                                    imageWidth: 30.w,
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
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

