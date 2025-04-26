

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:noor_e_quran/app/config/app_sizedbox.dart';
import 'package:noor_e_quran/app/modules/prayer/views/prayer_yearly_record.dart';
import 'package:shimmer/shimmer.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../config/app_colors.dart';
import '../../../controllers/app_theme_switch_controller.dart';
import '../../../widgets/custom_text.dart';
import '../../home/controllers/app_home_screen_controller.dart';


class PrayerTrackerScreen extends StatefulWidget {
  @override
  _PrayerTrackerScreenState createState() => _PrayerTrackerScreenState();
}

class _PrayerTrackerScreenState extends State<PrayerTrackerScreen> {
  final AppHomeScreenController controller = Get.put(AppHomeScreenController());
  final AppThemeSwitchController themeController = Get.put(AppThemeSwitchController());

  CalendarFormat _calendarFormat = CalendarFormat.week;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  final GetStorage _storage = GetStorage();

  Map<String, String> _selectedPrayerStatus = {};

  List<String> mainPrayers = ['Fajr', 'Dhuhr', 'Asr', 'Maghrib', 'Isha'];

  void _savePrayerData() {
    if (_selectedDay == null) {
      Get.snackbar(
        'Error',
        'Please select a valid date!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    String selectedDate = _selectedDay!.toIso8601String().split("T")[0];

    if (_selectedDay!.isAfter(DateTime.now())) {
      Get.snackbar(
        'Warning',
        'You cannot add Prayers status for future dates!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (_storage.hasData(selectedDate)) {
      Get.snackbar(
        'Info',
        'You already offered Namaz for $selectedDate.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    Map<String, String> prayerData = {};

    for (String prayer in mainPrayers) {
      prayerData[prayer] = _selectedPrayerStatus[prayer] ?? "Missed";
    }

    _storage.write(selectedDate, prayerData);

    Get.snackbar(
      'Success',
      'Prayer data saved successfully for $selectedDate!',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  void _showPrayerStatusBottomSheet(String date) {
    Map<String, String> savedData = Map<String, String>.from(
        _storage.read(date) ?? {});

    showModalBottomSheet(
      backgroundColor: AppColors.white,
      context: context,
      builder: (context) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppSizedBox.space5h,
            Padding(
              padding: EdgeInsets.only(left: 12.w, top: 15.h),
              child: CustomText(
                textColor: AppColors.primary,
                fontSize: 20.sp,
                title: "Salat Record for ${date}",
                textAlign: TextAlign.start,
                fontFamily: 'grenda',
              ),
            ),
            AppSizedBox.space10h,
            Expanded(
              child: ListView.builder(
                itemCount: mainPrayers.length,
                itemBuilder: (context, index) {
                  String prayer = mainPrayers[index];
                  String status = savedData[prayer] ?? "Missed";
                  String emoji = "";

                  if (status == "Prayed") {
                    emoji = "🕌🙏";
                  } else if (status == "Late") {
                    emoji = "🕰️😔";
                  } else if (status == "Missed") {
                    emoji = "❌😞";
                  }

                  return Container(
                    margin: EdgeInsets.only(left: 10.w,right: 10.w,bottom: 8.h,top: 8.h),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.r),
                      color: (index % 2 == 0)
                          ? AppColors.primary.withOpacity(0.25)
                          : AppColors.primary.withOpacity(0.09),
                    ),
                    child: ListTile(
                      leading: CustomText(
                        title: (index + 1).toString(),
                        fontSize: 16.sp,
                        textColor: AppColors.black,
                        fontWeight: FontWeight.w600,
                        textOverflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        textAlign: TextAlign.start,
                      ),
                      title: CustomText(
                        title: prayer,
                        fontSize: 16.sp,
                        textColor: AppColors.black,
                        fontWeight: FontWeight.w600,
                        textOverflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        textAlign: TextAlign.start,
                      ),
                      subtitle: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomText(
                            title: "Status $status",
                            fontSize: 14.sp,
                            textColor: AppColors.primary,
                            textAlign: TextAlign.start,
                            textOverflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                          CustomText(
                            title: emoji,
                            fontSize: 18.sp,
                            textColor: AppColors.white,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  void _navigateToMonthlyTracking() {
    int selectedYear = _selectedDay?.year ?? DateTime
        .now()
        .year;
    int selectedMonth = _selectedDay?.month ?? DateTime
        .now()
        .month;



    Get.to(PrayerRecordYearDetail(year: selectedYear,));
  }


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
          firstText: "Prayer ",
          secondText: "Tracker",
          firstTextColor: isDarkMode ? AppColors.white : AppColors.black,
          secondTextColor: AppColors.primary,
          fontSize: 18.sp,
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.data_thresholding_outlined,
              color: textColor,
            ),
            onPressed: _navigateToMonthlyTracking,
          ),
        ],
      ),
      body: Column(
        children: [
          TableCalendar(
            headerStyle: HeaderStyle(
              titleTextStyle: GoogleFonts.quicksand(
                fontSize: 20.sp,
                color: textColor,
              ),
              leftChevronIcon: Icon(
                Icons.arrow_left,
                color: AppColors.primary,
              ),
              rightChevronIcon: Icon(
                Icons.arrow_right,
                color: AppColors.primary,
              ),
            ),
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });

              String dateKey = selectedDay.toIso8601String().split("T")[0];
              if (_storage.hasData(dateKey)) {
                _showPrayerStatusBottomSheet(dateKey);
              }
            },
            calendarFormat: _calendarFormat,
            onFormatChanged: (format) {
              setState(() {
                _calendarFormat = format;
              });
            },
            calendarStyle: CalendarStyle(
              defaultTextStyle: GoogleFonts.quicksand(
                color: textColor,
              ),
              todayDecoration: BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: AppColors.orange,
                shape: BoxShape.circle,
              ),
            ),
          ),
          AppSizedBox.space10h,
          Expanded(
            child: Obx(() {
              return controller.isLoading.value
                  ? Shimmer.fromColors(
                period: Duration(milliseconds: 1000),
                baseColor: AppColors.black.withOpacity(0.1),
                highlightColor: AppColors.grey.withOpacity(0.1),
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: AlwaysScrollableScrollPhysics(),
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8.0),
                      padding: EdgeInsets.all(20.h),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.r),
                        color: (index % 2 == 0)
                            ? AppColors.primary.withOpacity(0.25)
                            : AppColors.primary.withOpacity(0.09),
                      ),
                    );
                  },
                ),
              )
                  : ListView.builder(
                itemCount: mainPrayers.length,
                // Only 4 prayers will be displayed
                itemBuilder: (context, index) {
                  String prayer = mainPrayers[index];
                  String namazTime =
                      controller.namazTimings[prayer] ?? "--/--";
                  Color backgroundColor = (index % 2 == 0)
                      ? AppColors.primary.withOpacity(0.25)
                      : AppColors.primary.withOpacity(0.09);

                  return Container(
                    margin: EdgeInsets.only(
                        left: 10.w, right: 10.w, bottom: 5, top: 10.h),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.r),
                      color: backgroundColor,
                    ),
                    child: ListTile(
                      leading: CustomText(
                        title: (index + 1).toString(),
                        fontSize: 14.sp,
                        textColor: textColor,
                        fontWeight: FontWeight.normal,
                        textOverflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      title: CustomText(
                        title: prayer,
                        fontSize: 16.sp,
                        textColor: textColor,
                        fontWeight: FontWeight.w600,
                        textOverflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        textAlign: TextAlign.start,
                      ),
                      subtitle: CustomText(
                        title: "Time: $namazTime",
                        fontSize: 16.sp,
                        textColor: AppColors.primary,
                        textAlign: TextAlign.start,
                        textOverflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      trailing: DropdownButton<String>(
                        underline: SizedBox.shrink(),
                        dropdownColor: AppColors.white,
                        iconDisabledColor: AppColors.primary,
                        iconEnabledColor: AppColors.primary,
                        value: _selectedPrayerStatus[prayer] ?? "Missed",
                        items: [
                          DropdownMenuItem(
                            value: "Prayed",
                            child: CustomText(
                              title: "Prayed",
                              fontSize: 15.sp,
                              textColor: AppColors.primary,
                            ),
                          ),
                          DropdownMenuItem(
                            value: "Late",
                            child: CustomText(
                              title: "Late",
                              fontSize: 15.sp,
                              textColor: AppColors.primary,
                            ),
                          ),
                          DropdownMenuItem(
                            value: "Missed",
                            child: CustomText(
                              title: "Missed",
                              fontSize: 15.sp,
                              textColor: AppColors.primary,
                            ),
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _selectedPrayerStatus[prayer] = value!;
                          });
                        },
                      ),
                    ),
                  );
                },
              );
            }),
          )
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: themeController.isDarkMode.value ? AppColors.black : AppColors.white,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 0.h),
          child: InkWell(
            onTap: _savePrayerData,
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(10.r),
                gradient: LinearGradient(
                  colors: [
                    AppColors.primary,
                    AppColors.secondry.withOpacity(0.9),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add,
                    color: AppColors.white,
                  ),
                  AppSizedBox.space10w,
                  CustomText(
                    title: "Save Prayer Record",
                    fontSize: 14.sp,
                    textColor:AppColors.white,
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
}
