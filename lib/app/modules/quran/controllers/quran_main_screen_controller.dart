//
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:noor_e_quran/app/controllers/user_location_premission_controller.dart';
import 'package:quran/quran.dart';
import 'package:quran/quran.dart' as quran;
import '../../../controllers/app_theme_switch_controller.dart';

class QuranMainScreenController extends GetxController with GetSingleTickerProviderStateMixin {
  final AppThemeSwitchController themeController = Get.put(AppThemeSwitchController());
  final UserPermissionController locationController = Get.put(UserPermissionController());

  var randomVerse = RandomVerse().obs;
  Timer? timer;

  @override
  void onInit() {
    super.onInit();
    startRandomVerseTimer();
  }

  @override
  void onClose() {
    timer?.cancel();
    super.onClose();
  }

  void startRandomVerseTimer() {
    _getRandomVerse();
    timer = Timer.periodic(const Duration(hours: 1), (timer) {
      _getRandomVerse();
    });
  }

  void _getRandomVerse() {
    randomVerse.value = RandomVerse();
  }

  String getSurahName(int surahNumber) {
    return quran.getSurahName(surahNumber);
  }

  String getSurahNameArabic(int surahNumber) {
    return quran.getSurahNameArabic(surahNumber);
  }

  String getPlaceOfRevelation(int surahNumber) {
    return quran.getPlaceOfRevelation(surahNumber);
  }

  int getVerseCount(int surahNumber) {
    return quran.getVerseCount(surahNumber);
  }

  DateTime parseAccessTime(String isoTime) {
    return DateTime.parse(isoTime);
  }

  final List<Map<String, dynamic>> quranMenuGridItems = [
    {
      "title": "Navigate",
      "subtitle": "Explore Surahs",
      "destination": () => const Placeholder(),
    },
    {
      "title": "Quran",
      "subtitle": "Read Quran",
      "destination": () => const Placeholder(), // Replace Placeholder() with your actual widget
    },
    {
      "title": "Sajdaas",
      "subtitle": "Verses In Quran",
      "destination": () => const Placeholder(), // Replace Placeholder()
    },
    {
      "title": "Notes",
      "subtitle": "Write & Reflect",
      "destination": () => const Placeholder(), // Replace Placeholder()
    },
    {
      "title": "Tajweed",
      "subtitle": "Learn Tajweed",
      "destination": () => const Placeholder(), // Replace Placeholder()
    },
    {
      "title": "Bookmark",
      "subtitle": "Resume Reading",
      "destination": () => const Placeholder(), // Replace Placeholder()
    },
  ];
}

