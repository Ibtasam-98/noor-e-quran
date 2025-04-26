// controllers/quran_sajdah_list_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quran/quran.dart' as quran;

class QuranSajdahListController extends GetxController {
  final ScrollController scrollController = ScrollController();
  final scrollProgress = 0.0.obs;
  final sajdahVerses = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    scrollController.addListener(updateScrollProgress);
    fetchSajdahVerses();
  }

  @override
  void onClose() {
    scrollController.removeListener(updateScrollProgress);
    scrollController.dispose();
    super.onClose();
  }

  void updateScrollProgress() {
    if (scrollController.hasClients) {
      scrollProgress.value = scrollController.offset /
          scrollController.position.maxScrollExtent;
      scrollProgress.value = scrollProgress.value.clamp(0.0, 1.0);
    }
  }

  void fetchSajdahVerses() {
    for (int surahNumber = 1; surahNumber <= quran.totalSurahCount; surahNumber++) {
      for (int verseNumber = 1; verseNumber <= quran.getVerseCount(surahNumber); verseNumber++) {
        if (quran.isSajdahVerse(surahNumber, verseNumber)) {
          sajdahVerses.add({
            'surahNumber': surahNumber,
            'verseNumber': verseNumber,
          });
        }
      }
    }
  }
}