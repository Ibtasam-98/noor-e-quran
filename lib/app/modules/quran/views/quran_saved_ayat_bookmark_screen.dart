import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:noor_e_quran/app/config/app_colors.dart';
import 'package:noor_e_quran/app/config/app_sizedbox.dart';
import 'package:noor_e_quran/app/modules/quran/views/quran_surah_detail_screen.dart';
import '../../../controllers/app_theme_switch_controller.dart';
import '../../../widgets/custom_text.dart';
import '../controllers/quran_saved_ayat_bookmark_controller.dart'; // Import the controller

class QuranSavedAyatBookmarkScreen extends StatelessWidget {
  final QuranSavedAyatBookmarkController controller = Get.put(QuranSavedAyatBookmarkController());
  final AppThemeSwitchController themeController = Get.find<AppThemeSwitchController>();

  @override
  Widget build(BuildContext context) {
    // Call fetchSavedAyahs every time the widget is built (when it becomes visible)
    controller.fetchSavedAyahs();

    return Scaffold(
      backgroundColor: themeController.isDarkMode.value ? AppColors.black : AppColors.white,
      appBar: AppBar(
        backgroundColor: themeController.isDarkMode.value ? AppColors.black : AppColors.white,
        surfaceTintColor: AppColors.transparent,
        foregroundColor: AppColors.transparent,
        title: CustomText(
          firstText: "Saved",
          secondText: " Ayat",
          fontSize: 18.sp,
          firstTextColor: themeController.isDarkMode.value ? AppColors.white : AppColors.black,
          secondTextColor: AppColors.primary,
        ),
        centerTitle: false,
        leading: InkWell(
          onTap: () {
            Get.back();
          },
          child: Icon(
            Icons.west,
            color: themeController.isDarkMode.value ? AppColors.white : AppColors.black,
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        if (controller.errorMessage.isNotEmpty) {
          return Center(child: Text("Error: ${controller.errorMessage.value}"));
        }

        if (controller.savedAyahs.isEmpty) {
          return Center(
              child: CustomText(
                title: "No Saved Ayahs",
                fontSize: 20.sp,
                textColor: themeController.isDarkMode.value ? AppColors.white : AppColors.black,
              ));
        }

        return ListView.builder(
          itemCount: controller.savedAyahs.length,
          itemBuilder: (context, index) {
            var ayah = controller.savedAyahs[index];
            String timestamp = ayah['timestamp']?.toString() ?? "";
            String date = ayah['date']?.toString() ?? "";
            int ayatNumber = ayah['ayatNumber'] as int? ?? 0;
            int surahIndex = ayah['surahIndex'] as int? ?? 0;
            String surahArabicName = ayah['surahArabicName']?.toString() ?? "-";
            String surahLatinName = ayah['surahLatinName']?.toString() ?? "-";
            String arabicText = ayah['ayahArabicText']?.toString() ?? "No text available";
            String currentDate = DateFormat('dd MMMM yyyy').format(DateTime.now()); // Corrected format

            return Container(
              padding: EdgeInsets.all(10.h),
              margin: EdgeInsets.only(left: 10.w, right: 10.w, bottom: 5, top: 10.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.r),
                color: (index % 2 == 0)
                    ? AppColors.primary.withOpacity(0.25)
                    : AppColors.primary.withOpacity(0.09),
              ),
              child: ListTile(
                splashColor: AppColors.transparent,
                hoverColor: AppColors.transparent,
                focusColor: AppColors.transparent,
                onTap: () {
                  Get.to(
                        () => QuranSurahDetailScreen(
                      ayatNumber: ayatNumber,
                      surahNumber: surahIndex,
                    ),
                  );
                },
                leading: Container(
                  width: 32.w,
                  height: 32.h,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/images/ayat_marker.png"),
                      fit: BoxFit.contain,
                    ),
                  ),
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: 3.h, bottom: 3.h),
                      child: Text(
                        ayatNumber.toString(),
                        style: TextStyle(
                          fontSize: 10.sp,
                          color: themeController.isDarkMode.value ? AppColors.white : AppColors.black,
                        ),
                        textAlign: TextAlign.end,
                      ),
                    ),
                  ),
                ),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomText(
                            title: surahLatinName,
                            textAlign: TextAlign.end,
                            fontSize: 14.sp,
                            maxLines: 1,
                            textColor: themeController.isDarkMode.value ? AppColors.white : AppColors.black),
                        CustomText(
                          title: surahArabicName,
                          textAlign: TextAlign.end,
                          fontSize: 25.sp,
                          maxLines: 1,
                          textColor: AppColors.primary,
                        )
                      ],
                    ),
                    AppSizedBox.space5w,
                    CustomText(
                      title: arabicText,
                      textAlign: TextAlign.end,
                      fontSize: 18.sp,
                      maxLines: 1,
                      textColor: themeController.isDarkMode.value ? AppColors.white : AppColors.black,
                    ),
                  ],
                ),
                subtitle: Padding(
                  padding: EdgeInsets.only(top: 5.h),
                  child: CustomText(
                    title: "Saved on ${ayah['date']} at ${ayah['timestamp']}",
                    textAlign: TextAlign.end,
                    fontSize: 12.sp,
                    maxLines: 2,
                    textColor: AppColors.primary,
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}