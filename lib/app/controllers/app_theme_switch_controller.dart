
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter/material.dart';

class AppThemeSwitchController extends GetxController {
  final GetStorage _storage = GetStorage();
  final String _themeKey = 'isDarkMode';
  final String _fontSizeKey = 'currentFontSize';
  RxDouble currentFontSize = 18.0.obs;
  RxBool isDarkMode = false.obs;

  @override
  void onInit() {
    super.onInit();
    isDarkMode.value = _loadThemeFromStorage();
    currentFontSize.value = _loadFontSizeFromStorage();
  }

  void toggleTheme() {
    isDarkMode.value = !isDarkMode.value;
    _saveThemeToStorage(isDarkMode.value);
    Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
  }

  ThemeMode get currentTheme => isDarkMode.value ? ThemeMode.dark : ThemeMode.light;

  bool _loadThemeFromStorage() {
    return _storage.read<bool>(_themeKey) ?? false;
  }

  void _saveThemeToStorage(bool isDark) {
    _storage.write(_themeKey, isDark);
  }

  double _loadFontSizeFromStorage() {
    return _storage.read<double>(_fontSizeKey) ?? 18.0;
  }

  void _saveFontSizeToStorage(double fontSize) {
    _storage.write(_fontSizeKey, fontSize);
  }

  void updateFontSize(double value) {
    currentFontSize.value = value;
    _saveFontSizeToStorage(value);
  }

  RxDouble get fontSizeFactor => RxDouble(currentFontSize.value / 18.0);
}