import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:noor_e_quran/app/config/app_colors.dart';
import 'package:noor_e_quran/app/config/app_sizedbox.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../controllers/app_theme_switch_controller.dart';

import 'package:hadith/hadith.dart';

import '../../controllers/hadith_detail_controller.dart';
import '../../widgets/custom_frame.dart';
import '../../widgets/custom_text.dart';

class HadithDetailScreen extends StatelessWidget {
  final String hadithNumber;
  final String hadithFirstBody;
  final String hadithLastBody;
  final String grade;
  final int bookNumber;
  final String bookFirstName;
  final String bookLastName;
  final String collectionName;
  final bool isFromSavedHadithList;

  HadithDetailScreen({
    required this.hadithNumber,
    required this.hadithFirstBody,
    required this.hadithLastBody,
    required this.grade,
    required this.bookLastName,
    required this.bookFirstName,
    required this.bookNumber,
    required this.collectionName,
    this.isFromSavedHadithList = false,
  });

  final HadithDetailScreenController controller =
  Get.put(HadithDetailScreenController());
  final AppThemeSwitchController themeController =
  Get.put(AppThemeSwitchController());
  final GetStorage storage = GetStorage();

  String cleanText(String text) {
    return text.replaceAll(RegExp(r'\[.*?\]'), '');
  }

  @override
  Widget build(BuildContext context) {
    controller.checkBookmarkStatus(hadithNumber);

// Print statement to check if saved
    final savedHadith = storage.read('lastAccessedHadith');
    if (savedHadith != null) {
    print('Last accessed Hadith saved successfully: $savedHadith');
    } else {
    print('Failed to save last accessed Hadith.');
    }

    bool isDarkMode = themeController.isDarkMode.value;
    final iconColor = isDarkMode ? AppColors.white : AppColors.black;
    final textColor = isDarkMode ? AppColors.white : AppColors.black;

    return Scaffold(
      backgroundColor:
      themeController.isDarkMode.value ? AppColors.black : AppColors.white,
      appBar: AppBar(
        surfaceTintColor: AppColors.transparent,
        centerTitle: false,
        title: CustomText(
          firstText: "Book ",
          secondText: collectionName,
          fontSize: 18.sp,
          secondTextColor: AppColors.primary,
          firstTextColor: isDarkMode ? AppColors.white : AppColors.black,
          capitalize: true,
        ),
        backgroundColor:
        themeController.isDarkMode.value ? AppColors.black : AppColors.white,
        leading: IconButton(
          icon: Icon(Icons.west, color: iconColor),
          onPressed: () {
            Get.back();
          },
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 20.w),
            child: Row(
              children: [
                if (!isFromSavedHadithList)
                  Obx(() {
                    return IconButton(
                      icon: Icon(
                        controller.isBookmarked.value
                            ? Icons.bookmark
                            : Icons.bookmark_border,
                        color: iconColor,
                      ),
                      onPressed: () {
                        controller.toggleBookmark(hadithNumber, {
                          'hadithNumber': hadithNumber,
                          'hadithFirstBody': hadithFirstBody,
                          'hadithLastBody': hadithLastBody,
                          'grade': grade,
                          'bookNumber': bookNumber,
                          'bookFirstName': bookFirstName,
                          'bookLastName': bookLastName,
                          'collectionName': collectionName,
                        });
                      },
                    );
                  }),
                AppSizedBox.space5w,
                InkWell(
                  splashColor: AppColors.transparent,
                  hoverColor: AppColors.transparent,
                  highlightColor: AppColors.transparent,
                  onTap: () {
                    print("As");
                    Share.share("Check out this Hadith \nHadith Number ${hadithNumber} Book ${bookNumber} \n${bookFirstName} ${hadithLastBody} \n ${hadithFirstBody} \n Share from Noor e Quran App");
                  },
                  child: Icon(
                    Icons.share,
                    size: 17.h,
                    color: iconColor,
                  ),
                ),
              ],
            ),
          )

        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
          decoration: BoxDecoration(
            color:
            themeController.isDarkMode.value ? AppColors.black : AppColors.white,
            borderRadius: BorderRadius.circular(1.r),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.5),
                blurRadius: 5,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomFrame(
                leftImageAsset: "assets/frames/topLeftFrame.png",
                rightImageAsset: "assets/frames/topRightFrame.png",
                imageHeight: 65.h,
                imageWidth: 65.w,
              ),
              Center(
                child: Padding(
                  padding: EdgeInsets.only(left: 10.h, right: 10.h),
                  child: Column(
                    children: [
                      Html(
                        data: cleanText("${bookLastName}"),
                        style: {
                          "body": Style(
                            fontSize: FontSize(30.sp),
                            color: textColor,
                            textAlign: TextAlign.right,
                            fontWeight: FontWeight.normal,
                            fontFamily: 'grenda',
                            margin: Margins(left: Margin.zero()),
                            maxLines: 2,
                          ),
                        },
                      ),
                      AppSizedBox.space10h,
                      Html(
                        data: cleanText("${bookFirstName}"),
                        style: {
                          "body": Style(
                            fontSize: FontSize(20.sp),
                            color: AppColors.primary,
                            textAlign: TextAlign.left,
                            fontFamily: 'quicksand',
                            margin: Margins(left: Margin.zero()),
                            maxLines: 2,
                          ),
                        },
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: CustomText(
                            fontSize: 15.sp,
                            textAlign: TextAlign.start,
                            textColor:
                            isDarkMode ? AppColors.white : AppColors.black,
                            title:
                            "Book ${bookNumber} | Hadith Number ${hadithNumber}"),
                      )
                    ],
                  ),
                ),
              ),
              AppSizedBox.space10h,
              Obx(() {
                return Padding(
                  padding: EdgeInsets.only(
                    right: 15.w,
                    left: 15.h,
                  ),
                  child: Container(
                    padding: EdgeInsets.all(5.h),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.39),
                      borderRadius: BorderRadius.circular(15.r),
                    ),
                    child: Html(
                      data: cleanText(hadithLastBody),
                      style: {
                        "body": Style(
                          color: textColor,
                          fontSize: FontSize(controller.currentFontSize.value),
                          textAlign: TextAlign.right,
                          margin: Margins(left: Margin.zero()),
                        ),
                      },
                    ),
                  ),
                );
              }),
              Obx(() {
                return Padding(
                  padding: EdgeInsets.only(left: 15.w, right: 15.w),
                  child: Html(
                    data: cleanText(hadithFirstBody),
                    style: {
                      "body": Style(
                        fontSize: FontSize(controller.currentFontSize.value.sp),
                        color: textColor,
                        textAlign: TextAlign.left,
                        fontWeight: FontWeight.normal,
                        fontFamily: 'quicksand',
                        margin: Margins(left: Margin.zero()),
                      ),
                    },
                  ),
                );
              }),
              CustomFrame(
                leftImageAsset: "assets/frames/bottomLeftFrame.png",
                rightImageAsset: "assets/frames/bottomRightFrame.png",
                imageHeight: 65.h,
                imageWidth: 65.w,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: AppColors.transparent,
        child: Row(
          children: [
            CustomText(
              textColor: textColor,
              fontSize: 15.sp,
              title: "Font Size",
            ),
            Expanded(
              child: Obx(
                    () => Slider(
                  value: controller.currentFontSize.value,
                  min: 12.0,
                  max: 60.0,
                  divisions: 14,
                  label: "${controller.currentFontSize.value.toStringAsFixed(1)}",
                  activeColor: AppColors.primary,
                  inactiveColor: AppColors.primary,
                  onChanged: (value) {
                    controller.updateFontSize(value);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}