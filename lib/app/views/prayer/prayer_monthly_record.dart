import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:noor_e_quran/app/config/app_colors.dart';
import 'package:noor_e_quran/app/config/app_sizedbox.dart';
import 'package:noor_e_quran/app/controllers/app_theme_switch_controller.dart';
import 'package:noor_e_quran/app/controllers/prayer_record_monthly_controller.dart';
import 'package:noor_e_quran/app/widgets/custom_text.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';


class PrayerRecordMonthly extends StatelessWidget {
  final String monthKey;
  final String monthName;

  PrayerRecordMonthly({required this.monthKey, required this.monthName});


  Future<void> _generateYearPdf(PrayerRecordMonthlyController controller) async {
    final pdf = pw.Document();

    // Group data by month
    Map<String, List<Map<String, dynamic>>> monthlyData = {};
    for (var dayData in controller.dailyData) {
      String month = controller.formatDate(dayData['date']).substring(3, 10);
      if (!monthlyData.containsKey(month)) {
        monthlyData[month] = [];
      }
      monthlyData[month]!.add(dayData);
    }

    // Generate PDF pages for each month
    monthlyData.forEach((month, data) {
      pdf.addPage(
        pw.Page(
          build: (pw.Context context) {
            // Calculate monthly summary
            int totalPrayers = data.length * 5;
            int offeredPrayers = 0;
            int latePrayers = 0;
            int missedPrayers = 0;

            for (var dayData in data) {
              dayData['prayers'].forEach((key, value) {
                if (value == 'Prayed') {
                  offeredPrayers++;
                } else if (value == 'Late') {
                  latePrayers++;
                } else {
                  missedPrayers++;
                }
              });
            }

            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text('$month Prayer Summary',
                    style: pw.TextStyle(fontSize: 20)),
                pw.SizedBox(height: 10),
                pw.Table.fromTextArray(
                  context: context,
                  data: <List<String>>[
                    <String>['Date', 'Fajr', 'Dhuhr', 'Asr', 'Maghrib', 'Isha'],
                    for (var dayData in data)
                      <String>[
                        controller.formatDate(dayData['date']),
                        _getColoredText(dayData['prayers']['Fajr'] ?? ''),
                        _getColoredText(dayData['prayers']['Dhuhr'] ?? ''),
                        _getColoredText(dayData['prayers']['Asr'] ?? ''),
                        _getColoredText(dayData['prayers']['Maghrib'] ?? ''),
                        _getColoredText(dayData['prayers']['Isha'] ?? ''),
                      ],
                  ],
                  border: pw.TableBorder.all(),
                  headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  cellAlignment: pw.Alignment.center,
                ),
                pw.SizedBox(height: 20),
                pw.Text('Summary:', style: pw.TextStyle(fontSize: 18)),
                pw.Text('Total Prayers: $totalPrayers',
                    style: pw.TextStyle(fontSize: 14)),
                pw.Text('Offered: $offeredPrayers',
                    style: pw.TextStyle(fontSize: 14)),
                pw.Text('Late: $latePrayers',
                    style: pw.TextStyle(fontSize: 14)),
                pw.Text('Missed: $missedPrayers',
                    style: pw.TextStyle(fontSize: 14)),
              ],
            );
          },
        ),
      );
    });

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  String _getColoredText(String status) {
    return status;
  }

  pw.Widget _getColoredWidget(String status) {
    pw.TextStyle textStyle;
    if (status == 'Prayed') {
      textStyle = pw.TextStyle(color: PdfColors.green);
    } else if (status == 'Late') {
      textStyle = pw.TextStyle(color: PdfColors.orange);
    } else {
      textStyle = pw.TextStyle(color: PdfColors.red);
    }
    return pw.Text(status, style: textStyle);
  }

  @override
  Widget build(BuildContext context) {
    final PrayerRecordMonthlyController controller = Get.put(
        PrayerRecordMonthlyController(monthKey, monthName));
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
              onPressed: () => _generateYearPdf(controller),
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
                  DateTime.parse(b['date']).compareTo(
                      DateTime.parse(a['date'])));
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
                      for (int index = 0; index <
                          dayData['prayers'].keys.length; index++)
                        Container(
                          padding: EdgeInsets.all(15.h),
                          margin: EdgeInsets.only(bottom: 5, top: 5.h),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.r),
                            color: (index % 2 == 1) ? AppColors.primary
                                .withOpacity(0.29) : AppColors.primary
                                .withOpacity(0.1),
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
                                  mainAxisAlignment: MainAxisAlignment
                                      .spaceBetween,
                                  children: [
                                    Expanded(
                                      child: CustomText(
                                        title: dayData['prayers'].keys
                                            .elementAt(index),
                                        fontSize: 16.sp,
                                        textColor: themeController.isDarkMode
                                            .value ? AppColors.white : AppColors
                                            .black,
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
                    color: (index % 2 == (index ~/ 2) % 2) ? AppColors.primary
                        .withOpacity(0.29) : AppColors.primary.withOpacity(0.1),
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
                        textColor: themeController.isDarkMode.value ? AppColors
                            .white : AppColors.black,
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
      String status = data['prayers'][prayerName] ?? "";
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
        ? AppColors.white
        : AppColors.black;

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
          collapsedIconColor: themeController.isDarkMode.value ? AppColors
              .primary : AppColors.white,
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
                        CustomText(title: "Prayed",
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w600,
                            textColor: AppColors.paleGreen,
                            maxLines: 2),
                        CustomText(
                          textColor: themeController.isDarkMode.value ? AppColors.black :AppColors.white,
                            fontSize: 18.sp,
                            title: prayedCount.toString(),
                        )
                      ],
                    ),
                    Column(
                      children: [
                        CustomText(title: "Missed",
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w600,
                            textColor: AppColors.red,
                            maxLines: 2),
                        CustomText( textColor: themeController.isDarkMode.value ? AppColors.black :AppColors.white,
                            fontSize: 18.sp,
                            title: missedCount.toString())
                      ],
                    ),
                    Column(
                      children: [
                        CustomText(title: "Late",
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w600,
                            textColor: AppColors.orange,
                            maxLines: 2),
                        CustomText( textColor: themeController.isDarkMode.value ? AppColors.black :AppColors.white,
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