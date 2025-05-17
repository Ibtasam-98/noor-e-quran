import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:noor_e_quran/app/config/app_colors.dart';
import 'package:noor_e_quran/app/widgets/custom_snackbar.dart';
import 'package:quran/quran.dart' as quran;

class QuranNotesController extends GetxController {
  final GetStorage _storage = GetStorage();
  final TextEditingController noteController = TextEditingController();
  final TextEditingController searchController = TextEditingController();

  RxInt selectedSurah = 1.obs;
  RxInt selectedAyah = 1.obs;
  RxList<Map<String, dynamic>> notes = <Map<String, dynamic>>[].obs;
  RxList<int> filteredSurahs = List.generate(114, (index) => index + 1).obs;
  RxBool isSurahDialog = true.obs;
  RxInt expandedIndex = RxInt(-1);

  @override
  void onInit() {
    super.onInit();
    loadNotes();
    searchController.addListener(onSearchChanged);
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }



  void onSearchChanged() {
    final query = searchController.text.toLowerCase();
    filteredSurahs.value = List.generate(114, (index) => index + 1)
        .where((surah) => quran.getSurahName(surah).toLowerCase().contains(query))
        .toList();
  }

  Future<void> loadNotes() async {
    final storedNotes = _storage.read('quranNotes') ?? [];
    notes.value = List<Map<String, dynamic>>.from(storedNotes);
  }

  Future<void> saveNote() async {
    final now = DateTime.now();
    final formattedDate = DateFormat('yyyy-MM-dd HH:mm').format(now);
    final note = {
      'surah': selectedSurah.value,
      'ayah': selectedAyah.value,
      'note': noteController.text,
      'time': formattedDate,
    };
    notes.add(note);
    await _storage.write('quranNotes', notes);
    noteController.clear();
    loadNotes();
    Get.back(); // Close the bottom sheet
  }

  Future<void> deleteNote(int index) async {
    notes.removeAt(index);
    await _storage.write('quranNotes', notes);
    loadNotes();
    CustomSnackbar.show(
      backgroundColor: AppColors.green,
        title: "Success",
        subtitle: "Your selected note has been deleted successfully",
        icon: Icon(Icons.check),);

  }

  void toggleExpanded(int index) {
    expandedIndex.value = expandedIndex.value == index ? -1 : index;
  }

  void selectItem(int item) {
    if (isSurahDialog.value) {
      selectedSurah.value = item;
      selectedAyah.value = 1;
    } else {
      selectedAyah.value = item;
    }
  }
}