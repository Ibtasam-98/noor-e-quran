import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';



class TasbeehListController extends GetxController {
  final _storage = GetStorage();
  RxList<String> defaultTasbeehs = <String>[
    "سُبْحَانَ ٱللَّٰهِ",
    "ٱلْحَمْدُ لِلَّٰهِ",
    "ٱللَّٰهُ أَكْبَرُ",
    "لَا إِلَٰهَ إِلَّا ٱللَّٰهُ",
    "أَسْتَغْفِرُ ٱللَّٰهَ",
    "سُبْحَانَ ٱللَّٰهِ وَبِحَمْدِهِ",
    "سُبْحَانَ ٱللَّٰهِ ٱلْعَظِيمِ",
    "لَا حَوْلَ وَلَا قُوَّةَ إِلَّا بِٱللَّٰهِ",
    "ٱللَّٰهُمَّ صَلِّ عَلَىٰ مُحَمَّدٍ",
    "حَسْبُنَا ٱللَّٰهُ وَنِعْمَ ٱلْوَكِيلُ",
    "يَا حَيُّ يَا قَيُّومُ",
    "يَا ذَا ٱلْجَلَالِ وَٱلْإِكْرَامِ",
    "رَبَّنَا آتِنَا فِي ٱلدُّنْيَا حَسَنَةً",
    "رَبَّنَا لَا تُزِغْ قُلُوبَنَا",
    "ٱللَّٰهُمَّ إِنَّكَ عَفُوٌّ تُحِبُّ ٱلْعَفْوَ فَٱعْفُ عَنِّي"
  ].obs;

  RxList<String> userTasbeehs = <String>[].obs;
  RxList<Map<String, dynamic>> completedTasbeehs =
      <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadTasbeehData();
  }

  void _loadTasbeehData() {
    userTasbeehs.value =
        (_storage.read('tasbeehs') ?? <String>[]).cast<String>();
    completedTasbeehs.value =
        (_storage.read('completedTasbeehs') ?? <Map<String, dynamic>>[])
            .cast<Map<String, dynamic>>();
  }

  void removeUserTasbeeh(String tasbeeh) {
    userTasbeehs.remove(tasbeeh);
    _storage.write('tasbeehs', userTasbeehs);
  }

  void removeCompletedTasbeeh(int index) {
    completedTasbeehs.removeAt(index);
    _storage.write('completedTasbeehs', completedTasbeehs);
  }
}