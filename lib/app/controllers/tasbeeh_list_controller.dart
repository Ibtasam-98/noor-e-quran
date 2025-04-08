import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';



class TasbeehListController extends GetxController {
  final _storage = GetStorage();
  RxList<String> defaultTasbeehs = <String>[
    "SubhanAllah",
    "Alhamdulillah",
    "Allahu Akbar",
    "La ilaha illallah",
    "Astaghfirullah",
    "SubhanAllahi wa bihamdihi",
    "SubhanAllahi l-azim",
    "La hawla wa la quwwata illa billah",
    "Allahumma salli ala Muhammad",
    "HasbunAllahu wa ni'mal wakil",
    "Ya Hayyu Ya Qayyum",
    "Ya Dhal Jalali wal Ikram",
    "Rabbana atina fid-dunya hasanah",
    "Rabbana la tuzigh qulubana",
    "Allahumma innaka afuwwun tuhibbul afwa fa'fu anni"
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