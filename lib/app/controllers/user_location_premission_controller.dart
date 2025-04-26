import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
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

void main() {
  runApp(const MaterialApp(home: NearbyMasjidFinder()));
}

class NearbyMasjidFinder extends StatefulWidget {
  const NearbyMasjidFinder({super.key});

  @override
  _NearbyMasjidFinderState createState() => _NearbyMasjidFinderState();
}

class _NearbyMasjidFinderState extends State<NearbyMasjidFinder> {
  late GoogleMapController mapController;
  // Default to a reasonable starting point, e.g., Jakarta, Indonesia
  LatLng _center = const LatLng(-6.2088, 106.8456);
  final Set<Marker> _markers = {};
  bool _isLoading = false;
  bool _mapCreated = false;
  final String? _googlePlacesApiKey =
  const String.fromEnvironment('GOOGLE_PLACES_API_KEY'); //  API key
  final UserPermissionController _userPermissionController =
  Get.put(UserPermissionController());

  // Function to add a marker to the map
  void _addMarker(
      String placeId, LatLng position, String title, String vicinity) {
    if (!_mapCreated) return; // Don't add markers if map is not created
    setState(() {
      _markers.add(
        Marker(
          markerId: MarkerId(placeId),
          position: position,
          infoWindow: InfoWindow(
            title: title,
            snippet: vicinity,
            onTap: () {
              //_showMasjidDetailsBottomSheet(placeId); // Removed for now
            },
          ),
        ),
      );
    });
  }

  // Function to fetch nearby mosques using Google Places API
  Future<void> _findNearbyMosques(LatLng location) async {
    if (_googlePlacesApiKey == null || _googlePlacesApiKey!.isEmpty) {
      // Handle the case where the API key is not provided
      print("Google Places API key is missing.");
      return;
    }
    setState(() {
      _isLoading = true;
      _markers.clear(); // Clear previous markers
    });

    try {
      // Use the provided  location
      String url =
          'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=${location.latitude},${location.longitude}&radius=2000&type=mosque&key=$_googlePlacesApiKey'; //radius upto 2km
      if (kDebugMode) {
        print("API Request URL: $url"); // Print the URL
      }
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        if (kDebugMode) {
          print("API Response Status Code: ${response.statusCode}"); // Print status
        }
        final data = json.decode(response.body);
        if (kDebugMode) {
          print("API Response Body: $data"); // Print the response
        }
        if (data['status'] == 'OK') {
          List<dynamic> results = data['results'];
          for (var result in results) {
            String placeId = result['place_id'];
            LatLng mosqueLocation = LatLng(
              result['geometry']['location']['lat'],
              result['geometry']['location']['lng'],
            );
            String name = result['name'];
            String vicinity = result['vicinity'];
            _addMarker(placeId, mosqueLocation, name, vicinity);
          }
        } else {
          // Handle API errors
          print('Error from Google Places API: ${data['status']}');
        }
      } else {
        // Handle HTTP errors
        print('Failed to fetch nearby mosques: ${response.statusCode}');
      }
    } catch (e) {
      // Handle exceptions
      print('Error finding nearby mosques: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    setState(() {
      _mapCreated = true; // Set the flag when the map is created
    });
  }

  // Function to initialize the map
  Future<void> _initializeMap() async {
    setState(() {
      _isLoading = true;
    });
    // Use the location from UserPermissionController
    if (_userPermissionController.locationAccessed.value) {
      _center = LatLng(
        _userPermissionController.latitude.value,
        _userPermissionController.longitude.value,
      );
    } else {
      await _userPermissionController.accessLocation();
      _center = LatLng(
        _userPermissionController.latitude.value,
        _userPermissionController.longitude.value,
      );
    }

    await _findNearbyMosques(_center); // Find mosques
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    if (_userPermissionController.locationAccessed.value) {
      _center = LatLng(
        _userPermissionController.latitude.value,
        _userPermissionController.longitude.value,
      );
    }
    _initializeMap();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nearby Masjids'),
        centerTitle: true,
      ),
      body: Obx(() {
        if (_isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        return GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: _center,
            zoom: 15.0, // Zoom level
          ),
          markers: _markers,
        );
      }),
    );
  }
}

