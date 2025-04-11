import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';
import 'package:noor_e_quran/app/views/home/app_home_screen.dart';
import '../../config/app_colors.dart';
import '../../controllers/app_home_screen_bottom_navigation.dart';
import '../../controllers/app_home_screen_controller.dart';
import '../../controllers/app_theme_switch_controller.dart';
import '../additional/additional_category_screen.dart';
import '../hadith/hadith_collection_screen.dart';
import '../ibadat/ibadat_category_screen.dart';

class BottomNavigationHomeScreen extends StatelessWidget {

  final BottomNavigationController controller = Get.put(BottomNavigationController());

  static final List<Widget> widgetOptions = <Widget>[
    HomeScreen(),
    HadithCollectionScreen(),
    IbadatCategoryScreen(),
    AdditionalCategoryScreen(),
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
          width: Get.width,
          padding: EdgeInsets.only(bottom: 10.h),
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
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.h, vertical: 20.w),
              child: GNav(
                gap: 15,
                activeColor: AppColors.white,
                textStyle: GoogleFonts.quicksand(color: AppColors.white),
                padding: EdgeInsets.symmetric(horizontal: 20.h, vertical: 10.w),
                duration: Duration(milliseconds: 400),
                tabBorderRadius: 45.r,
                tabBackgroundColor: AppColors.primary,
                iconSize: 20.sp,
                color: isDarkMode ? AppColors.white : AppColors.black,
                tabs: [
                  GButton(icon: LineIcons.home, text: 'Home'),
                  GButton(icon: LineIcons.quran, text: 'Hadith'),
                  GButton(icon: LineIcons.prayingHands, text: 'Ibadat'),
                  GButton(icon: Icons.pending_outlined, text: 'More'),
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
