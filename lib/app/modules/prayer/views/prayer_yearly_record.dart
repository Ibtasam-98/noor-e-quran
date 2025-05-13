
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:noor_e_quran/app/config/app_colors.dart';
import 'package:noor_e_quran/app/config/app_sizedbox.dart';
import 'package:noor_e_quran/app/modules/prayer/views/prayer_monthly_record.dart';
import 'package:shimmer/shimmer.dart';
import '../../../controllers/app_theme_switch_controller.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_snackbar.dart';
import '../../../widgets/custom_text.dart';
import '../../home/views/app_home_screen.dart';

class PrayerRecordYearDetail extends StatefulWidget {
  final int year;

  PrayerRecordYearDetail({required this.year});

  @override
  _PrayerRecordYearDetailState createState() => _PrayerRecordYearDetailState();
}

class _PrayerRecordYearDetailState extends State<PrayerRecordYearDetail> {
  final AppThemeSwitchController themeController = Get.put(AppThemeSwitchController());

  final GetStorage _storage = GetStorage();
  bool isLoading = true;
  Map<String, int> prayerStats = {};
  Map<String, Map<String, int>> monthlyStats = {};

  List<String> monthsInYear = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December'
  ];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    await Future.delayed(Duration(seconds: 2)); // Simulate loading

    prayerStats = getPrayerStats(widget.year);
    monthlyStats = getMonthlyPrayerStats(widget.year);

    setState(() {
      isLoading = false;
    });
  }

  Map<String, int> getPrayerStats(int year) {
    Map<String, int> stats = {
      'Fajr': 0,
      'Dhuhr': 0,
      'Asr': 0,
      'Maghrib': 0,
      'Isha': 0,
    };

    for (int month = 1; month <= 12; month++) {
      String monthKey = '$year-${month.toString().padLeft(2, '0')}';
      for (int day = 1; day <= 31; day++) {
        String dateKey = '$monthKey-${day.toString().padLeft(2, '0')}';
        if (_storage.hasData(dateKey)) {
          Map<String, String> prayerData = Map<String, String>.from(_storage.read(dateKey));
          prayerData.forEach((prayer, status) {
            if (status == "Prayed") {
              stats[prayer] = stats[prayer]! + 1;
            }
          });
        }
      }
    }
    return stats;
  }

  Map<String, Map<String, int>> getMonthlyPrayerStats(int year) {
    Map<String, Map<String, int>> stats = {};
    for (int month = 1; month <= 12; month++) {
      String monthKey = '$year-${month.toString().padLeft(2, '0')}';
      Map<String, int> monthData = getPrayerStatsForMonth(monthKey);
      stats[monthsInYear[month - 1]] = monthData;
    }
    return stats;
  }

  Map<String, int> getPrayerStatsForMonth(String monthKey) {
    Map<String, int> stats = {
      'Fajr': 0,
      'Dhuhr': 0,
      'Asr': 0,
      'Maghrib': 0,
      'Isha': 0,
    };

    for (int day = 1; day <= 31; day++) {
      String dateKey = '$monthKey-${day.toString().padLeft(2, '0')}';
      if (_storage.hasData(dateKey)) {
        Map<String, String> prayerData = Map<String, String>.from(_storage.read(dateKey));
        prayerData.forEach((prayer, status) {
          if (status == "Prayed") {
            stats[prayer] = stats[prayer]! + 1;
          }
        });
      }
    }
    return stats;
  }

  Widget buildShimmerGrid() {
    return GridView.builder(
      padding: EdgeInsets.only(left: 10.w, right: 10.w, top: 10.h, bottom: 25.h),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16.w,
        mainAxisSpacing: 16.h,
        childAspectRatio: 1.0,
      ),
      itemCount: monthsInYear.length,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: AppColors.grey.withOpacity(0.1),
          highlightColor: AppColors.grey.withOpacity(0.2),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: (index % 2 == (index ~/ 2) % 2)
                  ? AppColors.grey.withOpacity(0.15)
                  : AppColors.grey.withOpacity(0.6),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = themeController.isDarkMode.value;
    final iconColor = isDarkMode ? AppColors.white :  AppColors.black;
    final textColor = isDarkMode ?  AppColors.white : AppColors.black;
    List<String> monthsWithData = monthsInYear.where((month) {
      Map<String, int>? monthData = monthlyStats[month];
      return monthData?.values.any((count) => count > 0) ?? false;
    }).toList();
    return Scaffold(
      backgroundColor: themeController.isDarkMode.value ? AppColors.black :  AppColors.white,
      appBar: AppBar(
        backgroundColor: themeController.isDarkMode.value ? AppColors.black :  AppColors.white,
        surfaceTintColor: AppColors.transparent,
        leading: InkWell(
          onTap: () {
            Get.back();
          },
          child: Icon(
            Icons.arrow_back,
            color: themeController.isDarkMode.value ?  AppColors.white : AppColors.black,
          ),
        ),
        title: CustomText(
          firstText: "Year ${widget.year}",
          secondText: " Record",
          fontSize:18.sp,
          firstTextColor: isDarkMode ? AppColors.white : AppColors.black,
          secondTextColor: AppColors.primary,
        ),
      ),
      body: isLoading
          ? buildShimmerGrid()
          : GridView.builder(
        padding: EdgeInsets.only(left: 10.w, right: 10.w, top: 10.h, bottom: 25.h),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16.w,
          mainAxisSpacing: 16.h,
          childAspectRatio: 1.0,
        ),
        itemCount: monthsWithData.length,
        itemBuilder: (context, index) {
          String month = monthsWithData[index];
          String monthKey = '${widget.year}-${(monthsInYear.indexOf(month) + 1).toString().padLeft(2, '0')}'; // Construct the monthKey

          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: (index % 2 == (index ~/ 2) % 2)
                  ? AppColors.primary.withOpacity(0.15)
                  : AppColors.primary.withOpacity(0.6),
            ),
            child: ListTile(
              splashColor: AppColors.transparent,
              hoverColor: AppColors.transparent,
              onTap: (){
                Get.to(PrayerRecordMonthly(
                  monthKey: monthKey,
                  monthName: month,  // Pass the month name
                ));
              },
              title: CustomText(
                title: month,
                fontSize: 18.sp,
                textColor: AppColors.primary,
                fontWeight: FontWeight.w600,
                fontFamily: 'grenda',
                textAlign: TextAlign.start,
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (var prayer in ['Fajr', 'Dhuhr', 'Asr', 'Maghrib', 'Isha'])
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 4.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomText(
                            title: "$prayer",
                            fontSize: 14.sp,
                            textColor: themeController.isDarkMode.value ? AppColors.white : AppColors.black,
                            fontWeight: FontWeight.w400,
                            textAlign: TextAlign.start,
                          ),
                          CustomText(
                            title: "${monthlyStats[month]?[prayer] ?? 0}",
                            fontSize: 14.sp,
                            textColor: themeController.isDarkMode.value ? AppColors.white : AppColors.black,
                            fontWeight: FontWeight.bold,
                            textAlign: TextAlign.end,
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        color:themeController.isDarkMode.value ? AppColors.black : AppColors.white,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 0.h),
          child: InkWell(
            onTap: _showDeleteConfirmationDialog,
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                      Icons.delete_forever,
                      color: AppColors.white
                  ),
                  AppSizedBox.space10w,
                  CustomText(
                    title: "Delete Year Records",
                    fontSize: 14.sp,
                    textColor: AppColors.white,
                    fontWeight: FontWeight.normal,
                    textOverflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }


  int getYearlyStat(String statType) {
    // Replace this with your actual logic to fetch stats for the year
    // from GetStorage or any other source.
    return 0; // Placeholder
  }

  void _showDeleteConfirmationDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.white,
          title: CustomText(
            title: "Delete Operation",
            fontSize: 20.sp,
            textColor: AppColors.primary,
            textAlign: TextAlign.start,
            fontFamily: 'grenda',
          ),
          content: CustomText(
            title: "Are you sure you want to delete all Namaz records for the year ${widget.year}?",
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
            textColor: themeController.isDarkMode.value ? AppColors.white : AppColors.black,
            maxLines: 3,
            textAlign: TextAlign.start,
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: InkWell(
                    onTap:(){ Navigator.of(context).pop(false);},
                    child: CustomButton(
                      height: 40.h,
                      haveBgColor: true,
                      borderRadius: 10,
                      btnTitle: 'Cancel',
                      btnTitleColor: AppColors.white,
                      btnBorderColor: AppColors.red,
                      bgColor: AppColors.red,
                      useGradient: false,
                    ),
                  ),
                ),
                AppSizedBox.space10w,
                Expanded(
                  child: InkWell(
                    onTap:(){
                      _deleteYearRecords();
                      CustomSnackbar.show(
                        title: "Success",
                        subtitle: "Records deleted successfully!",
                        icon: Icon(Icons.check),
                        backgroundColor: AppColors.green,
                      );
                      Get.to(AppHomeScreen());
                    },
                    child: CustomButton(
                      height: 40.h,
                      haveBgColor: true,
                      borderRadius: 10,
                      btnTitle: 'Allow',
                      btnTitleColor: AppColors.white,
                      btnBorderColor: AppColors.indigo,
                      bgColor: AppColors.indigo,
                      useGradient: false,
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  void _deleteYearRecords() {
    for (int month = 1; month <= 12; month++) {
      String monthKey = '${widget.year}-${month.toString().padLeft(2, '0')}';
      for (int day = 1; day <= 31; day++) {
        String dateKey = '$monthKey-${day.toString().padLeft(2, '0')}';
        if (_storage.hasData(dateKey)) {
          _storage.remove(dateKey);
        }
      }
    }
  }
}
