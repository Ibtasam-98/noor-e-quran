import 'package:get/get.dart';
import 'package:quran/quran.dart' as quran;
import 'dart:math';

class AdditionalFeatureController extends GetxController {
  RxInt _currentSurahNumber = 0.obs;

  String get currentSurahNameArabic => quran.getSurahNameArabic(_currentSurahNumber.value);
  String get currentSurahName => quran.getSurahName(_currentSurahNumber.value);
  int get currentSurahVerseCount => quran.getVerseCount(_currentSurahNumber.value);
  // Use the existing _currentSurahNumber.value for the Surah number
  int get currentSurahNumberValue => _currentSurahNumber.value;
  String get currentSurahRevelationPlace => quran.getPlaceOfRevelation(_currentSurahNumber.value);

  @override
  void onInit() {
    super.onInit();
    _generateRandomSurah();
  }

  void _generateRandomSurah() {
    _currentSurahNumber.value = Random().nextInt(114) + 1;
  }
}