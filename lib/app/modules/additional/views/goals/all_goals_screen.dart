import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../config/app_colors.dart';
import '../../../../controllers/app_theme_switch_controller.dart';
import '../../../../widgets/custom_text.dart';

class AllGoalsScreen extends StatelessWidget {
  final Map<DateTime, List<String>> savedGoals;
  final List<String> dailyGoals;
  final AppThemeSwitchController themeController;

  AllGoalsScreen({required this.savedGoals, required this.dailyGoals, required this.themeController});

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = themeController.isDarkMode.value;
    final textColor = isDarkMode ? AppColors.white : AppColors.black;
    return Scaffold(
      backgroundColor: themeController.isDarkMode.value ? AppColors.black : AppColors.white,
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: themeController.isDarkMode.value ? AppColors.black : AppColors.white,
        leading: InkWell(
          onTap: () {
            Get.back();
          },
          child: Icon(
            Icons.west,
            color: textColor,
          ),
        ),
        centerTitle: false,
        title: CustomText(
          firstText: "Daily ",
          secondText: "Goals",
          firstTextColor: isDarkMode ? AppColors.white : AppColors.black,
          secondTextColor: AppColors.primary,
          fontSize: 18.sp,
        ),
      ),
      body: savedGoals.isEmpty
          ? Center(
        child: CustomText(
          title: "No goals added yet.",
          fontSize: 16.sp,
          textColor: textColor.withOpacity(0.6),
        ),
      )
          : Padding(
        padding: EdgeInsets.only(left: 10.w, right: 10.w),
        child: ListView.builder(
          itemCount: savedGoals.length,
          itemBuilder: (context, index) {
            final date = savedGoals.keys.toList()[index];
            final goals = savedGoals[date]!;
            return Container(
              margin: EdgeInsets.only(bottom: 5.h, top: 5.h, left: 5.w, right: 5.w),
              padding: EdgeInsets.all(10.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.r),
                color: (index % 2 == 1)
                    ? AppColors.primary.withOpacity(0.29)
                    : AppColors.primary.withOpacity(0.1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: CustomText(
                          title: '${DateFormat('MMMM').format(date)}',
                          fontSize: 16.sp,
                          maxLines: 1,
                          textColor: AppColors.primary,
                          fontWeight: FontWeight.w600,
                          textAlign: TextAlign.start,
                          textOverflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Expanded(
                        child: CustomText(
                          title: DateFormat('yyyy-MM-dd').format(date),
                          fontSize: 12.sp,
                          maxLines: 1,
                          textAlign: TextAlign.end,
                          textOverflow: TextOverflow.ellipsis,
                          textColor: textColor,
                        ),
                      )
                    ],
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: goals.length,
                    itemBuilder: (context, goalIndex) {
                      final goal = goals[goalIndex];
                      return Column(
                        children: [
                          ListTile(
                            leading: Icon(
                              Icons.check_circle_outline,
                              color: AppColors.green,
                              size: 16.h,
                            ),
                            title: CustomText(
                              title: goal,
                              fontSize: 15.sp,
                              textColor: textColor,
                              textAlign: TextAlign.start,
                            ),
                          ),
                          if (goalIndex < goals.length - 1) // Add divider if not the last item
                            Divider(
                              color: AppColors.primary,
                              thickness: 0.1,
                            ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}