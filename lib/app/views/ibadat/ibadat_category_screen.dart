import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icons.dart';
import 'package:marquee/marquee.dart';
import 'package:noor_e_quran/app/config/app_colors.dart';
import 'package:noor_e_quran/app/config/app_sizedbox.dart';
import 'package:noor_e_quran/app/controllers/app_home_screen_controller.dart';
import 'package:noor_e_quran/app/controllers/app_theme_switch_controller.dart';
import 'package:noor_e_quran/app/controllers/flying_bird_animation_controller.dart';
import 'package:noor_e_quran/app/controllers/ibadat_category_controller.dart';
import 'package:noor_e_quran/app/views/ibadat/view_continue_azkar_list_screen.dart';
import 'package:noor_e_quran/app/widgets/custom_card.dart';
import 'package:noor_e_quran/app/widgets/custom_drawer.dart';
import 'package:noor_e_quran/app/widgets/custom_text.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

import '../../controllers/user_location_premission_controller.dart';
import '../../models/grid_item_model.dart';
import '../../widgets/custom_frame.dart';
import '../../widgets/custom_marquee.dart';
import '../../widgets/flying_bird_animtion.dart';
import '../common/dua_details_screen.dart';
import '../home/app_home_screen_header.dart';
import '../home/base_home_screen.dart';
import 'azkar/azkar_counter_screen.dart';
import 'azkar/azkar_detail_screen.dart';


class IbadatCategoryScreen extends StatelessWidget {
  final IbadatCategoryController controller = Get.put(IbadatCategoryController());
  final FlyingBirdAnimationController _ibadatBirdController = Get.put(FlyingBirdAnimationController(), tag: 'ibadat_bird');
  final UserPermissionController locationPermissionScreenController = Get.find<UserPermissionController>();
  final AppHomeScreenController homeScreenController = Get.find<AppHomeScreenController>();
  final AppThemeSwitchController themeController = Get.find<AppThemeSwitchController>();

  final box = GetStorage();

