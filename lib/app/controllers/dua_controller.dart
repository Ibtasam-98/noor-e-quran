
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../models/dua_model.dart';

class DuaController extends GetxController {
  var duasList = <Dua>[].obs;
  var filteredData = <Dua>[].obs;
  var screenTitle = ''.obs;

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> loadDuas(String jsonFilePath) async {
    try {
      // Load JSON file dynamically
      String jsonData = await rootBundle.loadString(jsonFilePath);
      Map<String, dynamic> parsedJson = json.decode(jsonData);

      // Identify the category key dynamically (e.g., "masnoon", "qurani", "ramadan")
      String? categoryKey = parsedJson.keys.isNotEmpty ? parsedJson.keys.first : null;

      if (categoryKey == null || parsedJson[categoryKey] == null) {
        throw Exception("Invalid JSON structure or missing data.");
      }

      // Extract duas and convert to model
      List<Dua> duaList = (parsedJson[categoryKey] as List)
          .map((item) => Dua.fromJson(item))
          .toList();

      // Assign data to lists
      duasList.assignAll(duaList);
      filteredData.assignAll(duaList);

      // Update screen title dynamically based on the category
      screenTitle.value = categoryKey.capitalizeFirst ?? "Duas";
    } catch (e) {
      print("Error loading duas: $e");
    }
  }

  void updateSearchQuery(String query) {
    if (query.isEmpty) {
      filteredData.assignAll(duasList);
    } else {
      filteredData.assignAll(
        duasList.where((dua) => dua.title.toLowerCase().contains(query.toLowerCase())).toList(),
      );
    }
  }
}
