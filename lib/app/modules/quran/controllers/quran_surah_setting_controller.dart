import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:quran/quran.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class QuranSurahSettingController extends GetxController {
  RxBool isTranslationEnabled = false.obs;
  Rx<Translation> selectedTranslation = Translation.enSaheeh.obs;
  RxDouble translationSpacing = 1.0.obs;
  RxDouble arabicWordSpacing = 0.0.obs;
  RxString arabicFontFamily = 'amiri'.obs;
  RxString translationFontFamily = 'Roboto'.obs;
  final arabicFontSize = 20.0.obs;
  final translationFontSize = 20.0.obs;

  void initSettings({
    required Translation currentTranslation,
    required bool isTranslationEnabled,
    required double currentWordSpacing,
    required String currentArabicFontFamily,
    required String currentTranslationFontFamily,
    double currentFontSize = 20.0,
  }) {
    selectedTranslation.value = currentTranslation;
    this.isTranslationEnabled.value = isTranslationEnabled;
    arabicWordSpacing.value = currentWordSpacing.clamp(0.0, 25.0);
    arabicFontFamily.value = currentArabicFontFamily;
    translationFontFamily.value = currentTranslationFontFamily;
    arabicFontSize.value = currentFontSize > 18.sp ? currentFontSize : 18.sp;
    translationFontSize.value = currentFontSize > 18.sp ? currentFontSize : 18.sp;
    arabicFontSize.value = currentFontSize.clamp(20.0, 100.0);
    translationFontSize.value = currentFontSize.clamp(20.0, 100.0);
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    isTranslationEnabled.value = prefs.getBool('isTranslationEnabled') ?? isTranslationEnabled.value;
    selectedTranslation.value = Translation.values.firstWhere(
          (translation) => translation.name == (prefs.getString('selectedTranslation') ?? selectedTranslation.value.name),
      orElse: () => selectedTranslation.value,
    );
    translationSpacing.value = prefs.getDouble('translationSpacing') ?? 1.0;
    arabicWordSpacing.value = prefs.getDouble('arabicWordSpacing') ?? arabicWordSpacing.value;
    arabicFontFamily.value = prefs.getString('arabicFontFamily') ?? arabicFontFamily.value;
    translationFontFamily.value = prefs.getString('translationFontFamily') ?? translationFontFamily.value;
    arabicFontSize.value = prefs.getDouble('arabicFontSize') ?? arabicFontSize.value;
    translationFontSize.value = prefs.getDouble('translationFontSize') ?? translationFontSize.value;
  }

  Future<void> saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isTranslationEnabled', isTranslationEnabled.value);
    await prefs.setString('selectedTranslation', selectedTranslation.value.name);
    await prefs.setDouble('translationSpacing', translationSpacing.value);
    await prefs.setDouble('arabicWordSpacing', arabicWordSpacing.value);
    await prefs.setString('arabicFontFamily', arabicFontFamily.value);
    await prefs.setString('translationFontFamily', translationFontFamily.value);
    await prefs.setDouble('arabicFontSize', arabicFontSize.value);
    await prefs.setDouble('translationFontSize', translationFontSize.value);
  }

  void resetToDefault() {
    isTranslationEnabled.value = false;
    selectedTranslation.value = Translation.enSaheeh;
    translationSpacing.value = 1.0;
    arabicWordSpacing.value = 0.0;
    arabicFontFamily.value = 'amiri';
    translationFontFamily.value = 'Roboto';
    arabicFontSize.value = 18.sp;
    translationFontSize.value = 18.sp;
  }

  Map<String, dynamic> getSettings() {
    return {
      'isTranslationEnabled': isTranslationEnabled.value,
      'selectedTranslation': selectedTranslation.value,
      'arabicWordSpacing': arabicWordSpacing.value,
      'arabicFontFamily': arabicFontFamily.value,
      'translationFontFamily': translationFontFamily.value,
      'translationSpacing': translationSpacing.value,
      'arabicFontSize': arabicFontSize.value,
      'translationFontSize': translationFontSize.value,
    };
  }

  String getTranslationLabel(Translation translation) {
    switch (translation.name) {
      case 'enSaheeh':
        return 'English (Saheeh International)';
      case 'enClearQuran':
        return 'English (Clear Quran)';
      case 'trSaheeh':
        return 'Turkish';
      case 'chinese':
        return 'Chinese';
      case 'indonesian':
        return 'Indonesian';
      case 'spanish':
        return 'Spanish';
      case 'swedish':
        return 'Swedish';
      case 'bengali':
        return 'Bengali';
      case 'portuguese':
        return 'Portuguese';
      case 'english':
        return 'English';
      case 'urdu':
        return 'Urdu';
      default:
        return translation.name;
    }
  }
}