import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:noor_e_quran/app/config/app_colors.dart';
import 'package:noor_e_quran/app/config/app_sizedbox.dart';
import 'package:noor_e_quran/app/controllers/app_theme_switch_controller.dart';
import 'package:noor_e_quran/app/widgets/custom_button.dart';
import 'package:noor_e_quran/app/widgets/custom_snackbar.dart';
import 'package:vibration/vibration.dart';

import '../views/home/tasbeeh/tasbeeh_list_screen.dart';
import '../widgets/custom_text.dart';

class TasbeehController extends GetxController {
  final _storage = GetStorage();
  RxString selectedTasbeeh = RxString('');
  RxInt targetCount = 0.obs;
  RxInt currentCount = 0.obs;
  RxBool isCompleted = false.obs;
  RxDouble firstImageOpacity = 0.0.obs;
  RxDouble secondImageOpacity = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    _loadTasbeehState();
  }

  void _loadTasbeehState() {
    final state = _storage.read('currentTasbeehState') as Map<String, dynamic>?;
    if (state != null) {
      selectedTasbeeh.value = state['name'];
      targetCount.value = state['targetCount'];
      currentCount.value = state['currentCount'];
      isCompleted.value = state['isCompleted'] ?? false;
      _updateImageOpacities();
    }
  }

  void saveTasbeehState() {
    if (selectedTasbeeh.value.isNotEmpty && targetCount.value > 0) {
      _storage.write('currentTasbeehState', {
        'name': selectedTasbeeh.value,
        'targetCount': targetCount.value,
        'currentCount': currentCount.value,
        'isCompleted': isCompleted.value,
      });
    } else {
      _storage.remove('currentTasbeehState');
    }
  }

  void showAddTasbeehBottomSheet() {
    String tasbeehName = '';
    Get.bottomSheet(
      Container(
        color: Colors.white,
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              title: 'Add Tasbeeh',
              fontSize: 18.sp,
              fontFamily: 'grenda',
              textAlign: TextAlign.start,
              textColor: AppColors.primary,
            ),
            AppSizedBox.space15h,
            TextField(
              decoration: InputDecoration(
                filled: true,
                fillColor: AppColors.grey.withOpacity(0.3),
                hintText: "SubhanAllah",
                hintStyle: GoogleFonts.quicksand(color: AppColors.black),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
              style: GoogleFonts.quicksand(color: AppColors.black),
              onChanged: (value) => tasbeehName = value,
            ),
            AppSizedBox.space20h,
            CustomButton(
              haveBgColor: true,
              btnTitle: "Add Dhikr",
              btnTitleColor: AppColors.white,
              bgColor: AppColors.primary,
              borderRadius: 50.r,
              height: 45.h,
              onTap: () {
                if (tasbeehName.isNotEmpty) {
                  final tasbeehs = _storage.read('tasbeehs') ?? <String>[];
                  if (!tasbeehs.contains(tasbeehName)) {
                    tasbeehs.add(tasbeehName);
                    _storage.write('tasbeehs', tasbeehs);
                  }
                  Get.back();
                }
              },
            ),
            AppSizedBox.space25h,
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  void showSelectTasbeehScreen() {
    Get.to(() => TasbeehListScreen())?.then((selectedTasbeeh) {
      if (selectedTasbeeh != null) {
        this.selectedTasbeeh.value = selectedTasbeeh;
        showTargetCountDialog();
      }
    });
  }

  void showTargetCountDialog() {
    final AppThemeSwitchController themeController = Get.put(AppThemeSwitchController());
    String count = '';
    Get.dialog(
      AlertDialog(
        backgroundColor: AppColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        title: CustomText(
          title: 'Enter Target Count',
          fontSize: 20.sp,
          textColor: AppColors.primary,
          textAlign: TextAlign.start,
          fontFamily: 'grenda',
        ),
        content: TextField(
          decoration: InputDecoration(
            filled: true,
            fillColor: themeController.isDarkMode.value ? AppColors.grey.withOpacity(0.1) : AppColors.grey.withOpacity(0.2),
            hintText: "30",
            hintStyle: GoogleFonts.quicksand(),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
          ),
          style: GoogleFonts.quicksand(color: AppColors.black),
          keyboardType: TextInputType.number,
          onChanged: (value) => count = value,
        ),
        actions: [
          CustomButton(
            haveBgColor: true,
            btnTitle: "Done",
            btnTitleColor: AppColors.white,
            bgColor: AppColors.primary,
            borderRadius: 50.r,
            height: 45.h,
            onTap: () {
              if (int.tryParse(count) != null) {
                targetCount.value = int.parse(count);
                currentCount.value = 0;
                isCompleted.value = false;
                _updateImageOpacities();
                saveTasbeehState();
                Get.back();
              }
            },
          ),
        ],
      ),
    );
  }

  Future<void> incrementCount() async {
    if (selectedTasbeeh.value.isNotEmpty &&
        targetCount.value > 0 &&
        !isCompleted.value) {
      if (await Vibration.hasCustomVibrationsSupport()) {
        Vibration.vibrate(duration: 100);
      } else {
        Vibration.vibrate();
        await Future.delayed(Duration(milliseconds: 500));
        Vibration.vibrate();
      }
      currentCount.value++;
      _updateImageOpacities();
      if (currentCount.value >= targetCount.value) {
        isCompleted.value = true;
        _saveCompletedTasbeeh();
        _storage.remove('currentTasbeehState');
        CustomSnackbar.show(
          backgroundColor: AppColors.green,
          title: "Ma Sha Allah",
          subtitle: "You have completed the dhikr!",
          icon: Icon(Icons.check),
        );
        //Long vibration when completed
        if (await Vibration.hasCustomVibrationsSupport()) {
          Vibration.vibrate(duration: 500);
        } else {
          Vibration.vibrate();
          await Future.delayed(Duration(milliseconds: 500));
          Vibration.vibrate();
        }
      }
      saveTasbeehState();
    }
  }

  void _updateImageOpacities() {
    if (targetCount.value > 0) {
      final halfCount = targetCount.value / 2;
      if (currentCount.value <= halfCount) {
        firstImageOpacity.value = (currentCount.value / halfCount).clamp(0.0, 1.0);
        secondImageOpacity.value = 0.0;
      } else {
        firstImageOpacity.value = 0.0; // Ensure first image disappears
        secondImageOpacity.value = ((currentCount.value - halfCount) / halfCount).clamp(0.0, 1.0);
      }
    } else {
      firstImageOpacity.value = 0.0;
      secondImageOpacity.value = 0.0;
    }
  }

  void _saveCompletedTasbeeh() {
    final completedTasbeehs = _storage.read('completedTasbeehs') ??
        <Map<String, dynamic>>[];
    completedTasbeehs.insert(0, {
      'name': selectedTasbeeh.value,
      'targetCount': targetCount.value,
      'currentCount': currentCount.value,
      'timestamp': DateTime.now().toIso8601String(),
    });
    _storage.write('completedTasbeehs', completedTasbeehs);
  }

  @override
  void onClose() {
    saveTasbeehState();
    super.onClose();
  }
}