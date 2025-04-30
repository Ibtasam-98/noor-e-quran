import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:noor_e_quran/app/config/app_colors.dart';
import 'package:noor_e_quran/app/config/app_sizedbox.dart';
import 'package:noor_e_quran/app/controllers/app_theme_switch_controller.dart';
import 'package:noor_e_quran/app/modules/home/views/app_home_base_screen.dart';
import 'package:noor_e_quran/app/modules/quran/views/quran_surah_detail_screen.dart';
import 'package:noor_e_quran/app/widgets/custom_card.dart';
import 'package:noor_e_quran/app/widgets/custom_text.dart';
import 'package:quran/quran.dart' as quran;
import '../../../data/models/additional_feature_model.dart';
import '../../../widgets/custom_frame.dart';
import 'package:noor_e_quran/app/controllers/flying_bird_animation_controller.dart';
import 'package:noor_e_quran/app/controllers/user_location_premission_controller.dart';
import '../../home/controllers/app_home_screen_controller.dart';
import '../../home/views/app_home_screen_header.dart';
import '../controllers/additional_feature_controller.dart';

class AdditionalFeatureScreen extends StatelessWidget {
  final Map<String, dynamic>? userData;
  final FlyingBirdAnimationController _additionalBirdController =
  Get.put(FlyingBirdAnimationController(), tag: 'additional_bird');
  final UserPermissionController locationPermissionScreenController = Get.find<UserPermissionController>();
  final AppHomeScreenController homeScreenController = Get.find<AppHomeScreenController>();
  final AppThemeSwitchController themeController = Get.find<AppThemeSwitchController>();
  final AdditionalFeatureController additionalFeatureController = Get.put(AdditionalFeatureController()); // Initialize the new controller

  AdditionalFeatureScreen({super.key, this.userData});

  @override
  Widget build(BuildContext context) {
    return AppHomeBaseScreen(
      titleFirstPart: "Noor e",
      titleSecondPart: " Quran",
      birdController: _additionalBirdController,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HomeScreenHeader(birdController: _additionalBirdController),
          Obx(() => CustomText(
            title: "Surah of the hour",
            textColor: themeController.isDarkMode.value ? AppColors.white : AppColors.black,
            fontSize: 16.sp,
            fontFamily: 'grenda',
            maxLines: 1,
            textAlign: TextAlign.start,
            textOverflow: TextOverflow.ellipsis,
          )),
          AppSizedBox.space15h,
          Stack(
        children: [
          InkWell(
            splashColor: AppColors.transparent,
            highlightColor: AppColors.transparent,
            onTap: () {
              Get.to(QuranSurahDetailScreen(
                  surahNumber: additionalFeatureController.currentSurahNumberValue
              ));
            },
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(themeController.isDarkMode.value
                      ? "assets/images/quran_bg_dark.jpg"
                      : "assets/images/quran_bg_light.jpg"),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(15.r),
                boxShadow: [
                  BoxShadow(
                    color: themeController.isDarkMode.value
                        ? AppColors.primary.withOpacity(0.3)
                        : AppColors.transparent,
                    blurRadius: 5,
                  ),
                ],
              ),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.black.withOpacity(0.5),
                      AppColors.transparent,
                      AppColors.black.withOpacity(0.5),
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(15.r),
                ),
                child: Padding(
                  padding: EdgeInsets.all(10.h),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Obx(() => CustomText(
                        title: additionalFeatureController.currentSurahNameArabic,
                        textAlign: TextAlign.end,
                        textColor: AppColors.white,
                        fontSize: 20.sp,
                        maxLines: 1,
                      )),
                      AppSizedBox.space5h,
                      Obx(() => Align(
                        alignment: Alignment.centerLeft,
                        child: CustomText(
                          title: additionalFeatureController.currentSurahName,
                          fontSize: 14.sp,
                          textColor: AppColors.white,
                          maxLines: 2,
                          fontWeight: FontWeight.w500,
                          textAlign: TextAlign.start,
                        ),
                      )),
                      AppSizedBox.space5h,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Obx(() => CustomText(
                              title:
                              "Surah No. ${additionalFeatureController.currentSurahNumberValue} | Total Verse. ${additionalFeatureController.currentSurahVerseCount}",
                              fontSize: 13.sp,
                              textColor: AppColors.white,
                              maxLines: 2,
                              textAlign: TextAlign.start,
                              fontWeight: FontWeight.bold,
                              textStyle: const TextStyle(fontStyle: FontStyle.italic),
                            )),
                          ),
                          Icon(Icons.remove_red_eye, color: AppColors.white, size: 15.h),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
          AppSizedBox.space15h,
          Obx(()=>CustomText(
            title: "Divine Wisdom",
            textColor: themeController.isDarkMode.value ? AppColors.white : AppColors.black,
            fontSize: 18.sp,
            fontFamily: 'grenda',
            maxLines: 1,
            textAlign: TextAlign.start,
            textOverflow: TextOverflow.ellipsis,
          ),),
          AppSizedBox.space15h,
          Column(
            children: [
              SingleChildScrollView(
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2,
                    childAspectRatio: 1,
                  ),
                  itemCount: additionalCategoryMenu.length,
                  itemBuilder: (context, index) {
                    final item = additionalCategoryMenu[index];

                    return Obx(()=>InkWell(
                      splashColor: AppColors.transparent,
                      highlightColor: AppColors.transparent,
                      hoverColor: AppColors.transparent,
                      onTap: () {
                        if (item.destination != null) {
                          Get.to(() => item.destination!);
                        } else {
                          Get.snackbar("Destination Not Available", "This feature is not yet implemented.");
                        }
                      },
                      child: GridTile(
                        child: Container(
                          margin: EdgeInsets.all(5.h),
                          decoration: BoxDecoration(
                            color: themeController.isDarkMode.value ? AppColors.black : AppColors.white,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withOpacity(0.2),
                                spreadRadius: 1,
                                blurRadius: 4,
                              ),
                            ],
                          ),
                          child: Column(
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
                                  Obx(()=>CustomText(
                                    title: item.title,
                                    fontSize: 18.sp,
                                    textColor: themeController.isDarkMode.value ? AppColors.white : AppColors.black,
                                    fontWeight: FontWeight.normal,
                                    textOverflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                    capitalize: true,
                                    maxLines: 2,
                                    fontFamily: 'grenda',
                                  ),),
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
                          ),
                        ),
                      ),
                    ));
                  },
                ),
              ),
            ],
          ),

        ],
      ),
    );
  }
}