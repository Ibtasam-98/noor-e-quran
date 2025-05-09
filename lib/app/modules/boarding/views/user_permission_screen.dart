import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:line_icons/line_icons.dart';
import 'package:noor_e_quran/app/config/app_colors.dart';
import 'package:noor_e_quran/app/config/app_sizedbox.dart';
import 'package:noor_e_quran/app/config/app_contants.dart';
import 'package:noor_e_quran/app/controllers/app_theme_switch_controller.dart';
import 'package:noor_e_quran/app/widgets/custom_appbar.dart';
import 'package:noor_e_quran/app/widgets/custom_button.dart';
import 'package:noor_e_quran/app/widgets/custom_text.dart';
import '../../../controllers/connectivity_controller.dart';
import '../../../controllers/user_location_premission_controller.dart';
import '../../../widgets/custom_snackbar.dart';
import '../../home/views/home_screen_bottom_navigation.dart';

class UserPermissionScreen extends StatelessWidget {
  final AppThemeSwitchController themeSwitchController = Get.put(AppThemeSwitchController());
  final UserPermissionController userPermissionController = Get.put(UserPermissionController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      bool isDarkMode = themeSwitchController.isDarkMode.value;
      return Scaffold(
        backgroundColor: isDarkMode ? AppColors.black : AppColors.white,
        appBar: CustomAppBar(
          firstText: AppConstants.appPrimaryTitle,
          secondText: AppConstants.appSecondryTitle,
          firstTextColor: isDarkMode ? AppColors.white: AppColors.black,
          secondTextColor: AppColors.primary,
          addSpace: true,
        ),
        body: Column(
          children: [
            _buildProgressIndicator(),
            Expanded(
              child: PageView(
                controller: userPermissionController.pageController,
                physics: userPermissionController.canSwipe.value ? null : NeverScrollableScrollPhysics(),
                onPageChanged: (int page) => userPermissionController.currentPage.value = page,
                children: [
                  _buildConnectionScreen(isDarkMode),
                  _buildLocationScreen(isDarkMode),
                  _buildThemeScreen(isDarkMode),
                  _buildWelcomeScreen(isDarkMode),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildProgressIndicator() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 15.w),
      child: SizedBox(
        height: 4.h,
        child: Obx(() => LinearProgressIndicator(
          value: (userPermissionController.currentPage.value + 1) / 4,
          backgroundColor: AppColors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(5),
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
        )),
      ),
    );
  }

  Widget _buildScreenHeader(String title, String description, bool isDarkMode, {int maxLines = 2}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          title: title,
          fontSize: 20.sp,
          fontFamily: 'grenda',
          textAlign: TextAlign.start,
          textColor: AppColors.primary,
          maxLines: 2,
          textOverflow: TextOverflow.ellipsis,
        ),
        CustomText(
          fontSize: 15.sp,
          title: description,
          textAlign: TextAlign.start,
          textColor: isDarkMode ? AppColors.white : AppColors.black,
          maxLines: maxLines,
          textOverflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildConnectionScreen(bool isDarkMode) {
    final ConnectivityController connectivityController = Get.find<ConnectivityController>();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildScreenHeader(
            "Checking Internet Connection",
            "Internet is required to download Quran, Hadith and Prayer timings.",
            isDarkMode,
          ),
          AppSizedBox.space10h,
          Obx(() => CustomText(
            fontSize: 15.sp,
            title: connectivityController.internetCheckCompleted.value
                ? "Internet connection successfully."
                : "Please click the Check button below complete the checking process.",
            textAlign: TextAlign.start,
            textColor: isDarkMode ? AppColors.white : AppColors.black,
            maxLines: 2,
            textOverflow: TextOverflow.ellipsis,
          )),
          const Spacer(),
          Obx(() {
            return Column(
              children: [
                if (!connectivityController.internetCheckCompleted.value)
                  _buildActionButton(
                    'Check',
                    connectivityController.isLoading.value,
                        () async {
                      await connectivityController.checkConnectivity();
                      if (connectivityController.isConnected.value) {
                        connectivityController.internetCheckCompleted.value = true;
                        Future.delayed(const Duration(seconds: 2), () {
                          connectivityController.showNextButton.value = true;
                          userPermissionController.enableSwipeFunction(true);
                        });
                      } else {
                        CustomSnackbar.show(
                          backgroundColor: AppColors.red,
                          title: "No Internet Connection",
                          subtitle: "Please connect to Wi-Fi or cellular data.",
                          icon: Icon(LineIcons.wifi),
                        );
                      }
                    },
                  ),
                if (connectivityController.internetCheckCompleted.value)
                  AnimatedOpacity(
                    opacity: connectivityController.showNextButton.value ? 1.0 : 0.0,
                    duration: const Duration(seconds: 5),
                    child: _buildActionButton(
                      'Next',
                      false,
                          () => userPermissionController.nextPage(),
                    ),
                  ),
                AppSizedBox.space30h,
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildLocationScreen(bool isDarkMode) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildScreenHeader(
            "Allow Location access",
            "Enabling access allows us to automatically calculate accurate prayer times based on your current location, ensuring you never miss a prayer.",
            isDarkMode,
            maxLines: 3,
          ),
          AppSizedBox.space15h,
          Obx(() {
            if (userPermissionController.locationAccessed.value) {
              return Row(
                children: [
                  Icon(Icons.location_on_outlined, color: isDarkMode ? AppColors.white : AppColors.black),
                  AppSizedBox.space10w,
                  CustomText(
                    title: '${userPermissionController.cityName}, ${userPermissionController.countryName}',
                    fontSize: 15.sp,
                    textColor: isDarkMode ? AppColors.white : AppColors.black,
                  ),
                ],
              );
            }
            return const SizedBox();
          }),
          const Spacer(),
          Obx(() => _buildActionButton(
            userPermissionController.locationAccessed.value && userPermissionController.allowSwipe.value
                ? 'Next'
                : 'Access Location',
            userPermissionController.isLoading.value,
                () {
              if (userPermissionController.locationAccessed.value && userPermissionController.allowSwipe.value) {
                userPermissionController.nextPage();
                userPermissionController.enableSwipeForThemeFunction(true);
              } else {
                userPermissionController.accessLocation();
              }
            },
          )),
          AppSizedBox.space30h,
        ],
      ),
    );
  }

  Widget _buildThemeScreen(bool isDarkMode) {
    final AppThemeSwitchController themeController = Get.put(AppThemeSwitchController());
    final List<Map<String, dynamic>> themeOptions = [
      {'title': 'Light Mode', 'isDark': false, 'image': 'assets/images/theme_light_bg.jpg'},
      {'title': 'Dark Mode', 'isDark': true, 'image': 'assets/images/theme_dark_bg.jpg'},
    ];

    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildScreenHeader(
                "Choose Theme",
                "Choose your preferred theme from the options presented below. Select either Light Mode for a bright and vibrant interface, or Dark Mode for a sleek and comfortable experience, especially in low-light environments.",
                isDarkMode,
                maxLines: 2,
              ),
              AppSizedBox.space20h,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: themeOptions.map((option) =>
                    _buildThemeCard(
                      option['title'],
                      option['isDark'],
                      themeController.isDarkMode.value == option['isDark'],
                      option['image'],
                    )
                ).toList(),
              ),
            ],
          ),
        ),
        Positioned(
          left: 15.w,
          right: 15.w,
          bottom: 30.h,
          child: _buildActionButton(
            "Next",
            false,
            userPermissionController.nextPage,
          ),
        ),
      ],
    );
  }

