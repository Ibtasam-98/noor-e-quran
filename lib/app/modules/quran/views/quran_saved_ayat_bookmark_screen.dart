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

class QuranSavedAyatBookmarkScreen extends StatefulWidget {
  @override
  _QuranSavedAyatBookmarkScreenState createState() => _QuranSavedAyatBookmarkScreenState();
}

class _QuranSavedAyatBookmarkScreenState extends State<QuranSavedAyatBookmarkScreen> {
  final GetStorage _storage = GetStorage();
  final AppThemeSwitchController themeController = Get.find<AppThemeSwitchController>();

  @override
  void initState() {
    super.initState();
    debugPrint("Initializing QuranSavedAyatBookmarkScreen");
    debugPrint("Current storage keys: ${_storage.getKeys()}");
  }

  Future<List<Map<String, dynamic>>> _fetchSavedAyahs() async {
    List<Map<String, dynamic>> savedAyahs = [];

    debugPrint("Fetching saved ayahs...");

    for (String key in _storage.getKeys()) {
      if (key.startsWith('bookmark_') || key.startsWith('savedAyah_')) {
        final ayahData = _storage.read(key);
        debugPrint("Found bookmark key: $key with data: $ayahData");

        if (ayahData != null && ayahData is Map<String, dynamic>) {
          int? timestamp;
          if (ayahData['timestamp'] is String) {
            try {
              timestamp = DateFormat('hh:mm a, dd MMMM yyyy').parse(
                  '${ayahData['timestamp']}, ${ayahData['date']}').millisecondsSinceEpoch;
            } catch (e) {
              debugPrint("Error parsing timestamp string: $e");
              timestamp = DateTime.now().millisecondsSinceEpoch;
            }
          } else if (ayahData['timestamp'] is int) {
            timestamp = ayahData['timestamp'] as int;
          }

          String displayTime = "";
          String displayDate = "";
          if (timestamp != null) {
            displayTime = DateFormat('hh:mm a').format(DateTime.fromMillisecondsSinceEpoch(timestamp));
            displayDate = DateFormat('dd MMMM').format(DateTime.fromMillisecondsSinceEpoch(timestamp));
          } else {
            displayTime = ayahData['displayTime'] ?? "";
            displayDate = ayahData['displayDate'] ?? "";
          }

          savedAyahs.add({
            ...ayahData,
            'timestamp': timestamp,
            'displayTime': displayTime,
            'displayDate': displayDate,
            'storageKey': key,
          });
        }
      }
    }
    debugPrint("Total saved ayahs found: ${savedAyahs.length}");
    savedAyahs.sort((a, b) {
      final aTime = a['timestamp'] ?? 0;
      final bTime = b['timestamp'] ?? 0;
      return (bTime as int).compareTo(aTime as int);
    });
    return savedAyahs;
  }
  Future<void> _removeBookmark(String key) async {
    await _storage.remove(key);
    setState(() {});
    Get.snackbar(
      "Removed",
      "Ayah removed from bookmarks",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.primary.withOpacity(0.9),
      colorText: AppColors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = themeController.isDarkMode.value;
    final textColor = isDarkMode ? AppColors.white : AppColors.black;

    return Scaffold(
      backgroundColor: isDarkMode ? AppColors.black : AppColors.white,
      appBar: AppBar(
        backgroundColor: isDarkMode ? AppColors.black : AppColors.white,
        surfaceTintColor: AppColors.transparent,
        foregroundColor: AppColors.transparent,
        title: CustomText(
          firstText: "Saved",
          secondText: " Ayat",
          fontSize: 18.sp,
          firstTextColor: textColor,
          secondTextColor: AppColors.primary,
        ),
        centerTitle: false,
        leading: InkWell(
          onTap: () => Get.back(),
          child: Icon(
            Icons.west,
            color: textColor,
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
            debugPrint("Error fetching bookmarks: ${snapshot.error}");
            return Center(
              child: Text(
                "Error loading bookmarks",
                style: TextStyle(color: textColor),
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.bookmark_remove, size: 50, color: AppColors.primary),
                  SizedBox(height: 20),
                  CustomText(
                    title: "No Saved Ayahs",
                    fontSize: 20.sp,
                    textColor: textColor,
                  ),
                  SizedBox(height: 10),
                  CustomText(
                    title: "Bookmark ayahs to see them here",
                    fontSize: 14.sp,
                    textColor: textColor.withOpacity(0.7),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final ayah = snapshot.data![index];
              final timestamp = ayah['timestamp'] ?? 0;
              final displayTime = ayah['displayTime'] ??
                  DateFormat('hh:mm a').format(DateTime.fromMillisecondsSinceEpoch(timestamp));
              final displayDate = ayah['displayDate'] ??
                  DateFormat('dd MMMM yyyy').format(DateTime.fromMillisecondsSinceEpoch(timestamp));
              final ayatNumber = ayah['ayahNumber'] ?? ayah['ayatNumber'] ?? 0;
              final surahIndex = ayah['surahIndex'] ?? 0;
              final surahArabicName = ayah['surahArabicName'] ?? "-";
              final surahLatinName = ayah['surahLatinName'] ?? "-";
              final arabicText = ayah['ayahArabicText'] ?? "No text available";
              final translation = ayah['translation'] ?? "";
              final storageKey = ayah['storageKey'];

              return Dismissible(
                key: Key(storageKey ?? UniqueKey().toString()),
                direction: DismissDirection.endToStart,
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.only(right: 20),
                  color: Colors.red,
                  child: Icon(Icons.delete, color: Colors.white),
                ),
                confirmDismiss: (direction) async {
                  return await showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text("Remove Bookmark"),
                      content: Text("Are you sure you want to remove this bookmark?"),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: Text("Cancel"),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: Text("Remove", style: TextStyle(color: Colors.red)),
                        ),
                      ],
                    ),
                  );
                },
                onDismissed: (_) => _removeBookmark(storageKey),
                child: Container(
                  padding: EdgeInsets.all(10.h),
                  margin: EdgeInsets.only(left: 10.w, right: 10.w, bottom: 5, top: 10.h),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.r),
                    color: (index % 2 == 0)
                        ? AppColors.primary.withOpacity(0.25)
                        : AppColors.primary.withOpacity(0.09),
                  ),
                  child: ListTile(
                    onTap: () => Get.to(
                      QuranSurahDetailScreen(
                        ayatNumber: ayatNumber,
                        surahNumber: surahIndex,
                      ),
                    ),
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
                              color: textColor,
                            ),
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
                              textColor: textColor,
                            ),
                            CustomText(
                              title: surahArabicName,
                              textAlign: TextAlign.end,
                              fontSize: 25.sp,
                              textColor: AppColors.primary,
                            )
                          ],
                        ),
                        AppSizedBox.space5w,
                        CustomText(
                          title: arabicText,
                          textAlign: TextAlign.end,
                          fontSize: 18.sp,
                          maxLines: 2,
                          textColor: textColor,
                        ),
                        if (translation.isNotEmpty) ...[
                          AppSizedBox.space5w,
                          CustomText(
                            title: translation,
                            textAlign: TextAlign.end,
                            fontSize: 14.sp,
                            maxLines: 2,
                            textColor: textColor.withOpacity(0.7),
                          ),
                        ],
                      ],
                    ),
                    subtitle: Padding(
                      padding: EdgeInsets.only(top: 5.h),
                      child: CustomText(
                        title: "Saved on $displayDate at $displayTime",
                        textAlign: TextAlign.end,
                        fontSize: 12.sp,
                        textColor: AppColors.primary,
                      ),
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