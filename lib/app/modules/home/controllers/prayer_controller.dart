import 'package:adhan/adhan.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:shimmer/shimmer.dart';
import 'package:intl/intl.dart';

import '../../../controllers/user_location_premission_controller.dart';

class PrayerController extends GetxController {
  final userPermissionController = Get.find<UserPermissionController>();
  var selectedMethod = CalculationMethod.muslim_world_league.obs;
  var prayerTimes = Rxn<PrayerTimes>();
  var isLoading = false.obs;
  var isLoadingPrayerTimes = false.obs;

  void startPrayerTimeLoading() {
    isLoadingPrayerTimes.value = true;
  }

  void stopPrayerTimeLoading() {
    isLoadingPrayerTimes.value = false;
  }

  @override
  void onInit() {
    super.onInit();
    _loadInitialPrayerTimes();
    ever(userPermissionController.locationAccessed, (_) {
      if (userPermissionController.locationAccessed.value) {
        _updatePrayerTimes();
      } else {
        prayerTimes.value = null;
      }
    });
    ever(selectedMethod, (_) async { // Make the ever callback async
      startPrayerTimeLoading();
      await _updatePrayerTimes();
      stopPrayerTimeLoading();
    });
  }

  Future<void> _loadInitialPrayerTimes() async {
    startPrayerTimeLoading();
    await _updatePrayerTimesInternal();
    stopPrayerTimeLoading();
  }

  void updateCalculationMethod(CalculationMethod? method) {
    if (method != null) {
      selectedMethod.value = method;
      // No need to call _updatePrayerTimes directly here, the 'ever' listener will handle it
    }
  }

  Future<void> _updatePrayerTimes() async {
    startPrayerTimeLoading(); // Ensure loading starts when _updatePrayerTimes is called
    await _updatePrayerTimesInternal();
    stopPrayerTimeLoading();
  }

  Future<void> _updatePrayerTimesInternal() async {
    isLoading(true);
    try {
      if (userPermissionController.locationAccessed.value) {
        final myCoordinates = Coordinates(
          userPermissionController.latitude.value,
          userPermissionController.longitude.value,
        );
        final params = selectedMethod.value.getParameters();
        params.madhab = Madhab.hanafi;
        prayerTimes.value = PrayerTimes.today(
          myCoordinates,
          params,
          utcOffset: Duration(hours: DateTime.now().timeZoneOffset.inHours),
        );
      } else {
        prayerTimes.value = null;
      }
    } catch (e) {
      print("Error updating prayer times: $e");
      prayerTimes.value = null;
    } finally {
      isLoading(false);
    }
  }

  String formatTime(DateTime? time) {
    if (time == null) {
      return 'N/A';
    }
    return DateFormat.jm().format(time);
  }

  String formattedHijriDate() {
    HijriCalendar hijri = HijriCalendar.now();
    String monthName = hijri.longMonthName;
    int day = hijri.hDay;
    int year = hijri.hYear;
    return "$monthName, $day. $year";
  }
}