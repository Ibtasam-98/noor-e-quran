import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';
import 'package:quran/quran.dart' as quran;
import '../../../config/app_colors.dart';
import '../../../widgets/custom_snackbar.dart';


class QuranFavrouiteSurahTabController extends GetxController {

  final GetStorage _storage = GetStorage();
  RxList<int> savedSurahs = <int>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadSavedSurahs();
  }



  void _loadSavedSurahs() {
    savedSurahs.value = (_storage.read('favoriteSurahs') as List?)?.cast<int>() ?? [];
  }

  void deleteSurah(int surahNumber) {
    savedSurahs.remove(surahNumber);
    _storage.write('favoriteSurahs', savedSurahs);
    CustomSnackbar.show(
      title: "Removed",
      subtitle: "${quran.getSurahNameArabic(surahNumber)} removed from saved surahs",
      icon: Icon(Icons.delete, color: AppColors.white),
      backgroundColor: Colors.red,
      textColor: AppColors.white,
    );
  }
}