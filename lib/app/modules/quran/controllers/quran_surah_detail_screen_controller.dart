
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icons.dart';
import 'package:quran/quran.dart' as quran;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../config/app_colors.dart';
import '../../../config/app_sizedbox.dart';
import '../../../controllers/app_theme_switch_controller.dart';
import '../../../widgets/custom_snackbar.dart';
import '../../../widgets/custom_text.dart';
import '../../common/views/audio_player_screen.dart';
import '../views/quran_surah_ayat_detail_screen.dart';
import '../views/quran_surah_setting_screen.dart';

class QuranSurahDetailController extends GetxController with GetSingleTickerProviderStateMixin {
  final AppThemeSwitchController themeController = Get.find();
  final GetStorage _storage = GetStorage();

  var isDarkMode = false.obs;
  var isTranslationEnabled = false.obs;
  var selectedTranslation = quran.Translation.enSaheeh.obs;
  var arabicFontSize = 20.0.obs;
  var selectedFontStyle = 'Amiri Quran'.obs;
  var selectedWordSpacing = 0.0.obs;
  var selectedTranslationFontFamily = 'Roboto'.obs;
  var translationSpacing = 1.0.obs;
  var translationFontSize = 20.0.obs;
  var isSavingAyah = false.obs;
  var highlightedAyah = Rx<int?>(null);
  var scrollProgress = 0.0.obs;
  var isFavorite = false.obs;

  late ScrollController scrollController;
  late AnimationController animationController;
  late Animation<double> scaleAnimation;
  Timer? debounceTimer;

  @override
  void onInit() {
    super.onInit();
    isDarkMode.value = themeController.isDarkMode.value;
    scrollController = ScrollController();
    scrollController.addListener(updateScrollProgress);

    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    scaleAnimation = Tween<double>(begin: 0.86, end: 1.0).animate(
      CurvedAnimation(parent: animationController, curve: Curves.easeInOut),
    );

    loadSettings();
  }

  @override
  void onClose() {
    scrollController.removeListener(updateScrollProgress);
    scrollController.dispose();
    animationController.dispose();
    debounceTimer?.cancel();
    super.onClose();
  }

  void updateScrollProgress() {
    if (scrollController.hasClients) {
      double maxScrollExtent = scrollController.position.maxScrollExtent;
      double currentScrollPosition = scrollController.position.pixels;
      if (maxScrollExtent > 0) {
        double newScrollProgress = currentScrollPosition / maxScrollExtent;
        if ((newScrollProgress - scrollProgress.value).abs() > 0.005) {
          scrollProgress.value = newScrollProgress;
        }
      }
    }
  }

  void scrollToAyah(int ayahNumber, BuildContext context) {
    if (scrollController.hasClients) {
      double itemHeight = 100.h;
      double offset = (ayahNumber - 1) * itemHeight;
      double screenHeight = MediaQuery.of(context).size.height;
      double centerOffset = offset - screenHeight / 2 + itemHeight / 2;

      scrollController.animateTo(
        centerOffset > 0 ? centerOffset : 0,
        duration: Duration(milliseconds: 1000),
        curve: Curves.easeInOut,
      );

      highlightedAyah.value = ayahNumber;
      animationController.repeat(reverse: true);

      Timer(Duration(seconds: 10), () {
        animationController.stop();
      });
    }
  }

  Future<void> updateSettings(Map<String, dynamic> settings) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isTranslationEnabled', settings['isTranslationEnabled']);
    await prefs.setString('selectedTranslation', settings['selectedTranslation'].toString());
    await prefs.setDouble('arabicWordSpacing', settings['arabicWordSpacing']);
    await prefs.setString('arabicFontFamily', settings['arabicFontFamily']);
    await prefs.setString('translationFontFamily', settings['translationFontFamily']);
    await prefs.setDouble('translationSpacing', settings['translationSpacing']);
    await prefs.setDouble('arabicFontSize', settings['arabicFontSize']);
    await prefs.setDouble('translationFontSize', settings['translationFontSize']);

