import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:noor_e_quran/app/config/app_colors.dart';
import 'package:noor_e_quran/app/config/app_sizedbox.dart';
import 'package:noor_e_quran/app/controllers/app_theme_switch_controller.dart';
import 'package:noor_e_quran/app/modules/home/views/qibla_screen.dart';
import 'package:noor_e_quran/app/modules/home/views/view_all_namaz_screen.dart';
import 'package:noor_e_quran/app/widgets/custom_card.dart';
import 'package:noor_e_quran/app/widgets/custom_text.dart';
import 'package:quran/quran.dart' as quran;
import '../../../widgets/custom_frame.dart';
import '../../../widgets/custom_marquee.dart';
import '../../prayer/views/prayer_main_screen.dart';
import '../../quran/views/quran_menu_screen.dart';
import '../../quran/views/quran_surah_detail_screen.dart';
import '../../quran/views/quran_verse_of_the_hour_screen.dart';
import '../../tasbeeh/views/tasbeeh_counter_screen.dart';
import '../controllers/app_home_screen_controller.dart';
import 'app_home_screen_header.dart';
import 'base_home_screen.dart';
import 'islamic_calender_screen.dart';
import 'package:noor_e_quran/app/controllers/flying_bird_animation_controller.dart';
import 'package:noor_e_quran/app/controllers/user_location_premission_controller.dart';


class AppHomeScreen extends StatelessWidget {
  final Map<String, dynamic>? userData;
  final FlyingBirdAnimationController _homeBirdController = Get.put(FlyingBirdAnimationController(), tag: 'home_bird');
  final UserPermissionController locationPermissionScreenController = Get.find<UserPermissionController>();
  final AppHomeScreenController homeScreenController = Get.find<AppHomeScreenController>();
  final AppThemeSwitchController themeController = Get.find<AppThemeSwitchController>();

  AppHomeScreen({super.key, this.userData});

