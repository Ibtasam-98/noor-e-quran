import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:noor_e_quran/app/widgets/custom_text.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../../config/app_colors.dart';
import 'package:quran/quran.dart' as quran;
import '../../../config/app_sizedbox.dart';
import '../../../controllers/app_theme_switch_controller.dart';

class MemorizationProgressScreen extends StatelessWidget {
  final GetStorage _storage = GetStorage();
  final String _memorizedVersesKey = 'memorizedVerses';
  final AppThemeSwitchController appThemeSwitchController = Get.find<AppThemeSwitchController>();

  MemorizationProgressScreen({super.key});

  int _getMemorizedVersesCount(int surahNumber) {
    final memorizedVerses = _storage.read(_memorizedVersesKey) ?? <String>[];
    int count = 0;
    for (var verseKey in memorizedVerses) {
      try {
        final parts = verseKey.split(':');
        final savedSurahNumber = int.parse(parts[0]);
        if (savedSurahNumber == surahNumber) {
          count++;
        }
      } catch (e) {
        debugPrint("Error parsing verse key: $verseKey. Error: $e");
      }
    }
    return count;
  }

  double _getMemorizationPercentage(int surahNumber) {
    final memorizedCount = _getMemorizedVersesCount(surahNumber);
    final totalVerses = quran.getVerseCount(surahNumber);
    return totalVerses > 0 ? (memorizedCount / totalVerses) : 0.0;
  }

  int _getTotalMemorizedVerses() {
    final memorizedVerses = _storage.read(_memorizedVersesKey) ?? <String>[];
    return memorizedVerses.length;
  }

  int _getTotalVersesInQuran() {
    return 6236;
  }

  double _getOverallMemorizationPercentage() {
    final totalMemorized = _getTotalMemorizedVerses();
    final totalVerses = _getTotalVersesInQuran();
    return totalVerses > 0 ? (totalMemorized / totalVerses) : 0.0;
  }

  int _getTotalMemorizedSurahs() {
    Set<int> memorizedSurahs = {};
    final memorizedVerses = _storage.read(_memorizedVersesKey) ?? <String>[];
    for (var verseKey in memorizedVerses) {
      try {
        final parts = verseKey.split(':');
        final savedSurahNumber = int.parse(parts[0]);
        final verseCount = quran.getVerseCount(savedSurahNumber);
        final memorizedCount = _getMemorizedVersesCount(savedSurahNumber);
        if (memorizedCount == verseCount) {
          memorizedSurahs.add(savedSurahNumber);
        }
      } catch (e) {
        debugPrint("Error parsing verse key: $verseKey. Error: $e");
      }
    }
    return memorizedSurahs.length;
  }

  int _getTotalJuzVersesMemorized() {
    final memorizedVerses = _storage.read(_memorizedVersesKey) ?? <String>[];
    int count = 0;
    for (int i = 1; i <= 30; i++) {
      final juzData = quran.getSurahAndVersesFromJuz(i);
      juzData.forEach((surahNumber, verseRange) {
        for (int verseNumber = verseRange[0]; verseNumber <= verseRange[1]; verseNumber++) {
          if (memorizedVerses.contains('$surahNumber:$verseNumber')) {
            count++;
          }
        }
      });
    }
    return count;
  }

  int _getTotalJuzVerses() {
    int count = 0;
    for (int i = 1; i <= 30; i++) {
      final juzData = quran.getSurahAndVersesFromJuz(i);
      juzData.forEach((surahNumber, verseRange) {
        count += (verseRange[1] - verseRange[0] + 1);
      });
    }
    return count;
  }

  double _getJuzMemorizationPercentage() {
    final memorizedCount = _getTotalJuzVersesMemorized();
    final totalCount = _getTotalJuzVerses();
    return totalCount > 0 ? (memorizedCount / totalCount) : 0.0;
  }


