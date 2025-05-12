//
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:noor_e_quran/app/controllers/user_location_premission_controller.dart';
import 'package:quran/quran.dart';
import 'package:quran/quran.dart' as quran;
import '../../../controllers/app_theme_switch_controller.dart';
import '../../../widgets/pdf_viewer.dart';
import '../views/quran_complete_list_surahs.dart';
import '../views/quran_digital_screen.dart';
import '../views/quran_sajjdas_list_screen.dart';
import '../views/quran_saved_ayat_bookmark_screen.dart';
import '../views/quran_write_note_screen.dart';

class QuranMainScreenController extends GetxController with GetSingleTickerProviderStateMixin {
  final AppThemeSwitchController themeController = Get.put(AppThemeSwitchController());
  final UserPermissionController locationController = Get.put(UserPermissionController());

  List<Map<String, dynamic>> lastAccessedSurahs = [];
  final GetStorage _box = GetStorage();


  var randomVerse = RandomVerse().obs;
  Timer? timer;

  @override
  void onInit() {
    super.onInit();
    loadLastAccessedSurahs();
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

  Future<void> loadLastAccessedSurahs() async {
    print("Loading last accessed surahs...");
    final List<dynamic>? storedSurahs = _box.read('lastAccessedSurahs');
    print("Stored surahs from GetStorage: $storedSurahs");
    if (storedSurahs != null) {
      lastAccessedSurahs.assignAll(storedSurahs.map((item) => item as Map<String, dynamic>).toList());
      print("Last accessed surahs loaded: $lastAccessedSurahs");
    } else {
      print("No last accessed surahs found in GetStorage.");
    }
    update(['lastAccessedSurahs']);
    print("Controller updated.");
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
      "destination": () =>  QuranCompleteListSurahs(),
    },
    {
      "title": "Quran",
      "subtitle": "Read Quran",
      "destination": () =>  QuranPdfViewer(),
    },
    {
      "title": "Sajdaas",
      "subtitle": "Verses In Quran",
      "destination": () =>  QuranSajdahListScreen(),
    },
    {
      "title": "Notes",
      "subtitle": "Write & Reflect",
      "destination": () => QuranNotesScreen(),
    },
    {
      "title": "Tajweed",
      "subtitle": "Learn Tajweed",
      "destination": () => PdfViewer(
        assetPath: "assets/pdf/basic_tajweed.pdf",
        firstTitle: "Tajweed",
        secondTitle: " Guide",
      ),
    },
    {
      "title": "Bookmark",
      "subtitle": "Resume Reading",
      "destination": () => QuranSavedAyatBookmarkScreen(),
    },
  ];
}

