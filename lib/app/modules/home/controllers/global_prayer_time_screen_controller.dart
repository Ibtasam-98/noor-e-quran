import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:noor_e_quran/app/config/app_colors.dart';
import 'package:noor_e_quran/app/widgets/custom_snackbar.dart';
import 'dart:convert';
import '../../../controllers/user_location_premission_controller.dart';
import '../controllers/view_all_prayer_screen_controller.dart';

class GlobalPrayerTimeScreenController extends GetxController {
  var prayerTimes = <String, String>{}.obs;
  var isFetchingPrayerTimes = false.obs;
  var selectedCountry = ''.obs;
  var selectedCity = ''.obs;
  var countries = <String>[].obs;
  var cities = <String>[].obs;
  var isFetchingCountries = false.obs;
  var isFetchingCities = false.obs;
  final formKey = GlobalKey<FormState>();

  final userPermissionController = Get.find<UserPermissionController>();
  final NamazController namazController = Get.find<NamazController>();

  @override
  void onInit() {
    super.onInit();
    fetchCountries();
  }

  Future<void> fetchCountries() async {
    isFetchingCountries(true);
    final url = Uri.parse('https://restcountries.com/v3.1/all');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        countries.value = data.map((e) => e['name']['common'].toString()).toList();
        countries.sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
        if (countries.isNotEmpty) {
          selectedCountry.value = countries.first;
          fetchCities(selectedCountry.value);
        }
      } else {
        print('Failed to fetch countries: ${response.statusCode}');
        CustomSnackbar.show(
            title: 'Error',
            subtitle: 'Failed to fetch countries',
            icon: Icon(Icons.error),
          backgroundColor: AppColors.red
        );
      }
    } catch (e) {
      print('Error fetching countries: $e');
      CustomSnackbar.show(
          title: 'Error',
          subtitle: 'Failed to fetch countries',
          icon: Icon(Icons.error),
          backgroundColor: AppColors.red
      );
    } finally {
      isFetchingCountries(false);
    }
  }

  Future<void> fetchCities(String country) async {
    if (country.isEmpty) return;
    isFetchingCities(true);
    cities.clear();
    selectedCity.value = '';
    try {
      final url = Uri.parse('https://restcountries.com/v3.1/name/$country');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final dynamic data = json.decode(response.body);
        if (data is List && data.isNotEmpty) {
          final Map<String, dynamic> countryData = data.first;
          if (countryData.containsKey('capital')) {
            List<String> fetchedCities =
            List<String>.from(countryData['capital']);
            fetchedCities.sort((a, b) =>
                a.toLowerCase().compareTo(
                    b.toLowerCase()));
            cities.assignAll(fetchedCities);
            if (fetchedCities.isNotEmpty) {
              selectedCity.value = fetchedCities.first;
            }
          } else {
            cities.assignAll([]);
          }
        } else {
          cities.assignAll([]);
        }
      }
    } catch (e) {
      print('Error fetching cities: $e');
      CustomSnackbar.show(
          title: 'Error',
          subtitle: 'Error fetching cities: $e',
          icon: Icon(Icons.error),
          backgroundColor: AppColors.red
      );
    } finally {
      isFetchingCities(false);
    }
  }

  Future<Map<String, dynamic>?> _getPrayerTimesFromApi(
      String city, String country, int method) async {
    final String baseUrl = 'http://api.aladhan.com/v1/timingsByCity';
    final Uri url = Uri.parse('$baseUrl?city=$city&country=$country&method=$method');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data.containsKey('data')) {
          return data['data'] as Map<String, dynamic>;
        } else {
          print('AlAdhan API: No "data" key found in the response.');
          return null;
        }
      } else {
        print('AlAdhan API Error: Request failed with status code ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('AlAdhan API Error: $e');
      return null;
    }
  }

  Future<void> fetchPrayerTimes(String city, String country) async {
    if (city.isEmpty || country.isEmpty) {
      prayerTimes.value = {
        'Fajr': 'N/A',
        'Sunrise': 'N/A',
        'Dhuhr': 'N/A',
        'Asr': 'N/A',
        'Sunset': 'N/A',
        'Maghrib': 'N/A',
        'Isha': 'N/A',
        'Imsak': 'N/A',
        'Midnight': 'N/A',
        'Firstthird': 'N/A',
        'Lastthird': 'N/A',
      };
      CustomSnackbar.show(
          title: 'Prayer Times Error',
          subtitle: 'Please select city and country',
          icon: Icon(Icons.error),
          backgroundColor: AppColors.red
      );
      return;
    }

    isFetchingPrayerTimes(true);
    final selectedMethod = namazController.selectedCalculationMethod.value;
    final prayerData = await _getPrayerTimesFromApi(city, country, selectedMethod!);
    isFetchingPrayerTimes(false);
    if (prayerData != null && prayerData.containsKey('timings')) {
      final timings = prayerData['timings'] as Map<String, dynamic>;
      prayerTimes.value = {
        'Fajr': timings['Fajr'] ?? 'N/A',
        'Sunrise': timings['Sunrise'] ?? 'N/A',
        'Dhuhr': timings['Dhuhr'] ?? 'N/A',
        'Asr': timings['Asr'] ?? 'N/A',
        'Sunset': timings['Sunset'] ?? "--",
        'Maghrib': timings['Maghrib'] ?? 'N/A',
        'Isha': timings['Isha'] ?? 'N/A',
        'Imsak': timings['Imsak'] ?? '--',
        'Midnight': timings['Midnight'] ?? '--',
        'Firstthird': timings['Firstthird'] ?? '--',
        'Lastthird': timings['Lastthird'] ?? '--',
      };
      selectedCity.value = city; selectedCountry.value = country;
    } else {
      prayerTimes.value = {
        'Fajr': 'N/A',
        'Sunrise': 'N/A',
        'Dhuhr': 'N/A',
        'Asr': 'N/A',
        'Sunset': 'N/A',
        'Maghrib': 'N/A',
        'Isha': 'N/A',
        'Imsak': 'N/A',
        'Midnight': 'N/A',
        'Firstthird': 'N/A',
        'Lastthird': 'N/A',
      };
      CustomSnackbar.show(
          title: 'Prayer Times Error',
          subtitle: 'Failed to fetch prayer times for $city, $country with the selected method.',
          icon: Icon(Icons.error),
          backgroundColor: AppColors.red
      );
      selectedCity.value = '';
      selectedCountry.value = '';
    }
  }

  void clearPrayerTimes() {
    prayerTimes.clear();
    selectedCity.value = '';
    selectedCountry.value = '';
  }

  void onCountryChanged(String? newValue) {
    if (newValue != null) {
      selectedCountry.value = newValue;
      fetchCities(newValue);
    }
  }
  void onCityChanged(String? newValue) {
    if (newValue != null) {
      selectedCity.value = newValue;
    }
  }
}