  @override
  Widget build(BuildContext context) {
    return BaseHomeScreen(
      titleFirstPart: "Noor e",
      titleSecondPart: " Quran",
      birdController: _ibadatBirdController,
      marqueeText: 'As of ${homeScreenController.getCurrentDate()}, in ${locationPermissionScreenController.cityName}, the Islamic date is ${homeScreenController.getIslamicDate()}',

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HomeScreenHeader(birdController: _ibadatBirdController),
          AppSizedBox.space5h,
          CustomMarquee(),
          if (_hasContinueAzkar()) // Check if there are continue azkar
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Obx(()=>CustomText(
                        title: "Continue your Azkar",
                        textColor: themeController.isDarkMode.value
                            ? AppColors.white
                            : AppColors.black,
                        fontSize: 18.sp,
                        fontFamily: 'grenda',
                        maxLines: 1,
                        textAlign: TextAlign.start,
                        textOverflow: TextOverflow.ellipsis,
                      ),)
                    ),
                    Expanded(
                      child: InkWell(
                        splashColor: AppColors.transparent,
                        onTap: () {
                          Get.to(ViewContinueAzkarListScreen());
                        },
                        child: CustomText(
                          title: "View All",
                          textColor: themeController.isDarkMode.value
                              ? AppColors.primary
                              : AppColors.black,
                          fontSize: 14.sp,
                          fontFamily: 'quicksand',
                          textAlign: TextAlign.end,
                          fontWeight: FontWeight.w600,
                          textOverflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                ),
                AppSizedBox.space10h,
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _buildContinueAzkarList(themeController.isDarkMode.value),
                  ),
                ),
              ],
            ),
          AppSizedBox.space10h,
          Obx(()=>CustomText(
            title: "Name Of The Hour",
            textColor: themeController.isDarkMode.value ? AppColors.white : AppColors.black,
            fontSize: 18.sp,
            fontFamily: 'grenda',
            maxLines: 1,
            textOverflow: TextOverflow.ellipsis,
          ),),
          AppSizedBox.space10h,
          Obx(()=>Container(
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
            child: GetBuilder <IbadatCategoryController>(
              init: controller,
              builder: (controller) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InkWell(
                      splashColor: AppColors.transparent,
                      highlightColor: AppColors.transparent,
                      onTap: () {
                        Get.to(DuaDetailCommonScreen(
                          arabicDua: controller.currentName.arabicName,
                          audioUrl: "",
                          duaTranslation: controller.currentName.paragraph,
                          duaUrduTranslation: "",
                          engFirstTitle: controller.currentName.englishName,
                          showAudiotWidgets: false,
                          engSecondTitle: "",
                          latinTitle: "",
                          isComingFromAllahNameScreen: true,
                        ));
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
                          padding: EdgeInsets.all(10.h),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Align(
                                alignment: Alignment.centerRight,
                                child: CustomText(
                                  title: controller.currentName.arabicName,
                                  fontSize: 30.sp,
                                  textColor: AppColors.white,
                                  maxLines: 1,
                                  textOverflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceBetween,
                                children: [
                                  Expanded(
                                    child: CustomText(
                                      title: controller.currentName.description,
                                      fontSize: 13.sp,
                                      textColor: AppColors.white,
                                      maxLines: 2,
                                      textOverflow: TextOverflow.ellipsis,
                                      capitalize: true,
                                      textAlign: TextAlign.start,
                                      textStyle: const TextStyle(
                                          fontStyle: FontStyle.italic),
                                    ),
                                  ),
                                  AppSizedBox.space25w,
                                  Icon(Icons.remove_red_eye,
                                      color: AppColors.white, size: 15.h),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),),
          AppSizedBox.space10h,
          Obx(()=>CustomText(
            title: "Explore Azkar Categories",
            textColor: themeController.isDarkMode.value ? AppColors.white : AppColors.black,
            fontSize: 18.sp,
            fontFamily: 'grenda',
            maxLines: 1,
            textAlign: TextAlign.start,
            textOverflow: TextOverflow.ellipsis,
          ),),
          AppSizedBox.space10h,
          GetBuilder<IbadatCategoryController>(builder: (controller) {
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: controller.azkarData
                    .asMap()
                    .entries
                    .map((entry) { // Use asMap().entries to get index
                  final index = entry.key;
                  final azkar = entry.value;

                  final containerColor = index.isEven
                      ? AppColors.primary.withOpacity(0.1)
                      : AppColors.primary.withOpacity(0.29);

                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              AzkarDetailsScreen(azkar: azkar),
                        ),
                      );
                    },
                    child: Container(
                      width: 280.w,
                      padding: EdgeInsets.all(20.w),
                      margin: EdgeInsets.only(right: 10.h),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.r),
                        color: containerColor, // Apply the color based on index
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment
                                  .start,
                              children: [
                                Obx(()=>CustomText(
                                  title: azkar['engTitle'] ?? '',
                                  textColor: themeController.isDarkMode.value
                                      ? AppColors.white
                                      : AppColors.black,
                                  capitalize: true,
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w500,
                                  textOverflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  textAlign: TextAlign.start,
                                ),),
                                Obx(()=>CustomText(
                                  title: "Total Azkar ${azkar['totalAzkar']}",
                                  textAlign: TextAlign.start,
                                  capitalize: true,
                                  maxLines: 1,
                                  fontSize: 12.sp,
                                  textColor: themeController.isDarkMode.value
                                      ? AppColors.grey
                                      : AppColors.black,
                                  textOverflow: TextOverflow.ellipsis,
                                  fontWeight: FontWeight.w500,
                                ),),
                              ],
                            ),
                          ),
                          AppSizedBox.space15w,
                          Expanded(
                            child: CustomText(
                              title: azkar['title'] ?? '',
                              textAlign: TextAlign.end,
                              maxLines: 1,
                              textColor: AppColors.primary,
                              textOverflow: TextOverflow.ellipsis,
                              fontSize: 20.sp,
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            );
          }),
          AppSizedBox.space10h,
          Obx(()=>CustomText(
            title: "Shahadat",
            textColor: themeController.isDarkMode.value ? AppColors.white : AppColors.black,
            fontSize: 18.sp,
            fontFamily: 'grenda',
            maxLines: 1,
            textAlign: TextAlign.start,
            textOverflow: TextOverflow.ellipsis,
          ),),
          AppSizedBox.space10h,
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    "assets/images/shahadat.jpg"),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(15.r),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
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
                    borderRadius: BorderRadius.circular(15.r),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(10.h),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Align(
                          alignment: Alignment.centerRight,
                          child: CustomText(
                            title: "اَشْهَدُ اَنْ لَّآ اِلٰهَ اِلَّا اللهُ وَحْدَہٗ لَاشَرِيْكَ لَہٗ وَاَشْهَدُ اَنَّ مُحَمَّدًا عَبْدُهٗ وَرَسُولُہٗ",
                            fontSize: 20.sp,
                            textColor: AppColors.white,
                            maxLines: 50,
                            textAlign: TextAlign.end,
                            textOverflow: TextOverflow.ellipsis,
                          ),
                        ),
                        AppSizedBox.space5h,
                        CustomText(
                          title: "I bear witness that there is none worthy of worship except Allah, the One alone, without partner, and I bear witness that Muhammad is His servant and Messenger",
                          fontSize: 13.sp,
                          textColor: AppColors.white,
                          maxLines: 10,
                          textOverflow: TextOverflow.ellipsis,
                          capitalize: true,
                          textAlign: TextAlign.start,
                          textStyle: const TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          AppSizedBox.space10h,
          Obx(()=>CustomText(
            title: "Essentials",
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
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2,
                    childAspectRatio: 1,
                  ),
                  itemCount: IbadatCategoryMenu.length,
                  itemBuilder: (context, index) {
                    final item = IbadatCategoryMenu[index];

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
  List<Widget> _buildContinueAzkarList(bool isDarkMode) {
    List<Widget> azkarWidgets = [];
    final now = DateTime.now();
    final dateFormat = DateFormat('yyyy-MM-dd HH:mm');
    int index = 0; // Initialize an index to track even/odd
    int displayedCount = 0; // Counter for displayed Azkar

    box.getKeys().forEach((key) {
      if (displayedCount < 3 && key.startsWith('azkar_count_')) {
        final zikarName = key.substring('azkar_count_'.length);
        final count = box.read(key) ?? 0;
        final timeKey = 'azkar_time_$zikarName';
        final timeString = box.read(timeKey) ?? '';
        final time = timeString.isNotEmpty ? DateTime.parse(timeString) : null;
        final repeat = _getRepeatCount(zikarName); // Fetch repeat count
        final zikarData = _getZikarData(zikarName); // Fetch the zikar data
        final title = box.read('azkar_title_$zikarName') ?? zikarName;
        final azkarType = box.read('azkar_heading_$zikarName') ?? "Azkar";
        final azkarNameFromStorage = box.read('azkar_name_$zikarName') ?? title;

        if (count > 0 && count < repeat) {
          azkarWidgets.add(
            Container(
              width: 280.w,
              margin: EdgeInsets.only(right: 8.w),
              padding: EdgeInsets.all(6.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.r),
                color: index % 2 == 0
                    ? AppColors.primary.withOpacity(0.1)
                    : AppColors.primary.withOpacity(0.29),
              ),
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                dense: true,
                title: Obx(()=>CustomText(
                  title: title,
                  fontSize: 15.sp,
                  textColor: themeController.isDarkMode.value ? AppColors.white : AppColors.black,
                  fontWeight: FontWeight.w500,
                  textOverflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  textAlign: TextAlign.start,
                ),),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: CustomText(
                        title: zikarName,
                        fontSize: 13.sp,
                        textColor: AppColors.primary,
                        fontWeight: FontWeight.w500,
                        textOverflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        textAlign: TextAlign.end,
                      ),
                    ),
                    AppSizedBox.space5h,
                    Obx(()=>CustomText(
                      title: "Last Accessed ${time != null ? dateFormat.format(time) : 'No time recorded'}",
                      fontSize: 12.sp,
                      textAlign: TextAlign.start,
                      textColor: themeController.isDarkMode.value? AppColors.grey : AppColors.black,
                    ),),
                    AppSizedBox.space5h,
                    LinearProgressIndicator(
                      value: count / repeat,
                      backgroundColor: AppColors.grey.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(20.r),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColors.primary,
                      ),
                    ),
                  ],
                ),
                onTap: () {
                  if (zikarData != null) {
                    Get.to(AzkarCounterScreen(
                      zikar: zikarData,
                      azkarType: azkarType,
                      azkarName: azkarNameFromStorage,
                    ));
                  } else {
                    print('Zikar data not found for $zikarName');
                  }
                },
              ),
            ),
          );
          index++;
          displayedCount++; // Increment the displayed count
        }
      }
    });

    return azkarWidgets;
  }

  int _getRepeatCount(String zikarName) {
    for (var azkarList in controller.azkarData) {
      for (var azkar in azkarList['content']) {
        if (azkar['zikar'] == zikarName) {
          return azkar['repeat'];
        }
      }
    }
    return 0; // Return 0 if not found
  }

  Map<String, dynamic>? _getZikarData(String zikarName) {
    for (var azkarList in controller.azkarData) {
      for (var azkar in azkarList['content']) {
        if (azkar['zikar'] == zikarName) {
          return azkar;
        }
      }
    }
    return null; // Return null if not found
  }

  bool _hasContinueAzkar() {
    return box.getKeys().any((key) =>
    key.startsWith('azkar_count_') && (box.read(key) ?? 0) > 0 &&
        (box.read(key) ?? 0) <
            _getRepeatCount(key.substring('azkar_count_'.length)));
  }
}





