import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:noor_e_quran/app/widgets/custom_text.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../../config/app_colors.dart';
import '../../../config/app_sizedbox.dart';
import '../../../controllers/app_theme_switch_controller.dart';
import '../controllers/quran_memorization_progress_controller.dart';

class MemorizationProgressScreen extends StatelessWidget {
  MemorizationProgressScreen({super.key});

  final QuranMemorizationProgressController controller = Get.put(QuranMemorizationProgressController());
  final AppThemeSwitchController appThemeSwitchController = Get.find<AppThemeSwitchController>();

  @override
  Widget build(BuildContext context) {
    final totalVersesInQuran = controller.getTotalVersesInQuran();
    final totalSurahsInQuran = 114;
    final memorizedVersesCount = controller.getTotalMemorizedVerses();
    final memorizedSurahsCount = controller.getTotalMemorizedSurahs();

    // Get raw percentages (0-100 range)
    final overallPercentage = controller.getOverallMemorizationPercentage();
    final surahsPercentage = (memorizedSurahsCount / totalSurahsInQuran) * 100;
    final versesPercentage = (memorizedVersesCount / totalVersesInQuran) * 100;
    final juzPercentage = controller.getJuzMemorizationPercentage();

    // Data for chart - use raw percentages divided by 100 (0-1 range)
    List<ChartData> summaryData = [
      ChartData('Overall', overallPercentage / 100),
      ChartData('Surahs', surahsPercentage / 100),
      ChartData('Verses', versesPercentage / 100),
      ChartData('Juz', juzPercentage / 100),
    ];

    return Scaffold(
      backgroundColor: appThemeSwitchController.isDarkMode.value ? AppColors.black : AppColors.white,
      appBar: AppBar(
        surfaceTintColor: AppColors.transparent,
        foregroundColor: AppColors.transparent,
        centerTitle: false,
        title: CustomText(
          firstText: "Memorization",
          secondText: " Progress",
          firstTextColor: appThemeSwitchController.isDarkMode.value ? AppColors.white : AppColors.black,
          secondTextColor: AppColors.primary,
          fontSize: 18.sp,
        ),
        leading: IconButton(
          icon: Icon(
            Icons.west,
            color: appThemeSwitchController.isDarkMode.value
                ? AppColors.white
                : AppColors.black,
          ),
          onPressed: () => Get.back(),
        ),
        backgroundColor: appThemeSwitchController.isDarkMode.value ? AppColors.black : AppColors.white,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Progress Summary Section
            CustomText(
              title: "Progress Summary",
              textColor: appThemeSwitchController.isDarkMode.value
                  ? AppColors.white
                  : AppColors.black,
              fontSize: 14.sp,
              fontFamily: 'grenda',
              textAlign: TextAlign.start,
              maxLines: 1,
            ),
            AppSizedBox.space10h,

            // Progress Cards Grid
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 10.h,
              crossAxisSpacing: 10.w,
              children: [
                _buildMemorizationCard(
                  title: "Overall Progress",
                  percentage: overallPercentage,
                  textColor: appThemeSwitchController.isDarkMode.value ? AppColors.white : AppColors.black,
                  isDarkMode: appThemeSwitchController.isDarkMode.value,
                  cardColor: AppColors.primary.withOpacity(0.29),
                ),
                _buildMemorizationCard(
                  title: "Verses Memorized",
                  memorizedCount: memorizedVersesCount,
                  totalCount: totalVersesInQuran,
                  textColor: appThemeSwitchController.isDarkMode.value ? AppColors.white : AppColors.black,
                  isDarkMode: appThemeSwitchController.isDarkMode.value,
                  cardColor: AppColors.primary.withOpacity(0.1),
                ),
                _buildMemorizationCard(
                  title: "Surahs Memorized",
                  memorizedCount: memorizedSurahsCount,
                  totalCount: totalSurahsInQuran,
                  textColor: appThemeSwitchController.isDarkMode.value ? AppColors.white : AppColors.black,
                  isDarkMode: appThemeSwitchController.isDarkMode.value,
                  cardColor: AppColors.primary.withOpacity(0.1),
                ),
                _buildMemorizationCard(
                  title: "Juz Progress",
                  percentage: juzPercentage,
                  textColor: appThemeSwitchController.isDarkMode.value ? AppColors.white : AppColors.black,
                  isDarkMode: appThemeSwitchController.isDarkMode.value,
                  cardColor: AppColors.primary.withOpacity(0.29),
                ),
              ],
            ),

            // Progress Visualization Section
            CustomText(
              title: "Progress Visualization",
              textColor: appThemeSwitchController.isDarkMode.value ? AppColors.white : AppColors.black,
              fontSize: 14.sp,
              fontFamily: 'grenda',
              textAlign: TextAlign.start,
              maxLines: 1,
            ),
            AppSizedBox.space10h,

            // Chart Container
            Container(
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(15.r),
              ),
              child: Padding(
                padding: EdgeInsets.all(10.w),
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10.r),
                      child: SizedBox(
                        height: 200.h,
                        child: SfCartesianChart(
                          borderColor: AppColors.primary,
                          backgroundColor: AppColors.primary.withOpacity(0.29),
                          primaryXAxis: CategoryAxis(
                            labelStyle: GoogleFonts.quicksand(
                              fontSize: 10.sp,
                              color: appThemeSwitchController.isDarkMode.value ? AppColors.white : AppColors.black,
                            ),
                          ),
                          primaryYAxis: NumericAxis(
                            minimum: 0,
                            maximum: 0.1, // Show up to 10%
                            interval: 0.01, // 1% intervals
                            numberFormat: NumberFormat.decimalPercentPattern(
                              decimalDigits: 2,
                            ),
                            labelStyle: GoogleFonts.quicksand(
                              fontSize: 10.sp,
                              color: appThemeSwitchController.isDarkMode.value ? AppColors.white : AppColors.black,
                            ),
                          ),
                          series: <CartesianSeries<ChartData, String>>[
                            BarSeries<ChartData, String>(
                              dataSource: summaryData,
                              xValueMapper: (ChartData data, _) => data.x,
                              yValueMapper: (ChartData data, _) => data.y,
                              dataLabelSettings: DataLabelSettings(
                                isVisible: true,
                                labelAlignment: ChartDataLabelAlignment.auto,
                                textStyle: GoogleFonts.quicksand(
                                  fontSize: 10.sp,
                                  color: appThemeSwitchController.isDarkMode.value ? AppColors.white : AppColors.black,
                                ),
                                labelPosition: ChartDataLabelPosition.outside,
                                builder: (dynamic data, dynamic point, dynamic series, int pointIndex, int seriesIndex) {
                                  final rawValue = point.y * 100;
                                  final displayValue = rawValue < 0.1 ? '<0.1%' : '${rawValue.toStringAsFixed(1)}%';
                                  return Text(displayValue);
                                },
                              ),
                              color: AppColors.primary,
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            AppSizedBox.space20h,
          ],
        ),
      ),
    );
  }

  Widget _buildMemorizationCard({
    String? title,
    int? memorizedCount,
    int? totalCount,
    double? percentage,
    required Color textColor,
    required bool isDarkMode,
    required Color cardColor,
  }) {
    return Container(
      padding: EdgeInsets.all(16.0.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.r),
        color: cardColor,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          if (title != null)
            CustomText(
              title: title,
              fontSize: 14.sp,
              textColor: textColor,
              fontWeight: FontWeight.w500,
            ),
          AppSizedBox.space10h,
          if (percentage != null)
            CustomText(
              title: percentage < 0.1 ? "<0.1%" : "${percentage.toStringAsFixed(1)}%",
              fontSize: 16.sp,
              textColor: AppColors.primary,
            )
          else if (memorizedCount != null && totalCount != null)
            CustomText(
              title: "$memorizedCount/$totalCount",
              fontSize: 16.sp,
              textColor: AppColors.primary,
            ),
          AppSizedBox.space10h,
          SizedBox(
            height: 40.h,
            width: 40.w,
            child: CircularProgressIndicator(
              strokeWidth: 4.w,
              value: percentage != null
                  ? (percentage / 100).clamp(0.0, 1.0)
                  : (memorizedCount != null && totalCount != null && totalCount > 0
                  ? (memorizedCount / totalCount).clamp(0.0, 1.0)
                  : 0),
              backgroundColor: Colors.grey.withOpacity(0.3),
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }
}

class ChartData {
  final String x;
  final double y;

  ChartData(this.x, this.y);
}