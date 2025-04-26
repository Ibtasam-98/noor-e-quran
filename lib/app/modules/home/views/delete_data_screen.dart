import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ripple_wave/ripple_wave.dart';

import '../../../config/app_colors.dart';
import '../../../config/app_sizedbox.dart';
import '../../../controllers/app_theme_switch_controller.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_text.dart';

class DeleteDataScreen extends StatelessWidget {
  const DeleteDataScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AppThemeSwitchController themeController =
    Get.put(AppThemeSwitchController());
    bool isDarkMode = themeController.isDarkMode.value;
    return Scaffold(
      backgroundColor: isDarkMode ? AppColors.black : AppColors.white,
      appBar: AppBar(
        backgroundColor: isDarkMode ? AppColors.black : AppColors.white,
        surfaceTintColor: AppColors.transparent,
        foregroundColor: AppColors.transparent,
        title: CustomText(
          firstText: "Delete",
          secondText: " Data",
          fontSize: 18.sp,
          firstTextColor: isDarkMode ? AppColors.white : AppColors.black,
          secondTextColor: AppColors.primary,
        ),
        centerTitle: false,
        leading: InkWell(
          splashColor: AppColors.transparent,
          highlightColor: AppColors.transparent,
          onTap: () {
            Get.back();
          },
          child: Icon(
            Icons.west,
            color: isDarkMode ? AppColors.white : AppColors.black,
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(),
          RippleWave(
            color: AppColors.red,
            childTween: Tween(begin: 0.8, end: 1),
            child: Icon(
              Icons.delete_outline_outlined,
              size: 25.h,
              color: Colors.white,
            ),
          ),
          Column(
            children: [
              CustomText(
                title: 'This action will permanently delete all locally stored data, including saved hadith, surahs bookmarks, and all saved content.',
                fontSize: 16.sp,
                textColor: isDarkMode ? AppColors.white : AppColors.black,
                textAlign: TextAlign.center,
                maxLines: 10,
                textOverflow: TextOverflow.ellipsis,
              ),
              AppSizedBox.space30h,
              CustomButton(
                height: 45.h,
                haveBgColor: true,
                borderRadius: 45.r,
                btnTitle: 'Delete Data',
                btnTitleColor: AppColors.white,
                bgColor: AppColors.red,
                useGradient: true,
                gradient: LinearGradient(
                  colors: [
                    AppColors.redDarkShade,
                    AppColors.red.withOpacity(0.3),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                onTap: () {
                  // Show confirmation dialog
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      backgroundColor: AppColors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      title: CustomText(
                        title: 'Confirmation',
                        fontSize: 20.sp,
                        textColor: AppColors.primary,
                        textAlign: TextAlign.start,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'grenda',
                      ),
                      content: CustomText(
                        title:
                        'Are you sure you want to delete all locally stored data?',
                        fontSize: 16.sp,
                        textColor: AppColors.black,
                        maxLines: 10,
                        textAlign: TextAlign.start,
                        textOverflow: TextOverflow.ellipsis,
                      ),
                      actions: [
                        Column(
                          mainAxisAlignment:
                          MainAxisAlignment.end,
                          children: [
                            InkWell(
                              onTap: () async {
                                Get.back();
                              },
                              child: CustomButton(
                                height: 40.h,
                                haveBgColor: true,
                                borderRadius: 45.r,
                                btnTitle: 'Cancel',  // Changed from "Got It" to "Cancel"
                                btnTitleColor: AppColors.white,
                                btnBorderColor: AppColors.primary,
                                bgColor: AppColors.primary,
                                useGradient: true,
                                gradient: LinearGradient(
                                  colors: [
                                    AppColors.primary,
                                    AppColors.secondry.withOpacity(0.9),
                                  ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                              ),
                            ),
                            AppSizedBox.space10h,
                            InkWell(
                              onTap: () async {
                                final box = GetStorage();
                                await box.erase();
                                Navigator.of(context).pop();
                                Get.back();
                              },
                              child: CustomButton(
                                height: 40.h,
                                haveBgColor: true,
                                bgColor: AppColors.red,
                                borderRadius: 45.r,
                                btnTitle: 'Delete',
                                btnTitleColor: AppColors.white,
                                btnBorderColor: AppColors.primary,
                                useGradient: true,
                                gradient: LinearGradient(
                                  colors: [
                                    AppColors.redDarkShade,
                                    AppColors.red,
                                  ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
          SizedBox(),
        ],
      ),
    );
  }
}
