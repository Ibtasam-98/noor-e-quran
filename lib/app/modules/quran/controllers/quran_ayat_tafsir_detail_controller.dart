
// controllers/ayat_tafsir_controller.dart
import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class AyatTafsirController extends GetxController {
  final int surahNumber;
  final int ayahNumber;
  final String? surahName, ayat, surahArabicName;


  AyatTafsirController({required this.surahNumber, required this.ayahNumber, this.surahName, this.ayat, this.surahArabicName});

  var tafsirText = "".obs;
  var isLoading = false.obs;
  var selectedAuthor = Rxn<String>();
  var selectedTafsir = Rxn<String>();
  var selectedLanguage = Rxn<String>();
  var selectedLanguageSlug = Rxn<String>();
  RxDouble currentFontSize = 18.0.obs;

  var availableTafsir = <String>[].obs;
  var availableLanguages = <String>[].obs;

  final List<Map<String, dynamic>> tafsirData = [
    {"author": "Saddi", "name": "Tafseer Al Saddi", "language": "Arabic", "slug": "ar-tafseer-al-saddi"},
    {"author": "Hafiz Ibn Kathir", "name": "Tafsir Ibn Kathir", "language": "Arabic", "slug": "ar-tafsir-ibn-kathir"},
    {"author": "Hafiz Ibn Kathir", "name": "Tafsir Ibn Kathir (abridged)", "language": "English", "slug": "en-tafisr-ibn-kathir"},
    {"author": "Hafiz Ibn Kathir", "name": "Tafsir Ibn Kathir", "language": "Urdu", "slug": "ur-tafseer-ibn-e-kaseer"},
    {"author": "Dr. Israr Ahmad", "name": "Tafsir Bayan ul Quran", "language": "Urdu", "slug": "ur-tafsir-bayan-ul-quran"},
    {"author": "Mufti Muhammad Shafi", "name": "Maarif-ul-Quran", "language": "English", "slug": "en-tafsir-maarif-ul-quran"},
    {"author": "Sayyid Ibrahim Qutb", "name": "Fi Zilal al-Quran", "language": "Urdu", "slug": "ur-tafsir-fe-zalul-quran-syed-qatab"},
    {"author": "Maulana Wahid Uddin Khan", "name": "Tazkirul Quran(Maulana Wahiduddin Khan)", "language": "Urdu", "slug": "ur-tazkirul-quran"},
  ];

  void onAuthorSelected(String? author) {
    if (author == null) return;

    selectedAuthor.value = author;
    availableTafsir.value = tafsirData
        .where((item) => item["author"] == author)
        .map((item) => item["name"] as String)
        .toSet()
        .toList();

    selectedTafsir.value = null;
    selectedLanguage.value = null;
    selectedLanguageSlug.value = null;
    availableLanguages.value = [];
    tafsirText.value = "";
  }

  void onTafsirSelected(String? tafsir) {
    if (tafsir == null) return;

    selectedTafsir.value = tafsir;
    availableLanguages.value = tafsirData
        .where((item) => item["name"] == tafsir)
        .map((item) => item["language"] as String)
        .toSet()
        .toList();

    selectedLanguage.value = null;
    selectedLanguageSlug.value = null;
    tafsirText.value = "";
  }

  void onLanguageSelected(String? language) {
    if (language == null) return;

    final selected = tafsirData.firstWhere(
          (item) => item["name"] == selectedTafsir.value && item["language"] == language,
    );

    selectedLanguage.value = language;
    selectedLanguageSlug.value = selected["slug"];
    fetchTafsir();
  }

  Future<void> fetchTafsir() async {
    if (selectedLanguageSlug.value == null) {
      tafsirText.value = "";
      return;
    }

    isLoading.value = true;
    tafsirText.value = "Fetching Tafsir...";

    final url = "https://cdn.jsdelivr.net/gh/spa5k/tafsir_api@main/tafsir/${selectedLanguageSlug.value}/${surahNumber}/${ayahNumber}.json";

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        tafsirText.value = data['text'] ?? "No Tafsir available.";
      } else {
        tafsirText.value = "Error fetching Tafsir.";
      }
    } catch (e) {
      tafsirText.value = "Failed to load Tafsir.";
    } finally {
      isLoading.value = false;
    }
  }

  bool get isUrdu => selectedLanguageSlug.value?.startsWith("ur") ?? false;

  void updateFontSize(double value) {
    currentFontSize.value = value;
  }

}
