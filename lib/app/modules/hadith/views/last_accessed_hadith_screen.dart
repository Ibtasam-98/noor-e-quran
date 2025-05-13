import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:intl/intl.dart';
import 'package:noor_e_quran/app/config/app_sizedbox.dart';

import '../../../config/app_colors.dart';
import '../../../controllers/app_theme_switch_controller.dart';
import '../../../widgets/custom_card.dart';
import '../../../widgets/custom_text.dart';
import 'hadith_detail_screen.dart';

class LastAccessedHadithsScreen extends StatelessWidget {
  final box = GetStorage();

  @override
  Widget build(BuildContext context) {
    final keys = box.getKeys().cast<String>().toList();
    final hadithNumberKeys = keys.where((key) {
      if (key is String && key.startsWith('lastAccessedHadithNumber') && key.length > 'lastAccessedHadithNumber'.length) {
        return true;
      }
      return false;
    }).toList();

    print('Found hadithNumberKeys: $hadithNumberKeys'); // Debugging
    final AppThemeSwitchController themeController = Get.put(AppThemeSwitchController());
    bool isDarkMode = themeController.isDarkMode.value;
    final textColor = isDarkMode ? AppColors.white : AppColors.black;

    return Scaffold(
      backgroundColor: isDarkMode ? AppColors.black : AppColors.white,
      appBar: AppBar(
        surfaceTintColor: AppColors.transparent,
        foregroundColor: AppColors.transparent,
        centerTitle: false,
        title: CustomText(
          firstText: "Last",
          secondText: " Accessed",
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
      body: Padding(
        padding: EdgeInsets.only(left: 10.w, right: 10.w),
        child: Column(
          children: [
            CustomCard(
              title: "Recently Accessed Hadith",
              subtitle: "Hadith You've Recently Opened",
              imageUrl: "assets/images/hadith_wallpaper.jpg",
              titleFontSize: 18.sp,
              subtitleFontSize: 12.sp,
              mergeWithGradientImage: true,

            ),
            AppSizedBox.space10h,
            Expanded(
              child: ListView.builder(
                itemCount: hadithNumberKeys.length,
                itemBuilder: (context, index) {
                  final hadithNumberKey = hadithNumberKeys[hadithNumberKeys.length - 1 - index]; // Reverse the order
                  try {
                    final hadithIndex = int.parse(hadithNumberKey.replaceAll('lastAccessedHadithNumber', ''));
                    final hadithFirstBodyKey = 'lastAccessedHadithFirstBody$hadithIndex';
                    final hadithLastBodyKey = 'lastAccessedHadithLastBody$hadithIndex';
                    final hadithGradeKey = 'lastAccessedHadithGrade$hadithIndex';
                    final bookNumberKey = 'lastAccessedBookNumber$hadithIndex';
                    final bookLastNameKey = 'lastAccessedBookLastName$hadithIndex';
                    final bookFirstNameKey = 'lastAccessedBookFirstName$hadithIndex';
                    final collectionNameKey = 'lastAccessedCollectionName$hadithIndex';
                    final timestampKey = 'lastAccessedTimestamp$hadithIndex';
                    print('Attempting to read keys with index: $hadithIndex'); // Debugging
                    final hadithNumber = box.read(hadithNumberKey);
                    final hadithFirstBody = box.read(hadithFirstBodyKey);
                    final hadithLastBody = box.read(hadithLastBodyKey);
                    final hadithGrade = box.read(hadithGradeKey);
                    final bookNumber = box.read(bookNumberKey);
                    final bookLastName = box.read(bookLastNameKey);
                    final bookFirstName = box.read(bookFirstNameKey);
                    final collectionName = box.read(collectionNameKey);
                    final timestampString = box.read(timestampKey);
                    print('Read data: {hadithNumber: $hadithNumber, hadithFirstBody: $hadithFirstBody, ...}'); // Debugging
                    if (hadithNumber == null) {
                      return SizedBox.shrink();
                    }
                    DateTime? timestamp;
                    if (timestampString != null) {
                      timestamp = DateTime.parse(timestampString);
                    }
                    return Container(
                      margin: EdgeInsets.only(bottom: 5, top: 5.h),
                      padding: EdgeInsets.all(12.h),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.r),
                        color: (index % 2 == 1)
                            ? AppColors.primary.withOpacity(0.1)
                            : AppColors.primary.withOpacity(0.29),
                      ),
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          size: 12.h,
                          color: isDarkMode ? AppColors.white : AppColors.black,
                        ),
                        title: CustomText(
                          title: 'Hadith $hadithNumber',
                          fontSize: 16.sp,
                          textColor: isDarkMode ? AppColors.white : AppColors.black,
                          fontWeight: FontWeight.w500,
                          textOverflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          textAlign: TextAlign.start,
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (hadithFirstBody != null)
                              Html(
                                data: hadithFirstBody,
                                shrinkWrap: true,
                                style: {
                                  "body": Style(
                                    fontSize: FontSize(14.0),
                                    maxLines: 2,
                                    color: isDarkMode ? AppColors.white : AppColors.black,
                                  ),
                                },
                              ),
                            if (timestamp != null)
                              CustomText(
                                title: 'Last Accessed: ${DateFormat('yyyy-MM-dd HH:mm').format(timestamp)}',
                                fontSize: 10.sp,
                                textAlign: TextAlign.start,
                                textColor: isDarkMode ? AppColors.white : AppColors.black,
                              ),
                          ],
                        ),
                        onTap: () {
                          Get.to(
                            HadithDetailScreen(
                              hadithNumber: hadithNumber,
                              hadithFirstBody: hadithFirstBody ?? '',
                              hadithLastBody: hadithLastBody ?? '',
                              grade: hadithGrade ?? '',
                              bookNumber: bookNumber ?? '',
                              bookLastName: bookLastName ?? '',
                              bookFirstName: bookFirstName ?? '',
                              collectionName: collectionName ?? '',
                            ),
                          );
                        },
                      ),
                    );
                  } catch (e) {
                    // Handle the FormatException
                    print('Error parsing hadithIndex: $e');
                    print('Key causing the error: $hadithNumberKey');
                    return SizedBox.shrink();
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}