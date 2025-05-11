import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';
import 'package:get/get.dart';

import '../../../config/app_colors.dart';
import '../../../controllers/app_theme_switch_controller.dart';
import '../../hadith/views/hadith_collection_screen.dart';
import '../../memorizer/views/quran_memorizer_main_screen.dart';
import '../../quran/views/quran_main_screen.dart';
import 'app_home_screen.dart';
import '../controllers/app_home_screen_bottom_navigation_controller.dart';

class AppHomeScreenBottomNavigation extends StatelessWidget {
  // Use Get.find() since the controller is already instantiated.
  final AppHomeScreenBottomNavigationController controller = Get.find<AppHomeScreenBottomNavigationController>();
  final AppThemeSwitchController themeController = Get.find<AppThemeSwitchController>();

  static final List<Widget> widgetOptions = <Widget>[
    AppHomeScreen(), // Use the AppHomeScreen widget
    QuranMainScreen(),
    HadithCollectionScreen(),
    QuranMemorizerMainScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      bool isDarkMode = themeController.isDarkMode.value;

      return Scaffold(
        backgroundColor: isDarkMode ? AppColors.black : AppColors.white,
        body: Center(
          child: widgetOptions.elementAt(controller.currentIndex),
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: isDarkMode ? AppColors.black : AppColors.white,
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 4,
              ),
            ],
          ),
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
              child: GNav(
                gap: 10.w,
                activeColor: AppColors.white,
                textStyle: GoogleFonts.quicksand(
                  color: AppColors.white,
                  fontSize: 12.sp,
                ),
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
                duration: const Duration(milliseconds: 400),
                tabBorderRadius: 45.r,
                iconSize: 18.sp,
                color: isDarkMode ? AppColors.white : AppColors.black,
                tabBackgroundGradient: LinearGradient(
                  colors: [
                    AppColors.primary,
                    AppColors.secondry.withOpacity(0.9),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                tabs: [
                  GButton(
                    icon: LineIcons.home,
                    text: 'Home',
                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                  ),
                  GButton(
                    icon: LineIcons.quran,
                    text: 'Quran',
                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                  ),
                  GButton(
                    icon: LineIcons.scroll,
                    text: 'Hadith',
                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                  ),
                  GButton(
                    icon: LineIcons.bookReader,
                    text: 'Memorizer',
                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                  ),
                ],
                selectedIndex: controller.currentIndex,
                onTabChange: controller.updateSelectedIndex,
              ),
            ),
          ),
        ),
      );
    });
  }
}
