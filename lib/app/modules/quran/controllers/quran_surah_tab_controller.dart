import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:noor_e_quran/app/modules/quran/views/quran_surah_detail_screen.dart';
import 'package:quran/quran.dart' as quran;

import '../../../config/app_colors.dart';
import '../../../controllers/app_theme_switch_controller.dart';
import '../../../widgets/custom_text.dart';
import '../controllers/quran_main_screen_controller.dart';

class QuranSurahTabController extends GetxController {
  final QuranMainScreenController quranMainScreenController = Get.find<QuranMainScreenController>();
  final GetStorage _box = GetStorage();


  void addSurahToLastAccessed(int surahNumber) {
    final now = DateTime.now().toIso8601String();
    final newSurah = {
      'surahNumber': surahNumber,
      'accessTime': now,
    };

    final existingIndex = quranMainScreenController.lastAccessedSurahs.indexWhere(
          (element) => element['surahNumber'] == surahNumber,
    );

    if (existingIndex != -1) {
      quranMainScreenController.lastAccessedSurahs[existingIndex] = newSurah;
    } else {
      quranMainScreenController.lastAccessedSurahs.add(newSurah);
    }

    _box.write('lastAccessedSurahs', quranMainScreenController.lastAccessedSurahs);
    quranMainScreenController.update();
  }

  void navigateToSurahDetailScreen(int surahNumber) {
    addSurahToLastAccessed(surahNumber);
    Get.to(() => QuranSurahDetailScreen(surahNumber: surahNumber));
  }
}
