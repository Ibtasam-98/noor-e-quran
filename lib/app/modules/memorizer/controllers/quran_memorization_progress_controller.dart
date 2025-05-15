import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:quran/quran.dart' as quran;

class QuranMemorizationProgressController extends GetxController {
  final GetStorage _storage = GetStorage();
  final String _memorizedVersesKey = 'memorizedVerses';

  // Cache for better performance
  final Map<int, int> _surahMemorizationCache = {};
  final Map<int, int> _juzMemorizationCache = {};
  bool _cacheDirty = true;

  @override
  void onInit() {
    super.onInit();
    // Clear cache when storage changes
    _storage.listenKey(_memorizedVersesKey, (_) {
      _cacheDirty = true;
      update();
    });
  }

  List<String> get _memorizedVerses {
    return _storage.read<List<dynamic>>(_memorizedVersesKey)?.cast<String>() ?? [];
  }

  void _refreshCacheIfNeeded() {
    if (!_cacheDirty) return;

    _surahMemorizationCache.clear();
    _juzMemorizationCache.clear();

    final verses = _memorizedVerses;
    for (final verseKey in verses) {
      try {
        final parts = verseKey.split(':');
        final surahNumber = int.parse(parts[0]);
        final verseNumber = int.parse(parts[1]);

        // Update surah cache
        _surahMemorizationCache.update(
            surahNumber,
                (value) => value + 1,
            ifAbsent: () => 1
        );

        // Update juz cache
        final juzNumber = _getJuzNumber(surahNumber, verseNumber);
        if (juzNumber != null) {
          _juzMemorizationCache.update(
              juzNumber,
                  (value) => value + 1,
              ifAbsent: () => 1
          );
        }
      } catch (e) {
        print("Error parsing verse key: $verseKey. Error: $e");
      }
    }
    _cacheDirty = false;
  }

  int? _getJuzNumber(int surahNumber, int verseNumber) {
    for (int juz = 1; juz <= 30; juz++) {
      final juzData = quran.getSurahAndVersesFromJuz(juz);
      if (juzData.containsKey(surahNumber)) {
        final range = juzData[surahNumber]!;
        if (verseNumber >= range[0] && verseNumber <= range[1]) {
          return juz;
        }
      }
    }
    return null;
  }

  int getMemorizedVersesCount(int surahNumber) {
    _refreshCacheIfNeeded();
    return _surahMemorizationCache[surahNumber] ?? 0;
  }

  int getTotalMemorizedVerses() {
    return _memorizedVerses.length;
  }

  int getTotalVersesInQuran() => 6236;

  double getOverallMemorizationPercentage() {
    final totalMemorized = getTotalMemorizedVerses();
    return (totalMemorized / getTotalVersesInQuran()) * 100;
  }

  int getTotalMemorizedSurahs() {
    _refreshCacheIfNeeded();
    int completeSurahs = 0;

    _surahMemorizationCache.forEach((surahNumber, memorizedCount) {
      if (memorizedCount == quran.getVerseCount(surahNumber)) {
        completeSurahs++;
      }
    });

    return completeSurahs;
  }

  int getTotalJuzVersesMemorized() {
    _refreshCacheIfNeeded();
    return _juzMemorizationCache.values.fold(0, (sum, count) => sum + count);
  }

  int getTotalJuzVerses() {
    int total = 0;
    for (int juz = 1; juz <= 30; juz++) {
      final juzData = quran.getSurahAndVersesFromJuz(juz);
      juzData.forEach((surahNumber, verseRange) {
        total += (verseRange[1] - verseRange[0] + 1);
      });
    }
    return total;
  }

  double getJuzMemorizationPercentage() {
    final memorized = getTotalJuzVersesMemorized();
    final total = getTotalJuzVerses();
    return total > 0 ? (memorized / total) * 100 : 0.0;
  }

  // Additional helper methods
  Map<int, double> getSurahWiseProgress() {
    _refreshCacheIfNeeded();
    final progress = <int, double>{};

    for (int surah = 1; surah <= 114; surah++) {
      final totalVerses = quran.getVerseCount(surah);
      final memorized = _surahMemorizationCache[surah] ?? 0;
      progress[surah] = totalVerses > 0 ? (memorized / totalVerses) * 100 : 0.0;
    }

    return progress;
  }

  Map<int, double> getJuzWiseProgress() {
    _refreshCacheIfNeeded();
    final progress = <int, double>{};

    for (int juz = 1; juz <= 30; juz++) {
      final total = _calculateJuzVerseCount(juz);
      final memorized = _juzMemorizationCache[juz] ?? 0;
      progress[juz] = total > 0 ? (memorized / total) * 100 : 0.0;
    }

    return progress;
  }

  int _calculateJuzVerseCount(int juz) {
    int count = 0;
    final juzData = quran.getSurahAndVersesFromJuz(juz);
    juzData.forEach((surah, range) {
      count += (range[1] - range[0] + 1);
    });
    return count;
  }
}