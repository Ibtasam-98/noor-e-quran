import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:quran/quran.dart' as quran;
import 'package:intl/intl.dart';

class QuranMemorizerController extends GetxController with SingleGetTickerProviderMixin {
  final GetStorage _storage = GetStorage();
  final String _memorizedVersesKey = 'memorizedVerses';
  final String _lastAccessedTimeKey = 'lastAccessedTime';
  final String _lastAccessedSurahNumberKey = 'lastAccessedSurahNumber';
  late TabController tabController;

  RxInt currentTabIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 3, vsync: this);
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }

  int getMemorizedVersesCount(int surahNumber) {
    final memorizedVerses = _storage.read(_memorizedVersesKey) ?? <String>[];
    int count = 0;
    for (var verseKey in memorizedVerses) {
      try {
        final parts = verseKey.split(':');
        final savedSurahNumber = int.parse(parts[0]);
        if (savedSurahNumber == surahNumber) {
          count++;
        }
      } catch (e) {
        print("Error parsing verse key: $verseKey. Error: $e");
      }
    }
    return count;
  }

  double getMemorizationPercentage(int surahNumber) {
    final memorizedCount = getMemorizedVersesCount(surahNumber);
    final totalVerses = quran.getVerseCount(surahNumber);
    return totalVerses > 0 ? (memorizedCount / totalVerses) : 0.0;
  }

  List<int> getCompletedSurahs() {
    List<int> completedSurahs = [];
    for (int i = 1; i <= quran.totalSurahCount; i++) {
      final percentage = getMemorizationPercentage(i);
      if (percentage >= 1.0) {
        completedSurahs.add(i);
      }
    }
    return completedSurahs;
  }

  int getTotalMemorizedVerses() {
    final memorizedVerses = _storage.read(_memorizedVersesKey) ?? <String>[];
    return memorizedVerses.length;
  }

  int getTotalJuzVersesMemorized() {
    final memorizedVerses = _storage.read(_memorizedVersesKey) ?? <String>[];
    int count = 0;
    for (int i = 1; i <= 30; i++) {
      final juzData = quran.getSurahAndVersesFromJuz(i);
      juzData.forEach((surahNumber, verseRange) {
        for (int verseNumber = verseRange[0]; verseNumber <= verseRange[1]; verseNumber++) {
          if (memorizedVerses.contains('$surahNumber:$verseNumber')) {
            count++;
          }
        }
      });
    }
    return count;
  }

  int getTotalJuzVerses() {
    int count = 0;
    for (int i = 1; i <= 30; i++) {
      final juzData = quran.getSurahAndVersesFromJuz(i);
      juzData.forEach((surahNumber, verseRange) {
        count += (verseRange[1] - verseRange[0] + 1);
      });
    }
    return count;
  }

  String? getLastAccessedTime(int surahNumber) {
    return _storage.read<String?>(_lastAccessedTimeKey);
  }

  int? getLastAccessedSurahNumber() {
    return _storage.read<int?>(_lastAccessedSurahNumberKey);
  }

  String getJuzSurahsText(int juzNumber) {
    final juzData = quran.getSurahAndVersesFromJuz(juzNumber);
    if (juzData.isEmpty) return "No surahs found";

    final surahNumbers = juzData.keys.toList()..sort();
    return surahNumbers.length == 1
        ? "Surah ${surahNumbers.first}"
        : "Surah ${surahNumbers.first} - Surah ${surahNumbers.last}";
  }

  String? getJuzLastAccessedTime(int juzNumber) {
    return _storage.read<String?>('${_lastAccessedTimeKey}Juz$juzNumber');
  }

  double getJuzMemorizationPercentage(int juzNumber) {
    final memorizedVerses = _storage.read(_memorizedVersesKey) ?? <String>[];
    int memorizedCount = 0;
    int totalVerses = 0;

    final juzData = quran.getSurahAndVersesFromJuz(juzNumber);
    juzData.forEach((surahNumber, verseRange) {
      final startVerse = verseRange[0];
      final endVerse = verseRange[1];
      totalVerses += (endVerse - startVerse + 1);

      for (int verseNumber = startVerse; verseNumber <= endVerse; verseNumber++) {
        if (memorizedVerses.contains('$surahNumber:$verseNumber')) {
          memorizedCount++;
        }
      }
    });

    return totalVerses > 0 ? memorizedCount / totalVerses : 0.0;
  }

  int getJuzMemorizedCount(int juzNumber) {
    final memorizedVerses = _storage.read(_memorizedVersesKey) ?? <String>[];
    int count = 0;
    final juzData = quran.getSurahAndVersesFromJuz(juzNumber);
    juzData.forEach((surahNumber, verseRange) {
      for (int verseNumber = verseRange[0]; verseNumber <= verseRange[1]; verseNumber++) {
        if (memorizedVerses.contains('$surahNumber:$verseNumber')) {
          count++;
        }
      }
    });
    return count;
  }

  int getJuzTotalVerses(int juzNumber) {
    int count = 0;
    final juzData = quran.getSurahAndVersesFromJuz(juzNumber);
    juzData.forEach((surahNumber, verseRange) {
      count += (verseRange[1] - verseRange[0] + 1);
    });
    return count;
  }

  List<int> getIncompleteSurahs() {
    List<int> incompleteSurahs = [];
    for (int i = 1; i <= quran.totalSurahCount; i++) {
      final percentage = getMemorizationPercentage(i);
      if (percentage < 1.0) { // Less than 100% memorized
        incompleteSurahs.add(i);
      }
    }
    return incompleteSurahs;
  }
}