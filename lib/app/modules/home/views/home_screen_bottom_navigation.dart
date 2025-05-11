import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';
import 'package:noor_e_quran/app/modules/home/views/app_home_screen.dart';
import '../../../config/app_colors.dart';
import '../../../controllers/app_theme_switch_controller.dart';
import '../../additional/views/additional_feature_screen.dart';
import '../../hadith/views/hadith_collection_screen.dart';
import '../../ibadat/views/ibadat_category_screen.dart';
import '../controllers/app_home_screen_bottom_navigation_controller.dart';

class AppHomeScreenBottomNavigation extends StatelessWidget {
  final AppHomeScreenBottomNavigationController controller = Get.put(AppHomeScreenBottomNavigationController());

  static final List<Widget> widgetOptions = <Widget>[
    AppHomeScreen(),
    HadithCollectionScreen(),
    IbadatCategoryScreen(),
    AdditionalFeatureScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final AppThemeSwitchController themeController = Get.put(AppThemeSwitchController());

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
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
              child: GNav(
                gap: 10.w,
                activeColor: AppColors.white,
                textStyle: GoogleFonts.quicksand(
                  color: AppColors.white,
                  fontSize: 12.sp, // Smaller font size
                ),
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
                duration: Duration(milliseconds: 400),
                tabBorderRadius: 45.r,
                iconSize: 20.sp,
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
                    text: 'Hadith',
                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                  ),
                  GButton(
                    icon: LineIcons.prayingHands,
                    text: 'Ibadat',
                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),),
                  GButton(
                    icon: Icons.pending_outlined,
                    text: 'More',
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