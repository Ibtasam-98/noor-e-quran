import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quran/quran.dart' as quran;

import '../../config/app_colors.dart';
import '../../controllers/app_theme_switch_controller.dart';
import '../../widgets/custom_text.dart';
import 'quran_juz_detail_screen.dart';


class QuranJuzTab extends StatelessWidget {
  final AppThemeSwitchController themeController = Get.put(AppThemeSwitchController());

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = themeController.isDarkMode.value;
    final textColor = isDarkMode ? AppColors.white : AppColors.black;
    return ListView.builder(
      itemCount: quran.totalJuzCount,
      itemBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.only(bottom: 5, top: 5.h,left: 5.w,right: 5.w),
          padding: EdgeInsets.all(10.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.r),
            color: (index % 2 == 1)
                ? AppColors.primary.withOpacity(0.29)
                : AppColors.primary.withOpacity(0.1),
          ),
          child: ListTile(
            splashColor: AppColors.transparent,
            hoverColor: AppColors.transparent,
            leading: CustomText(
              title:'Juz ${index + 1}',
              fontSize: 15.sp,
              textColor: textColor,
              fontWeight: FontWeight.w500,
              textOverflow: TextOverflow.ellipsis,
              maxLines: 1,
              textAlign: TextAlign.start,
            ),
            subtitle:  CustomText(
              title:'',
              fontSize: 15.sp,
              textColor: textColor,
              fontWeight: FontWeight.w500,
              textOverflow: TextOverflow.ellipsis,
              maxLines: 1,
              textAlign: TextAlign.start,
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              size: 12.h,
              color: isDarkMode ? AppColors.white : AppColors.black,
            ),
            onTap: () {
              Get.to(() => JuzDetailScreen(juzNumber: index + 1));
            },
          ),
        );
      },
    );
  }
}
