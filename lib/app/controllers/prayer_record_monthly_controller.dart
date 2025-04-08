import 'dart:ui';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:noor_e_quran/app/config/app_colors.dart';

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
        Map<String, String> prayers = Map<String, String>.from(_storage.read(dateKey));
        int offeredCount = prayers.values.where((status) => status == "Prayed").length;
        int lateCount = prayers.values.where((status) => status == "Late").length;

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
      missedPrayers += (5 - (data['offered'] as int));

      data['prayers'].forEach((prayer, status) {
        if (status == "Prayed") {
          prayerStats[prayer] = prayerStats[prayer]! + 1;
        } else if (status == "Late") {
          prayerStats[prayer] = prayerStats[prayer]! + 1;
        }
      });
    });
  }

  Color getPrayerColor(String status, bool isDarkMode) {
    switch (status) {
      case 'Prayed':
        return AppColors.green;
      case 'Missed':
        return AppColors.red;
      case 'Late':
        return AppColors.orange;
      default:
        return AppColors.transparent;
    }
  }

  String formatDate(String dateString) {
    DateTime date = DateTime.parse(dateString);
    return DateFormat('d MMMM yyyy').format(date);
  }
}