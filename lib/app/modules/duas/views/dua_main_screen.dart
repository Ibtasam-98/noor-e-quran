import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icons.dart';
import 'package:noor_e_quran/app/config/app_sizedbox.dart';

import '../../../config/app_colors.dart';
import '../../../controllers/app_theme_switch_controller.dart';
import '../../../widgets/custom_text.dart';

class DuaMainScreen extends StatelessWidget {

  final AppThemeSwitchController themeController = Get.find<AppThemeSwitchController>();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: themeController.isDarkMode.value ? AppColors.black : AppColors.white,
      appBar: AppBar(
        backgroundColor: themeController.isDarkMode.value ? AppColors.black : AppColors.white,
        title: CustomText(
          title: 'Daily Dua',
          fontSize: 18.sp,
          textColor: themeController.isDarkMode.value ? AppColors.white : AppColors.black,
        ),
        centerTitle: false,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.west,
            color: themeController.isDarkMode.value ? AppColors.white : AppColors.black,
          ),
        ),

      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
           Container(
             padding: EdgeInsets.all(25.h),
             decoration: BoxDecoration(
               color: AppColors.grey.withOpacity(0.1),
               borderRadius: BorderRadius.circular(15.r),
             ),
             child: Column(
               children: [
                 Icon(
                   LineIcons.code,
                   size: 40.h,
                   color: AppColors.primary,
                 ),
                 AppSizedBox.space20h,
                 CustomText(
                   title: "This screen is \nUnder development.",
                   fontSize: 18.sp,
                   textAlign: TextAlign.center,
                   textColor: themeController.isDarkMode.value ? AppColors.white : AppColors.black,
                 )
               ],
             ),
           )
          ],
        ),
      ),
    );
  }
}
