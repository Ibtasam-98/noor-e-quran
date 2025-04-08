import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';

import '../../config/app_colors.dart';
import '../../config/app_sizedbox.dart';
import '../../controllers/app_theme_switch_controller.dart';
import '../../controllers/ibadat_category_controller.dart';
import '../../widgets/custom_card.dart';
import '../../widgets/custom_text.dart';
import 'azkar/azkar_counter_screen.dart';

class ViewContinueAzkarListScreen extends StatelessWidget {
  final IbadatCategoryController controller = Get.put(IbadatCategoryController());
  final AppThemeSwitchController themeController = Get.find<AppThemeSwitchController>();
  final GetStorage box = GetStorage();

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = themeController.isDarkMode.value;
    final iconColor = isDarkMode ? AppColors.white : AppColors.black;
    final now = DateTime.now();
    final dateFormat = DateFormat('yyyy-MM-dd HH:mm');
    int index = 0;
    List<Widget> azkarWidgets = [];

    box.getKeys().forEach((key) {
      if (key.startsWith('azkar_count_')) {
        final zikarName = key.substring('azkar_count_'.length);
        final count = box.read(key) ?? 0;
        final timeKey = 'azkar_time_$zikarName';
        final timeString = box.read(timeKey) ?? '';
        final time = timeString.isNotEmpty ? DateTime.parse(timeString) : null;
        final repeat = _getRepeatCount(zikarName);
        final zikarData = _getZikarData(zikarName);
        final title = box.read('azkar_title_$zikarName') ?? zikarName;
        final azkarType = box.read('azkar_heading_$zikarName') ?? "Azkar";
        final azkarNameFromStorage = box.read('azkar_name_$zikarName') ?? title;

        if (count > 0 && count < repeat) {
          azkarWidgets.add(
            Container(
              width: 1.sw,
              margin: EdgeInsets.only(bottom: 10.h,),
              padding: EdgeInsets.all(12.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.r),
                color: index % 2 == 0
                    ? AppColors.primary.withOpacity(0.1)
                    : AppColors.primary.withOpacity(0.29),
              ),
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                dense: true,
                title: CustomText(
                  title: title,
                  fontSize: 14.sp,
                  textColor: isDarkMode ? AppColors.white : AppColors.black,
                  fontWeight: FontWeight.w500,
                  textOverflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  textAlign: TextAlign.start,
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    AppSizedBox.space5h,
                    Align(
                      alignment: Alignment.centerRight,
                      child: CustomText(
                        title: zikarName,
                        fontSize: 16.sp,
                        textColor: AppColors.primary,
                        fontWeight: FontWeight.w500,
                        textOverflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        textAlign: TextAlign.end,
                      ),
                    ),
                    AppSizedBox.space10h,
                    CustomText(
                      title:
                      "Last Accessed: ${time != null ? dateFormat.format(time) : 'No time recorded'}",
                      fontSize: 12.sp,
                      textAlign: TextAlign.start,
                      textColor:
                      isDarkMode ? AppColors.grey : AppColors.black,
                    ),
                    AppSizedBox.space10h,
                    LinearProgressIndicator(
                      value: count / repeat,
                      backgroundColor: AppColors.grey.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(20.r),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColors.primary,
                      ),
                    ),
                  ],
                ),
                onTap: () {
                  if (zikarData != null) {
                    Get.to(AzkarCounterScreen(
                      zikar: zikarData,
                      azkarType: azkarType,
                      azkarName: azkarNameFromStorage,
                    ));
                  } else {
                    print('Zikar data not found for $zikarName');
                  }
                },
              ),
            ),
          );
          index++;
        }
      }
    });

    return Scaffold(
      backgroundColor: isDarkMode ? AppColors.black : AppColors.white,
      appBar: AppBar(
        surfaceTintColor: AppColors.transparent,
        foregroundColor: AppColors.transparent,
        title: CustomText(
          firstText: "Continue",
          secondText: " Azkar",
          fontSize: 18.sp,
          firstTextColor: isDarkMode ? AppColors.white : AppColors.black,
          secondTextColor: AppColors.primary,
        ),
        centerTitle: false,
        backgroundColor: isDarkMode ? AppColors.black : AppColors.white,
        leading: InkWell(
          onTap: () {
            Get.back();
          },
          child: Icon(
            Icons.west,
            color: iconColor,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(left: 10.w,right: 10.w),
        child: Column(
          children: [
            CustomCard(
              title: "Daily Blessings",
              subtitle: "Powerful azkar for daily peace and blessings",
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
              child: SingleChildScrollView(
                child: Column(
                  children: azkarWidgets,
                ),
              )
            ),
            AppSizedBox.space25h,
          ],
        ),
      ),
    );
  }

  int _getRepeatCount(String zikarName) {
    for (var azkarList in controller.azkarData) {
      for (var azkar in azkarList['content']) {
        if (azkar['zikar'] == zikarName) {
          return azkar['repeat'];
        }
      }
    }
    return 0;
  }

  Map<String, dynamic>? _getZikarData(String zikarName) {
    for (var azkarList in controller.azkarData) {
      for (var azkar in azkarList['content']) {
        if (azkar['zikar'] == zikarName) {
          return azkar;
        }
      }
    }
    return null;
  }

  bool _hasContinueAzkar() {
    return box.getKeys().any((key) =>
    key.startsWith('azkar_count_') && (box.read(key) ?? 0) > 0 &&
        (box.read(key) ?? 0) <
            _getRepeatCount(key.substring('azkar_count_'.length)));
  }
}