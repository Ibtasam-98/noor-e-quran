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
import '../../widgets/custom_text.dart';
import '../../widgets/flying_bird_animtion.dart';



class AdditionalCategoryScreen extends StatelessWidget {
  const AdditionalCategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final box = GetStorage();
    final AppThemeSwitchController themeController = Get.put(AppThemeSwitchController());
    final AppHomeScreenController homeScreenController = Get.put(AppHomeScreenController());
    final UserPermissionController locationPermissionScreenController = Get.find<UserPermissionController>();
    bool isDarkMode = themeController.isDarkMode.value;
    final textColor = isDarkMode ? AppColors.white : AppColors.black;

    return Obx(() {
      bool isDarkMode = themeController.isDarkMode.value;
      final iconColor = isDarkMode ? AppColors.white : AppColors.black;

      return AdvancedDrawer(
        backdrop: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            color: isDarkMode ? AppColors.black : AppColors.white,
          ),
        ),
        controller: homeScreenController.advancedDrawerController,
        animationCurve: Curves.easeInOut,
        animationDuration: const Duration(milliseconds: 300),
        animateChildDecoration: true,
        rtlOpening: false,
        disabledGestures: false,
        childDecoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(16)),
          boxShadow: isDarkMode
              ? [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.8),
              blurRadius: 20,
            ),
          ]
              : [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.8),
              blurRadius: 20,
            ),
          ],
        ),
        drawer: CustomDrawer(isDarkMode: isDarkMode),
        child: Scaffold(
          backgroundColor: isDarkMode ? AppColors.black : AppColors.white,
          appBar: AppBar(
            foregroundColor: AppColors.black,
            surfaceTintColor: AppColors.transparent,
            leading: IconButton(
              splashColor: AppColors.transparent,
              hoverColor: AppColors.transparent,
              onPressed: homeScreenController.handleMenuButtonPressed,
              icon: ValueListenableBuilder<AdvancedDrawerValue>(
                valueListenable: homeScreenController.advancedDrawerController,
                builder: (_, value, __) {
                  homeScreenController.isIconOpen = !value.visible;
                  return AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    child: Image.asset(
                      homeScreenController.isIconOpen
                          ? "assets/images/menu_open_dark.png"
                          : "assets/images/menu_close_dark.png",
                      key: ValueKey<bool>(homeScreenController.isIconOpen),
                      color: iconColor,
                      width: 22.w,
                      height: 22.h,
                    ),
                  );
                },
              ),
            ),
            backgroundColor: isDarkMode ? AppColors.black : AppColors.white,
            centerTitle: false,
            iconTheme: const IconThemeData(
              color: AppColors.black,
            ),
            title: CustomText(
              firstText: "Noor e",
              secondText: " Quran",
              fontSize: 18.sp,
              firstTextColor: isDarkMode ? AppColors.white : AppColors.black,
              secondTextColor: AppColors.primary,
            ),
            actions: [

              IconButton(
                icon: SvgPicture.asset(
                  isDarkMode
                      ? 'assets/images/isha.svg'
                      : 'assets/images/dhuhr.svg',
                  color: iconColor,
                  width: 18.w,
                  height: 18.h,
                ),
                onPressed: themeController.toggleTheme,
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Obx(
                  () =>
              homeScreenController.isLoading.value
                  ? Shimmer.fromColors(
                period: const Duration(milliseconds: 1000),
                baseColor: themeController.isDarkMode.value
                    ? AppColors.black.withOpacity(0.1)
                    : AppColors.black.withOpacity(0.2),
                highlightColor: themeController.isDarkMode.value
                    ? AppColors.lightGrey.withOpacity(0.1)
                    : AppColors.grey.withOpacity(0.2),
                child: Padding(
                  padding: EdgeInsets.only(
                      left: 12.w, bottom: 5.h, right: 12.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            width: 120.w,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: Get.width * 0.4,
                                  height: 18.sp,
                                  decoration: BoxDecoration(
                                    color: AppColors.white,
                                    borderRadius: BorderRadius.circular(10.r),
                                  ),
                                ),
                                AppSizedBox.space5h,
                                Container(
                                  width: Get.width * 0.3,
                                  height: 14.sp,
                                  decoration: BoxDecoration(
                                    color: AppColors.white,
                                    borderRadius: BorderRadius.circular(10.r),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      AppSizedBox.space10h,
                      Container(
                        height: 45.h,
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                      ),
                      AppSizedBox.space10h,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: Get.width * 0.4,
                            height: 18.sp,
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                          ),
                          Container(
                            width: Get.width * 0.2,
                            height: 14.sp,
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                          ),
                        ],
                      ),
                      AppSizedBox.space10h,
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: List.generate(
                            3,
                                (index) =>
                                Container(
                                  width: 280.w,
                                  margin: EdgeInsets.only(right: 8.w),
                                  child: Container(
                                    padding: EdgeInsets.all(6.h),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15.r),
                                      color: AppColors.white,
                                    ),
                                    child: ListTile(
                                      contentPadding: EdgeInsets.zero,
                                      dense: true,
                                      title: Column(
                                        crossAxisAlignment: CrossAxisAlignment
                                            .start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Container(
                                            width: Get.width * 0.4,
                                            height: 15.sp,
                                            decoration: BoxDecoration(
                                              color: AppColors.white,
                                              borderRadius: BorderRadius
                                                  .circular(10.r),
                                            ),
                                          ),
                                          AppSizedBox.space5h,
                                          Container(
                                            width: Get.width * 0.5,
                                            height: 14.sp,
                                            decoration: BoxDecoration(
                                              color: AppColors.white,
                                              borderRadius: BorderRadius
                                                  .circular(10.r),
                                            ),
                                          ),
                                        ],
                                      ),
                                      subtitle: Container(
                                        width: Get.width * 0.3,
                                        height: 12.sp,
                                        decoration: BoxDecoration(
                                          color: AppColors.white,
                                          borderRadius: BorderRadius.circular(
                                              10.r),
                                        ),
                                      ),
                                      trailing: Container(
                                        width: 25.sp,
                                        height: 25.sp,
                                        decoration: BoxDecoration(
                                          color: AppColors.white,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                          ),
                        ),
                      ),
                      AppSizedBox.space10h,
                      Container(
                        width: Get.width * 0.4,
                        height: 18.sp,
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                      ),
                      AppSizedBox.space10h,
                      Container(
                        width: double.infinity,
                        height: 150.h,
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(15.r),
                        ),
                      ),
                      AppSizedBox.space10h,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: Get.width * 0.4,
                            height: 18.sp,
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                          ),
                          Container(
                            width: Get.width * 0.2,
                            height: 14.sp,
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                          ),
                        ],
                      ),
                      AppSizedBox.space10h,
                      Container(
                        height: 180.h,
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(15.r),
                        ),
                      ),
                      AppSizedBox.space15h,
                      Container(
                        width: Get.width * 0.5,
                        height: 18.sp,
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                      ),
                      AppSizedBox.space10h,
                      ...List.generate(
                        2,
                            (rowIndex) =>
                            Column(
                              children: [
                                Row(
                                  children: List.generate(
                                    3,
                                        (colIndex) =>
                                        Expanded(
                                          child: Container(
                                            margin: EdgeInsets.symmetric(
                                                horizontal: 2.5.w),
                                            padding: EdgeInsets.all(8.0),
                                            decoration: BoxDecoration(
                                              color: AppColors.white,
                                              borderRadius: BorderRadius
                                                  .circular(10.r),
                                            ),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment
                                                  .start,
                                              children: [
                                                Container(
                                                  width: Get.width * 0.2,
                                                  height: 16.sp,
                                                  decoration: BoxDecoration(
                                                    color: AppColors.white,
                                                    borderRadius: BorderRadius
                                                        .circular(10.r),
                                                  ),
                                                ),
                                                AppSizedBox.space5h,
                                                Container(
                                                  width: Get.width * 0.15,
                                                  height: 12.sp,
                                                  decoration: BoxDecoration(
                                                    color: AppColors.white,
                                                    borderRadius: BorderRadius
                                                        .circular(10.r),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                  ),
                                ),
                                AppSizedBox.space10h,
                              ],
                            ),
                      ),
                    ],
                  ),
                ),
              )
                  : Padding(
                padding: EdgeInsets.only(left: 10.w, bottom: 5.h, right: 10.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(() {
                      return Row(
                        children: [
                          SizedBox(
                            width: 150.w,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomText(
                                  title: "Location",
                                  textColor: isDarkMode ? AppColors.white : AppColors.black,
                                  fontSize: 18.sp,
                                  fontFamily: 'grenda',
                                  maxLines: 1,
                                  textOverflow: TextOverflow.ellipsis,
                                ),
                                locationPermissionScreenController.locationAccessed.value
                                    ? CustomText(
                                  title: locationPermissionScreenController.cityName.toString() + ", " + locationPermissionScreenController.countryName.toString(),
                                  textColor: AppColors.primary,
                                  fontSize: 14.sp,
                                  maxLines: 1,
                                  textAlign: TextAlign.start,
                                  textOverflow: TextOverflow.ellipsis,
                                )
                                    : CustomText(
                                  title: 'Access Denied',
                                  textColor: AppColors.primary,
                                  fontSize: 14.sp,
                                  maxLines: 1,
                                  textOverflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          GetBuilder<FlyingBirdAnimationControllerForHistory>(
                            init: FlyingBirdAnimationControllerForHistory(),
                            builder: (controller) {
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: List.generate(
                                  2,
                                      (index) => FlyingBird(
                                    positionAnimation: controller.positionAnimation,
                                    opacityAnimation: controller.opacityAnimation,
                                    offsetMultiplier: index == 0 ? 0.01 : 0.1,
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      );
                    }),
                    AppSizedBox.space15h,
                    Obx(() {
                      if (locationPermissionScreenController.locationAccessed.value) {
                        if (homeScreenController.getCurrentDate().isNotEmpty &&
                            locationPermissionScreenController.cityName.isNotEmpty &&
                            homeScreenController.getIslamicDate().isNotEmpty) {
                          return Container(
                            height: 45.h,
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            child: Padding(
                              padding: EdgeInsets.only(left: 8.w, right: 8.w),
                              child: Marquee(
                                text:
                                'As of ${homeScreenController.getCurrentDate()}, in ${locationPermissionScreenController.cityName}, the Islamic date is ${homeScreenController.getIslamicDate()}',
                                style: GoogleFonts.quicksand(
                                  color: AppColors.primary,
                                  fontSize: 14.sp,
                                  fontStyle: FontStyle.italic,
                                ),
                                scrollAxis: Axis.horizontal,
                                blankSpace: 10.0,
                                velocity: 30.0,
                                pauseAfterRound: const Duration(seconds: 2),
                                startPadding: 10.0,
                                accelerationDuration: const Duration(seconds: 1),
                                accelerationCurve: Curves.easeIn,
                                decelerationDuration: const Duration(milliseconds: 500),
                                decelerationCurve: Curves.easeOut,
                              ),
                            ),
                          );
                        } else {
                          return const SizedBox.shrink(); // Don't show Marquee if data is empty
                        }
                      } else {
                        return const SizedBox.shrink(); // Don't show Marquee if location access is denied
                      }
                    }),
                    AppSizedBox.space10h,
                    CustomText(
                      title: "Divine Wisdom",
                      textColor: isDarkMode ? AppColors.white : AppColors.black,
                      fontSize: 18.sp,
                      fontFamily: 'grenda',
                      maxLines: 1,
                      textAlign: TextAlign.start,
                      textOverflow: TextOverflow.ellipsis,
                    ),
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
                            itemCount: deedsCategoryMenu.length,
                            itemBuilder: (context, index) {
                              final item = deedsCategoryMenu[index];

                              return InkWell(
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
                                      color: isDarkMode ? AppColors.black : AppColors.white,
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
                                            CustomText(
                                              title: item.title,
                                              fontSize: 18.sp,
                                              textColor: isDarkMode ? AppColors.white : AppColors.black,
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
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),

                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}

