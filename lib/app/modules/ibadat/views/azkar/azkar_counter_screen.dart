import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:get_storage/get_storage.dart';
import 'package:vibration/vibration.dart';

import '../../../../config/app_colors.dart';
import '../../../../controllers/app_theme_switch_controller.dart';
import '../../../../widgets/custom_snackbar.dart';
import '../../../../widgets/custom_text.dart';

class AzkarCounterScreen extends StatelessWidget {
  final String? azkarType, azkarName;
  final Map<String, dynamic> zikar;

  AzkarCounterScreen({required this.zikar, this.azkarType, required this.azkarName});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Get.find<AppThemeSwitchController>().isDarkMode.value;
    final controller = Get.put(AzkarCounterController(
        zikar,
        zikar['repeat'] as int, azkarType ?? "",
        azkarName ?? ""
    )); // Pass title to controller

    // Load state on screen creation
    controller.loadState();

    return Scaffold(
      backgroundColor: isDarkMode ? AppColors.black : AppColors.white,
      appBar: AppBar(
        backgroundColor: isDarkMode ? AppColors.black : AppColors.white,
        surfaceTintColor: AppColors.transparent,
        centerTitle: false,
        title: CustomText(
          firstText: azkarType ?? "",
          secondText: "",
          fontSize: 18.sp,
          firstTextColor: isDarkMode ? AppColors.white : AppColors.black,
          secondTextColor: AppColors.primary,
        ),
        leading: InkWell(
          onTap: () => Get.back(),
          child: Icon(Icons.west, color: isDarkMode ? AppColors.white : AppColors.black),
        ),
      ),
      body: Obx(
            () => InkWell(
          splashColor: AppColors.transparent,
          highlightColor: AppColors.transparent,
          onTap: () {
            controller.incrementCount();
            if (controller.currentCount.value == controller.targetCount) {
              Vibration.vibrate(duration: 500); // Long vibration on completion
              CustomSnackbar.show(
                backgroundColor: AppColors.green,
                title: "Ma Sha Allah",
                subtitle: "You have completed the Azkar!",
                icon: Icon(Icons.check),
              );
              controller.resetAzkar(); // Reset after snackbar
            } else {
              Vibration.vibrate(duration: 100); // Short vibration on tap
            }
          },
          child: Stack(
            children: [
              if (controller.backgroundImageOpacity.value > 0.0)
                Opacity(
                  opacity: controller.backgroundImageOpacity.value,
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/images/quran_bg_audio.jpg"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: EdgeInsets.all(10.h),
                    margin: EdgeInsets.all(15.w),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.r),
                      color: AppColors.primary,
                    ),
                    child:  Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: CustomText(
                          title: zikar['zikar'],
                          fontSize: controller.zikarFontSize.value.sp,
                          textColor: AppColors.white,
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ),
                  ),
                  CircularPercentIndicator(
                    radius: 80.0,
                    lineWidth: 8.0,
                    percent: controller.currentCount.value / controller.targetCount,
                    center: CustomText(
                      title: '${controller.currentCount.value} / ${controller.targetCount}',
                      fontSize: 20.sp,
                      textColor: Colors.white,
                      textStyle: GoogleFonts.montserrat(),
                      fontWeight: FontWeight.bold,
                    ),
                    linearGradient: LinearGradient(
                      colors: <Color>[
                        Colors.greenAccent,
                        Colors.lightGreen,
                        Colors.green,
                        Colors.tealAccent,
                        Colors.teal,
                        Colors.cyanAccent,
                        Colors.cyan,
                        Colors.lightBlueAccent,
                        Colors.lightBlue,
                        Colors.blueAccent,
                        Colors.blue,
                      ],
                      stops: <double>[
                        0.0,
                        0.1,
                        0.2,
                        0.3,
                        0.4,
                        0.5,
                        0.6,
                        0.7,
                        0.8,
                        0.9,
                        1.0,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    backgroundColor: Colors.grey.withOpacity(0.3),
                  ),
                  SizedBox(),
                  SizedBox(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

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