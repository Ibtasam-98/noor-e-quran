
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PrayerController extends GetxController with GetSingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> scaleAnimation;
  final String? prayerName;
  final String? rakats;
  final List<String>? uniqueStrings;
  var fontSize = 14.0.obs;
  var currentFontSize = 18.0.obs;

  PrayerController({
    this.prayerName,
    this.rakats,
    this.uniqueStrings,
  });


  final RxList<String> arabicText = <String>[].obs;
  final RxList<String> translations = <String>[].obs;


  @override
  void onInit() {
    super.onInit();
    _separateTexts();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);

    scaleAnimation = Tween<double>(begin: 0.9, end: 1.0).animate(
      CurvedAnimation(parent: animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void onClose() {
    animationController.dispose();
    super.onClose();
  }

  void updateFontSize(double value) {
    currentFontSize.value = value;
  }


  void _separateTexts() {
    for (var string in uniqueStrings!) {
      // Assuming Arabic Text is any string that contains Arabic characters.
      if (string.contains(RegExp(r'[\u0600-\u06FF]'))) {
        arabicText.add(string);
      } else {
        translations.add(string);
      }
    }
  }

}
