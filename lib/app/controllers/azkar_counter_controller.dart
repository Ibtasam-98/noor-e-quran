import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';


class AzkarCounterController extends GetxController {
  final Map<String, dynamic> zikar;
  final int targetCount;
  final currentCount = 0.obs;
  final zikarFontSize = 18.0.obs;
  final backgroundImageOpacity = 0.0.obs;
  final GetStorage box = GetStorage();
  final String title, azkarName; // Added title and azkarName properties


  AzkarCounterController(this.zikar, this.targetCount, this.title, this.azkarName); // Added azkarName to constructor

  @override
  void onInit() {
    super.onInit();
    loadState();
  }

  @override
  void onClose() {
    saveState();
    super.onClose();
  }

  void incrementCount() {
    if (currentCount.value < targetCount) {
      currentCount.value++;
      backgroundImageOpacity.value = (currentCount.value / targetCount).clamp(0.0, 1.0);
    }
  }

  void setFontSize(double value) {
    zikarFontSize.value = value;
  }

  Future<void> loadState() async {
    final savedCount = box.read('azkar_count_${zikar['zikar']}') ?? 0;
    currentCount.value = savedCount;
    backgroundImageOpacity.value = (savedCount / targetCount).clamp(0.0, 1.0);
  }

  Future<void> saveState() async {
    box.write('azkar_count_${zikar['zikar']}', currentCount.value);
    box.write('azkar_time_${zikar['zikar']}', DateTime.now().toIso8601String());
    box.write('azkar_title_${zikar['zikar']}', title); // Save the title
    box.write('azkar_name_${zikar['zikar']}', azkarName); // Save the azkarName
    box.write('azkar_arabic_${zikar['zikar']}', zikar['zikar']); // Save the Arabic text
    box.write('azkar_heading_${zikar['zikar']}', title); // Save the heading/azkarType
  }

  void resetAzkar() {
    currentCount.value = 0;
    backgroundImageOpacity.value = 0.0;
    saveState(); // Save the reset state
  }
}