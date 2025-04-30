
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:noor_e_quran/app/config/app_sizedbox.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../config/app_colors.dart';
import '../../../controllers/app_theme_switch_controller.dart';
import '../../../widgets/custom_card.dart';
import '../../../widgets/custom_text.dart';
import 'azkar_counter_screen.dart';

class AzkarDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> azkar;

  AzkarDetailsScreen({required this.azkar});

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Get.find<AppThemeSwitchController>().isDarkMode.value;
    final textColor = isDarkMode ? AppColors.white : AppColors.black;


    return Scaffold(
      backgroundColor: isDarkMode ? AppColors.black : AppColors.white,
      appBar: AppBar(
        backgroundColor: isDarkMode ? AppColors.black : AppColors.white,
        surfaceTintColor: AppColors.transparent,
        centerTitle: false,
        title: CustomText(
          firstText: azkar['engTitle'],
          secondText: "",
          fontSize: 18.sp,
          firstTextColor: isDarkMode ? AppColors.white : AppColors.black,
          secondTextColor: AppColors.primary,
        ),
        leading: InkWell(
          onTap: () => Get.back(),
          child: Icon(Icons.west, color: isDarkMode ? AppColors.white : AppColors.black),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(left: 10.w,right: 10.w),
        child: Column(
          children: [
            CustomCard(
              title:"Daily Blessings",
              subtitle:"Powerful azkar for daily peace and blessings",
              imageUrl: "assets/images/tasbeeh.png",
              mergeWithGradientImage: true,
              titleFontSize: 18.sp,
              subtitleFontSize: 12.sp,
              decorationColor: AppColors.red,
              addBoxShadow: true,
              useLinearGradient: true,
              gradientColors: [
                AppColors.black.withOpacity(0.4),
                AppColors.transparent,
                AppColors.black.withOpacity(0.4),
              ],
            ),
            AppSizedBox.space10h,
            Expanded(
              child: ListView.builder(
                itemCount: (azkar['content'] as List).length,
                itemBuilder: (context, index) {
                  final zikar = (azkar['content'] as List)[index];
                  return Container(
                    margin: EdgeInsets.only(bottom: 5, top: 5.h,),
                    padding: EdgeInsets.all(10.h),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.r),
                      color: (index % 2 == 1)
                          ? AppColors.primary.withOpacity(0.29)
                          : AppColors.primary.withOpacity(0.1),
                    ),
                    child: ListTile(
                      title: CustomText(
                        title: zikar['zikartitle'],
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
                        Get.to(AzkarCounterScreen(zikar: zikar, azkarType: azkar['engTitle'], azkarName: zikar['zikartitle'],));
                      },
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
