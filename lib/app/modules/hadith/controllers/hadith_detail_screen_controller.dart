

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:noor_e_quran/app/config/app_colors.dart';

import '../../../widgets/custom_snackbar.dart';

class HadithDetailScreenController extends GetxController {
  final isBookmarked = false.obs; // Reactive variable for bookmark status
  final GetStorage storage = GetStorage();
  RxDouble currentFontSize = 18.0.obs;

  // Method to check if the hadith is bookmarked
  void checkBookmarkStatus(String hadithNumber) {
    final savedHadiths = storage.read<List>('savedHadiths') ?? [];
    isBookmarked.value = savedHadiths.any((hadith) => hadith['hadithNumber'] == hadithNumber);
  }

  // Method to toggle the bookmark and save the date and time
  void toggleBookmark(String hadithNumber, Map<String, dynamic> hadithData) {
    final savedHadiths = storage.read<List>('savedHadiths') ?? [];

    if (isBookmarked.value) {
      // Remove the hadith from saved hadiths
      savedHadiths.removeWhere((hadith) => hadith['hadithNumber'] == hadithNumber);
      CustomSnackbar.show(
        title: "Removed",
        subtitle: "Hadith removed from bookmarks",
        icon: Icon(Icons.check),
        backgroundColor: AppColors.green,
      );
    } else {
      String dateTime = DateFormat('d MMM yyyy, hh:mm a').format(DateTime.now());
      hadithData['savedAt'] = dateTime;
      savedHadiths.add(hadithData);
      CustomSnackbar.show(
        title: "Saved",
        subtitle: "Hadith added to bookmarks",
        icon: Icon(Icons.check),
        backgroundColor: AppColors.green,
      );
    }
    storage.write('savedHadiths', savedHadiths);
    isBookmarked.value = !isBookmarked.value;
  }
  void updateFontSize(double value) {
    currentFontSize.value = value;
  }
}