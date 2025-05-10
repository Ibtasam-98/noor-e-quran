import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:intl/intl.dart';
import 'package:noor_e_quran/app/modules/home/controllers/view_all_prayer_screen_controller.dart';
import '../../../controllers/user_location_premission_controller.dart';
import '../../../controllers/app_theme_switch_controller.dart';
import 'package:quran/quran.dart' as quran;

class AppHomeScreenController extends GetxController with GetSingleTickerProviderStateMixin {
  final AppThemeSwitchController themeController = Get.put(AppThemeSwitchController());
  final UserPermissionController locationController = Get.put(UserPermissionController());
  final NamazController namazController = Get.put(NamazController());

  var city = "Locating...".obs;
  final isLoading = false.obs;
  bool isIconOpen = false;
  var currentFontSize = 24.0.obs;
  Timer? timer;
  final GetStorage _box = GetStorage();
  List<Map<String, dynamic>> lastAccessedSurahs = [];
  RxString marqueeText = ''.obs;

  late AnimationController animationController;
  late Animation<double> scaleAnimation;
  final advancedDrawerController = AdvancedDrawerController();

  @override
  void onInit() {
    super.onInit();
    updateMarqueeText();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
    scaleAnimation = Tween<double>(begin: 0.9, end: 1.0).animate(
      CurvedAnimation(parent: animationController, curve: Curves.easeInOut),
    );
    loadLastAccessedSurahs();
    _initialize();
  }

  @override
  void onClose() {
    animationController.dispose();
    timer?.cancel();
    super.onClose();
  }

  Future<void> _initialize() async {
    await getLocationPermissionAndFetchNamazTimes();
  }

  Future<void> loadLastAccessedSurahs() async {
    final List<dynamic>? storedSurahs = _box.read('lastAccessedSurahs');
    if (storedSurahs != null) {
      lastAccessedSurahs.assignAll(storedSurahs.map((item) => item as Map<String, dynamic>).toList());
    }
    update(['lastAccessedSurahs']);
  }

  String getCurrentDate() {
    return DateFormat('EEEE, MMMM d, y').format(DateTime.now());
  }

  String getIslamicDate() {
    final today = HijriCalendar.now();
    return '${today.hDay} ${today.longMonthName} ${today.hYear} AH';
  }

  void handleMenuButtonPressed() {
    advancedDrawerController.showDrawer();
  }

  void updateFontSize(double value) {
    currentFontSize.value = value;
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

  void updateMarqueeText() {
    final cityName = locationController.cityName.value;
    final islamicDate = getIslamicDate();
    final currentDate = getCurrentDate();
    marqueeText.value = 'As of $currentDate, in $cityName, the Islamic date is $islamicDate';
  }

  String getSurahName(int surahNumber) {
    return quran.getSurahName(surahNumber);
  }

  String getSurahNameArabic(int surahNumber) {
    return quran.getSurahNameArabic(surahNumber);
  }

  DateTime parseAccessTime(String isoTime) {
    return DateTime.parse(isoTime);
  }
}