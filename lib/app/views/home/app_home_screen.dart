import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icons.dart';
import 'package:marquee/marquee.dart';
import 'package:noor_e_quran/app/config/app_colors.dart';
import 'package:noor_e_quran/app/config/app_sizedbox.dart';
import 'package:noor_e_quran/app/controllers/app_home_screen_controller.dart';
import 'package:noor_e_quran/app/controllers/app_theme_switch_controller.dart';
import 'package:noor_e_quran/app/views/home/qibla_screen.dart';
import 'package:noor_e_quran/app/views/home/tasbeeh/tasbeeh_counter_screen.dart';
import 'package:noor_e_quran/app/views/home/verse_of_the_hour_screen.dart';
import 'package:noor_e_quran/app/views/home/view_all_namaz_screen.dart';
import 'package:noor_e_quran/app/widgets/custom_card.dart';
import 'package:noor_e_quran/app/widgets/custom_drawer.dart';
import 'package:noor_e_quran/app/widgets/custom_text.dart';
import 'package:quran/quran.dart' as quran;
import 'package:shimmer/shimmer.dart';
import '../../controllers/flying_bird_animation_controller.dart';
import '../../controllers/user_location_premission_controller.dart';
import '../../widgets/custom_frame.dart';
import '../../widgets/flying_bird_animtion.dart';
import '../prayer/prayer_main_screen.dart';
import '../prayer/prayer_tracker_screen.dart';
import '../quran/quran_menu_screen.dart';
import '../quran/quran_surah_detail_screen.dart';
import 'islamic_calender_screen.dart';
import 'last_access_surah_list_screen.dart';

class HomeScreen extends StatelessWidget {
  final Map<String, dynamic>? userData;
  int selectedIndex = 0;

  HomeScreen({super.key, this.userData});

