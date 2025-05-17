import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icons.dart';
import 'package:noor_e_quran/app/config/app_colors.dart';
import 'package:noor_e_quran/app/config/app_sizedbox.dart';
import 'package:noor_e_quran/app/controllers/app_theme_switch_controller.dart';
import 'package:noor_e_quran/app/modules/home/views/app_home_base_screen.dart';
import 'package:noor_e_quran/app/modules/home/views/names_of_allah_screen.dart';
import 'package:noor_e_quran/app/modules/home/views/qibla_direction_screen.dart';
import 'package:noor_e_quran/app/modules/home/views/view_all_feature_screen.dart';
import 'package:noor_e_quran/app/modules/home/views/view_all_prayer_screen.dart';
import 'package:noor_e_quran/app/modules/quran/views/quran_surah_detail_screen.dart';
import 'package:noor_e_quran/app/widgets/custom_card.dart';
import 'package:noor_e_quran/app/widgets/custom_text.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../config/app_contants.dart';
import '../../../controllers/flying_bird_animation_controller.dart';
import '../../../controllers/user_location_premission_controller.dart';
import '../../../models/name_of_allah_model.dart';
import '../../../widgets/custom_frame.dart';
import '../../common/views/dua_detail_screen.dart';
import '../controllers/app_home_screen_controller.dart';
import '../controllers/name_of_allah_controller.dart';
import '../controllers/view_all_prayer_screen_controller.dart';
import 'app_home_screen_header.dart';
import 'donation_organization_profile.dart';
import 'makkah_live_transmission_screen.dart';

class AppHomeScreen extends StatelessWidget {
  AppHomeScreen({super.key});

  final AppHomeScreenController controller = Get.put(AppHomeScreenController());
  final UserPermissionController locationController = Get.find<UserPermissionController>();
  final NamazController namazController = Get.find<NamazController>();
  final FlyingBirdAnimationController _homeBirdController = Get.put(FlyingBirdAnimationController(), tag: 'home_bird');
  final AppThemeSwitchController appThemeSwitchController = Get.put(AppThemeSwitchController());



