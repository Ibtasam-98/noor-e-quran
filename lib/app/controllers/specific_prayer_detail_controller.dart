
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../config/prayer_enum.dart';

class PrayerDetailsController extends GetxController {
  final PrayerType prayerType;
  final String prayerName;
  final prayerDetails = Rxn<Map<String, dynamic>>();
  final isLoading = true.obs;
  final errorMessage = Rxn<String>();

  PrayerDetailsController(this.prayerType, this.prayerName);

  @override
  void onInit() {
    super.onInit();
    loadPrayerData();
  }

  Future<void> loadPrayerData() async {
    try {
      isLoading.value = true;
      String data = await rootBundle.loadString('assets/json/prayer.json');
      Map<String, dynamic> jsonData = json.decode(data);

      String prayerCategory;
      switch (prayerType) {
        case PrayerType.obligatory:
          prayerCategory = 'Obligatory';
          break;
        case PrayerType.sunnah:
          prayerCategory = 'Sunnah';
          break;
        case PrayerType.eid:
          prayerCategory = 'Eid';
          break;
        case PrayerType.friday:
          prayerCategory = 'Friday';
          break;
        case PrayerType.taraweeh:
          prayerCategory = 'Taraweeh';
          break;
        case PrayerType.funeral:
          prayerCategory = 'Funeral';
          break;
        case PrayerType.hajat:
          prayerCategory = 'Hajat';
          break;
        case PrayerType.istikhara:
          prayerCategory = 'Istikhara';
          break;
        default:
          prayerCategory = '';
      }

      if (prayerCategory == prayerName) {
        prayerDetails.value = jsonData[prayerCategory][prayerName];
      } else {
        prayerDetails.value = jsonData[prayerCategory][prayerName];
      }

      if (prayerDetails.value == null) {
        throw Exception(
            'Prayer details not found for $prayerName in $prayerCategory. jsonData[prayerCategory]: ${jsonData[prayerCategory]}');
      }

      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      errorMessage.value = 'Failed to load data: <span class="math-inline">e';
    }
  }
}