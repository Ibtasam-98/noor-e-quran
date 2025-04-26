import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:noor_e_quran/app/config/app_colors.dart';
import 'package:noor_e_quran/app/config/app_sizedbox.dart';
import 'package:noor_e_quran/app/modules/quran/views/quran_surah_ayat_detail_screen.dart';

import '../../../controllers/app_theme_switch_controller.dart';
import '../../../widgets/custom_text.dart';

class QuranSavedAyatBookmarkScreen extends StatefulWidget {
  @override
  _QuranSavedAyatBookmarkScreenState createState() => _QuranSavedAyatBookmarkScreenState();
}

class _QuranSavedAyatBookmarkScreenState extends State<QuranSavedAyatBookmarkScreen> {
  final GetStorage _storage = GetStorage(); // GetStorage instance

  @override
  void initState() {
    super.initState();
  }

  // Function to fetch saved ayahs from GetStorage
  Future<List<Map<String, dynamic>>> _fetchSavedAyahs() async {
    List<Map<String, dynamic>> savedAyahs = [];

    // Iterate over the keys in GetStorage to find saved ayah details
    for (String key in _storage.getKeys()) {
      if (key.startsWith('savedAyah_')) {
        final ayahData = _storage.read(key);
        if (ayahData != null && ayahData is Map<String, dynamic>) {
          savedAyahs.add(ayahData);
        }
      }
    }
    return savedAyahs;
  }

  final AppThemeSwitchController themeController = Get.put(AppThemeSwitchController());

  @override
  Widget build(BuildContext context) {
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
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _fetchSavedAyahs(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
                child: CustomText(
                  title: "No Saved Ayahs",
                  fontSize: 20.sp,
                  textColor: themeController.isDarkMode.value ? AppColors.white : AppColors.black,
                ));
          }

          // List of saved ayahs
          List<Map<String, dynamic>> savedAyahs = snapshot.data!;

          return ListView.builder(
            itemCount: savedAyahs.length,
            itemBuilder: (context, index) {
              var ayah = savedAyahs[index];
              String timestamp = ayah['timestamp']?.toString() ?? "";
              String date = ayah['date']?.toString() ?? "";
              int ayatNumber = ayah['ayatNumber'] as int? ?? 0;
              int surahIndex = ayah['surahIndex'] as int? ?? 0;
              String surahArabicName = ayah['surahArabicName']?.toString() ?? "-";
              String surahLatinName = ayah['surahLatinName']?.toString() ?? "-";
              String arabicText = ayah['ayahArabicText']?.toString() ?? "No text available";
              String currentDate = DateFormat('dd MMMM yyyy').format(DateTime.now());

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
                    Get.to(QuranSurahAyatDetailsScreen(
                      arabicText: arabicText,
                      ayahIndex: ayatNumber,
                      surahIndex: surahIndex,
                      surahName: surahArabicName,
                      surahLatinName: surahLatinName,
                      surahArabicName: surahArabicName,
                      textAlign: TextAlign.end,
                    ));
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
                            color: themeController.isDarkMode.value
                                ? AppColors.white
                                : AppColors.black,
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
                            // fontFamily: 'grenda',
                            maxLines: 1,
                            textColor: themeController.isDarkMode.value ? AppColors.white : AppColors.black
                          ),

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
                        textColor: themeController.isDarkMode.value
                            ? AppColors.white
                            : AppColors.black,
                      ),
                    ],
                  ),
                  subtitle: Padding(
                    padding: EdgeInsets.only(top: 5.h),
                    child: CustomText(
                      title: "Date $currentDate | Saved on $timestamp",
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
        },
      ),
    );
  }
}