/*


SingleChildScrollView(
                  child: Padding(
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
                                GetBuilder<FlyingBirdAnimationControllerForIbadat>(
                                  init: FlyingBirdAnimationControllerForIbadat(),
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
                          if (_hasContinueAzkar()) // Check if there are continue azkar
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AppSizedBox.space15h,
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: CustomText(
                                        title: "Continue your Azkar",
                                        textColor: isDarkMode
                                            ? AppColors.white
                                            : AppColors.black,
                                        fontSize: 18.sp,
                                        fontFamily: 'grenda',
                                        maxLines: 1,
                                        textAlign: TextAlign.start,
                                        textOverflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Expanded(
                                      child: InkWell(
                                        splashColor: AppColors.transparent,
                                        onTap: () {
                                          Get.to(ViewContinueAzkarListScreen());
                                        },
                                        child: CustomText(
                                          title: "View All",
                                          textColor: isDarkMode
                                              ? AppColors.primary
                                              : AppColors.black,
                                          fontSize: 14.sp,
                                          fontFamily: 'quicksand',
                                          textAlign: TextAlign.end,
                                          fontWeight: FontWeight.w600,
                                          textOverflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                AppSizedBox.space15h,
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: _buildContinueAzkarList(isDarkMode),
                                  ),
                                ),
                              ],
                            ),
                          AppSizedBox.space15h,
                          CustomText(
                            title: "Name Of The Hour",
                            textColor: isDarkMode ? AppColors.white : AppColors.black,
                            fontSize: 18.sp,
                            fontFamily: 'grenda',
                            maxLines: 1,
                            textOverflow: TextOverflow.ellipsis,
                          ),
                          AppSizedBox.space15h,
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage(isDarkMode
                                    ? "assets/images/quran_bg_dark.jpg"
                                    : "assets/images/quran_bg_light.jpg"),
                                fit: BoxFit.cover,
                              ),
                              borderRadius: BorderRadius.circular(15.r),
                              boxShadow: [
                                BoxShadow(
                                  color: isDarkMode
                                      ? AppColors.primary.withOpacity(0.3)
                                      : AppColors.transparent,
                                  blurRadius: 5,
                                ),
                              ],
                            ),
                            child: GetBuilder <IbadatCategoryController>(
                              init: controller,
                              builder: (controller) {
                                return Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    InkWell(
                                      splashColor: AppColors.transparent,
                                      highlightColor: AppColors.transparent,
                                      onTap: () {
                                        Get.to(DuaDetailCommonScreen(
                                          arabicDua: controller.currentName.arabicName,
                                          audioUrl: "",
                                          duaTranslation: controller.currentName.paragraph,
                                          duaUrduTranslation: "",
                                          engFirstTitle: controller.currentName.englishName,
                                          showAudiotWidgets: false,
                                          engSecondTitle: "",
                                          latinTitle: "",
                                          isComingFromAllahNameScreen: true,
                                        ));
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
                                          padding: EdgeInsets.all(10.h),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Align(
                                                alignment: Alignment.centerRight,
                                                child: CustomText(
                                                  title: controller.currentName.arabicName,
                                                  fontSize: 30.sp,
                                                  textColor: AppColors.white,
                                                  maxLines: 1,
                                                  textOverflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment
                                                    .spaceBetween,
                                                children: [
                                                  Expanded(
                                                    child: CustomText(
                                                      title: controller.currentName.description,
                                                      fontSize: 13.sp,
                                                      textColor: AppColors.white,
                                                      maxLines: 2,
                                                      textOverflow: TextOverflow.ellipsis,
                                                      capitalize: true,
                                                      textAlign: TextAlign.start,
                                                      textStyle: const TextStyle(
                                                          fontStyle: FontStyle.italic),
                                                    ),
                                                  ),
                                                  AppSizedBox.space25w,
                                                  Icon(Icons.remove_red_eye,
                                                      color: AppColors.white, size: 15.h),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                          AppSizedBox.space15h,
                          CustomText(
                            title: "Explore Azkar Categories",
                            textColor: isDarkMode ? AppColors.white : AppColors.black,
                            fontSize: 18.sp,
                            fontFamily: 'grenda',
                            maxLines: 1,
                            textAlign: TextAlign.start,
                            textOverflow: TextOverflow.ellipsis,
                          ),
                          AppSizedBox.space15h,
                          GetBuilder<IbadatCategoryController>(builder: (controller) {
                            return SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: controller.azkarData
                                    .asMap()
                                    .entries
                                    .map((entry) { // Use asMap().entries to get index
                                  final index = entry.key;
                                  final azkar = entry.value;

                                  final containerColor = index.isEven
                                      ? AppColors.primary.withOpacity(0.1)
                                      : AppColors.primary.withOpacity(0.29);

                                  return InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              AzkarDetailsScreen(azkar: azkar),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      width: 280.w,
                                      padding: EdgeInsets.all(20.w),
                                      margin: EdgeInsets.only(right: 10.h),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10.r),
                                        color: containerColor, // Apply the color based on index
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment
                                                  .start,
                                              children: [
                                                CustomText(
                                                  title: azkar['engTitle'] ?? '',
                                                  textColor: isDarkMode
                                                      ? AppColors.white
                                                      : AppColors.black,
                                                  capitalize: true,
                                                  fontSize: 15.sp,
                                                  fontWeight: FontWeight.w500,
                                                  textOverflow: TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                  textAlign: TextAlign.start,
                                                ),
                                                CustomText(
                                                  title: "Total Azkar ${azkar['totalAzkar']}",
                                                  textAlign: TextAlign.start,
                                                  capitalize: true,
                                                  maxLines: 1,
                                                  fontSize: 12.sp,
                                                  textColor: isDarkMode
                                                      ? AppColors.grey
                                                      : AppColors.black,
                                                  textOverflow: TextOverflow.ellipsis,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ],
                                            ),
                                          ),
                                          AppSizedBox.space15w,
                                          Expanded(
                                            child: CustomText(
                                              title: azkar['title'] ?? '',
                                              textAlign: TextAlign.end,
                                              maxLines: 1,
                                              textColor: AppColors.primary,
                                              textOverflow: TextOverflow.ellipsis,
                                              fontSize: 20.sp,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            );
                          }),
                          AppSizedBox.space15h,
                          CustomText(
                            title: "Shahadat",
                            textColor: isDarkMode ? AppColors.white : AppColors.black,
                            fontSize: 18.sp,
                            fontFamily: 'grenda',
                            maxLines: 1,
                            textAlign: TextAlign.start,
                            textOverflow: TextOverflow.ellipsis,
                          ),
                          AppSizedBox.space15h,
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage(
                                    "assets/images/shahadat.jpg"),
                                fit: BoxFit.cover,
                              ),
                              borderRadius: BorderRadius.circular(15.r),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
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
                                    borderRadius: BorderRadius.circular(15.r),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(10.h),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: CustomText(
                                            title: "اَشْهَدُ اَنْ لَّآ اِلٰهَ اِلَّا اللهُ وَحْدَہٗ لَاشَرِيْكَ لَہٗ وَاَشْهَدُ اَنَّ مُحَمَّدًا عَبْدُهٗ وَرَسُولُہٗ",
                                            fontSize: 20.sp,
                                            textColor: AppColors.white,
                                            maxLines: 50,
                                            textAlign: TextAlign.end,
                                            textOverflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        AppSizedBox.space5h,
                                        CustomText(
                                          title: "I bear witness that there is none worthy of worship except Allah, the One alone, without partner, and I bear witness that Muhammad is His servant and Messenger",
                                          fontSize: 13.sp,
                                          textColor: AppColors.white,
                                          maxLines: 10,
                                          textOverflow: TextOverflow.ellipsis,
                                          capitalize: true,
                                          textAlign: TextAlign.start,
                                          textStyle: const TextStyle(fontStyle: FontStyle.italic),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          AppSizedBox.space15h,
                          CustomText(
                            title: "Essentials",
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
                                  itemCount: IbadatCategoryMenu.length,
                                  itemBuilder: (context, index) {
                                    final item = IbadatCategoryMenu[index];

                                    return InkWell(
                                      splashColor: AppColors.transparent,
                                      highlightColor: AppColors.transparent,
                                      hoverColor: AppColors.transparent,
                                      onTap: () {
                                        if (item.destination != null) {
                                          Get.to(() => item.destination!);
                                        } else {
                                          // Handle case where destination is null (e.g., show a snackbar)
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
                      )
                  )
              )*/