  @override
  Widget build(BuildContext context) {

    return BaseHomeScreen(
      titleFirstPart: "Noor e",
      titleSecondPart: " Quran",
      birdController: _homeBirdController,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HomeScreenHeader(birdController: _homeBirdController),
          AppSizedBox.space5h,
          CustomMarquee(),
          if (homeScreenController.lastAccessedSurahs.isNotEmpty) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Obx(() => CustomText(
                    title: "Last Accessed Surah",
                    textColor: themeController.isDarkMode.value
                        ? AppColors.white
                        : AppColors.black,
                    fontSize: 18.sp,
                    fontFamily: 'grenda',
                    textAlign: TextAlign.start,
                    textOverflow: TextOverflow.ellipsis,
                  )),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () => Get.to(() => ViewAllNamazScreen()),
                    child: CustomText(
                      title: "View All",
                      textColor: AppColors.primary,
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
            GetBuilder<AppHomeScreenController>(
              builder: (controller) {
                if (controller.lastAccessedSurahs.isEmpty) {
                  return Center(child: Text('No recent activity.'));
                }
                final sortedSurahs = List<Map<String, dynamic>>.from(controller.lastAccessedSurahs)
                  ..sort((a, b) => controller.parseAccessTime(b['accessTime']).compareTo(controller.parseAccessTime(a['accessTime'])));
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
                                  Obx(()=>CustomText(
                                    title: surahName,
                                    fontSize: 15.sp,
                                    textColor: themeController.isDarkMode.value ? AppColors.white : AppColors.black,
                                    fontWeight: FontWeight.w500,
                                    textOverflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    textAlign: TextAlign.start,),
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
                              subtitle: Obx(()=>CustomText(
                                title: 'Last Accessed $formattedTime',
                                fontSize: 12.sp,
                                textColor: themeController.isDarkMode.value  ? AppColors.grey : AppColors.black,
                                fontWeight: FontWeight.w500,
                                textOverflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                textAlign: TextAlign.start,),
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
          AppSizedBox.space10h,
          Obx(() => CustomText(
            title: "Verse Of The Hour",
            textColor: themeController.isDarkMode.value ? AppColors.white : AppColors.black,
            fontSize: 18.sp,
            fontFamily: 'grenda',
            textAlign: TextAlign.start,
            textOverflow: TextOverflow.ellipsis,
          )),
          AppSizedBox.space10h,
          Stack(
            children: [
              InkWell(
                splashColor: AppColors.transparent,
                highlightColor: AppColors.transparent,
                onTap: () {
                  Get.to(VerseOfHourScreen(
                    surahNumber: homeScreenController.randomVerse.value.surahNumber,
                    verseNumber: homeScreenController.randomVerse.value.verseNumber,
                    arabicText: homeScreenController.randomVerse.value.verse,
                    translation: homeScreenController.randomVerse.value.translation,
                    title: quran.getSurahName(homeScreenController.randomVerse.value.surahNumber),
                    surahArabicTitle: quran.getSurahNameArabic(homeScreenController.randomVerse.value.surahNumber),
                  ));
                },
                child: Obx(()=>Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                          themeController.isDarkMode.value
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
                          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h).copyWith(right: 20.w),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Obx(() =>
                                  CustomText(
                                    title: homeScreenController.randomVerse.value.verse,
                                    textAlign: TextAlign.end,
                                    textColor: AppColors.white,
                                    fontSize: 20.sp,
                                    maxLines: 1,
                                  )),
                              AppSizedBox.space5h,
                              Obx(() =>
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: CustomText(
                                      title: homeScreenController.randomVerse.value.translation,
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
                                    child: Obx(() =>
                                        CustomText(
                                          title: 'Surah ${quran.getSurahName(homeScreenController
                                              .randomVerse.value.surahNumber)} | Surah No. ${homeScreenController
                                              .randomVerse.value
                                              .surahNumber} | Verse No.${homeScreenController
                                              .randomVerse.value
                                              .verseNumber}',
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
                    ],
                  ),
                ),)
              ),
            ],
          ),
          AppSizedBox.space15h,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Obx(()=>CustomText(
                  title: "Upcoming Prayers",
                  textColor: themeController.isDarkMode.value ? AppColors.white : AppColors.black,
                  fontSize: 18.sp,
                  fontFamily: 'grenda',
                  textAlign: TextAlign.start,
                  textOverflow: TextOverflow.ellipsis,
                ),)
              ),
              Expanded(
                child: InkWell(
                  onTap: () => Get.to(ViewAllNamazScreen()),
                  child: CustomText(
                    title: "View All",
                    textColor:  AppColors.primary,
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
          Obx(()=>Container(
            decoration: BoxDecoration(
              color: AppColors.transparent,
              boxShadow: [
                BoxShadow(
                  color: themeController.isDarkMode.value ? AppColors.primary.withOpacity(0.1) : AppColors.primary.withOpacity(0.1),
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
                          image: AssetImage(themeController.isDarkMode.value
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
                              padding: EdgeInsets.symmetric(horizontal: 15.w),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  locationPermissionScreenController.locationAccessed.value
                                      ? CustomText(
                                    title: homeScreenController.nextNamazName.value.isNotEmpty &&
                                        homeScreenController.nextNamazTime.value != null
                                        ? '${homeScreenController.nextNamazName.value} ${DateFormat('h:mm a').format(homeScreenController.nextNamazTime.value!)}'
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
                                  Obx(() => CustomText(
                                    textColor: AppColors.white,
                                    fontSize: 24.sp,
                                    title: homeScreenController.timeRemaining.value, // Use the RxString
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
                    color: themeController.isDarkMode.value ? AppColors.black : AppColors.white,
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
                          margin: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CustomText(
                                title: namazName,
                                fontSize: 13.sp,
                                textColor: isNextNamaz ? AppColors.secondry : isLoading ? Colors.grey : themeController.isDarkMode.value ? AppColors.white : AppColors.black,
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
                                    color: isNextNamaz ? (themeController.isDarkMode.value ? AppColors.white : AppColors.primary)
                                        : (themeController.isDarkMode.value ? AppColors
                                        .white : AppColors.black),
                                  ),
                                  if (isNextNamaz)
                                    Container(
                                      height: 25.h,
                                      width: 25.w,
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
                                textColor: isNextNamaz ? AppColors.secondry : themeController.isDarkMode.value ? AppColors.white : AppColors.black,
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
          ),),
          AppSizedBox.space15h,
          Obx(()=>CustomText(
            title: "Find your Qibla ",
            textColor: themeController.isDarkMode.value ? AppColors.white : AppColors.black,
            fontSize: 18.sp,
            fontFamily: 'grenda',
            maxLines: 1,
            textOverflow: TextOverflow.ellipsis,
          ),),
          AppSizedBox.space10h,
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
          AppSizedBox.space10h,
          Obx(()=>CustomText(
            title: "Strengthen Your Iman Daily",
            textColor:  themeController.isDarkMode.value ? AppColors.white : AppColors.black,
            fontSize: 18.sp,
            fontFamily: 'grenda',
            maxLines: 1,
            textOverflow: TextOverflow.ellipsis,
          ),),
          AppSizedBox.space10h,
          Column(
            children: [
              SingleChildScrollView(
                child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(), // To disable GridView's scrolling
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2,
                    childAspectRatio: 1,
                  ),
                  itemCount: menuItems.length,
                  itemBuilder: (context, index) {
                    final menuItem = menuItems[index];
                    return Obx(
                          () => InkWell(
                        highlightColor: AppColors.transparent,
                        splashColor: AppColors.transparent,
                        onTap: () {
                          Get.to(menuItem['destination']());
                        },
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
                                      fontSize: 18.sp,
                                      textColor: themeController.isDarkMode.value ? AppColors.white : AppColors.black,
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
                    );
                  },
                ),
              )
            ],
          )

        ],
      ),
    );
  }
  final List<Map<String, dynamic>> menuItems = [
    {"title": "Quran", "subtitle": "Recitation", "destination": () => QuranMenuScreen()},
    {"title": "Tasbeeh", "subtitle": "Counter", "destination": () => TasbeehCounterScreen()},
    {"title": "Salah", "subtitle": "Practices", "destination": () => PrayerMainScreen()},
    {"title": "Islamic", "subtitle": "Calender", "destination": () => IslamicCalendarScreen()},
  ];

}
