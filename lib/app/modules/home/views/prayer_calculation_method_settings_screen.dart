import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:noor_e_quran/app/config/app_colors.dart';
import 'package:noor_e_quran/app/config/app_sizedbox.dart';
import 'package:noor_e_quran/app/widgets/custom_text.dart';
import 'package:shimmer/shimmer.dart';
import '../../../config/app_contants.dart';
import '../../../controllers/app_theme_switch_controller.dart';
import '../controllers/view_all_prayer_screen_controller.dart';
import '../../../widgets/custom_shimmer.dart';

class PrayerCalculationMethodSettingsScreen extends StatelessWidget {
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
      body: Padding(
        padding: EdgeInsets.only(left: 12.w, right: 12.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              title: "Prayer Time Calculation",
              fontSize: 18.sp,
              textColor: AppColors.primary,
              maxLines: 1,
              textAlign: TextAlign.start,
              fontFamily: 'grenda',
            ),
            AppSizedBox.space5h,
            CustomText(
              title: "To ensure the prayer times are accurate for your area, please select your preferred calculation method.",
              fontSize: 14.sp,
              textColor: isDarkMode ? AppColors.white : AppColors.black,
              textOverflow: TextOverflow.ellipsis,
              textAlign: TextAlign.start,
              maxLines: 3,
            ),
            AppSizedBox.space15h,
            Expanded(
              child: Obx(() {
                if (namazController.calculationMethods.isEmpty) {
                  return SingleChildScrollView(
                    child: Shimmer.fromColors(
                      baseColor: isDarkMode
                          ? AppColors.black.withOpacity(0.02)
                          : AppColors.black.withOpacity(0.2),
                      highlightColor: isDarkMode
                          ? AppColors.lightGrey.withOpacity(0.1)
                          : AppColors.grey.withOpacity(0.2),
                      child: Column(
                        children: [
                          for (int i = 0; i <  4; i++) // Adjust the number of shimmer items as needed
                            Padding(
                              padding: EdgeInsets.only(bottom: 12.h),
                              child: buildShimmerContainer(height: 50.h, borderRadius: 12.r),
                            ),
                        ],
                      ),
                    ),
                  );
                }
                return ListView.builder(
                  itemCount: namazController.calculationMethods.length,
                  itemBuilder: (context, index) {
                    final method = namazController.calculationMethods[index];
                    final isSelected = namazController.selectedCalculationMethod.value == method['id'];
                    final methodIndex = index + 1; // Calculate index starting from 1
                    final methodName = AppConstants.prayerCalculationMethodsFullNames[method['code']] ?? method['name']; // Use the constant map

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
                        leading: SizedBox(
                          width: 24.w, // Adjust width as needed
                          height: 24.h, // Adjust height as needed
                          child: Center(
                            child: CustomText( // Display the index as text
                              title: '$methodIndex',
                              fontSize: 14.sp,
                              textColor: isDarkMode ? AppColors.white : AppColors.black,
                            ),
                          ),
                        ),
                        title: CustomText(
                          title: methodName,
                          fontSize: 14.sp,
                          textAlign: TextAlign.start,
                          textColor: isDarkMode ? AppColors.white : AppColors.black,
                        ),
                        trailing: isSelected
                            ? const Icon(Icons.check_circle, color: AppColors.primary)
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
            )
          ],
        ),
      ),
    );
  }
}