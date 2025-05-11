import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:noor_e_quran/app/config/app_colors.dart';
import 'package:noor_e_quran/app/config/app_sizedbox.dart';
import 'package:noor_e_quran/app/controllers/app_theme_switch_controller.dart';
import 'package:noor_e_quran/app/widgets/custom_drawer.dart';
import 'package:noor_e_quran/app/widgets/custom_text.dart';
import 'package:shimmer/shimmer.dart';
import '../../../controllers/flying_bird_animation_controller.dart';
import '../../../controllers/user_location_premission_controller.dart';
import '../../../widgets/custom_shimmer.dart';
import '../controllers/app_home_screen_controller.dart';
import '../controllers/view_all_prayer_screen_controller.dart';

class AppHomeBaseScreen extends StatelessWidget {
  final Widget child;
  final String titleFirstPart;
  final String titleSecondPart;
  final FlyingBirdAnimationController? birdController;
  final String? marqueeText;
  final Widget? birdAnimationWidget;

  const AppHomeBaseScreen({
    Key? key,
    required this.child,
    required this.titleFirstPart,
    required this.titleSecondPart,
    this.birdController,
    this.marqueeText,
    this.birdAnimationWidget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AppHomeScreenController homeScreenController = Get.find<AppHomeScreenController>();
    final AppThemeSwitchController themeController = Get.find<AppThemeSwitchController>();
    final UserPermissionController locationPermissionScreenController = Get.find<UserPermissionController>();
    final NamazController namazController = Get.find<NamazController>();

    return AdvancedDrawer(
      backdrop: Obx(() => Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          color: themeController.isDarkMode.value ? AppColors.black : AppColors.white,
        ),
      )),
      controller: homeScreenController.advancedDrawerController,
      animationCurve: Curves.easeInOut,
      animationDuration: const Duration(milliseconds: 300),
      animateChildDecoration: true,
      rtlOpening: false,
      disabledGestures: false,
      childDecoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(16)),
        boxShadow: Get.find<AppThemeSwitchController>().isDarkMode.value
            ? [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.2),
            blurRadius: 10,
          ),
        ]
            : [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.8),
            blurRadius: 10,
          ),
        ],
      ),
      drawer: Obx(() => CustomDrawer(isDarkMode: themeController.isDarkMode.value)),
      child: Obx(() {
        final isDarkMode = themeController.isDarkMode.value;
        final defaultTextColor = isDarkMode ? AppColors.white : AppColors.black;

        return Scaffold(
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
                      color: isDarkMode ? AppColors.white : AppColors.black,
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
              firstText: titleFirstPart,
              secondText: titleSecondPart,
              fontSize: 15.sp,
              firstTextColor: defaultTextColor,
              secondTextColor: AppColors.primary,
            ),
            actions: [
              IconButton(
                icon: SvgPicture.asset(
                  isDarkMode ? 'assets/images/isha.svg' : 'assets/images/dhuhr.svg',
                  color: isDarkMode ? AppColors.white : AppColors.black,
                  width: 18.w,
                  height: 18.h,
                ),
                onPressed: themeController.toggleTheme,
              ),
            ],
          ),
          body: RefreshIndicator(
            color: AppColors.primary,
            onRefresh: () async {
              homeScreenController.isLoading.value = true;
              await Future.wait([
                locationPermissionScreenController.accessLocation(),
                if (locationPermissionScreenController.locationAccessed.value)
                  namazController.getNamazTimings(
                    locationPermissionScreenController.latitude.value,
                    locationPermissionScreenController.longitude.value,
                    method: namazController.selectedCalculationMethod.value,
                  ),
                Future.delayed(const Duration(seconds: 1)), // Minimum shimmer time
              ]);
              homeScreenController.isLoading.value = false;
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.only(left: 15.w, right: 15.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (birdAnimationWidget != null) birdAnimationWidget!,
                    Obx(() => homeScreenController.isLoading.value
                        ? Shimmer.fromColors(
                      baseColor: themeController.isDarkMode.value
                          ? AppColors.black.withOpacity(0.02)
                          : AppColors.black.withOpacity(0.2),
                      highlightColor: themeController.isDarkMode.value
                          ? AppColors.lightGrey.withOpacity(0.1)
                          : AppColors.grey.withOpacity(0.2),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          buildShimmerContainer(widthFactor: 0.4, height: 18.sp),
                          AppSizedBox.space5h,
                          buildShimmerContainer(widthFactor: 0.2, height: 18.sp),
                          AppSizedBox.space10h,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              buildShimmerContainer(widthFactor: 0.4, height: 18.sp),
                              buildShimmerContainer(widthFactor: 0.2, height: 18.sp),
                            ],
                          ),
                          AppSizedBox.space10h,
                          buildShimmerContainer(height: 140.h),
                          AppSizedBox.space10h,
                          buildShimmerContainer(widthFactor: 0.4, height: 18.sp),
                          AppSizedBox.space10h,
                          buildShimmerContainer(height: 140.h),
                          AppSizedBox.space10h,
                          buildShimmerContainer(widthFactor: 0.4, height: 18.sp),
                          AppSizedBox.space10h,
                          ...List.generate(
                            2,
                                (rowIndex) => Column(
                              children: [
                                Row(
                                  children: List.generate(
                                    2,
                                        (colIndex) => Expanded(
                                      child: Container(
                                        margin: EdgeInsets.only(right: 10.w,),
                                        padding: EdgeInsets.all(8.0),
                                        decoration: shimmerBoxDecoration(borderRadius: 10.r),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            buildShimmerContainer(widthFactor: 0.25, height: 80.sp, borderRadius: 5.r),
                                            AppSizedBox.space5h,
                                            buildShimmerContainer(widthFactor: 0.15, height: 80.sp),
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
                    )
                        : child
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}