  @override
  Widget build(BuildContext context) {
    return AppHomeBaseScreen(
      titleFirstPart: "Noor e",
      titleSecondPart: " Quran",
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HomeScreenHeader(birdController: _homeBirdController,),

          // Upcoming Prayers
          _buildSectionHeader(
            "Upcoming Prayers",
            onViewAll: () => Get.to(() => ViewAllPrayerScreen()),
          ),
          AppSizedBox.space15h,
          _buildPrayerTimes(),

          // Make a Difference
          AppSizedBox.space15h,
          _buildSectionHeader(
            "Make a Difference",
            onViewAll: () => Get.to(OrganizationProfileScreen()),
          ),
          AppSizedBox.space15h,
          _buildDonationSlider(),

          // Explore Features
          AppSizedBox.space15h,
          _buildSectionHeader("Explore Features", showViewAll: true, onViewAll: (){Get.to(ViewAllFeatureScreen());}),
          AppSizedBox.space15h,
          _buildFeatureGrid(context),

          // Qibla Direction
          AppSizedBox.space5h,
          _buildSectionHeader("Qibla Direction", showViewAll: false),
          AppSizedBox.space10h,
          InkWell(
            // onTap: () => Get.to(QiblaScreen(city: locationController.cityName.toString())),
            child: CustomCard(
              title: "Locate the Kaaba",
              subtitle: "Ensuring Correct Prayer Direction",
              imageUrl: controller.themeController.isDarkMode.value
                  ? "assets/images/sajdah_bg_dark.jpg"
                  : "assets/images/sajdah_bg_light.jpg",
              mergeWithGradientImage: true,
              titleFontSize: 18.sp,
              subtitleFontSize: 12.sp,
            ),
          ),

          // Daily Recommended Surahs
          AppSizedBox.space15h,
          _buildSectionHeader("Daily Recommended Surahs", showViewAll: false),
          _buildRecommendedSurahs(),
          AppSizedBox.space10h,
          Align(
            alignment: Alignment.center,
            child: SmoothPageIndicator(
              controller: controller.dailySurahsPageController,
              count: controller.recommendedSurahs.length,
              effect: WormEffect(
                dotColor: AppColors.grey.withOpacity(0.2),
                activeDotColor: AppColors.primary,
                dotHeight: 6.h,
                dotWidth: 6.w,
                spacing: 6.w,
              ),
            ),
          ),
          AppSizedBox.space15h,
          _buildSectionHeader(
            "Shahadat",
            showViewAll: false
          ),
          AppSizedBox.space15h,
          CustomCard(
            title: "أَشْهَدُ أَنْ لَا إِلَـٰهَ إِلَّا اللَّـٰهُ وَأَشْهَدُ أَنَّ مُحَمَّدًا رَسُولُ اللَّـٰهِ",
            subtitle: "I bear witness that there is none worthy of worship except Allah, the One alone, without partner, and I bear witness that Muhammad is His servant and Messenger",
            imageUrl: controller.themeController.isDarkMode.value
                ? "assets/images/shahadat_bg_dark.jpg"
                : "assets/images/shahadat_bg_light.jpg",
            mergeWithGradientImage: true,
            titleFontSize: 22.sp,
            titleAlign: TextAlign.end,
            subtitleFontSize: 12.sp,
            subtitleAlign: TextAlign.start,
          ),
          AppSizedBox.space15h,
          // _buildNamesOfAllah(),
          _buildSectionHeader("Divine Names", showViewAll: true, onViewAll: (){Get.to(NameOfAllahScreen());}),
          AppSizedBox.space15h,
          _buildNamesOfAllah(context),
          AppSizedBox.space15h,
          _buildSectionHeader("Live Transmission", showViewAll: false,),
          AppSizedBox.space15h,
          _buildLiveStreamsRow(),
          AppSizedBox.space15h,
        ],
      ),
    );
  }

  final List<Map<String, dynamic>> _liveStreams = [
    {
      'title': 'Makkah',
      'image': 'assets/images/makkah_live_bg.jpg',
      'videoId': '2Gub8-cSH9c',
    },
    {
      'title': 'Madinah',
      'image': 'assets/images/masjid_nabvi.jpg',
      'videoId': 'BviEnfIS70c',
    },
  ];

  Widget _buildLiveStreamsRow() {
    return Row(
      children: [
        for (var stream in _liveStreams) ...[
          Expanded(child: _buildLiveStreamCard(stream)),
          if (stream != _liveStreams.last) AppSizedBox.space10w,
        ],
      ],
    );
  }


  Widget _buildLiveStreamCard(Map<String, dynamic> stream) {
    return InkWell(
      onTap: () => Get.to(() => LiveTransmissionScreen(
        videoId: stream['videoId'],
        title: stream['title'],
      )),
      child: Container(
        height: 180.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          image: DecorationImage(
            image: AssetImage(stream['image']),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.r),
                gradient: LinearGradient(
                  end: Alignment.bottomLeft,
                  colors: [AppColors.transparent, AppColors.black.withOpacity(0.9)],
                ),
              ),
            ),
            Center(
              child: Container(
                padding: EdgeInsets.all(12.r),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary.withOpacity(0.7),
                ),
                child: Icon(Icons.play_arrow, size: 30.sp, color: AppColors.white),
              ),
            ),
            Positioned(
              bottom: 10.h,
              left: 10.w,
              right: 10.w,
              child: CustomText(
                title: stream['title'],
                textColor: AppColors.white,
                fontSize: 16.sp,
                textAlign: TextAlign.start,
              ),
            ),
          ],
        ),
      ),
    );
  }


