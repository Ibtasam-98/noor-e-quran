import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:noor_e_quran/app/config/app_colors.dart';
import 'package:noor_e_quran/app/config/app_sizedbox.dart';
import 'package:noor_e_quran/app/controllers/app_theme_switch_controller.dart';
import 'package:noor_e_quran/app/widgets/custom_text.dart';
import 'package:pdf/pdf.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:pdf/widgets.dart' as pw;

class PrayerRecordMonthly extends StatelessWidget {
  final String monthKey;
  final String monthName;

  PrayerRecordMonthly({required this.monthKey, required this.monthName});

  Future<void> _generatePdf(PrayerRecordMonthlyController controller) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return [
            _buildPdfHeader(controller.monthName),
            pw.SizedBox(height: 20),
            _buildOverallSummary(controller),
            pw.SizedBox(height: 20),
            _buildDailyPrayerDetailsTable(controller),
            pw.SizedBox(height: 20),
            _buildPrayerSpecificSummaryTable(controller),
          ];
        },
      ),
    );

    final bytes = await pdf.save();
    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/prayer_record_${controller.monthKey}.pdf');
    await file.writeAsBytes(bytes);

    OpenFile.open(file.path);
  }

  pw.Widget _buildPdfHeader(String monthName) {
    return pw.Center(
      child: pw.Text(
        '$monthName Prayer Summary',
        style: pw.TextStyle(
          fontSize: 24,
          fontWeight: pw.FontWeight.bold,
        ),
      ),
    );
  }

  pw.Widget _buildOverallSummary(PrayerRecordMonthlyController controller) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Overall Summary:',
          style: pw.TextStyle(
            fontSize: 18,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.SizedBox(height: 10),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
          children: [
            _buildSummaryCell('Total Prayers', controller.totalPrayers.toString()),
            _buildSummaryCell('Offered', controller.offeredPrayers.toString()),
            _buildSummaryCell('Late', controller.latePrayers.toString()),
            _buildSummaryCell('Missed', controller.missedPrayers.toString()),
          ],
        ),
      ],
    );
  }

  pw.Widget _buildDailyPrayerDetailsTable(PrayerRecordMonthlyController controller) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Daily Prayer Details:',
          style: pw.TextStyle(
            fontSize: 18,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.SizedBox(height: 10),
        pw.Table(
          border: pw.TableBorder.all(),
          columnWidths: {
            0: const pw.FixedColumnWidth(80),
            1: const pw.FixedColumnWidth(80),
            2: const pw.FixedColumnWidth(80),
            3: const pw.FixedColumnWidth(80),
            4: const pw.FixedColumnWidth(80),
            5: const pw.FixedColumnWidth(80),
          },
          children: [
            pw.TableRow(
              children: [
                _buildTableHeaderCell('Date'),
                _buildTableHeaderCell('Fajr'),
                _buildTableHeaderCell('Dhuhr'),
                _buildTableHeaderCell('Asr'),
                _buildTableHeaderCell('Maghrib'),
                _buildTableHeaderCell('Isha'),
              ],
            ),
            for (var dayData in controller.dailyData)
              pw.TableRow(
                children: [
                  _buildTableCell(controller.formatDate(dayData['date'])),
                  _buildTableCell(dayData['prayers']['Fajr'] ?? ''),
                  _buildTableCell(dayData['prayers']['Dhuhr'] ?? ''),
                  _buildTableCell(dayData['prayers']['Asr'] ?? ''),
                  _buildTableCell(dayData['prayers']['Maghrib'] ?? ''),
                  _buildTableCell(dayData['prayers']['Isha'] ?? ''),
                ],
              ),
          ],
        ),
      ],
    );
  }

  pw.Widget _buildPrayerSpecificSummaryTable(PrayerRecordMonthlyController controller) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Prayer Specific Summary:',
          style: pw.TextStyle(
            fontSize: 18,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.SizedBox(height: 10),
        pw.Table(
          border: pw.TableBorder.all(),
          columnWidths: {
            0: const pw.FixedColumnWidth(100),
            1: const pw.FixedColumnWidth(80),
            2: const pw.FixedColumnWidth(80),
            3: const pw.FixedColumnWidth(80),
          },
          children: [
            pw.TableRow(
              children: [
                _buildTableHeaderCell('Prayer'),
                _buildTableHeaderCell('Prayed'),
                _buildTableHeaderCell('Late'),
                _buildTableHeaderCell('Missed'),
              ],
            ),
            for (var entry in controller.prayerStats.entries)
              pw.TableRow(
                children: [
                  _buildTableCell(entry.key),
                  _buildTableCell(controller.dailyData.fold<int>(0, (sum, data) => sum + ((data['prayers'][entry.key] == 'Prayed') ? 1 : 0)).toString()),
                  _buildTableCell(controller.dailyData.fold<int>(0, (sum, data) => sum + ((data['prayers'][entry.key] == 'Late') ? 1 : 0)).toString()),
                  _buildTableCell(controller.dailyData.fold<int>(0, (sum, data) => sum + ((data['prayers'][entry.key] == null || data['prayers'][entry.key] == 'Missed') ? 1 : 0)).toString()),
                ],
              ),
          ],
        ),
      ],
    );
  }

  pw.Widget _buildTableHeaderCell(String text) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(8.0),
      child: pw.Text(
        text,
        style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
        textAlign: pw.TextAlign.center,
      ),
    );
  }

  pw.Widget _buildTableCell(String text) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(8.0),
      child: pw.Text(text, textAlign: pw.TextAlign.center),
    );
  }

  pw.Widget _buildSummaryCell(String title, String value) {
    return pw.Column(
      children: [
        pw.Text(title, style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
        pw.Text(value),
      ],
    );
  }


  @override
  Widget build(BuildContext context) {
    final PrayerRecordMonthlyController controller =
    Get.put(PrayerRecordMonthlyController(monthKey, monthName));

    final AppThemeSwitchController themeController = Get.find();
    bool isDarkMode = themeController.isDarkMode.value;
    final iconColor = isDarkMode ? AppColors.white : AppColors.black;
    final textColor = isDarkMode ? AppColors.white : AppColors.black;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: isDarkMode ? AppColors.black : AppColors.white,
        appBar: AppBar(
          backgroundColor: isDarkMode ? AppColors.black : AppColors.white,
          surfaceTintColor: Colors.transparent,
          leading: InkWell(
            onTap: () => Get.back(),
            child: Icon(Icons.arrow_back, color: iconColor),
          ),
          centerTitle: false,
          title: CustomText(
            firstText: "${controller.monthName}",
            secondText: " Summary",
            firstTextColor: textColor,
            secondTextColor: AppColors.primary,
            fontSize: 18.sp,
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.picture_as_pdf, color: iconColor),
              onPressed: () => _generatePdf(controller),
            ),
          ],
          bottom: TabBar(
            dividerColor: Colors.transparent,
            indicatorSize: TabBarIndicatorSize.tab,
            indicatorColor: AppColors.primary,
            labelColor: AppColors.primary,
            labelStyle: GoogleFonts.quicksand(fontSize: 14.sp),
            unselectedLabelColor: textColor,
            tabs: const [
              Tab(text: 'All'),
              Tab(text: 'Prayer Specific'),
              Tab(text: 'Summary'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            buildAllTab(controller, themeController),
            buildPrayerSpecificTab(controller, themeController),
            buildSummaryTab(controller, themeController),
          ],
        ),
      ),
    );
  }

  Widget buildAllTab(PrayerRecordMonthlyController controller,
      AppThemeSwitchController themeController) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppSizedBox.space15h,
        Expanded(
          child: ListView.builder(
            itemCount: controller.dailyData.length,
            itemBuilder: (context, index) {
              controller.dailyData.sort((a, b) =>
                  DateTime.parse(b['date'])
                      .compareTo(DateTime.parse(a['date'])));
              final dayData = controller.dailyData[index];
              return ListTile(
                title: Padding(
                  padding: EdgeInsets.only(bottom: 12.h),
                  child: CustomText(
                    title: "Date ${controller.formatDate(dayData['date'])}",
                    fontSize: 18.sp,
                    textColor: AppColors.primary,
                    fontWeight: FontWeight.w600,
                    textAlign: TextAlign.start,
                    fontFamily: 'grenda',
                  ),
                ),
                subtitle: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (int index = 0;
                      index < dayData['prayers'].keys.length;
                      index++)
                        Container(
                          padding: EdgeInsets.all(15.h),
                          margin: EdgeInsets.only(bottom: 5, top: 5.h),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.r),
                            color: (index % 2 == 1)
                                ? AppColors.primary.withOpacity(0.29)
                                : AppColors.primary.withOpacity(0.1),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              CustomText(
                                title: (index + 1).toString(),
                                fontSize: 14.sp,
                                textColor: themeController.isDarkMode.value
                                    ? AppColors.white
                                    : AppColors.black,
                                fontWeight: FontWeight.w600,
                                textOverflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                              AppSizedBox.space15w,
                              Expanded(
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: CustomText(
                                        title: dayData['prayers'].keys
                                            .elementAt(index),
                                        fontSize: 16.sp,
                                        textColor: themeController
                                            .isDarkMode.value
                                            ? AppColors.white
                                            : AppColors.black,
                                        fontWeight: FontWeight.w600,
                                        textOverflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        textAlign: TextAlign.start,
                                      ),
                                    ),
                                    Expanded(
                                      child: CustomText(
                                        textAlign: TextAlign.end,
                                        title: dayData['prayers'][dayData['prayers']
                                            .keys.elementAt(index)],
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.bold,
                                        textColor: controller.getPrayerColor(
                                          dayData['prayers'][dayData['prayers']
                                              .keys.elementAt(index)],
                                          false,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
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
        )
      ],
    );
  }

  Widget buildPrayerSpecificTab(PrayerRecordMonthlyController controller,
      AppThemeSwitchController themeController) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppSizedBox.space15h,
        Padding(
          padding: EdgeInsets.only(bottom: 15.h, left: 10.w),
          child: CustomText(
            title: "All Prayer Details",
            fontSize: 18.sp,
            textColor: AppColors.primary,
            fontWeight: FontWeight.w600,
            textAlign: TextAlign.start,
            fontFamily: 'grenda',
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                buildPrayerDetailWithExpansion(
                    "Fajr", controller, themeController, 0),
                buildPrayerDetailWithExpansion(
                    "Dhuhr", controller, themeController, 1),
                buildPrayerDetailWithExpansion(
                    "Asr", controller, themeController, 2),
                buildPrayerDetailWithExpansion(
                    "Maghrib", controller, themeController, 3),
                buildPrayerDetailWithExpansion(
                    "Isha", controller, themeController, 4),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget buildSummaryTab(PrayerRecordMonthlyController controller,
      AppThemeSwitchController themeController) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            title: "Namaz Summary",
            fontSize: 18.sp,
            textColor: AppColors.primary,
            fontWeight: FontWeight.w600,
            textAlign: TextAlign.start,
            fontFamily: 'grenda',
          ),
          AppSizedBox.space15h,
          Expanded(
            child: GridView.builder(
              shrinkWrap: true,
              physics: AlwaysScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: 4,
              itemBuilder: (context, index) {
                final List<String> titles = [
                  "Total Prayers",
                  "Offered",
                  "Late",
                  "Missed"
                ];
                final List<int> subtitles = [
                  controller.totalPrayers,
                  controller.offeredPrayers,
                  controller.latePrayers,
                  controller.missedPrayers
                ];

                return Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: (index % 2 == (index ~/ 2) % 2)
                        ? AppColors.primary.withOpacity(0.29)
                        : AppColors.primary.withOpacity(0.1),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CustomText(
                        title: titles[index],
                        fontSize: 18.sp,
                        textColor: AppColors.primary,
                      ),
                      AppSizedBox.space5h,
                      CustomText(
                        title: subtitles[index].toString(),
                        fontSize: 18.sp,
                        textColor: themeController.isDarkMode.value
                            ? AppColors.white
                            : AppColors.black,
                      ),
                    ],
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }

  Widget buildPrayerDetailWithExpansion(String prayerName,
      PrayerRecordMonthlyController controller,
      AppThemeSwitchController themeController, int index) {
    int prayedCount = 0;
    int lateCount = 0;
    int missedCount = 0;

    controller.dailyData.forEach((data) {
      String? status = data['prayers'][prayerName];
      if (status == "Prayed") {
        prayedCount++;
      } else if (status == "Late") {
        lateCount++;
      } else {
missedCount++;
      }
    });

    Color backgroundColor = (index % 2 == 0)
        ? AppColors.primary.withOpacity(0.29)
        : AppColors.primary.withOpacity(0.01);

    Color containerColor = (index % 2 == 1)
        ? AppColors.primary.withOpacity(0.05)
        : AppColors.primary.withOpacity(0.05);

    Color expandedBackgroundColor = themeController.isDarkMode.value
        ? AppColors.black.withOpacity(0.8)
        : AppColors.white;

    return Container(
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: containerColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: ExpansionTile(
          showTrailingIcon: true,
          iconColor: themeController.isDarkMode.value
              ? AppColors.white
              : AppColors.black,
          collapsedBackgroundColor: backgroundColor,
          shape: Border.all(color: AppColors.transparent),
          collapsedIconColor: themeController.isDarkMode.value
              ? AppColors.primary
              : AppColors.black,
          title: Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 5.h),
            child: Row(
              children: [
                CustomText(
                  title: "${index + 1}",
                  fontSize: 16.sp,
                  textColor: themeController.isDarkMode.value
                      ? AppColors.white
                      : AppColors.black,
                  fontWeight: FontWeight.w600,
                  textAlign: TextAlign.start,
                ),
                AppSizedBox.space10w,
                CustomText(
                  title: "$prayerName",
                  fontSize: 16.sp,
                  textColor: themeController.isDarkMode.value
                      ? AppColors.white
                      : AppColors.black,
                  fontWeight: FontWeight.w600,
                  textAlign: TextAlign.start,
                ),
              ],
            ),
          ),
          children: [
            Container(
              decoration: BoxDecoration(
                color: expandedBackgroundColor, // Use the new color
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: EdgeInsets.only(top: 10.h, bottom: 10.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        CustomText(
                            title: "Prayed",
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w600,
                            textColor: AppColors.paleGreen,
                            maxLines: 2),
                        CustomText(
                          textColor: themeController.isDarkMode.value
                              ? AppColors.white
                              : AppColors.black,
                          fontSize: 18.sp,
                          title: prayedCount.toString(),
                        )
                      ],
                    ),
                    Column(
                      children: [
                        CustomText(
                            title: "Missed",
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w600,
                            textColor: AppColors.red,
                            maxLines: 2),
                        CustomText(
                            textColor: themeController.isDarkMode.value
                                ? AppColors.white
                                : AppColors.black,
                            fontSize: 18.sp,
                            title: missedCount.toString())
                      ],
                    ),
                    Column(
                      children: [
                        CustomText(
                            title: "Late",
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w600,
                            textColor: AppColors.orange,
                            maxLines: 2),
                        CustomText(
                            textColor: themeController.isDarkMode.value
                                ? AppColors.white
                                : AppColors.black,
                            fontSize: 18.sp,
                            title: lateCount.toString())
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class PrayerRecordMonthlyController extends GetxController {
  final GetStorage _storage = GetStorage();
  late String monthKey;
  late String monthName;
  late List<Map<String, dynamic>> dailyData;
  late int totalPrayers;
  late int offeredPrayers;
  late int latePrayers;
  late int missedPrayers;
  late Map<String, int> prayerStats;

  PrayerRecordMonthlyController(this.monthKey, this.monthName) {
    dailyData = getDailyPrayerData(monthKey);
    aggregateStats();
  }

  List<Map<String, dynamic>> getDailyPrayerData(String monthKey) {
    List<Map<String, dynamic>> dailyData = [];

    for (int day = 1; day <= 31; day++) {
      String dateKey = '$monthKey-${day.toString().padLeft(2, '0')}';
      if (_storage.hasData(dateKey)) {
        Map<String, String> prayers =
        Map<String, String>.from(_storage.read(dateKey));
        int offeredCount =
            prayers.values.where((status) => status == "Prayed").length;
        int lateCount =
            prayers.values.where((status) => status == "Late").length;

        dailyData.add({
          "date": dateKey,
          "offered": offeredCount,
          "late": lateCount,
          "prayers": prayers,
        });
      }
    }

    return dailyData;
  }

  void aggregateStats() {
    totalPrayers = 0;
    offeredPrayers = 0;
    latePrayers = 0;
    missedPrayers = 0;

    prayerStats = {
      'Fajr': 0,
      'Dhuhr': 0,
      'Asr': 0,
      'Maghrib': 0,
      'Isha': 0,
    };

    dailyData.forEach((data) {
      totalPrayers += 5;
      offeredPrayers += (data['offered'] as int);
      latePrayers += (data['late'] as int);
      missedPrayers += (5 - (data['offered'] as int) - (data['late'] as int));

      data['prayers'].forEach((prayer, status) {
        if (status == "Prayed") {
          prayerStats[prayer] = prayerStats[prayer]! + 1;
        } else if (status == "Late") {
          prayerStats[prayer] = prayerStats[prayer]! + 1;
        }
      });
    });
  }

  Color getPrayerColor(String? status, bool isDarkMode) {
    switch (status) {
      case 'Prayed':
        return AppColors.paleGreen;
      case 'Missed':
        return AppColors.red;
      case 'Late':
        return AppColors.orange;
      default:
        return AppColors.transparent;
    }
  }

  String formatDate(String dateString) {
    DateTime date = DateTime.parse(dateString.split('-').take(3).join('-'));
    return DateFormat('d MMMM yyyy').format(date);
  }
}