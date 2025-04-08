

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:line_icons/line_icons.dart';
import 'package:noor_e_quran/app/config/app_colors.dart';
import 'package:noor_e_quran/app/config/app_sizedbox.dart';
import 'package:noor_e_quran/app/controllers/app_theme_switch_controller.dart';
import 'package:noor_e_quran/app/widgets/custom_button.dart';
import 'package:noor_e_quran/app/widgets/custom_text.dart';
import '../../controllers/connectivity_controller.dart';
import '../../controllers/onboarding_controller.dart';
import '../../controllers/user_location_premission_controller.dart';
import '../../widgets/custom_snackbar.dart';
import '../home/home_screen_bottom_navigation.dart';


class UserPermissionScreen extends StatelessWidget {
  final AppThemeSwitchController themeSwitchController = Get.put(AppThemeSwitchController());
  final UserPermissionScreenController userPermissionController = Get.put(UserPermissionScreenController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      bool isDarkMode = themeSwitchController.isDarkMode.value;
      return Scaffold(
        backgroundColor: isDarkMode ? Colors.black : AppColors.white,
        appBar: AppBar(
          backgroundColor: isDarkMode ? Colors.black : AppColors.white,
          centerTitle: false,
          title: CustomText(
            firstText: "Noor e",
            secondText: " Quran",
            fontSize: 18.sp,
            firstTextColor: isDarkMode ? AppColors.white : AppColors.black,
            secondTextColor: AppColors.primary,
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: isDarkMode ? AppColors.white : AppColors.black),
            onPressed: () => Get.back(),
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 15.w),
              child: LinearProgressIndicator(
                value: (userPermissionController.currentPage.value + 1) / 4,
                backgroundColor: AppColors.grey,
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
              ),
            ),
            Expanded(
              child: PageView(
                controller: userPermissionController.pageController,
                physics: userPermissionController.canSwipe.value ? null : NeverScrollableScrollPhysics(),
                onPageChanged: (int page) => userPermissionController.currentPage.value = page,
                children: [
                  _buildConnectionscreen(isDarkMode),
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

  Widget _buildConnectionscreen(bool isDarkMode) {
    final OnboardingScreenController controller =
    Get.find<OnboardingScreenController>();

    final ConnectivitiyController connectivitiyController = Get.find<ConnectivitiyController>();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            title: "Checking Internet Connection",
            fontSize: 20.sp,
            fontFamily: 'grenda',
            textAlign: TextAlign.start,
            textColor: AppColors.primary,
          ),
          CustomText(
            fontSize: 15.sp,
            title:
            "Internet is required to download Quran, Hadith and Prayer timings.",
            textAlign: TextAlign.start,
            textColor: isDarkMode ? AppColors.white : AppColors.black,
            maxLines: 2,
          ),
          AppSizedBox.space10h,
          Obx(() {
            return CustomText(
              fontSize: 15.sp,
              title: connectivitiyController.internetCheckCompleted.value
                  ? "Internet connection checked successfully."
                  : "Please click the Check button below to complete the internet checking process.",
              textAlign: TextAlign.start,
              textColor: isDarkMode ? AppColors.white : AppColors.black,
              maxLines: 2,
            );
          }),
          const Spacer(),
          Obx(() {
            return Column(
              children: [
                if (!connectivitiyController.internetCheckCompleted.value)
                  CustomButton(
                    height: 45.h,
                    haveBgColor: true,
                    borderRadius: 45.r,
                    btnTitle: 'Check',
                    btnTitleColor: Colors.white,
                    bgColor: AppColors.primary,
                    useGradient: true,
                    gradient: LinearGradient(
                      colors: [
                        AppColors.primary,
                        AppColors.secondry.withOpacity(0.9),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    isLoading: connectivitiyController.isLoading.value,
                    onTap: () async {
                      await connectivitiyController.checkConnectivity();
                      if (connectivitiyController.isConnected.value) {
                        connectivitiyController.internetCheckCompleted.value =
                        true;
                        Future.delayed(const Duration(seconds: 2), () {
                          connectivitiyController.showNextButton.value = true;
                          userPermissionController.enableSwipeFunction(true); // Enable swiping after internet check
                        });
                      } else {
                        CustomSnackbar.show(
                            backgroundColor: AppColors.red,
                            title: "No Internet Connection",
                            subtitle:
                            "Please connect to Wi-Fi or cellular data.",
                            icon: Icon(LineIcons.wifi));
                      }
                    },
                  ),
                if (connectivitiyController.internetCheckCompleted.value)
                  AnimatedOpacity(
                    opacity: connectivitiyController.showNextButton.value
                        ? 1.0
                        : 0.0,
                    duration: const Duration(seconds: 5),
                    child: CustomButton(
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
                      btnTitle: 'Next',
                      btnTitleColor: Colors.white,
                      bgColor: AppColors.primary,
                      onTap: () {
                        userPermissionController.nextPage();
                      },
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
          CustomText(
            title: "Allow location access",
            fontSize: 20.sp,
            fontFamily: 'grenda',
            textAlign: TextAlign.start,
            textColor: AppColors.primary,
          ),
          CustomText(
            fontSize: 15.sp,
            title:
            "Enabling location access allows us to automatically calculate accurate prayer times based on your current location, ensuring you never miss a prayer.",
            textAlign: TextAlign.start,
            textColor: isDarkMode ? AppColors.white : AppColors.black,
          ),
          AppSizedBox.space15h,
          Obx(() {
            if (userPermissionController.locationAccessed.value) {
              return Row(
                children: [
                  Icon(Icons.location_on_outlined,color: isDarkMode ? AppColors.white : AppColors.black,),
                  AppSizedBox.space10w,
                  CustomText(
                      title: '${userPermissionController.cityName}, ${userPermissionController.countryName}',
                      fontSize: 15.sp,
                      textColor: isDarkMode ? AppColors.white : AppColors.black),
                ],
              );
            } else {
              return const SizedBox();
            }
          }),
          const Spacer(),
          Obx(() {
            return Column(
              children: [
                CustomButton(
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
                  btnTitle: userPermissionController.isLoading.value
                      ? ''
                      : userPermissionController.locationAccessed.value &&
                      userPermissionController.allowSwipe.value
                      ? 'Next'
                      : 'Access Location',
                  btnTitleColor: Colors.white,
                  bgColor: AppColors.primary,
                  isLoading: userPermissionController.isLoading.value,
                  onTap: () {
                    if (userPermissionController.locationAccessed.value &&
                        userPermissionController.allowSwipe.value) {
                      userPermissionController.nextPage();
                      userPermissionController.enableSwipeForThemeFunction(true);
                    } else {
                      userPermissionController.accessLocation();
                    }
                  },
                ),
                AppSizedBox.space30h,
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildThemeScreen(bool isDarkMode) {
    final AppThemeSwitchController themeController = Get.put(AppThemeSwitchController());
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                title: "Choose Preferred Theme",
                fontSize: 20.sp,
                fontFamily: 'grenda',
                textAlign: TextAlign.start,
                textColor: AppColors.primary,
              ),
              CustomText(
                title: "Choose your preferred theme from the options presented below. Select either Light Mode for a bright and vibrant interface, or Dark Mode for a sleek and comfortable experience, especially in low-light environments.",
                textAlign: TextAlign.start,
                textColor: isDarkMode ? AppColors.white : AppColors.black,
                fontSize: 15.sp,
              ),
              AppSizedBox.space20h,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildThemeCard("Light Mode", false, themeController.isDarkMode.value == false),
                  _buildThemeCard("Dark Mode", true, themeController.isDarkMode.value == true),
                ],
              ),
            ],
          ),
        ),
        Positioned(
          left: 15.w,
          right: 15.w,
          bottom: 30.h,
          child: InkWell(
            onTap: (){
              userPermissionController.nextPage();
            },
            child: CustomButton(
              useGradient: true,
              gradient: LinearGradient(
                colors: [
                  AppColors.primary,
                  AppColors.secondry.withOpacity(0.9),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              haveBgColor: true,
              height: 45.h,
              btnTitle: "Next",
              btnTitleColor: Colors.white,
              bgColor: AppColors.primary,
              onTap: userPermissionController.nextPage,
              borderRadius: 45.r,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildThemeCard(String title, bool isDarkMode, bool isSelected) {
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
                  border: isSelected
                      ? Border.all(
                    color: isDarkMode ? AppColors.white : AppColors.primary,
                    width: 2.w,
                  )
                      : null,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.r),
                          image: DecorationImage(
                            image: AssetImage(isDarkMode ? 'assets/images/theme_dark_bg.jpg' : 'assets/images/theme_light_bg.jpg'),
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
    final ConnectivitiyController connectivitiyController = Get.put(ConnectivitiyController());
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
                  title: "Discover the Beauty of the Quran",
                  fontFamily: 'grenda',
                  textColor: AppColors.primary,
                  textAlign: TextAlign.start,
                ),
                AppSizedBox.space10h,
                Align(
                  alignment: Alignment.centerRight,
                  child: CustomText(
                    fontSize: 30.sp,
                    textAlign: TextAlign.end,
                    textColor: isDarkMode ? AppColors.white : AppColors.primary,
                    title: '﷽',
                  ),
                ),
                AppSizedBox.space15h,
                CustomText(
                  title: "Illuminate your heart with the light of the Quran. Explore, learn, and connect with the divine words of Allah.",
                  textAlign: TextAlign.start,
                  textColor: isDarkMode ? AppColors.white : AppColors.black,
                  fontSize: 15.sp,
                ),
                AppSizedBox.space15h,
                Container(
                  padding: EdgeInsets.all(15.w),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.36),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: CustomText(
                    title:
                    "طَلَبُ الْعِلْمِ فَرِيضَةٌ عَلَى كُلِّ مُسْلِمٍ وَوَاضِعُ الْعِلْمِ عِنْدَ غَيْرِ أَهْلِهِ كَمُقَلِّدِ الْخَنَازِيرِ الْجَوْهَرَ وَاللُّؤْلُؤَ وَالذَّهَبَ",
                    fontSize: 15.sp,
                    fontFamily: 'quicksand',
                    textAlign: TextAlign.end,
                    textColor: isDarkMode ? AppColors.white : AppColors.black,
                  ),
                ),
                AppSizedBox.space15h,
                CustomText(
                  title:
                  "Seeking knowledge is a duty upon every Muslim, and he who imparts knowledge to those who do not deserve it, is like one who puts a necklace of jewels, pearls and gold around the neck of swines",
                  fontSize: 14.sp,
                  fontFamily: 'quicksand',
                  textAlign: TextAlign.start,
                  textColor: isDarkMode ? AppColors.white : AppColors.black,
                ),
                AppSizedBox.space10h,
                Align(
                  alignment: Alignment.centerLeft,
                  child: CustomText(
                    title: "Reference Sunan Ibn Majah 224\nIn book reference: Introduction, Hadith 224",
                    fontSize: 12.sp,
                    fontFamily: 'quicksand',
                    textAlign: TextAlign.start,
                    textColor: isDarkMode ? AppColors.white.withOpacity(0.3) : AppColors.black,
                    textStyle: TextStyle(fontStyle: FontStyle.italic),
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
              child: CustomButton(
                haveBgColor: true,
                btnTitle: "Explore Noor e Quran",
                btnTitleColor: Colors.white,
                bgColor: AppColors.primary,
                borderRadius: 45.r,
                height: 45.h,
                useGradient: true,
                gradient: LinearGradient(
                  colors: [
                    AppColors.primary,
                    AppColors.secondry.withOpacity(0.9),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                onTap: () {
                  if(connectivitiyController.internetCheckCompleted.value && userPermissionController.locationAccessed.value){
                    final box = GetStorage();
                    box.write('hasSeenOnboarding', true);
                    Get.offAll(BottomNavigationHomeScreen());
                  } else if (!connectivitiyController.internetCheckCompleted.value && !userPermissionController.locationAccessed.value){
                    CustomSnackbar.show(
                      backgroundColor: AppColors.red,
                      title: "Complete Setup",
                      subtitle: "Ensure you've enabled both internet and location services.",
                      icon: Icon(LineIcons.exclamationTriangle),
                    );
                  } else if (!connectivitiyController.internetCheckCompleted.value){
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
}
