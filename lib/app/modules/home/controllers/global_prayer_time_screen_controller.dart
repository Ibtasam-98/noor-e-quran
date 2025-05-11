import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../../controllers/user_location_premission_controller.dart';

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

  // Get an instance of UserPermissionController
  final userPermissionController = Get.find<UserPermissionController>();

  @override
  void onInit() {
    super.onInit();
    fetchCountries(); // Fetch countries on initialization.
  }

  // API to get countries (Replace with a reliable API or local JSON)
  Future<void> fetchCountries() async {
    isFetchingCountries(true);
    // Using a  API.
    final url = Uri.parse('https://restcountries.com/v3.1/all');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        countries.value = data.map((e) => e['name']['common'].toString()).toList();
        countries.sort((a, b) =>
            a.toLowerCase().compareTo(b.toLowerCase())); // Sort countries
        if (countries.isNotEmpty) {
          selectedCountry.value =
              countries.first; // Optionally select the first country
          fetchCities(selectedCountry.value); //and load cities
        }
      } else {
        print('Failed to fetch countries: ${response.statusCode}');
        Get.snackbar('Error', 'Failed to fetch countries.');
      }
    } catch (e) {
      print('Error fetching countries: $e');
      Get.snackbar('Error', 'Error fetching countries: $e');
    } finally {
      isFetchingCountries(false);
    }
  }

  // API to get cities for a selected country (Replace with a reliable API or local JSON)
  Future<void> fetchCities(String country) async {
    if (country.isEmpty) return;
    isFetchingCities(true);
    cities.clear(); // Clear previous cities
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
                    b.toLowerCase())); // Sort cities
            cities.assignAll(
                fetchedCities); // Use assignAll to update the observable list
            if (fetchedCities.isNotEmpty) {
              selectedCity.value =
                  fetchedCities.first; // Select the first city.
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
      Get.snackbar('Error', 'Error fetching cities: $e');
    } finally {
      isFetchingCities(false);
    }
  }

  Future<Map<String, dynamic>?> _getPrayerTimesFromApi(
      String city, String country) async {
    final String baseUrl = 'http://api.aladhan.com/v1/timingsByCity';
    final Uri url = Uri.parse('$baseUrl?city=$city&country=$country');
    print('Fetching prayer times for: $url'); // Debug: Print the URL

    try {
      final response = await http.get(url);
      print('Response status code: ${response.statusCode}'); // Debug
      print('Response body: ${response.body}'); // Debug
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data.containsKey('data')) {
          return data['data'] as Map<String, dynamic>;
        } else {
          print('AlAdhan API: No "data" key found in the response.');
          return null;
        }
      } else {
        print(
            'AlAdhan API Error: Request failed with status code ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('AlAdhan API Error: $e');
      return null;
    }
  }

  Future<void> fetchPrayerTimes(String city, String country) async {
    print('fetchPrayerTimes called with city: $city, country: $country'); //Debug
    if (city.isEmpty || country.isEmpty) {
      prayerTimes.value = {
        'Fajr': 'N/A',
        'Sunrise': 'N/A',
        'Dhuhr': 'N/A',
        'Asr': 'N/A',
        'Maghrib': 'N/A',
        'Isha': 'N/A',
      };
      Get.snackbar(
        'Prayer Times Error',
        'Please select city and country.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    isFetchingPrayerTimes(true);
    final prayerData = await _getPrayerTimesFromApi(city, country);
    isFetchingPrayerTimes(false);
    if (prayerData != null && prayerData.containsKey('timings')) {
      final timings = prayerData['timings'] as Map<String, dynamic>;
      print('Timings data: $timings'); // Debug
      prayerTimes.value = {
        'Fajr': timings['Fajr'] ?? 'N/A',
        'Sunrise': timings['Sunrise'] ?? 'N/A',
        'Dhuhr': timings['Dhuhr'] ?? 'N/A',
        'Asr': timings['Asr'] ?? 'N/A',
        'Maghrib': timings['Maghrib'] ?? 'N/A',
        'Isha': timings['Isha'] ?? 'N/A',
      };
      selectedCity.value = city;
      selectedCountry.value = country;
    } else {
      prayerTimes.value = {
        'Fajr': 'N/A',
        'Sunrise': 'N/A',
        'Dhuhr': 'N/A',
        'Asr': 'N/A',
        'Maghrib': 'N/A',
        'Isha': 'N/A',
      };
      Get.snackbar(
        'Prayer Times Error',
        'Failed to fetch prayer times for $city, $country.',
        snackPosition: SnackPosition.BOTTOM,
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
      fetchCities(newValue); // Fetch cities for the selected country
    }
  }

  void onCityChanged(String? newValue) {
    if (newValue != null) {
      selectedCity.value = newValue;
    }
  }
}