    isTranslationEnabled.value = settings['isTranslationEnabled'];
    selectedTranslation.value = settings['selectedTranslation'];
    selectedWordSpacing.value = settings['arabicWordSpacing'];
    selectedFontStyle.value = settings['arabicFontFamily'];
    selectedTranslationFontFamily.value = settings['translationFontFamily'];
    translationSpacing.value = settings['translationSpacing'];
    arabicFontSize.value = settings['arabicFontSize'];
    translationFontSize.value = settings['translationFontSize'];
  }

  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    isTranslationEnabled.value = prefs.getBool('isTranslationEnabled') ?? false;
    selectedTranslation.value = quran.Translation.values.firstWhere(
          (element) => element.toString() ==
          (prefs.getString('selectedTranslation') ?? quran.Translation.enSaheeh.toString()),
      orElse: () => quran.Translation.enSaheeh,
    );
    arabicFontSize.value = prefs.getDouble('arabicFontSize') ?? 20.0;
    selectedFontStyle.value = prefs.getString('arabicFontFamily') ?? 'Amiri Quran';
    selectedWordSpacing.value = prefs.getDouble('arabicWordSpacing') ?? 0.0;
    selectedTranslationFontFamily.value = prefs.getString('translationFontFamily') ?? 'Roboto';
    translationSpacing.value = prefs.getDouble('translationSpacing') ?? 1.0;
    translationFontSize.value = prefs.getDouble('translationFontSize') ?? 20.0;
  }

  Future<void> checkFavoriteStatus(int surahNumber) async {
    final favorites = _storage.read('favoriteSurahs') ?? [];
    isFavorite.value = favorites.contains(surahNumber);
  }

  Future<void> toggleFavorite(int surahNumber) async {
    final favorites = _storage.read('favoriteSurahs') ?? [];
    if (isFavorite.value) {
      favorites.remove(surahNumber);
      CustomSnackbar.show(
        title: "Removed",
        subtitle: "${quran.getSurahNameEnglish(surahNumber)} removed from favorites",
        icon: Icon(Icons.favorite_border, color: AppColors.white),
        backgroundColor: Colors.red,
        textColor: AppColors.white,
      );
    } else {
      favorites.add(surahNumber);
      CustomSnackbar.show(
        title: "Added",
        subtitle: "${quran.getSurahNameArabic(surahNumber)} added to favorites",
        icon: Icon(Icons.favorite, color: AppColors.white),
        backgroundColor: AppColors.green,
        textColor: AppColors.white,
      );
    }
    await _storage.write('favoriteSurahs', favorites);
    isFavorite.value = !isFavorite.value;
  }

  TextStyle getArabicTextStyle(Color textColor) {
    switch (selectedFontStyle.value) {
      case 'Amiri':
        return GoogleFonts.amiri(
          fontSize: arabicFontSize.value,
          wordSpacing: selectedWordSpacing.value,
          color: textColor,
        );
      case 'Amiri Quran':
        return GoogleFonts.amiriQuran(
          fontSize: arabicFontSize.value,
          wordSpacing: selectedWordSpacing.value,
          color: textColor,
        );
      case 'Noto Sans Arabic':
        return GoogleFonts.notoSansArabic(
          fontSize: arabicFontSize.value,
          wordSpacing: selectedWordSpacing.value,
          color: textColor,
        );
      case 'Noto Naskh Arabic':
        return GoogleFonts.notoNaskhArabic(
          fontSize: arabicFontSize.value,
          wordSpacing: selectedWordSpacing.value,
          color: textColor,
        );
      case 'Cairo':
        return GoogleFonts.cairo(
          fontSize: arabicFontSize.value,
          wordSpacing: selectedWordSpacing.value,
          color: textColor,
        );
      case 'Tajawal':
        return GoogleFonts.tajawal(
          fontSize: arabicFontSize.value,
          wordSpacing: selectedWordSpacing.value,
          color: textColor,
        );
      case 'Lalezar':
        return GoogleFonts.lalezar(
          fontSize: arabicFontSize.value,
          wordSpacing: selectedWordSpacing.value,
          color: textColor,
        );
      case 'Lateef':
        return GoogleFonts.lateef(
          fontSize: arabicFontSize.value,
          wordSpacing: selectedWordSpacing.value,
          color: textColor,
        );
      case 'Quicksand':
        return GoogleFonts.quicksand(
          fontSize: arabicFontSize.value,
          wordSpacing: selectedWordSpacing.value,
          color: textColor,
        );
      default:
        return GoogleFonts.amiriQuran(
          fontSize: arabicFontSize.value,
          wordSpacing: selectedWordSpacing.value,
          color: textColor,
        );
    }
  }

  TextStyle getTranslationTextStyle(Color textColor) {
    switch (selectedTranslationFontFamily.value) {
      case 'Roboto':
        return GoogleFonts.roboto(
          color: textColor,
          height: translationSpacing.value,
          fontSize: translationFontSize.value,
        );
      case 'Times New Roman':
        return TextStyle(
          fontFamily: 'Times New Roman',
          color: textColor,
          height: translationSpacing.value,
          fontSize: translationFontSize.value,
        );
      case 'Montserrat':
        return GoogleFonts.montserrat(
          color: textColor,
          height: translationSpacing.value,
          fontSize: translationFontSize.value,
        );
      case 'Inter':
        return GoogleFonts.inter(
          color: textColor,
          height: translationSpacing.value,
          fontSize: translationFontSize.value,
        );
      case 'Comfortaa':
        return GoogleFonts.comfortaa(
          color: textColor,
          height: translationSpacing.value,
          fontSize: translationFontSize.value,
        );
      case 'Questrial':
        return GoogleFonts.questrial(
          color: textColor,
          height: translationSpacing.value,
          fontSize: translationFontSize.value,
        );
      case 'Open Sans':
        return GoogleFonts.openSans(
          color: textColor,
          height: translationSpacing.value,
          fontSize: translationFontSize.value,
        );
      case 'Poppins':
        return GoogleFonts.poppins(
          color: textColor,
          height: translationSpacing.value,
          fontSize: translationFontSize.value,
        );
      default:
        return GoogleFonts.roboto(
          color: textColor,
          height: translationSpacing.value,
          fontSize: translationFontSize.value,
        );
    }
  }

  Future<void> saveAyah(int surahNumber, int verseNumber, String verseText) async {
    if (isSavingAyah.value) return;
    isSavingAyah.value = true;

    final uniqueAyahKey = 'savedAyah_${surahNumber}_$verseNumber';
    if (_storage.read(uniqueAyahKey) != null) {
      CustomSnackbar.show(
        title: "Error",
        subtitle: "This Ayah is already saved!",
        icon: Icon(Icons.error, color: AppColors.white),
        backgroundColor: Colors.red,
        textColor: AppColors.white,
      );
      isSavingAyah.value = false;
      return;
    }

    final audioUrl = await quran.getAudioURLByVerse(surahNumber, verseNumber);
    final currentDate = DateFormat('dd MMMM yyyy').format(DateTime.now());
    final currentTime = DateFormat('hh:mm a').format(DateTime.now());

    await _storage.write(uniqueAyahKey, {
      'timestamp': currentTime,
      'date': currentDate,
      'surahIndex': surahNumber,
      'surahArabicName': quran.getSurahNameArabic(surahNumber),
      'surahLatinName': quran.getSurahNameEnglish(surahNumber),
      'ayahArabicText': verseText,
      'ayatNumber': verseNumber,
      'audioUrl': audioUrl,
    });

    CustomSnackbar.show(
      title: "Success",
      subtitle: "Ayah saved successfully!",
      icon: Icon(Icons.check_circle, color: AppColors.white),
      backgroundColor: AppColors.green,
      textColor: AppColors.white,
    );

    isSavingAyah.value = false;
  }
}