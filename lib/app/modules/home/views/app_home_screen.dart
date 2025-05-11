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
import 'package:noor_e_quran/app/modules/home/views/view_all_prayer_screen.dart';
import 'package:noor_e_quran/app/widgets/custom_text.dart';
import '../../../config/app_contants.dart';
import '../../../controllers/flying_bird_animation_controller.dart';
import '../../../controllers/user_location_premission_controller.dart';
import '../../../widgets/custom_frame.dart';
import '../controllers/app_home_screen_controller.dart';
import '../controllers/view_all_prayer_screen_controller.dart';
import 'app_home_screen_header.dart';

class AppHomeScreen extends StatelessWidget {
  AppHomeScreen({super.key});

  final AppHomeScreenController controller = Get.put(AppHomeScreenController());
  final FlyingBirdAnimationController _homeBirdController = Get.put(FlyingBirdAnimationController(), tag: 'home_bird');

  @override
  Widget build(BuildContext context) {
    return AppHomeBaseScreen(
      titleFirstPart: "Noor e",
      titleSecondPart: " Quran",
      birdController: _homeBirdController,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HomeScreenHeader(birdController: _homeBirdController),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Obx(() => CustomText(
                  title: "Upcoming Prayers",
                  textColor: controller.themeController.isDarkMode.value ? AppColors.white : AppColors.black,
                  fontSize: 14.sp,
                  fontFamily: 'grenda',
                  textAlign: TextAlign.start,
                )),
              ),
              Expanded(
                child: InkWell(
                  onTap: () => Get.to(() => ViewAllPrayerScreen()),
                  child: CustomText(
                    title: "View All",
                    textColor: AppColors.primary,
                    fontSize: 12.sp,
                    fontFamily: 'quicksand',
                    textAlign: TextAlign.end,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          AppSizedBox.space10h,
          Obx(() {
            final namazController = Get.find<NamazController>();
            return Container(
              decoration: BoxDecoration(
                color: AppColors.transparent,
                boxShadow: [
                  BoxShadow(
                    color: controller.themeController.isDarkMode.value
                        ? AppColors.primary.withOpacity(0.01)
                        : AppColors.primary.withOpacity(0.01),
                    blurRadius: 5,
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Mosque Background with Next Prayer
                  Stack(
                    children: [
                      Container(
                        height: 90.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(16.r),
                            topRight: Radius.circular(16.r),
                          ),
                          image: DecorationImage(
                            image: AssetImage(
                                controller.themeController.isDarkMode.value
                                    ? 'assets/images/mosque_bg_dark.png'
                                    : 'assets/images/masjid_bg_light.jpg'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Obx(() => Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppColors.black.withOpacity(0.8),
                                AppColors.transparent,
                                AppColors.black.withOpacity(0.8),
                              ],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(16.r),
                              topRight: Radius.circular(16.r),
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 15.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Get.find<UserPermissionController>().locationAccessed.value
                                    ? CustomText(
                                  title: namazController.nextNamazName.value.isNotEmpty &&
                                      namazController.nextNamazTime.value != null
                                      ? '${namazController.nextNamazName.value} ${DateFormat('h:mm a').format(namazController.nextNamazTime.value!)}'
                                      : '--/--/--',
                                  textColor: AppColors.white,
                                  fontSize: 18.sp,
                                  maxLines: 2,
                                  textStyle: GoogleFonts.montserrat(),
                                  fontWeight: FontWeight.bold,
                                )
                                    : CustomText(
                                  title: "--/--",
                                  textColor: AppColors.white,
                                  fontSize: 18.sp,
                                  maxLines: 2,
                                ),
                                Obx(() => CustomText(
                                  textColor: AppColors.white,
                                  fontSize: 24.sp,
                                  title: namazController.timeRemaining.value,
                                  fontFamily: 'grenda',
                                  maxLines: 2,
                                )),
                              ],
                            ),
                          ),
                        ),
                      )),
                    ],
                  ),

                  Container(
                    height: 90.h,
                    width: Get.width,
                    decoration: BoxDecoration(
                      color: controller.themeController.isDarkMode.value ? AppColors.black : AppColors.white,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(15.r),
                        bottomRight: Radius.circular(15.r),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.1),
                          blurRadius: 5,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Obx(() {
                        if (namazController.isNamazLoading.value) {
                          return ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: 5,
                            itemBuilder: (context, index) {
                              return Container(
                                margin: EdgeInsets.symmetric(horizontal: 8.w),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Container(
                                      width: 60.w,
                                      height: 10.h,
                                      color: AppColors.lightGrey,
                                    ),
                                    Container(
                                      width: 30.w,
                                      height: 30.h,
                                      color: AppColors.lightGrey,
                                    ),
                                    Container(
                                      width: 60.w,
                                      height: 10.h,
                                      color: AppColors.lightGrey,
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        } else {
                          return ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: namazController.namazTimes.length,
                            itemBuilder: (context, index) {
                              final namazName = namazController.namazTimes[index];
                              final namazTime = namazController.namazTimings[namazName] ?? "--/--";
                              final formattedTime = namazController.formatTime(
                                  namazTime,
                                  MediaQuery.of(context).alwaysUse24HourFormat
                              );
                              final iconName = namazController.icons[index];
                              final isNextNamaz = namazName == namazController.nextNamazName.value;

                              return Container(
                                alignment: Alignment.center,
                                padding: EdgeInsets.all(8.w),
                                margin: EdgeInsets.symmetric(horizontal: 8.w),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    CustomText(
                                      title: namazName,
                                      fontSize: 13.sp,
                                      textColor: isNextNamaz
                                          ? AppColors.secondry
                                          : controller.themeController.isDarkMode.value
                                          ? AppColors.white
                                          : AppColors.black,
                                      textStyle: GoogleFonts.quicksand(),
                                    ),
                                    Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        SvgPicture.asset(
                                          height: 16.h,
                                          "assets/images/$iconName",
                                          color: isNextNamaz
                                              ? (controller.themeController.isDarkMode.value
                                              ? AppColors.white
                                              : AppColors.primary)
                                              : (controller.themeController.isDarkMode.value
                                              ? AppColors.white
                                              : AppColors.black),
                                        ),
                                        if (isNextNamaz)
                                          Container(
                                            height: 20.h,
                                            width: 20.w,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(60.r),
                                              color: AppColors.transparent,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: AppColors.primary.withOpacity(0.4),
                                                  spreadRadius: 5,
                                                  blurRadius: 10,
                                                ),
                                              ],
                                            ),
                                          ),
                                      ],
                                    ),
                                    CustomText(
                                      title: formattedTime,
                                      fontSize: 12.sp,
                                      textColor: isNextNamaz
                                          ? AppColors.secondry
                                          : controller.themeController.isDarkMode.value
                                          ? AppColors.white
                                          : AppColors.black,
                                      textStyle: GoogleFonts.quicksand(),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        }
                      }),
                    ),
                  )
                ],
              ),
            );
          }),
          AppSizedBox.space15h,
          Obx(() => CustomText(
            title: "Make a Difference",
            textColor: controller.themeController.isDarkMode.value ? AppColors.white : AppColors.black,
            fontSize: 14.sp,
            fontFamily: 'grenda',
            maxLines: 1,
            textOverflow: TextOverflow.ellipsis,
          )),
          AppSizedBox.space15h,
          Column(
            children: [
              SizedBox(
                height: 0.20.sh,
                child: PageView.builder(
                  controller: controller.pageController,
                  itemCount: AppConstants.sliderItems.length,
                  onPageChanged: (index) {
                    controller.currentPage.value = index;
                  },
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5.w),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12.r),
                        child: Stack(
                          children: [
                            Image.asset(
                              AppConstants.sliderItems[index]['image']!,
                              width: double.infinity,
                              height: double.infinity,
                              fit: BoxFit.cover,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                  colors: [
                                    AppColors.black.withOpacity(0.9),
                                    AppColors.transparent,
                                  ],
                                ),
                              ),
                            ),
                            // Content
                            Positioned(
                              left: 16.w,
                              bottom: 16.h,
                              right: 16.w,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CustomText(
                                    title: AppConstants.sliderItems[index]['title']!,
                                    textColor: AppColors.white,
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'grenda',
                                    maxLines: 1,
                                    textAlign: TextAlign.start,
                                  ),
                                  CustomText(
                                    title: AppConstants.sliderItems[index]['subtitle']!,
                                    textColor: AppColors.white.withOpacity(0.9),
                                    fontSize: 12.sp,
                                    fontFamily: 'quicksand',
                                    maxLines: 2,
                                    textOverflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.start,
                                  ),
                                  AppSizedBox.space5h,
                                  Divider(),
                                  AppSizedBox.space5h,
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      CustomText(
                                        title: AppConstants.sliderItems[index]['reference']!,
                                        textColor: AppColors.white.withOpacity(0.9),
                                        fontSize: 10.sp,
                                        fontFamily: 'quicksand',
                                        maxLines: 2,
                                        fontWeight: FontWeight.bold,
                                        textStyle: TextStyle(fontStyle: FontStyle.italic),
                                        textAlign: TextAlign.start,
                                      ),
                                      Obx(() => Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: List.generate(
                                          AppConstants.sliderItems.length,
                                              (index) => AnimatedContainer(
                                            duration: const Duration(milliseconds: 300),
                                            width: controller.currentPage.value == index ? 20.w : 6.w,
                                            height: 6.h,
                                            margin: EdgeInsets.symmetric(horizontal: 4.w),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(4.r),
                                              color: controller.currentPage.value == index
                                                  ? AppColors.primary
                                                  : AppColors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          AppSizedBox.space15h,
          Obx(() => CustomText(
            title: "Explore Features",
            textColor: controller.themeController.isDarkMode.value ? AppColors.white : AppColors.black,
            fontSize: 14.sp,
            fontFamily: 'grenda',
            maxLines: 1,
            textOverflow: TextOverflow.ellipsis,
          )),
          AppSizedBox.space15h,
          Column(
            children: [
              SingleChildScrollView(
                child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2,
                    childAspectRatio: 1,
                  ),
                  itemCount: controller.menuItems.length,
                  itemBuilder: (context, index) {
                    final menuItem = controller.menuItems[index];
                    return Obx(() => InkWell(
                      highlightColor: AppColors.transparent,
                      splashColor: AppColors.transparent,
                      onTap: () {Get.to(menuItem['destination']());},
                      child: Container(
                        margin: EdgeInsets.only(right:10.h,bottom: 10.h),
                        decoration: BoxDecoration(
                          color: controller.themeController.isDarkMode.value
                              ? AppColors.black
                              : AppColors.white,
                          borderRadius: BorderRadius.circular(10.r),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withOpacity(0.2),
                              spreadRadius: 1,
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              CustomFrame(
                                leftImageAsset: "assets/frames/topLeftFrame.png",
                                rightImageAsset: "assets/frames/topRightFrame.png",
                                imageHeight: 30.h,
                                imageWidth: 30.w,
                              ),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CustomText(
                                      title: menuItem['title']!,
                                      fontSize: 16.sp,
                                      textColor: controller.themeController.isDarkMode.value
                                          ? AppColors.white
                                          : AppColors.black,
                                      fontWeight: FontWeight.normal,
                                      textOverflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.center,
                                      capitalize: true,
                                      maxLines: 2,
                                      fontFamily: 'grenda',
                                    ),
                                    CustomText(
                                      title: menuItem['subtitle']!,
                                      fontSize: 12.sp,
                                      textColor: AppColors.primary,
                                      fontWeight: FontWeight.w500,
                                      textAlign: TextAlign.center,
                                      textOverflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                    ),
                                  ],
                                ),
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
              )
            ],
          ),
          AppSizedBox.space10h,
        ],
      ),
    );
  }
}