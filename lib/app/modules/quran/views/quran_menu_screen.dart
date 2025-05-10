
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:noor_e_quran/app/config/app_sizedbox.dart';
import 'package:noor_e_quran/app/modules/quran/views/quran_digital_screen.dart';
import 'package:noor_e_quran/app/modules/quran/views/quran_sajjdas_list_screen.dart';
import 'package:noor_e_quran/app/modules/quran/views/quran_saved_ayat_bookmark_screen.dart';
import 'package:noor_e_quran/app/modules/quran/views/quran_write_note_screen.dart';
import 'package:noor_e_quran/app/widgets/pdf_viewer.dart';
import '../../../config/app_colors.dart';
import '../../../controllers/app_theme_switch_controller.dart';
import '../../../models/grid_item_models.dart';
import '../../../widgets/custom_card.dart';
import '../../../widgets/custom_frame.dart';
import '../../../widgets/custom_text.dart';
import 'navigte_explore_surahs_screen.dart';

class QuranMenuScreen extends StatelessWidget {
  const QuranMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AppThemeSwitchController themeController = Get.put(AppThemeSwitchController());
    bool isDarkMode = themeController.isDarkMode.value;
    final textColor = isDarkMode ? AppColors.white : AppColors.black;

    final List<GridItem> gridItems = [
      GridItem(
        title: "Navigate",
        subtitle: "Explore Surahs",
        destination: NavigteExploreSurahsScreen(),
      ),
      GridItem(
        title: "Quran",
        subtitle: "Digital",
        destination: QuranDigitalScreen(),
      ),
      GridItem(
        title: "Sajdaas",
        subtitle: "Verses In Quran",
        destination: QuranSajdahListScreen(),
      ),
      GridItem(
        title: "Notes",
        subtitle: "Write & Reflect",
        destination: QuranNotesScreen(),
      ),
      GridItem(
        title: "Tajweed",
        subtitle: "Guide",
        destination: PdfViewer(
          assetPath: "assets/pdf/basic_tajweed.pdf",
          firstTitle: "Tajweed",
          secondTitle: " Guide",
        ),
      ),
      GridItem(
        title: "Bookmark",
        subtitle: "Resume Reading",
        destination: QuranSavedAyatBookmarkScreen(),
      ),
    ];

    return Scaffold(
      backgroundColor: isDarkMode ? AppColors.black : AppColors.white,
      appBar: AppBar(
        surfaceTintColor: AppColors.transparent,
        foregroundColor: AppColors.transparent,
        centerTitle: false,
        title: CustomText(
          firstText: "Quran",
          secondText: " Collections",
          firstTextColor: isDarkMode ? AppColors.white : AppColors.black,
          secondTextColor: AppColors.primary,
          fontSize: 18.sp,
        ),
        leading: IconButton(
          icon: Icon(
            Icons.west,
            color: themeController.isDarkMode.value
                ? AppColors.white
                : AppColors.black,
          ),
          onPressed: () {
            Get.back();
          },
        ),
        backgroundColor: isDarkMode ? AppColors.black : AppColors.white,
      ),
      body: Padding(
        padding: EdgeInsets.only(left: 10.w, right: 10.w),
        child: Column(
          children: [
            CustomCard(
              title: "The Holy Quran",
              subtitle: "Guidance for Humanity",
              imageUrl: isDarkMode ? "assets/images/quran_bg_dark.jpg" : "assets/images/quran_bg_light.jpg",
              titleFontSize: 18.sp,
              subtitleFontSize: 12.sp,
              mergeWithGradientImage: true,
              useLinearGradient: true,
              gradientColors: [
                AppColors.black.withOpacity(0.4),
                AppColors.transparent,
                AppColors.black.withOpacity(0.4),
              ],
            ),
            AppSizedBox.space10h,
            Expanded(
              child: GridView.builder(
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2,
                  childAspectRatio: 1,
                ),
                itemCount: gridItems.length,
                itemBuilder: (context, index) {
                  final item = gridItems[index];
                  return InkWell(
                    splashColor: AppColors.transparent,
                    highlightColor: AppColors.transparent,
                    hoverColor: AppColors.transparent,
                    onTap: () {
                      Get.to(() => item.destination);
                    },
                    child: GridTile(
                      child: Container(
                        margin: EdgeInsets.all(5.h),
                        decoration: BoxDecoration(
                          color: isDarkMode ? AppColors.black : AppColors.white,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withOpacity(0.2),
                              blurRadius: 6,
                            ),
                          ],
                        ),
                        child: LayoutBuilder( // Wrap with LayoutBuilder
                          builder: (context, constraints) {
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CustomFrame(
                                  leftImageAsset: "assets/frames/topLeftFrame.png",
                                  rightImageAsset: "assets/frames/topRightFrame.png",
                                  imageHeight: 30.h,
                                  imageWidth: 30.w,
                                ),
                                Column(
                                  children: [
                                    CustomText(
                                      title: item.title,
                                      fontSize: 18.sp,
                                      textColor: textColor,
                                      fontWeight: FontWeight.normal,
                                      textOverflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.center,
                                      capitalize: true,
                                      maxLines: 2,
                                      fontFamily: 'grenda',
                                    ),
                                    AppSizedBox.space5h,
                                    CustomText(
                                      title: item.subtitle,
                                      fontSize: 12.sp,
                                      textColor: AppColors.primary,
                                      fontWeight: FontWeight.w500,
                                      textAlign: TextAlign.center,
                                      textOverflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                    ),
                                  ],
                                ),
                                CustomFrame(
                                  leftImageAsset: "assets/frames/bottomLeftFrame.png",
                                  rightImageAsset: "assets/frames/bottomRightFrame.png",
                                  imageHeight: 30.h,
                                  imageWidth: 30.w,
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
            ),
          ],
        ),
      ),
    );
  }
}
