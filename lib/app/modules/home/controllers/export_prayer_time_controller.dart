import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'app_home_screen_controller.dart';

class ExportPrayerTimeController extends GetxController {
  final AppHomeScreenController homeController = Get.find(); // To access location data and time formatting
  RxInt selectedMonth = DateTime.now().month.obs;
  RxInt selectedYear = DateTime.now().year.obs;
  // Corrected line: Use RxMap directly
  RxMap<DateTime, Map<String, String>> monthlyPrayerTimes = <DateTime, Map<String, String>>{}.obs;
  RxBool isLoading = false.obs;

  var namazTimes = <String>["Fajr", "Sunrise", "Dhuhr", "Asr", "Sunset", "Maghrib", "Isha", "Imsak", "Midnight", "Firstthird", "Lastthird"].obs;
  var icons = <String>["fajr.svg", "fajr.svg", "dhuhr.svg", "asr.svg", "asr.svg", "maghrib.svg", "isha.svg", "isha.svg", "isha.svg", "isha.svg", "isha.svg"].obs;

  @override
  void onInit() {
    super.onInit();
    fetchMonthlyPrayerTimes();
  }

  Future<void> fetchMonthlyPrayerTimes() async {
    isLoading.value = true;
    try {
      final latitude = homeController.locationController.latitude.value;
      final longitude = homeController.locationController.longitude.value;
      final response = await http.get(Uri.parse(
          'http://api.aladhan.com/v1/calendar?latitude=$latitude&longitude=$longitude&method=2&month=${selectedMonth.value}&year=${selectedYear.value}'));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final Map<DateTime, Map<String, String>> fetchedPrayerTimes = {};
        for (var dayData in jsonData['data']) {
          final dateString = dayData['date']['gregorian']['date'];
          final inputFormat = DateFormat('dd-MM-yyyy');
          final date = inputFormat.parse(dateString);
          fetchedPrayerTimes[date] = Map<String, String>.from(dayData['timings']);
        }
        monthlyPrayerTimes.value = fetchedPrayerTimes;
      } else {
        monthlyPrayerTimes.value = {};
        Get.snackbar('Error', 'Failed to load prayer times.');
      }
    } catch (e) {
      monthlyPrayerTimes.value = {};
      print('Error fetching monthly prayer times: $e');
      Get.snackbar('Error', 'An error occurred.');
    } finally {
      isLoading.value = false;
    }
  }

  void updateSelectedMonth(int? month) {
    if (month != null) {
      selectedMonth.value = month;
      fetchMonthlyPrayerTimes();
    }
  }

  String getIconForPrayer(String prayerName) {
    final index = namazTimes.indexOf(prayerName);
    if (index != -1 && index < icons.length) {
      return icons[index];
    }
    return '';
  }
}