  @override
  Widget build(BuildContext context) {
    final AppHomeScreenController homeScreenController = Get.put(AppHomeScreenController());
    final AppThemeSwitchController themeController = Get.find<AppThemeSwitchController>();
    final UserPermissionController locationPermissionScreenController = Get.find<UserPermissionController>();

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
              color: AppColors.primary.withOpacity(0.3),
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
          body: RefreshIndicator(
            color: AppColors.primary,
            onRefresh: () async {
              // Call methods in your controllers to refresh data
              homeScreenController.isNamazLoading.value;
              homeScreenController.loadLastAccessedSurahs();
              locationPermissionScreenController.locationAccessed.value;
              return Future.delayed(Duration(seconds: 1));
            },
            child: SingleChildScrollView(
              child: Obx(
                    () => Padding(
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
                            GetBuilder<FlyingBirdAnimationController>(
                              init: FlyingBirdAnimationController(),
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
                      if (homeScreenController.lastAccessedSurahs.isNotEmpty) ...[
                        AppSizedBox.space15h,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: CustomText(
                                title: "Last Accessed Surah",
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
                                onTap: () => Get.to(() => LastAccessListScreen()),
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
                        GetBuilder<AppHomeScreenController>(
                          builder: (controller) {
                            if (controller.lastAccessedSurahs.isEmpty) {
                              return Center(child: Text('No recent activity.'));
                            }
                            final sortedSurahs = List<Map<String, dynamic>>.from(
                                controller.lastAccessedSurahs)
                              ..sort((a, b) =>
                                  controller.parseAccessTime(b['accessTime'])
                                      .compareTo(controller.parseAccessTime(
                                      a['accessTime'])));
            
                            final latestSurahs = sortedSurahs.take(3).toList();
            
                            return SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: latestSurahs.map((surahData) {
                                  final surahNumber = surahData['surahNumber'] as int;
                                  final accessTime = controller.parseAccessTime(surahData['accessTime'] as String);
                                  final formattedTime = DateFormat('yyyy-MM-dd HH:mm').format(accessTime);
                                  final placeOfRevelation = quran.getPlaceOfRevelation(surahNumber);
                                  final verseCount = quran.getVerseCount(surahNumber);
                                  final surahName = controller.getSurahName(surahNumber);
                                  final surahNameArabic = controller.getSurahNameArabic(surahNumber);
                                  final isEvenIndex = latestSurahs.indexOf(surahData) % 2 == 0;
            
                                  return Container(
                                    width: 280.w,
                                    margin: EdgeInsets.only(right: 8.w),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Container(
                                        padding: EdgeInsets.all(6.h),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(15.r),
                                          color: isEvenIndex ? AppColors.primary.withOpacity(0.1) : AppColors.primary.withOpacity(0.29),
                                        ),
                                        child: ListTile(
                                          contentPadding: EdgeInsets.zero,
                                          dense: true,
                                          title: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              CustomText(
                                                title: surahName,
                                                fontSize: 15.sp,
                                                textColor: isDarkMode ? AppColors.white : AppColors.black,
                                                fontWeight: FontWeight.w500,
                                                textOverflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                                textAlign: TextAlign.start,
                                              ),
                                              CustomText(
                                                title: '${placeOfRevelation == 'Makkiyah' ? 'Makkah' : 'Madinah'} | $verseCount Verses',
                                                fontSize: 14.sp,
                                                textColor: AppColors.primary,
                                                textAlign: TextAlign.start,
                                                textOverflow: TextOverflow.ellipsis,
                                                fontWeight: FontWeight.w500,
                                                maxLines: 1,
                                              ),
                                              AppSizedBox.space5h,
                                            ],
                                          ),
                                          subtitle: CustomText(
                                            title: 'Last Accessed: $formattedTime',
                                            fontSize: 12.sp,
                                            textAlign: TextAlign.start,
                                            textColor: isDarkMode ? AppColors.grey : AppColors.black,
                                          ),
                                          trailing: SizedBox(
                                            width: 80.w, // Adjust width as needed
                                            child: Align(
                                              alignment: Alignment.centerRight,
                                              child: CustomText(
                                                title: surahNameArabic,
                                                fontSize: 25.sp,
                                                textColor: AppColors.primary,
                                                maxLines: 1,
                                                textOverflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ),
                                          onTap: () => Get.to(() => QuranSurahDetailScreen(surahNumber: surahNumber)),
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            );
                          },
                        ),
                      ],
                      AppSizedBox.space15h,
                      CustomText(
                          title: "Verse Of The Hour",
                          textColor: isDarkMode ? AppColors.white : AppColors
                              .black,
                          fontSize: 18.sp,
                          fontFamily: 'grenda',
                          maxLines: 1,
                          textOverflow: TextOverflow.ellipsis
                      ),
                      AppSizedBox.space15h,
                      Stack(
                        children: [
                          InkWell(
                            splashColor: AppColors.transparent,
                            highlightColor: AppColors.transparent,
                            onTap: () {
                              Get.to(VerseOfHourScreen(
                                surahNumber: homeScreenController.randomVerse
                                    .value.surahNumber,
                                verseNumber: homeScreenController.randomVerse
                                    .value.verseNumber,
                                arabicText: homeScreenController.randomVerse.value
                                    .verse,
                                translation: homeScreenController.randomVerse
                                    .value.translation,
                                title: quran.getSurahName(
                                    homeScreenController.randomVerse.value
                                        .surahNumber),
                                surahArabicTitle: quran.getSurahNameArabic(
                                    homeScreenController.randomVerse.value
                                        .surahNumber),
                              ));
                            },
                            child: Container(
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
                                    color: isDarkMode ? AppColors.primary
                                        .withOpacity(0.3) : AppColors.transparent,
                                    blurRadius: 5,
                                  ),
                                ],
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
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
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 15.w, vertical: 15.h)
                                          .copyWith(right: 20.w),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment: CrossAxisAlignment
                                            .end,
                                        children: [
                                          Obx(() =>
                                              CustomText(
                                                title: homeScreenController
                                                    .randomVerse.value.verse,
                                                textAlign: TextAlign.end,
                                                textColor: AppColors.white,
                                                fontSize: 20.sp,
                                                maxLines: 1,
                                              )),
                                          SizedBox(height: 5.h),
                                          Obx(() =>
                                              Align(
                                                alignment: Alignment.centerLeft,
                                                child: CustomText(
                                                  title: homeScreenController
                                                      .randomVerse.value
                                                      .translation,
                                                  fontSize: 14.sp,
                                                  textColor: AppColors.white,
                                                  maxLines: 2,
                                                  fontWeight: FontWeight.w500,
                                                  textAlign: TextAlign.start,
                                                ),
                                              )),
                                          AppSizedBox.space5h,
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment
                                                .spaceBetween,
                                            children: [
                                              Expanded(
                                                child: Obx(() =>
                                                    CustomText(
                                                      title:
                                                      'Surah ${quran.getSurahName(
                                                          homeScreenController
                                                              .randomVerse.value
                                                              .surahNumber)} | Surah No. ${homeScreenController
                                                          .randomVerse.value
                                                          .surahNumber} | Verse No.${homeScreenController
                                                          .randomVerse.value
                                                          .verseNumber}',
                                                      fontSize: 13.sp,
                                                      textColor: AppColors.white,
                                                      maxLines: 1000,
                                                      textAlign: TextAlign.start,
                                                      fontWeight: FontWeight.bold,
                                                      textStyle: const TextStyle(
                                                          fontStyle: FontStyle
                                                              .italic),
                                                    )),
                                              ),
                                              Icon(Icons.remove_red_eye,
                                                  color: AppColors.white,
                                                  size: 15.h),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      AppSizedBox.space15h,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: CustomText(
                              title: "Upcoming Prayers",
                              textColor: isDarkMode ? AppColors.white : AppColors
                                  .black,
                              fontSize: 18.sp,
                              fontFamily: 'grenda',
                              textAlign: TextAlign.start,
                              textOverflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Expanded(
                            child: InkWell(
                              onTap: () => Get.to(ViewAllNamazScreen()),
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
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.transparent,
                          boxShadow: [
                            BoxShadow(
                              color: isDarkMode ? AppColors.primary.withOpacity(
                                  0.1) : AppColors.primary.withOpacity(0.1),
                              blurRadius: 5,
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Stack(
                              children: [
                                Container(
                                  height: 90.h,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(16),
                                      topRight: Radius.circular(16),
                                    ),
                                    image: DecorationImage(
                                      image: AssetImage(isDarkMode
                                          ? 'assets/images/mosque_bg_dark.png'
                                          : 'assets/images/masjid_bg_light.jpg'),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Obx(() =>
                                    Positioned.fill(
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
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(16),
                                            topRight: Radius.circular(16),
                                          ),
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 15.w),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment
                                                .start,
                                            mainAxisAlignment: MainAxisAlignment
                                                .center,
                                            children: [
                                              locationPermissionScreenController
                                                  .locationAccessed.value
                                                  ? CustomText(
                                                title: homeScreenController
                                                    .nextNamazName.value
                                                    .isNotEmpty &&
                                                    homeScreenController
                                                        .nextNamazTime.value !=
                                                        null
                                                    ? '${homeScreenController
                                                    .nextNamazName
                                                    .value} ${DateFormat('h:mm a')
                                                    .format(homeScreenController
                                                    .nextNamazTime.value!)}'
                                                    : '--/--/--',
                                                textColor: AppColors.white,
                                                fontSize: 18.sp,
                                                maxLines: 2,
                                              )
                                                  : CustomText(
                                                title: "--/--",
                                                textColor: AppColors.white,
                                                fontSize: 18.sp,
                                                maxLines: 2,
                                              ),
                                              CustomText(
                                                textColor: AppColors.white,
                                                fontSize: 24.sp,
                                                title: homeScreenController
                                                    .getTimeRemaining(),
                                                fontFamily: 'grenda',
                                                maxLines: 2,
                                              ),
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
                                color: isDarkMode ? AppColors.black : AppColors
                                    .white,
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(15.r),
                                  bottomRight: Radius.circular(15.r),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.primary.withOpacity(0.3),
                                    blurRadius: 4,
                                  ),
                                ],
                              ),
                              child: Center(
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  itemCount: homeScreenController.isNamazLoading.value ? 5 : homeScreenController.namazTimes.length,
                                  itemBuilder: (context, index) {
                                    final namazName = homeScreenController.namazTimes[index];
                                    final namazTime = homeScreenController.namazTimings[namazName] ?? "--/--";
                                    final formattedTime = homeScreenController.formatTime(namazTime, homeScreenController.is24HourFormat);
                                    final iconName = homeScreenController.icons[index];
                                    final isNextNamaz = namazName == homeScreenController.nextNamazName.value;
                                    final isLoading = homeScreenController.isNamazLoading.value;
            
                                    return Container(
                                      alignment: Alignment.center,
                                      padding: const EdgeInsets.all(8.0),
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment
                                            .spaceEvenly,
                                        crossAxisAlignment: CrossAxisAlignment
                                            .center,
                                        children: [
                                          CustomText(
                                            title: namazName,
                                            fontSize: 13.sp,
                                            textColor: isNextNamaz ? AppColors
                                                .secondry : isLoading ? Colors
                                                .grey : isDarkMode ? AppColors
                                                .white : AppColors.black,
                                            textStyle: GoogleFonts.quicksand(),
                                          ),
                                          isLoading
                                              ? Icon(Icons.cloud_outlined,
                                              color: AppColors.white, size: 18.h)
                                              : Stack(
                                            alignment: Alignment.center,
                                            children: [
                                              SvgPicture.asset(
                                                height: 20.h,
                                                "assets/images/$iconName",
                                                color: isNextNamaz
                                                    ? (isDarkMode ? AppColors
                                                    .white : AppColors.primary)
                                                    : (isDarkMode ? AppColors
                                                    .white : AppColors.black),
                                              ),
                                              if (isNextNamaz)
                                                Container(
                                                  height: 25.h,
                                                  width: 25.w,
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius
                                                        .circular(60.r),
                                                    color: AppColors.transparent,
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: AppColors.primary
                                                            .withOpacity(0.4),
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
                                            textColor: isNextNamaz ? AppColors
                                                .secondry : isDarkMode ? AppColors
                                                .white : AppColors.black,
                                            textStyle: GoogleFonts.quicksand(),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      AppSizedBox.space15h,
                      CustomText(
                        title: "Find your Qibla ",
                        textColor: isDarkMode ? AppColors.white : AppColors.black,
                        fontSize: 18.sp,
                        fontFamily: 'grenda',
                        maxLines: 1,
                        textOverflow: TextOverflow.ellipsis,
                      ),
                      AppSizedBox.space15h,
                      InkWell(
                        onTap: () {
                          Get.to(QiblaScreen(city: locationPermissionScreenController.cityName.toString() + ", " + locationPermissionScreenController.countryName.toString()));
                        },
                        child: CustomCard(
                          title: "Pray Towards Makkah",
                          subtitle: "Find the Qibla Wherever You Are ",
                          imageUrl: 'assets/images/masjid_nabvi.jpg',
                          titleFontSize: 20.sp,
                          subtitleFontSize: 14.sp,
                          mergeWithGradientImage: true,
                          addPadding: true,
                          addBoxShadow: true,
                        ),
                      ),
                      AppSizedBox.space15h,
                      CustomText(
                        title: "Strengthen Your Iman Daily",
                        textColor: isDarkMode ? AppColors.white : AppColors.black,
                        fontSize: 18.sp,
                        fontFamily: 'grenda',
                        maxLines: 1,
                        textOverflow: TextOverflow.ellipsis,
                      ),
                      AppSizedBox.space15h,
                      Column(
                        children: [
                          for (int i = 0; i < 2; i++)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                for (int j = 0; j < 2; j++)
                                  Expanded(
                                    child: InkWell(
                                      highlightColor: AppColors.transparent,
                                      splashColor: AppColors.transparent,
                                      onTap: () {
                                        final destinations = [
                                          QuranMenuScreen(),
                                          TasbeehMainScreen(),
                                          PrayerMainScreen(),
                                          IslamicCalendarScreen(),
                                        ];
                                        Get.to(destinations[i * 2 + j]);
                                      },
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
                                          children: [
                                            CustomFrame(
                                              leftImageAsset: "assets/frames/topLeftFrame.png",
                                              rightImageAsset: "assets/frames/topRightFrame.png",
                                              imageHeight: 30.h,
                                              imageWidth: 30.w,
                                            ),
                                            Column(
                                              children: [
                                                AppSizedBox.space20h,
                                                CustomText(
                                                  title: [
                                                    "Quran",
                                                    "Tasbeeh",
                                                    "Salah",
                                                    "Islamic",
                                                  ][i * 2 + j],
                                                  fontSize: 18.sp,
                                                  textColor:
                                                  isDarkMode ? AppColors.white : AppColors.black,
                                                  fontWeight: FontWeight.normal,
                                                  textOverflow: TextOverflow.ellipsis,
                                                  textAlign: TextAlign.center,
                                                  capitalize: true,
                                                  maxLines: 2,
                                                  fontFamily: 'grenda',
                                                ),
                                                CustomText(
                                                  title: [
                                                    "Recitation",
                                                    "Counter",
                                                    "Practices",
                                                    "Calender",
                                                  ][i * 2 + j],
                                                  fontSize: 12.sp,
                                                  textColor: AppColors.primary,
                                                  fontWeight: FontWeight.w500,
                                                  textAlign: TextAlign.center,
                                                  textOverflow: TextOverflow.ellipsis,
                                                  maxLines: 2,
                                                ),
                                                AppSizedBox.space20h,
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
                                  ),
            
                              ],
                            ),
                        ],
                      )
            
            
            
            
            
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}

/*Shimmer.fromColors(
                period: const Duration(milliseconds: 1000),
                baseColor: themeController.isDarkMode.value
                    ? AppColors.black.withOpacity(0.02)
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
              )*/