  @override
  Widget build(BuildContext context) {
    final totalVersesInQuran = _getTotalVersesInQuran();
    final totalSurahsInQuran = 114;
    final memorizedVersesCount = _getTotalMemorizedVerses();
    final memorizedSurahsCount = _getTotalMemorizedSurahs();
    final juzMemorizationPercentage = _getJuzMemorizationPercentage();
    final overallPercentage = _getOverallMemorizationPercentage();

    // Data for the summary bar chart
    List<ChartData> summaryData = [
      ChartData('Overall', overallPercentage),
      ChartData('Surahs', memorizedSurahsCount / totalSurahsInQuran.toDouble()),
      ChartData('Verses', memorizedVersesCount / totalVersesInQuran.toDouble()),
      ChartData('Juz', juzMemorizationPercentage),
    ];

    return Scaffold(
      backgroundColor:  appThemeSwitchController.isDarkMode.value ? AppColors.black : AppColors.white,
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
          onPressed: () {
            Get.back();
          },
        ),
        backgroundColor:  appThemeSwitchController.isDarkMode.value ? AppColors.black : AppColors.white,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(left:10.w,right: 10.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                  isPercentage: true,
                ),
                _buildMemorizationCard(
                  title: "Verses Memorized",
                  memorizedCount: memorizedVersesCount,
                  totalCount: totalVersesInQuran,
                  textColor: appThemeSwitchController.isDarkMode.value ? AppColors.white : AppColors.black,
                  isDarkMode: appThemeSwitchController.isDarkMode.value,
                  cardColor: AppColors.primary.withOpacity(0.1),
                  isPercentage: false,
                ),
                _buildMemorizationCard(
                  title: "Surahs Memorized",
                  memorizedCount: memorizedSurahsCount,
                  totalCount: totalSurahsInQuran,
                  textColor: appThemeSwitchController.isDarkMode.value ? AppColors.white : AppColors.black,
                  isDarkMode: appThemeSwitchController.isDarkMode.value,
                  cardColor: AppColors.primary.withOpacity(0.1),
                  isPercentage: false,
                ),
                _buildMemorizationCard(
                  title: "Juz Progress",
                  percentage: juzMemorizationPercentage,
                  textColor: appThemeSwitchController.isDarkMode.value ? AppColors.white : AppColors.black,
                  isDarkMode: appThemeSwitchController.isDarkMode.value,
                  cardColor: AppColors.primary.withOpacity(0.29),
                  isPercentage: true,
                ),
              ],
            ),
            // Summary Bar Chart
            CustomText(
              title: "Progress Visualization",
              textColor: appThemeSwitchController.isDarkMode.value ? AppColors.white : AppColors.black,
              fontSize: 14.sp,
              fontFamily: 'grenda',
              textAlign: TextAlign.start,
              maxLines: 1,
            ),
            AppSizedBox.space10h,
            Container(
              decoration: BoxDecoration( // Use the decoration property
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(15.r), // Add your desired border radius
              ),
              child: Padding(
                padding: EdgeInsets.all(10.w),
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10.r),
                      child: SizedBox(
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
                            maximum: 1,
                            interval: 0.2,
                            numberFormat: NumberFormat.percentPattern(),
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
    bool isPercentage = false,
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
          if (!isPercentage && memorizedCount != null && totalCount != null)
            CustomText(
              title: "$memorizedCount/$totalCount",
              fontSize: 16.sp,
              textColor: AppColors.primary,

            ),
          if (isPercentage && percentage != null)
            CustomText(
              title: "${(percentage * 100).toStringAsFixed(1)}%",
              fontSize: 16.sp,
              textColor: AppColors.primary,

            ),
          AppSizedBox.space10h,
          SizedBox(
            child: CircularProgressIndicator(
              value: isPercentage && percentage != null
                  ? percentage
                  : (!isPercentage && memorizedCount != null && totalCount != null && totalCount > 0 ? memorizedCount / totalCount : 0),
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