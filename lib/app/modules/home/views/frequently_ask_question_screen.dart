import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../config/app_colors.dart';
import '../../../controllers/app_theme_switch_controller.dart';
import '../../../widgets/custom_text.dart';
import '../controllers/frequently_ask_question_controller.dart';

class FAQScreen extends StatelessWidget {
  final FrequentlyAskQuenstionAndPrivacyPolicyController faqController = Get.put(FrequentlyAskQuenstionAndPrivacyPolicyController()); // Initialize the controller

  FAQScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AppThemeSwitchController themeController = Get.find(); // Find the theme controller
    final isDarkMode = themeController.isDarkMode.value;
    final textColor = isDarkMode ? AppColors.white : AppColors.black;

    return Scaffold(
      backgroundColor: themeController.isDarkMode.value ? AppColors.black : AppColors.white,
      appBar: AppBar(
        surfaceTintColor: AppColors.transparent,
        foregroundColor: AppColors.transparent,
        centerTitle: false,
        title: CustomText(
          firstText: "Frequent",
          secondText: " Asked Question",
          firstTextColor: isDarkMode ? AppColors.white : AppColors.black,
          secondTextColor: AppColors.primary,
          fontSize: 18.sp,
        ),
        backgroundColor: isDarkMode ? AppColors.black : AppColors.white,
        leading: InkWell(
          onTap: () => Get.back(),
          child: Icon(Icons.west, color: isDarkMode ? AppColors.white : AppColors.black),
        ),
      ),
      body: GetBuilder<FrequentlyAskQuenstionAndPrivacyPolicyController>( // Use GetBuilder to rebuild on state changes
        builder: (controller) {
          return ListView.builder(
            itemCount: controller.faqItems.length,
            itemBuilder: (context, index) {
              final item = controller.faqItems[index];
              final isExpanded = controller.expandedIndex == index;
              return Container(
                margin: EdgeInsets.only(bottom: 5, top: 5.h, left: 10.w, right: 10.w),
                padding: EdgeInsets.all(5.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.r),
                  color: (index % 2 == 1)
                      ? AppColors.primary.withOpacity(0.29)
                      : AppColors.primary.withOpacity(0.1),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      splashColor: AppColors.transparent,
                      hoverColor: AppColors.transparent,
                      leading: CustomText(
                        title: '${index + 1}',
                        fontSize: 15.sp,
                        textColor: textColor,
                        fontWeight: FontWeight.w500,
                        textOverflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        textAlign: TextAlign.start,
                      ),
                      title: CustomText(
                        title: item.question,
                        fontSize: 15.sp,
                        textColor: textColor,
                        fontWeight: FontWeight.w500,
                        textOverflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.start,
                      ),
                      trailing: Icon(
                        isExpanded ? Icons.remove : Icons.add,
                        size: 12.h,
                        color: isDarkMode ? AppColors.white : AppColors.black,
                      ),
                      onTap: () {
                        controller.toggleExpanded(index); // Use the controller method
                      },
                    ),
                    if (isExpanded)
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: CustomText(
                          title: item.answer,
                          fontSize: 15.sp,
                          textColor: textColor,
                          fontWeight: FontWeight.w500,
                          textOverflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.start,
                          maxLines: 5000,
                        ),
                      ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}