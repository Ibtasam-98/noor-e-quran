import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http; // For making HTTP requests
import 'dart:convert'; // For JSON decoding
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/foundation.dart';

class UserPermissionController extends GetxController {
  var cityName = ''.obs;
  var countryName = ''.obs;
  var isLoading = false.obs;
  var locationAccessed = false.obs;
  var latitude = 0.0.obs;
  var longitude = 0.0.obs;
  var allowSwipe = false.obs;

  final pageController = PageController();
  final currentPage = 0.obs;
  final canSwipe = true.obs;

  void nextPage() {
    currentPage.value++;
    pageController.animateToPage(
      currentPage.value,
      duration: const Duration(milliseconds: 300),
      curve: Curves.ease,
    );
  }

  final enableSwipeForLocation = false.obs;
  final enableSwipeForTheme = false.obs;
  final enableSwipe = true.obs;

  Future<void> toggleLocation(bool value) async {
    locationAccessed.value = value;

    if (locationAccessed.value) {
      await accessLocation();
    } else {
      latitude.value = 0.0;
      longitude.value = 0.0;
      cityName.value = "N/A";
      countryName.value = "N/A";
      allowSwipe.value = false;
      update();
    }
  }

  Future<void> accessLocation() async {
    isLoading(true);
    try {
      bool isServiceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!isServiceEnabled) {
        cityName.value = 'Location services are disabled.';
        countryName.value = 'Location services are disabled.';
        isLoading(false);
        allowSwipe.value = false;
        update();
        return;
      }
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          cityName.value = 'Enable location from Settings.';
          countryName.value = 'Enable location from Settings.';
          isLoading(false);
          allowSwipe.value = false;
          update();
          return;
        }
      }
      if (permission == LocationPermission.deniedForever) {
        cityName.value = 'Enable location from device settings.';
        countryName.value = 'Enable location from device settings.';
        isLoading(false);
        allowSwipe.value = false;
        update();
        return;
      }
      Position position =
      await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      latitude.value = position.latitude;
      longitude.value = position.longitude;
      List<Placemark> placemarks =
      await placemarkFromCoordinates(position.latitude, position.longitude);
      if (placemarks.isNotEmpty) {
        String? locality = placemarks.first.locality;
        String? completeCountryName = placemarks.first.country;
        cityName.value = locality ?? 'Unknown City';
        countryName.value = completeCountryName ?? 'Unknown Country';
        locationAccessed(true);
        allowSwipe.value = true;
        enableSwipeForLocation.value = true;
      } else {
        cityName.value = 'City not found.';
        countryName.value = 'Country not found.';
        allowSwipe.value = false;
        enableSwipeForLocation.value = false;
      }
    } catch (e) {
      cityName.value = 'Error: ${e.toString()}';
      countryName.value = 'Error: ${e.toString()}';
      allowSwipe.value = false;
      enableSwipeForLocation.value = false;
    } finally {
      isLoading(false);
      update();
    }
  }

  void enableSwipeFunction(bool value) {
    canSwipe.value = value;
  }

  void enableSwipeForThemeFunction(bool value) {
    enableSwipeForTheme.value = value;
  }
}
