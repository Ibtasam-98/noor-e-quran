import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:noor_e_quran/app/modules/home/controllers/view_all_prayer_screen_controller.dart';
import 'package:quran/quran.dart' as quran;
import '../../../config/app_contants.dart';
import '../../../controllers/user_location_premission_controller.dart';
import '../../../controllers/app_theme_switch_controller.dart';
import '../../../models/surah_model.dart';
import '../../duas/views/dua_main_screen.dart';
import '../../prayer/views/prayer_main_screen.dart';
import '../../quran/controllers/quran_main_screen_controller.dart';
import '../../tasbeeh/views/tasbeeh_counter_screen.dart';
import '../views/hijri_calender_screen.dart';

class AppHomeScreenController extends GetxController with GetSingleTickerProviderStateMixin {
  final AppThemeSwitchController themeController = Get.put(AppThemeSwitchController());
  final UserPermissionController locationController = Get.put(UserPermissionController());
  final NamazController namazController = Get.put(NamazController());
  var city = "Locating...".obs;
  final isLoading = false.obs;
  bool isIconOpen = false;
  late AnimationController animationController;
  late Animation<double> scaleAnimation;
  final advancedDrawerController = AdvancedDrawerController();
  final PageController pageController = PageController();
  final RxInt currentPage = 0.obs;
  Timer? _timer;

  // New PageController for the Daily Surahs slider
  final PageController dailySurahsPageController = PageController(viewportFraction: 0.8);
  final _currentDailySurahPage = 0.obs;
  int get currentDailySurahPage => _currentDailySurahPage.value;
  set currentDailySurahPage(int value) => _currentDailySurahPage.value = value;

  @override
  void onInit() {
    super.onInit();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
    scaleAnimation = Tween<double>(begin: 0.9, end: 1.0).animate(
      CurvedAnimation(parent: animationController, curve: Curves.easeInOut),
    );
    _initialize();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startAutoScroll();
    });
    dailySurahsPageController.addListener(() {
      currentDailySurahPage = dailySurahsPageController.page!.round();
    });
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (pageController.hasClients) {
        if (currentPage.value < AppConstants.sliderItems.length - 1) {
          currentPage.value++;
        } else {
          currentPage.value = 0;
        }

        pageController.animateToPage(
          currentPage.value,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void onClose() {
    animationController.dispose();
    _timer?.cancel();
    pageController.dispose();
    dailySurahsPageController.dispose(); // Dispose the new controller
    super.onClose();
  }

  Future<void> _initialize() async {
    await getLocationPermissionAndFetchNamazTimes();
  }

  void handleMenuButtonPressed() {
    advancedDrawerController.showDrawer();
  }

  Future<void> getLocationPermissionAndFetchNamazTimes() async {
    await locationController.accessLocation();
    if (locationController.locationAccessed.value) {
      await namazController.getNamazTimings(
        locationController.latitude.value,
        locationController.longitude.value,
        method: namazController.selectedCalculationMethod.value,
      );
      city.value = locationController.cityName.value;
    } else {
      city.value = "Location Permission Denied";
    }
  }

  final List<Map<String, dynamic>> menuItems = [
    {"title": "Daily", "subtitle": "Daily Duas", "destination": () =>  DuaMainScreen()},
    {"title": "Tasbeeh", "subtitle": "Zikr Counter", "destination": () => TasbeehCounterScreen()},
    {"title": "Prayers", "subtitle": "Salat Guide", "destination": () => PrayerMainScreen()},
    {"title": "Islamic", "subtitle": "Hijri Calendar", "destination": () => HijriCalendarScreen()},
  ];

  final List<Surah> recommendedSurahs = [
    Surah(
      number: 1,
      name: 'Al-Fatiha',
      englishName: 'The Opening',
      arabicName: quran.getSurahNameArabic(1),
      verseCount: quran.getVerseCount(1),
      revelationType: quran.getPlaceOfRevelation(1),
    ),
    Surah(
      number: 67,
      name: 'Al-Mulk',
      englishName: 'The Sovereignty',
      arabicName: quran.getSurahNameArabic(67),
      verseCount: quran.getVerseCount(67),
      revelationType: quran.getPlaceOfRevelation(67),
    ),
    Surah(
      number: 112,
      name: 'Al-Ikhlas',
      englishName: 'The Sincerity',
      arabicName: quran.getSurahNameArabic(112),
      verseCount: quran.getVerseCount(112),
      revelationType: quran.getPlaceOfRevelation(112),
    ),
    Surah(
      number: 109,
      name: 'Al-Kafirun',
      englishName: 'The Disbelievers',
      arabicName: quran.getSurahNameArabic(109),
      verseCount: quran.getVerseCount(109),
      revelationType: quran.getPlaceOfRevelation(109),
    ),
    Surah(
      number: 114,
      name: 'An-Nas',
      englishName: 'Mankind',
      arabicName: quran.getSurahNameArabic(114),
      verseCount: quran.getVerseCount(114),
      revelationType: quran.getPlaceOfRevelation(114),
    ),
    Surah(
      number: 113,
      name: 'Al-Falaq',
      englishName: 'The Daybreak',
      arabicName: quran.getSurahNameArabic(113),
      verseCount: quran.getVerseCount(113),
      revelationType: quran.getPlaceOfRevelation(113),
    ),
  ];

  List<String> getSurahVerses(int surahNumber) {
    List<String> verses = [];
    for (int i = 1; i <= quran.getVerseCount(surahNumber); i++) {
      verses.add(quran.getVerse(surahNumber, i));
    }
    return verses;
  }

  void addSurahToLastAccessed(int surahNumber) {
    final QuranMainScreenController quranMainScreenController = Get.find<QuranMainScreenController>();
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

    GetStorage().write('lastAccessedSurahs', quranMainScreenController.lastAccessedSurahs); // Use GetStorage() directly
    quranMainScreenController.update();
  }



}