
import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../models/name_of_Allah.dart';

class IbadatCategoryController extends GetxController {
  late List<NameOfAllah> namesOfAllah;
  late NameOfAllah currentName;
  late Timer timer;
  final random = Random();
  List<Map<String, dynamic>> azkarData = []; // Store loaded azkar data

  @override
  void onInit() {
    super.onInit();
    namesOfAllah = parseJson(jsonData);
    currentName = getRandomName();
    startTimer();
    loadAzkarData();
  }

  @override
  void onClose() {
    timer.cancel();
    super.onClose();
  }

  NameOfAllah getRandomName() {
    return namesOfAllah[random.nextInt(namesOfAllah.length)];
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(minutes: 60), (Timer t) {
      currentName = getRandomName();
      update(); // Notify GetBuilder to rebuild
    });
  }

  Future<void> loadAzkarData() async {
    final sabahData = await rootBundle.loadString('assets/json/akar_al_sabah.json');
    final massaData = await rootBundle.loadString('assets/json/azkar_al_massa.json');
    final postPrayerData = await rootBundle.loadString('assets/json/azkar_post_prayer.json');

    azkarData = [
      json.decode(sabahData),
      json.decode(massaData),
      json.decode(postPrayerData),
    ];
    update(); //update the GetBuilder
  }
}