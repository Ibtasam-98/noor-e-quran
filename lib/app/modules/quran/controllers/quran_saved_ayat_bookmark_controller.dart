import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';

class QuranSavedAyatBookmarkController extends GetxController {
  final GetStorage _storage = GetStorage();
  var savedAyahs = <Map<String, dynamic>>[].obs;
  var isLoading = true.obs;
  var errorMessage = "".obs;

  @override
  void onInit() {
    super.onInit();
    fetchSavedAyahs();
  }

  Future<void> fetchSavedAyahs() async {
    isLoading.value = true;
    errorMessage.value = "";
    try {
      List<Map<String, dynamic>> fetchedAyahs = [];
      for (String key in _storage.getKeys()) {
        if (key.startsWith('savedAyah_')) {
          final ayahData = _storage.read(key);
          if (ayahData != null && ayahData is Map<String, dynamic>) {
            fetchedAyahs.add(ayahData);
          }
        }
      }

      // Sort saved ayahs by date and timestamp (newest first)
      fetchedAyahs.sort((a, b) {
        final dateA = a['date'] as String? ?? "";
        final dateB = b['date'] as String? ?? "";
        final timeA = a['timestamp'] as String? ?? "";
        final timeB = b['timestamp'] as String? ?? "";

        // Combine date and time for comparison
        final fullA = '$dateA $timeA';
        final fullB = '$dateB $timeB';

        try {
          // Parse the combined date and time
          final format = DateFormat('dd MMMM yyyy hh:mm a');
          final dateTimeA = format.parse(fullA);
          final dateTimeB = format.parse(fullB);
          return dateTimeB.compareTo(dateTimeA); // Sort in descending order (latest first)
        } catch (e) {
          // If parsing fails, fall back to string comparison
          return fullB.compareTo(fullA);
        }
      });

      savedAyahs.value = fetchedAyahs;
    } catch (e) {
      errorMessage.value = "Failed to fetch saved ayahs: $e";
    } finally {
      isLoading.value = false;
    }
  }
}