import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:noor_e_quran/app/config/app_colors.dart';
import 'package:noor_e_quran/app/widgets/custom_text.dart';
import '../../../controllers/app_theme_switch_controller.dart';
import '../controllers/view_all_prayer_screen_controller.dart';

class PrayerMethodSettingsView extends StatelessWidget {
  final NamazController namazController = Get.find<NamazController>();

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Get.find<AppThemeSwitchController>().isDarkMode.value;

    return Scaffold(
      backgroundColor: isDarkMode ? AppColors.black : AppColors.white,
      appBar: AppBar(
        centerTitle: false,
        title: CustomText(
          firstText: "Calculation",
          secondText: " Method",
          fontSize: 18.sp,
          firstTextColor: isDarkMode ? AppColors.white : AppColors.black,
          secondTextColor: AppColors.primary,
          textColor: isDarkMode ? AppColors.white : AppColors.black,
        ),
        leading: IconButton(
          icon: Icon(Icons.west, color: isDarkMode ? AppColors.white : AppColors.black),
          onPressed: () => Get.back(),
        ),
        backgroundColor: isDarkMode ? AppColors.black : AppColors.white,
        elevation: 0,
        surfaceTintColor: AppColors.transparent,
      ),
      body: Obx(() {
        if (namazController.calculationMethods.isEmpty) {
          return Center(child: CircularProgressIndicator());
        }

        return ListView.builder(
          padding: EdgeInsets.all(16.w),
          itemCount: namazController.calculationMethods.length,
          itemBuilder: (context, index) {
            final method = namazController.calculationMethods[index];
            final isSelected = namazController.selectedCalculationMethod.value == method['id'];
            final methodIndex = index + 1; // Calculate index starting from 1

            return Container(
              margin: EdgeInsets.only(bottom: 12.h),
              decoration: BoxDecoration(
                color: (index % 2 == 1)
                    ? AppColors.primary.withOpacity(0.29)
                    : AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: isSelected ? AppColors.primary : Colors.transparent,
                  width: 1,
                ),
              ),
              child: ListTile(
                leading: CustomText( // Add the index here
                  title:'$methodIndex',
                  fontSize: 14.sp,
                  textColor:  isDarkMode ? AppColors.white : AppColors.black,
                ),
                title: CustomText(
                  title: method['name'],
                  fontSize: 14.sp,
                  textAlign: TextAlign.start,
                  textColor: isDarkMode ? AppColors.white : AppColors.black,
                ),
                trailing: isSelected
                    ? Icon(Icons.check_circle, color: AppColors.primary)
                    : null,
                onTap: () async {
                  await namazController.saveSelectedMethod(method['id'] as int);
                  await namazController.loadSelectedMethodAndRefresh();
                  Get.back();
                },
              ),
            );
          },
        );
      }),
    );
  }
}
