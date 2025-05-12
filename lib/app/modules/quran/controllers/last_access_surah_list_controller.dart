import 'package:get/get.dart';
import 'package:noor_e_quran/app/modules/quran/controllers/quran_main_screen_controller.dart';
import '../../home/controllers/app_home_screen_controller.dart';


class LastAccessSurahListController extends GetxController {
  final QuranMainScreenController quranMainScreenController = Get.find<QuranMainScreenController>();
  RxList<Map<String, dynamic>> lastAccessedSurahs = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadLastAccessedSurahs();
  }

  void loadLastAccessedSurahs() {
    quranMainScreenController.loadLastAccessedSurahs();
    lastAccessedSurahs.assignAll(quranMainScreenController.lastAccessedSurahs);
  }

  String getSurahName(int surahNumber) {
    return quranMainScreenController.getSurahName(surahNumber);
  }

  String getSurahNameArabic(int surahNumber) {
    return quranMainScreenController.getSurahNameArabic(surahNumber);
  }

  DateTime parseAccessTime(String accessTime) {
    return quranMainScreenController.parseAccessTime(accessTime);
  }

}