Widget _buildNamesOfAllah(BuildContext context) {
    return  GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2,
        childAspectRatio: 1,
        crossAxisSpacing: 12,
      ),
      itemCount: controller.randomNames.length,
      itemBuilder: (context, index) {
        final menuItem = controller.randomNames[index];
        final name = menuItem; // Changed from NameOfAllah name to menuItem
        return Obx(() => InkWell(
          onTap: (){
            Get.to(DuaDetailCommonScreen(
              arabicDua: name.arabicName,
              audioUrl: "",
              duaTranslation: name.paragraph,
              duaUrduTranslation: "",
              engFirstTitle: name.englishName,
              showAudiotWidgets: false,
              engSecondTitle: "",
              latinTitle: "",
              isComingFromAllahNameScreen: true,
            ));
          },
          highlightColor: AppColors.transparent,
          splashColor: AppColors.transparent,
          child: Container(
            margin: EdgeInsets.only(bottom: 10.h),
            decoration: BoxDecoration(
              color: controller.themeController.isDarkMode.value
                  ? AppColors.black
                  : AppColors.white,
              borderRadius: BorderRadius.circular(10.r),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 2,
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
                          title: name.arabicName, // changed from nam to name.arabicName
                          fontSize: 22.sp,
                          textColor: controller.themeController.isDarkMode.value
                              ? AppColors.white
                              : AppColors.black,
                          fontFamily: 'grenda',
                          maxLines: 2,
                        ),
                        CustomText(
                          title: name.englishName, //changed from menuItem['subtitle']! to name.englishName
                          fontSize: 12.sp,
                          textColor: AppColors.primary,
                          fontWeight: FontWeight.w500,
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
    );
  }





  Widget _buildSectionHeader(String title, {VoidCallback? onViewAll, bool showViewAll = true}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Obx(() => CustomText(
            title: title,
            textColor: controller.themeController.isDarkMode.value ? AppColors.white : AppColors.black,
            fontSize: 16.sp,
            fontFamily: 'grenda',
            textAlign: TextAlign.start,
          )),
        ),
        if (showViewAll) // Conditionally include the "View All" section
          Expanded(
            child: InkWell(
              hoverColor: AppColors.transparent,
              splashColor: AppColors.transparent,
              highlightColor: AppColors.transparent,
              onTap: onViewAll,
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
    );
  }


  Widget _buildPrayerTimes() {
    return Obx(() {
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
                Positioned.fill(
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
                          locationController.locationAccessed.value
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
                ),
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
                child: namazController.isNamazLoading.value
                    ? _buildPrayerTimesShimmer()
                    : _buildPrayerTimesList(),
              ),
            )
          ],
        ),
      );
    });
  }

  Widget _buildPrayerTimesShimmer() {
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
              Container(width: 60.w, height: 10.h, color: AppColors.lightGrey),
              Container(width: 30.w, height: 30.h, color: AppColors.lightGrey),
              Container(width: 60.w, height: 10.h, color: AppColors.lightGrey),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPrayerTimesList() {
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
        final isDark = controller.themeController.isDarkMode.value;

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
                    : isDark ? AppColors.white : AppColors.black,
                textStyle: GoogleFonts.quicksand(),
              ),
              Stack(
                alignment: Alignment.center,
                children: [
                  SvgPicture.asset(
                    height: 16.h,
                    "assets/images/$iconName",
                    color: isNextNamaz
                        ? (isDark ? AppColors.white : AppColors.primary)
                        : (isDark ? AppColors.white : AppColors.black),
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
                    : isDark ? AppColors.white : AppColors.black,
                textStyle: GoogleFonts.quicksand(),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDonationSlider() {
    return SizedBox(
      height: 0.22.sh,
      child: PageView.builder(
        controller: controller.pageController,
        itemCount: AppConstants.sliderItems.length,
        onPageChanged: (index) => controller.currentPage.value = index,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.w),
            child: Column(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12.r),
                    child: Stack(
                      children: [
                        SizedBox.expand( // Use SizedBox.expand
                          child: Image.asset(
                            AppConstants.sliderItems[index]['image']!,
                            fit: BoxFit.cover,
                          ),
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
                                textAlign: TextAlign.start,
                              ),
                              CustomText(
                                title: AppConstants.sliderItems[index]['subtitle']!,
                                textColor: AppColors.white.withOpacity(0.9),
                                fontSize: 12.sp,
                                fontFamily: 'quicksand',
                                maxLines: 2,
                                textAlign: TextAlign.start,
                              ),
                              AppSizedBox.space5h,
                              const Divider(),
                              AppSizedBox.space5h,
                              CustomText(
                                title: AppConstants.sliderItems[index]['reference']!,
                                textColor: AppColors.white.withOpacity(0.9),
                                fontSize: 10.sp,
                                fontFamily: 'quicksand',
                                fontWeight: FontWeight.bold,
                                textStyle: const TextStyle(fontStyle: FontStyle.italic),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                AppSizedBox.space10h,
                SmoothPageIndicator(
                  controller: controller.pageController,
                  count: AppConstants.sliderItems.length,
                  effect: WormEffect(
                    dotColor: AppColors.grey.withOpacity(0.2),
                    activeDotColor: AppColors.primary,
                    dotHeight: 6.h,
                    dotWidth: 6.w,
                    spacing: 4.w,
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }


  Widget _buildFeatureGrid(BuildContext context) {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2,
        childAspectRatio: 1,
        crossAxisSpacing: 12,
      ),
      itemCount: controller.menuItems.length,
      itemBuilder: (context, index) {
        final menuItem = controller.menuItems[index];
        return Obx(() => InkWell(
          highlightColor: AppColors.transparent,
          splashColor: AppColors.transparent,
          onTap: () => Get.to(menuItem['destination']()),
          child: Container(
            margin: EdgeInsets.only(bottom: 10.h),
            decoration: BoxDecoration(
              color: controller.themeController.isDarkMode.value
                  ? AppColors.black
                  : AppColors.white,
              borderRadius: BorderRadius.circular(10.r),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 2,
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
                          fontFamily: 'grenda',
                          maxLines: 2,
                        ),
                        CustomText(
                          title: menuItem['subtitle']!,
                          fontSize: 12.sp,
                          textColor: AppColors.primary,
                          fontWeight: FontWeight.w500,
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
    );
  }

  Widget _buildRecommendedSurahs() {
    return SizedBox(
      height: 220.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        controller: controller.dailySurahsPageController,
        itemCount: controller.recommendedSurahs.length,
        separatorBuilder: (context, index) => SizedBox(width: 10),
        itemBuilder: (context, index) {
          final surah = controller.recommendedSurahs[index];
          final containerWidth = MediaQuery.of(context).size.width * 0.8;

          return Obx(()=>GestureDetector(
            onTap: () {
              controller.addSurahToLastAccessed(surah.number);
              Get.to(QuranSurahDetailScreen(surahNumber: surah.number));
            },
            child: Container(
              width: containerWidth,
              margin: EdgeInsets.symmetric(vertical: 10.h, horizontal: 5.w),
              decoration: BoxDecoration(
                color: controller.themeController.isDarkMode.value
                    ? AppColors.black
                    : AppColors.white,
                borderRadius: BorderRadius.circular(10.r),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 2,
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Image.asset("assets/frames/topLeftFrame.png", height: 40),
                        Image.asset("assets/frames/topRightFrame.png", height: 40),
                      ],
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomText(
                            title: surah.arabicName,
                            fontSize: 40.sp,
                            textColor: AppColors.primary,
                          ),
                          CustomText(
                            title: surah.name,
                            fontSize: 18.sp,
                            textColor: controller.themeController.isDarkMode.value
                                ? AppColors.white
                                : AppColors.black,
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Image.asset("assets/frames/bottomLeftFrame.png", height: 40),
                        Image.asset("assets/frames/bottomRightFrame.png", height: 40),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ));
        },
      ),
    );
  }
}