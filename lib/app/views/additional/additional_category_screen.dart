import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hadith/classes.dart';
import 'package:hadith/hadith.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icons.dart';
import 'package:marquee/marquee.dart';
import 'package:shimmer/shimmer.dart';
import '../../config/app_colors.dart';
import '../../config/app_sizedbox.dart';
import '../../controllers/app_home_screen_controller.dart';
import '../../controllers/app_theme_switch_controller.dart';
import '../../controllers/flying_bird_animation_controller.dart';
import '../../controllers/user_location_premission_controller.dart';
import '../../models/grid_item_model.dart';
import '../../widgets/custom_card.dart';
import '../../widgets/custom_drawer.dart';
import '../../widgets/custom_frame.dart';
import '../../widgets/custom_marquee.dart';
import '../../widgets/custom_text.dart';
import '../../widgets/flying_bird_animtion.dart';
import '../home/app_home_screen_header.dart';
import '../home/base_home_screen.dart';


class AdditionalCategoryScreen extends StatelessWidget {
  final FlyingBirdAnimationController _additionalBirdController = Get.put(FlyingBirdAnimationController(), tag: 'additional_bird');
  final UserPermissionController locationPermissionScreenController = Get.find<UserPermissionController>();
  final AppHomeScreenController homeScreenController = Get.find<AppHomeScreenController>();
  final AppThemeSwitchController themeController = Get.find<AppThemeSwitchController>();


  @override
  Widget build(BuildContext context) {
    return BaseHomeScreen(
      titleFirstPart: "Noor e",
      titleSecondPart: " Quran",
      birdController: _additionalBirdController,
      marqueeText: 'As of ${homeScreenController.getCurrentDate()}, in ${locationPermissionScreenController.cityName}, the Islamic date is ${homeScreenController.getIslamicDate()}',

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HomeScreenHeader(birdController: _additionalBirdController),
          CustomMarquee(),
          Obx(()=> CustomText(
           title: "Divine Wisdom",
           textColor: themeController.isDarkMode.value ? AppColors.white : AppColors.black,
           fontSize: 18.sp,
           fontFamily: 'grenda',
           maxLines: 1,
           textAlign: TextAlign.start,
           textOverflow: TextOverflow.ellipsis,
         ),),
          AppSizedBox.space10h,
          Column(
            children: [
              SingleChildScrollView(
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
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
