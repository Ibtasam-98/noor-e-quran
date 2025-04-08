import 'package:flutter/material.dart';
import 'package:noor_e_quran/app/config/app_sizedbox.dart';
import 'package:noor_e_quran/app/widgets/custom_button.dart';
import 'package:get/get.dart';
import 'package:quran/quran.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../config/app_colors.dart';
import '../../controllers/app_theme_switch_controller.dart';
import '../../controllers/quran_surah_setting_controller.dart';
import '../../widgets/custom_text.dart';

class QuranSurahSettingScreen extends StatelessWidget {
  final Translation currentTranslation;
  final bool isTranslationEnabled;
  final double currentFontSize;
  final double currentWordSpacing;
  final String currentArabicFontFamily;
  final String currentTranslationFontFamily;

  QuranSurahSettingScreen({
    Key? key,
    required this.currentTranslation,
    required this.isTranslationEnabled,
    required this.currentFontSize,
    required this.currentWordSpacing,
    required this.currentArabicFontFamily,
    required this.currentTranslationFontFamily,
  }) : super(key: key);

  final QuranSurahSettingController controller = Get.put(QuranSurahSettingController());
  final AppThemeSwitchController themeController = Get.find();

  @override
  Widget build(BuildContext context) {
    controller.initSettings(
      currentTranslation: currentTranslation,
      isTranslationEnabled: isTranslationEnabled,
      currentFontSize: currentFontSize,
      currentWordSpacing: currentWordSpacing,
      currentArabicFontFamily: currentArabicFontFamily,
      currentTranslationFontFamily: currentTranslationFontFamily,
    );

    final textColor = themeController.isDarkMode.value ? AppColors.white : AppColors.black;
    final iconColor = themeController.isDarkMode.value ? AppColors.white : AppColors.black;
    bool isDarkMode = themeController.isDarkMode.value;

    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        backgroundColor: themeController.isDarkMode.value ? AppColors.black : AppColors.white,
        appBar: AppBar(
          surfaceTintColor: AppColors.transparent,
          backgroundColor: themeController.isDarkMode.value ? AppColors.black : AppColors.white,
          title: CustomText(
            firstText: "Quran",
            secondText: " Setting",
            fontSize: 18.sp,
            firstTextColor: isDarkMode ? AppColors.white : AppColors.black,
            secondTextColor: AppColors.primary,
          ),
          iconTheme: IconThemeData(color: iconColor),
          leading: IconButton(
            icon: Icon(Icons.west, color: iconColor),
            onPressed: () {
              controller.saveSettings().then((_) {
                Navigator.pop(context, controller.getSettings());
              });
            },
          ),
          centerTitle: false,
        ),
        body: Padding(
          padding: EdgeInsets.only(left: 15.w, right: 10.w),
          child: Obx(() => ListView(
            children: [
              CustomText(
                title: "Translation",
                fontSize: 18.sp,
                textColor: AppColors.primary,
                fontFamily: 'grenda',
                maxLines: 1,
                textOverflow: TextOverflow.ellipsis,
                textAlign: TextAlign.start,
              ),
              Container(
                padding: EdgeInsets.all(12.w),
                margin: EdgeInsets.only(top: 10.h),
                decoration: BoxDecoration(
                  color: isDarkMode ? AppColors.primary.withOpacity(0.1) : AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(15.r),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText(
                      title: "Enable Translation",
                      fontSize: 16.sp,
                      textColor: isDarkMode ? AppColors.white : AppColors.black,
                      maxLines: 1,
                      textOverflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.start,
                    ),
                    Transform.scale(
                      scale: 0.8,
                      child: Switch(
                        activeColor: AppColors.primary,
                        value: controller.isTranslationEnabled.value,
                        onChanged: (value) => controller.isTranslationEnabled.value = value,
                      ),
                    ),
                  ],
                ),
              ),
              AppSizedBox.space10h,
              CustomText(
                title: "Translation Language",
                fontSize: 18.sp,
                textColor: AppColors.primary,
                fontFamily: 'grenda',
                maxLines: 1,
                textOverflow: TextOverflow.ellipsis,
                textAlign: TextAlign.start,
              ),
              AppSizedBox.space10h,
              Container(
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(15.r),
                ),
                child: Padding(
                  padding: EdgeInsets.all(12.w),
                  child: Wrap(
                    children: List.generate(
                      Translation.values.where((translation) {
                        return [
                          'chinese',
                          'indonesian',
                          'spanish',
                          'swedish',
                          'bengali',
                          'portuguese',
                          'english',
                          'urdu',
                          'enSaheeh',
                          'enClearQuran',
                          'trSaheeh'
                        ].contains(translation.name);
                      }).toList().length,
                          (index) {
                        final translation = Translation.values.where((translation) {
                          return [
                            'chinese',
                            'indonesian',
                            'spanish',
                            'swedish',
                            'bengali',
                            'portuguese',
                            'english',
                            'urdu',
                            'enSaheeh',
                            'enClearQuran',
                            'trSaheeh'
                          ].contains(translation.name);
                        }).toList()[index];

                        String translationLabel = controller.getTranslationLabel(translation);

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: CustomText(
                                    title: translationLabel,
                                    fontSize: 16.sp,
                                    capitalize: true,
                                    maxLines: 1,
                                    textAlign: TextAlign.start,
                                    textOverflow: TextOverflow.ellipsis,
                                    textColor: isDarkMode ? AppColors.white : AppColors.black,
                                  ),
                                ),
                                Radio<Translation>(
                                  value: translation,
                                  activeColor: AppColors.primary,
                                  groupValue: controller.selectedTranslation.value,
                                  onChanged: (Translation? val) => controller.selectedTranslation.value = val!,
                                ),
                              ],
                            ),
                            if (index != Translation.values.where((translation) {
                              return [
                                'chinese',
                                'indonesian',
                                'spanish',
                                'swedish',
                                'bengali',
                                'portuguese',
                                'english',
                                'urdu',
                                'enSaheeh',
                                'enClearQuran',
                                'trSaheeh'
                              ].contains(translation.name);
                            }).toList().length - 1)
                              Divider(
                                color: AppColors.primary,
                                thickness: 0.1,
                              ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppSizedBox.space10h,
                  CustomText(
                    title: "Translation Spacing",
                    fontSize: 18.sp,
                    textColor: AppColors.primary,
                    fontFamily: 'grenda',
                    maxLines: 1,
                    textOverflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.start,
                  ),
                  AppSizedBox.space10h,
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(15.r),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(12.w),
                      child: Slider(
                        value: controller.translationSpacing.value,
                        min: 0.5,
                        max: 2.0,
                        divisions: 15,
                        activeColor: AppColors.primary,
                        label: 'Translation Spacing: ${controller.translationSpacing.value.toStringAsFixed(1)}',
                        onChanged: (value) => controller.translationSpacing.value = value,
                      ),
                    ),
                  ),
                  AppSizedBox.space10h,
                  CustomText(
                    title: "Translation Font Size",
                    fontSize: 18.sp,
                    textColor: AppColors.primary,
                    fontFamily: 'grenda',
                    maxLines: 1,
                    textOverflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.start,
                  ),
                  AppSizedBox.space10h,
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(15.r),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(12.w),
                      child: Slider(
                        value: controller.translationFontSize.value,
                        min: 10.sp,
                        activeColor: AppColors.primary,
                        max: 35.sp,
                        divisions: 25,
                        label: 'Translation Font Size: ${controller.translationFontSize.value.toStringAsFixed(0)}',
                        onChanged: (value) => controller.translationFontSize.value = value,
                      ),
                    ),
                  ),
                ],
              ),
              AppSizedBox.space10h,
              CustomText(
                title: "Arabic Word Spacing",
                fontSize: 18.sp,
                textColor: AppColors.primary,
                fontFamily: 'grenda',
                maxLines: 1,
                textOverflow: TextOverflow.ellipsis,
                textAlign: TextAlign.start,
              ),
              AppSizedBox.space10h,
              Container(
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(15.r),
                ),
                child: Padding(
                  padding: EdgeInsets.all(12.w),
                  child: Slider(
                    value: controller.arabicWordSpacing.value,
                    min: -2.0,
                    max: 5.0,
                    activeColor: AppColors.primary,
                    divisions: 70,
                    label: 'Arabic Word Spacing: ${controller.arabicWordSpacing.value.toStringAsFixed(1)}',
                    onChanged: (value) => controller.arabicWordSpacing.value = value,
                  ),
                ),
              ),
              AppSizedBox.space10h,
              CustomText(
                title: "Arabic Font Style",
                fontSize: 18.sp,
                textColor: AppColors.primary,
                fontFamily: 'grenda',
                maxLines: 1,
                textOverflow: TextOverflow.ellipsis,
                textAlign: TextAlign.start,
              ),
              AppSizedBox.space10h,
              Container(
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Column(
                  children: [
                    ...['Amiri', 'Amiri Quran', 'Quicksand'].map((String font) {
                      return Column(
                        children: [
                          RadioListTile<String>(
                            title: CustomText(
                              title: font,
                              fontSize: 16.sp,
                              textColor: isDarkMode ? AppColors.white : AppColors.black,
                              textAlign: TextAlign.start,
                            ),
                            value: font,
                            activeColor: AppColors.primary,
                            groupValue: controller.arabicFontFamily.value,
                            onChanged: (String? val) => controller.arabicFontFamily.value = val!,
                            controlAffinity: ListTileControlAffinity.trailing,
                          ),
                          if (font != 'Quicksand')
                            Padding(
                              padding: EdgeInsets.only(left: 10.w, right: 10.w),
                              child: Divider(
                                color: AppColors.primary.withOpacity(0.1),
                                thickness: 1,
                              ),
                            ),
                        ],
                      );
                    }).toList(),
                  ],
                ),
              ),
              AppSizedBox.space10h,
              CustomText(
                title: "Arabic Font Size",
                fontSize: 18.sp,
                textColor: AppColors.primary,
                fontFamily: 'grenda',
                maxLines: 1,
                textOverflow: TextOverflow.ellipsis,
                textAlign: TextAlign.start,
              ),
              AppSizedBox.space10h,
              Container(
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(15.r),
                ),
                child: Padding(
                  padding: EdgeInsets.all(12.w),
                  child: Slider(
                    value: controller.arabicFontSize.value,
                    min: 10.sp,
                    max: 35.sp,
                    activeColor: AppColors.primary,
                    divisions: 25,
                    label: 'Arabic Font Size: ${controller.arabicFontSize.value.toStringAsFixed(0)}',
                    onChanged: (value) => controller.arabicFontSize.value = value,
                  ),
                ),
              ),
              AppSizedBox.space10h,
              CustomText(
                title: "Translation Font Style",
                fontSize: 18.sp,
                textColor: AppColors.primary,
                fontFamily: 'grenda',
                maxLines: 1,
                textOverflow: TextOverflow.ellipsis,
                textAlign: TextAlign.start,
              ),
              AppSizedBox.space10h,
              Container(
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(15.r),
                ),
                child: Column(
                  children: [
                    ...['Roboto', 'Times New Roman'].map((String font) {
                      return Column(
                        children: [
                          RadioListTile<String>(
                            title: CustomText(
                              title: font,
                              textColor: isDarkMode ? AppColors.white : AppColors.black,
                              fontSize: 16.sp,
                              textAlign: TextAlign.start,
                            ),
                            value: font,
                            activeColor: AppColors.primary,
                            groupValue: controller.translationFontFamily.value,
                            onChanged: (String? val) => controller.translationFontFamily.value = val!,
                            controlAffinity: ListTileControlAffinity.trailing,
                          ),
                          if (font != 'Times New Roman')
                            Padding(
                              padding: EdgeInsets.only(left: 10.w, right: 10.w),
                              child: Divider(
                                color: AppColors.primary.withOpacity(0.1),
                                thickness: 1,
                              ),
                            ),
                        ],
                      );
                    }).toList(),
                  ],
                ),
              ),
              AppSizedBox.space20h,
              Center(
                child: CustomButton(
                  haveBgColor: true,
                  btnTitle: "Set Quran to Default",
                  btnTitleColor: AppColors.white,
                  bgColor: AppColors.primary,
                  borderRadius: 10.r,
                  height: 45.h,
                  onTap: controller.resetToDefault,
                ),
              ),
              AppSizedBox.space20h,
            ],
          )),
        ),
      ),
    );
  }
}