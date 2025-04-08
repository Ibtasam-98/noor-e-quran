import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'app_home_screen_controller.dart';


class LastAccessSurahListController extends GetxController {
  final AppHomeScreenController homeScreenController = Get.find<AppHomeScreenController>();
  RxList<Map<String, dynamic>> lastAccessedSurahs = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadLastAccessedSurahs();
  }

  void loadLastAccessedSurahs() {
    homeScreenController.loadLastAccessedSurahs();
    lastAccessedSurahs.assignAll(homeScreenController.lastAccessedSurahs);
  }

  String getSurahName(int surahNumber) {
    return homeScreenController.getSurahName(surahNumber);
  }

  String getSurahNameArabic(int surahNumber) {
    return homeScreenController.getSurahNameArabic(surahNumber);
  }

  DateTime parseAccessTime(String accessTime) {
    return homeScreenController.parseAccessTime(accessTime);
  }
}