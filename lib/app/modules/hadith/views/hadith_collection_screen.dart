import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:noor_e_quran/app/modules/home/views/app_home_base_screen.dart';
import 'package:quran/quran.dart' as quran;
import 'package:noor_e_quran/app/controllers/flying_bird_animation_controller.dart';
import '../../../config/app_colors.dart';
import '../../../config/app_sizedbox.dart';
import '../../../controllers/app_theme_switch_controller.dart';
import '../../../widgets/custom_formated_text.dart';
import '../../../widgets/custom_text.dart';
import '../../home/controllers/app_home_screen_controller.dart';
import '../../home/views/app_home_screen_header.dart';
import 'package:flutter_html/flutter_html.dart';

import '../controllers/hadith_collectinon_screen_controller.dart';

class HadithCollectionScreen extends StatelessWidget {
  final Map<String, dynamic>? userData;

  HadithCollectionScreen({super.key, this.userData});
  @override
  Widget build(BuildContext context) {
    final FlyingBirdAnimationController _hadithBirdController = Get.find<FlyingBirdAnimationController>();
    final AppHomeScreenController controller = Get.put(AppHomeScreenController());
    final AppThemeSwitchController themeController = Get.find<AppThemeSwitchController>();
    final HadithCollectionController hadithCollectionController = Get.find<HadithCollectionController>();


    return AppHomeBaseScreen(
      titleFirstPart: "Noor e",
      titleSecondPart: " Quran",
      birdController: _hadithBirdController,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HomeScreenHeader(birdController: _hadithBirdController),
          AppSizedBox.space10h,
          Obx(() => CustomText(
            title: "Hadith of the Hour",
            textColor: controller.themeController.isDarkMode.value ? AppColors.white : AppColors.black,
            fontSize: 14.sp,
            fontFamily: 'grenda',
            textAlign: TextAlign.start,
            maxLines: 1,
            textOverflow: TextOverflow.ellipsis,
          )),
          AppSizedBox.space10h,
          Obx(()=> Container(
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
                  color: themeController.isDarkMode.value ? AppColors.primary.withOpacity(0.3) : AppColors.transparent,
                  blurRadius: 5,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                InkWell(
                  splashColor: AppColors.transparent,
                  highlightColor: AppColors.transparent,
                  onTap: () {
                    // Get.to(HadithDetailScreen(
                    //   hadithNumber: controller.currentHadith.hadithNumber,
                    //   hadithFirstBody: controller.currentHadith.hadith.first.body,
                    //   hadithLastBody: controller.currentHadith.hadith.last.body,
                    //   grade: "",
                    //   bookLastName: controller.currentHadith.hadith.last.chapterTitle,
                    //   bookFirstName: controller.currentHadith.hadith.first.chapterTitle,
                    //   bookNumber: int.tryParse(controller.currentHadith.bookNumber) ?? 0,
                    //   collectionName: controller.currentHadith.collection,
                    // ));
                  },
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
                      padding: EdgeInsets.all(5.h),
                      child:Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Html(
                              data: "<div>${truncateString(
                                  hadithCollectionController.currentHadith.hadith.first.body, 1,
                                  TextStyle(
                                    fontSize: 14.sp,
                                    fontFamily: 'quicksand',
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.white,
                                  ),context)}</div>",
                              style: {
                                "div": Style(
                                  fontSize: FontSize(13.sp),
                                  color: AppColors.white ,
                                  fontFamily: 'quicksand',
                                  fontWeight: FontWeight.w600,
                                  textAlign: TextAlign.start,
                                  maxLines: 2,
                                  margin: Margins.zero, // Remove implicit margins
                                  padding: HtmlPaddings.zero, // Remove implicit padding
                                ),
                              },
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom:8.h,right: 8.w),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: CustomText(
                                    title: '${hadithCollectionController.currentHadith.collection} | Hadith No. ${hadithCollectionController.currentHadith.hadithNumber} | Book ${hadithCollectionController.currentHadith.bookNumber}',
                                    fontSize: 13.sp,
                                    textColor: AppColors.white,
                                    maxLines: 2,
                                    capitalize: true,
                                    textAlign: TextAlign.start,
                                    fontWeight: FontWeight.bold,
                                    textStyle: const TextStyle(fontStyle: FontStyle.italic),
                                  ),
                                ),
                                Icon(Icons.remove_red_eye, color: AppColors.white, size: 15.h),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),),
          AppSizedBox.space10h,
          Obx(() => CustomText(
            title: "Last Accessed Hadith",
            textColor: controller.themeController.isDarkMode.value ? AppColors.white : AppColors.black,
            fontSize: 14.sp,
            fontFamily: 'grenda',
            textAlign: TextAlign.start,
            maxLines: 1,
            textOverflow: TextOverflow.ellipsis,
          )),

        ],
      ),
    );
  }
}