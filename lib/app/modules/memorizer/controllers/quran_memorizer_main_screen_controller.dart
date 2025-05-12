import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quran/quran.dart' as quran;
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../../../config/app_colors.dart';
import '../../../config/app_sizedbox.dart';
import '../../../widgets/custom_text.dart';

class QuranMemorizerController extends GetxController with GetSingleTickerProviderStateMixin {
  late TabController tabController;

  // Dummy data for hifz progress - replace with your actual data (Rx variables for reactivity)
  final RxDouble hifzProgressPercentage = 0.35.obs;
  final RxInt hifzSurahCount = 20.obs;
  final int totalSurahCount = quran.totalSurahCount;
  final RxInt hifzJuzCount = 5.obs;
  final int totalJuzCount = quran.totalJuzCount;
  final RxInt hifzAyatCount = 1000.obs;
  final int totalAyatCount = quran.totalVerseCount;

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 3, vsync: this);
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }

  // You can add methods here to update the hifz progress data
  void updateOverallProgress(double progress) {
    hifzProgressPercentage.value = progress;
  }

  void updateSurahHifzCount(int count) {
    hifzSurahCount.value = count;
  }

  void updateJuzHifzCount(int count) {
    hifzJuzCount.value = count;
  }

  void updateAyatHifzCount(int count) {
    hifzAyatCount.value = count;
  }

  double getSurahProgress(int surahNumber) {
    // Replace with your logic to get individual surah progress
    return 0.0;
  }

  double getJuzProgress(int juzNumber) {
    return 0.0;
  }
}
