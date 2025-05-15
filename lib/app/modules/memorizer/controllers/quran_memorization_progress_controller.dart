import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:quran/quran.dart' as quran;

class MemorizationProgressController extends GetxController {
  final GetStorage _storage = GetStorage();
  final String _memorizedVersesKey = 'memorizedVerses';

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

  int getTotalMemorizedVerses() {
    final memorizedVerses = _storage.read(_memorizedVersesKey) ?? <String>[];
    return memorizedVerses.length;
  }

  int getTotalVersesInQuran() {
    return 6236;
  }

  double getOverallMemorizationPercentage() {
    final totalMemorized = getTotalMemorizedVerses();
    final totalVerses = getTotalVersesInQuran();
    return totalVerses > 0 ? (totalMemorized / totalVerses) * 100 : 0.0;
  }

  int getTotalMemorizedSurahs() {
    Set<int> memorizedSurahs = {};
    final memorizedVerses = _storage.read(_memorizedVersesKey) ?? <String>[];
    for (var verseKey in memorizedVerses) {
      try {
        final parts = verseKey.split(':');
        final savedSurahNumber = int.parse(parts[0]);
        final verseCount = quran.getVerseCount(savedSurahNumber);
        final memorizedCount = getMemorizedVersesCount(savedSurahNumber);
        if (memorizedCount == verseCount) {
          memorizedSurahs.add(savedSurahNumber);
        }
      } catch (e) {
        print("Error parsing verse key: $verseKey. Error: $e");
      }
    }
    return memorizedSurahs.length;
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

  double getJuzMemorizationPercentage() {
    final memorizedCount = getTotalJuzVersesMemorized();
    final totalCount = getTotalJuzVerses();
    return totalCount > 0 ? (memorizedCount / totalCount) * 100 : 0.0;
  }
}