  Widget _buildThemeCard(String title, bool isDarkMode, bool isSelected, String imagePath) {
    final AppThemeSwitchController themeController = Get.put(AppThemeSwitchController());
    return SizedBox(
      height: 180.h,
      width: 150.w,
      child: Column(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                if (themeController.isDarkMode.value != isDarkMode) {
                  themeController.toggleTheme();
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : isDarkMode ? Colors.black87 : AppColors.primary,
                  borderRadius: BorderRadius.circular(15.r),
                  border: isSelected ? Border.all(
                    color: isDarkMode ? AppColors.white : AppColors.primary,
                    width: 2.w,
                  ) : null,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.r),
                          image: DecorationImage(
                            image: AssetImage(imagePath),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 8.h),
            child: CustomText(
              title: title,
              fontSize: 15.sp,
              textColor: isSelected ? AppColors.primary : isDarkMode ? AppColors.black : AppColors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeScreen(bool isDarkMode) {
    final ConnectivityController connectivityController = Get.put(ConnectivityController());
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      child: Column(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  fontSize: 20.sp,
                  title: AppConstants.onboardingTitle,
                  fontFamily: 'grenda',
                  textColor: AppColors.primary,
                  textAlign: TextAlign.start,
                  maxLines: 2,
                  textOverflow: TextOverflow.ellipsis,
                ),
                AppSizedBox.space10h,
                Align(
                  alignment: Alignment.centerRight,
                  child: CustomText(
                    fontSize: 30.sp,
                    textAlign: TextAlign.end,
                    textColor: isDarkMode ? AppColors.white : AppColors.primary,
                    title: AppConstants.bismillah,
                    maxLines: 2,
                    textOverflow: TextOverflow.ellipsis,
                  ),
                ),
                AppSizedBox.space15h,
                CustomText(
                  title: AppConstants.appWelcomeHeaderLine,
                  textAlign: TextAlign.start,
                  textColor: isDarkMode ? AppColors.white : AppColors.black,
                  fontSize: 15.sp,
                  maxLines: 4,
                  textOverflow: TextOverflow.ellipsis,
                ),
                AppSizedBox.space15h,
                Container(
                  padding: EdgeInsets.all(15.w),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.26),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: CustomText(
                    title: AppConstants.appWelcomeQuranicVerseArabic,
                    fontSize: 15.sp,
                    textAlign: TextAlign.end,
                    maxLines: 3,
                    textOverflow: TextOverflow.ellipsis,
                    textColor: isDarkMode ? AppColors.white : AppColors.black,
                  ),
                ),
                AppSizedBox.space15h,
                CustomText(
                  title: AppConstants.appWelcomeQuranicVerseTranslation,
                  fontSize: 14.sp,
                  textAlign: TextAlign.start,
                  textColor: isDarkMode ? AppColors.white : AppColors.black,
                  maxLines: 4,
                  textOverflow: TextOverflow.ellipsis,
                ),
                AppSizedBox.space10h,
                Align(
                  alignment: Alignment.centerLeft,
                  child: CustomText(
                    title: AppConstants.appWelcomeQuranicVerseReference,
                    fontSize: 12.sp,
                    textAlign: TextAlign.start,
                    textColor: isDarkMode ? AppColors.white.withOpacity(0.3) : AppColors.black,
                    textStyle: TextStyle(fontStyle: FontStyle.italic),
                    maxLines: 2,
                    textOverflow: TextOverflow.ellipsis,
                  ),
                ),
                AppSizedBox.space15h,
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(bottom: 30.h),
              child: _buildActionButton(
                AppConstants.exploreAppHeading,
                false,
                    () {
                  if (connectivityController.internetCheckCompleted.value && userPermissionController.locationAccessed.value) {
                    final box = GetStorage();
                    box.write('hasSeenOnboarding', true);
                    Get.offAll(AppHomeScreenBottomNavigation());
                  } else if (!connectivityController.internetCheckCompleted.value && !userPermissionController.locationAccessed.value) {
                    CustomSnackbar.show(
                      backgroundColor: AppColors.red,
                      title: "Complete Setup",
                      subtitle: "Ensure you've enabled both internet and location services.",
                      icon: Icon(LineIcons.exclamationTriangle),
                    );
                  } else if (!connectivityController.internetCheckCompleted.value) {
                    CustomSnackbar.show(
                      backgroundColor: AppColors.red,
                      title: "Check Internet Connection",
                      subtitle: "Please check internet connection first.",
                      icon: Icon(LineIcons.wifi),
                    );
                  } else {
                    CustomSnackbar.show(
                      backgroundColor: AppColors.red,
                      title: "Allow Location Access",
                      subtitle: "Please allow location access first.",
                      icon: Icon(LineIcons.mapMarked),
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(String title, bool isLoading, VoidCallback onTap) {
    return CustomButton(
      useGradient: true,
      gradient: LinearGradient(
        colors: [
          AppColors.primary,
          AppColors.secondry.withOpacity(0.9),
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
      height: 45.h,
      haveBgColor: true,
      borderRadius: 45.r,
      btnTitle: title,
      btnTitleColor: Colors.white,
      bgColor: AppColors.primary,
      isLoading: isLoading,
      onTap: onTap,
    );
  }
}