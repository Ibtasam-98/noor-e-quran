import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:noor_e_quran/app/controllers/user_location_premission_controller.dart';
import 'package:quran/quran.dart';
import 'package:quran/quran.dart' as quran;
import 'package:shared_preferences/shared_preferences.dart';
import 'app_theme_switch_controller.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class AppHomeScreenController extends GetxController with GetSingleTickerProviderStateMixin {
  final AppThemeSwitchController themeController = Get.put(AppThemeSwitchController());
  final UserPermissionController locationController = Get.put(UserPermissionController()); // Initialize Location Controller

  var city = "Locating...".obs;
  final isLoading = false.obs;
  var isNamazLoading = false.obs;
  var namazTimings = <String, String>{}.obs;
  var namazTimes = <String>["Fajr", "Sunrise", "Dhuhr", "Asr", "Sunset", "Maghrib", "Isha", "Imsak", "Midnight", "Firstthird", "Lastthird"].obs;
  var icons = <String>["fajr.svg", "fajr.svg", "dhuhr.svg", "asr.svg", "asr.svg", "maghrib.svg", "isha.svg", "isha.svg", "isha.svg", "isha.svg", "isha.svg"].obs;
  var nextNamazTime = Rx<DateTime?>(null);
  var nextNamazName = "".obs;
  bool isIconOpen = false;
  var currentFontSize = 24.0.obs;
  var randomVerse = RandomVerse().obs;
  Timer? _namazTimer, timer;
  late AnimationController animationController;
  late Animation<double> scaleAnimation;
  final GetStorage _box = GetStorage();
  List<Map<String, dynamic>> lastAccessedSurahs = [];

  @override
  void onInit() {
    super.onInit();
    startRandomVerseTimer();
    timer = Timer.periodic(const Duration(minutes: 1), (Timer t) {
      _calculateNextNamaz();
    });
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

  void startRandomVerseTimer() {
    _getRandomVerse();
    timer = Timer.periodic(Duration(hours: 1), (timer) {
      _getRandomVerse();
    });
  }

  void _getRandomVerse() {
    randomVerse.value = RandomVerse();
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

  @override
  void dispose() {
    _namazTimer?.cancel();
    super.dispose();
  }

  String getCurrentDate() {
    DateTime now = DateTime.now();
    return DateFormat('EEEE, MMMM d, y').format(now);
  }

  String getIslamicDate() {
    final today = HijriCalendar.now();
    return '${today.hDay} ${today.longMonthName} ${today.hYear} AH';
  }

  Future<void> getNamazTimings(double latitude, double longitude) async {
    isNamazLoading.value = true;
    try {
      final response = await http.get(Uri.parse('http://api.aladhan.com/v1/timings?latitude=$latitude&longitude=$longitude&method=2'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body)['data']['timings'];
        namazTimings.value = {
          'Fajr': data['Fajr'] ?? "--",
          'Sunrise': data['Sunrise'] ?? "--",
          'Dhuhr': data['Dhuhr'] ?? "--",
          'Asr': data['Asr'] ?? "--",
          'Sunset': data['Sunset'] ?? "--",
          'Maghrib': data['Maghrib'] ?? "--",
          'Isha': data['Isha'] ?? "--",
          'Imsak': data['Imsak'] ?? "--",
          'Midnight': data['Midnight'] ?? "--",
          'Firstthird': data['Firstthird'] ?? "--",
          'Lastthird': data['Lastthird'] ?? "--",
        };
        _calculateNextNamaz();
      }
    } finally {
      isNamazLoading.value = false;
    }
  }

  void _calculateNextNamaz() {
    DateTime currentTime = DateTime.now();
    Map<String, DateTime> namazTimes = {};

    namazTimings.forEach((namazName, timeStr) {
      if (timeStr != "--/--") {
        try {
          DateTime prayerTime = DateFormat("HH:mm").parse(timeStr);
          namazTimes[namazName] = DateTime(
            currentTime.year,
            currentTime.month,
            currentTime.day,
            prayerTime.hour,
            prayerTime.minute,
          );
        } catch (e) {
          print('Error parsing Namaz time for $namazName: $e');
        }
      }
    });

    DateTime? nextTime;
    String nextNamaz = "";

    namazTimes.forEach((namazName, namazTime) {
      if (namazTime.isAfter(currentTime) &&
          (nextTime == null || namazTime.isBefore(nextTime!))) {
        nextTime = namazTime;
        nextNamaz = namazName;
      }
    });

    if (nextTime != null) {
      nextNamazTime.value = nextTime;
      nextNamazName.value = nextNamaz;
    } else {
      nextNamazTime.value = null;
      nextNamazName.value = "None Today";
    }
  }

  bool get is24HourFormat {
    if (Get.context != null) {
      return MediaQuery.of(Get.context!).alwaysUse24HourFormat;
    }
    return true;
  }

  String formatTime(String timeStr, bool is24HourFormat) {
    if (timeStr == "--/--") {
      return timeStr;
    }
    try {
      DateTime prayerTime = DateFormat("HH:mm").parse(timeStr);
      return is24HourFormat
          ? DateFormat("HH:mm").format(prayerTime)
          : DateFormat("h:mm a").format(prayerTime);
    } catch (e) {
      print('Error formatting time: $e');
      return timeStr;
    }
  }

  String getTimeRemaining() {
    if (nextNamazTime.value != null) {
      Duration remainingTime = nextNamazTime.value!.difference(DateTime.now());
      if (remainingTime.isNegative) {
        return "Namaz Started";
      }
      int hours = remainingTime.inHours;
      int minutes = remainingTime.inMinutes % 60;
      return "$hours hours $minutes Min";
    }
    return "No Namaz Today";
  }

  final advancedDrawerController = AdvancedDrawerController();

  void handleMenuButtonPressed() {
    advancedDrawerController.showDrawer();
  }

  void updateFontSize(double value) {
    currentFontSize.value = value;
  }

  Future<void> getLocationPermissionAndFetchNamazTimes() async {
    await locationController.accessLocation();
    if (locationController.locationAccessed.value) {
      await getNamazTimings(
          locationController.latitude.value, locationController.longitude.value);
      city.value = locationController.cityName.value;
      locationController.locationAccessed.value = true;
    } else {
      city.value = "Location Permission Denied";
      locationController.locationAccessed.value = false;
    }
  }
}