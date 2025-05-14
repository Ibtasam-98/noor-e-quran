import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:noor_e_quran/app/config/app_sizedbox.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:shimmer/shimmer.dart';

import '../../../config/app_colors.dart';
import '../../../controllers/app_theme_switch_controller.dart';
import '../../../widgets/custom_formated_text.dart';
import '../../../widgets/custom_text.dart';
import '../../home/controllers/app_home_screen_controller.dart';

class ExportPrayerTime extends StatefulWidget {
  @override
  _ExportPrayerTimeState createState() => _ExportPrayerTimeState();
}

class _ExportPrayerTimeState extends State<ExportPrayerTime> {
  final AppHomeScreenController controller = Get.find();
  int selectedMonth = DateTime.now().month;
  int selectedYear = DateTime.now().year;
  Map<DateTime, Map<String, String>> monthlyPrayerTimes = {};
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchMonthlyPrayerTimes();
  }

  Future<void> _fetchMonthlyPrayerTimes() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final latitude = controller.locationController.latitude.value;
      final longitude = controller.locationController.longitude.value;
      final response = await http.get(Uri.parse(
          'http://api.aladhan.com/v1/calendar?latitude=$latitude&longitude=$longitude&method=2&month=$selectedMonth&year=$selectedYear'));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        monthlyPrayerTimes = {};
        for (var dayData in jsonData['data']) {
          final dateString = dayData['date']['gregorian']['date'];
          final inputFormat = DateFormat('dd-MM-yyyy');
          final date = inputFormat.parse(dateString);
          monthlyPrayerTimes[date] = Map<String, String>.from(dayData['timings']);
        }
      } else {
        monthlyPrayerTimes = {};
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load prayer times.')),
        );
      }
    } catch (e) {
      monthlyPrayerTimes = {};
      print('Error fetching monthly prayer times: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred.')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  final AppThemeSwitchController themeController = Get.find<AppThemeSwitchController>();

  Widget _buildShimmerItem() {
    return Shimmer.fromColors(
      period: const Duration(milliseconds: 1000),
      baseColor: themeController.isDarkMode.value
          ? AppColors.black.withOpacity(0.02)
          : AppColors.black.withOpacity(0.2),
      highlightColor: themeController.isDarkMode.value
          ? AppColors.lightGrey.withOpacity(0.1)
          : AppColors.grey.withOpacity(0.2),
      child: Container(
        margin: EdgeInsets.only(left: 10.w, right: 10.w, bottom: 5.h, top: 5.h),
        width: Get.width,
        height: 100.sp,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(10.r),
        ),
      ),
    );
  }

  Future<void> _generatePdf() async {
    final pdf = pw.Document();

    pdf.addPage(pw.Page(
      build: (pw.Context context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text(
                  'Prayer Calendar for ${DateFormat('MMMM yyyy').format(DateTime(selectedYear, selectedMonth))}', // Corrected line
                  style: pw.TextStyle(fontSize: 18),
                ),
                pw.Text(
                  'Noor e Quran',
                  style: pw.TextStyle(fontSize: 14),
                ),
              ],
            ),
            pw.SizedBox(height: 5),
            pw.Text(
              'Location: ${controller.city.value}',
              style: pw.TextStyle(fontSize: 12, fontStyle: pw.FontStyle.italic),
            ),
            pw.SizedBox(height: 10),
            pw.Table.fromTextArray(
              headers: <String>[
                'Date',
                ...monthlyPrayerTimes.isNotEmpty
                    ? monthlyPrayerTimes.values.first.keys.toList()
                    : []
              ],
              headerStyle: pw.TextStyle(fontSize: 8),
              cellStyle: pw.TextStyle(fontSize: 7),
              data: monthlyPrayerTimes.entries.map((entry) {
                final date = entry.key;
                final timings = entry.value;
                return <String>[
                  DateFormat('d MMMM').format(date),
                  ...timings.values
                      .map((time) =>
                      formatTime(time, is24HourFormat))
                      .toList(),
                ];
              }).toList(),
            ),
          ],
        );
      },
    ));

    await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf.save());
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = themeController.isDarkMode.value;
    final iconColor = isDarkMode ? AppColors.white : AppColors.black;

    return Scaffold(
      backgroundColor: isDarkMode ? AppColors.black : AppColors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: isDarkMode ? AppColors.black : AppColors.white,
        surfaceTintColor: AppColors.transparent,
        foregroundColor: AppColors.transparent,
        title: CustomText(
          firstText: "Export",
          secondText: " Timings",
          fontSize: 18.sp,
          firstTextColor: isDarkMode ? AppColors.white : AppColors.black,
          secondTextColor: AppColors.primary,
        ),
        centerTitle: false,
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
      body: _isLoading
          ? ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) => _buildShimmerItem(),
      )
          : Column(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 10.w, right: 10.w),
            child: Column(
              children: [
                InkWell(
                  focusColor:  AppColors.transparent,
                  hoverColor:  AppColors.transparent,
                  highlightColor:AppColors.transparent,
                  onTap: () {
                    _generatePdf();
                  },
                  child: Container(
                    width: Get.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.r),
                      border: Border.all(
                          color: isDarkMode
                              ? AppColors.white
                              : AppColors.black,
                          width: 1),
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(top: 8.h, bottom: 8.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.picture_as_pdf,
                            color: iconColor,
                          ),
                          AppSizedBox.space10w,
                          CustomText(
                            title: "Export Prayer Time",
                            fontSize: 14.sp,
                            capitalize: true,
                            textColor: isDarkMode
                                ? AppColors.white
                                : AppColors.black,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                AppSizedBox.space15h,
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.29),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: DropdownButton<int>(
                    value: selectedMonth,
                    items: List.generate(12, (index) => index + 1)
                        .map((month) => DropdownMenuItem(
                      value: month,
                      child: CustomText(
                        title: DateFormat('MMMM')
                            .format(DateTime(selectedYear, month)),
                        fontSize: 12.sp,
                        capitalize: true,
                        textAlign: TextAlign.start,
                        textColor: themeController.isDarkMode.value
                            ? AppColors.black
                            : AppColors.black,
                      ),
                    ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedMonth = value!;
                        _fetchMonthlyPrayerTimes();
                      });
                    },
                    underline: Container(),
                    dropdownColor: AppColors.white,
                    icon: Icon(Icons.arrow_drop_down,
                        color: themeController.isDarkMode.value
                            ? AppColors.white
                            : AppColors.black),
                    iconSize: 24,
                    isExpanded: true,
                    selectedItemBuilder: (BuildContext context) {
                      return List.generate(12, (index) => index + 1)
                          .map<Widget>((int item) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: CustomText(
                              title: DateFormat('MMMM').format(DateTime(selectedYear, item)),
                              fontSize: 12.sp,
                              capitalize: true,
                              textAlign: TextAlign.center,
                              textColor: themeController.isDarkMode.value
                                  ? AppColors.white
                                  : AppColors.black,
                            ),
                          ),
                        );
                      }).toList();
                    },
                  ),
                ),
              ],
            ),
          ),
          AppSizedBox.space10h,
          Expanded(
            child: ListView.builder(
              itemCount: monthlyPrayerTimes.length,
              itemBuilder: (context, index) {
                final date = monthlyPrayerTimes.keys.elementAt(index);
                final timings = monthlyPrayerTimes[date]!;
                return Container(
                  margin: EdgeInsets.only(top: 5.h, bottom: 5.h),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.r),
                    color: (index % 2 == 1)
                        ? AppColors.primary.withOpacity(0.29)
                        : AppColors.primary.withOpacity(0.1),
                  ),
                  child: ListTile(
                    title: CustomText(
                      title: DateFormat('d MMMM').format(date),
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      textAlign: TextAlign.start,
                      textColor: AppColors.primary,
                    ),
                    subtitle: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: timings.entries
                            .map((entry) => Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 10.h),
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.center,
                            children: [
                              CustomText(
                                title: entry.key,
                                fontSize: 12.sp,
                                textColor: themeController.isDarkMode.value
                                    ? AppColors.white
                                    : AppColors.black,
                              ),
                              CustomText(
                                title: formatTime(entry.value, is24HourFormat),
                                fontSize: 10.sp,
                                textColor: themeController.isDarkMode.value
                                    ? AppColors.white
                                    : AppColors.black,
                              ),
                              SizedBox(height: 4),
                            ],
                          ),
                        ))
                            .toList(),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}