import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:noor_e_quran/app/config/app_colors.dart';
import 'package:noor_e_quran/app/config/app_sizedbox.dart';
import 'package:noor_e_quran/app/widgets/custom_button.dart';
import 'package:noor_e_quran/app/widgets/custom_text.dart';
import 'package:quran/quran.dart' as quran;

import '../../../controllers/app_theme_switch_controller.dart';

import '../../../widgets/custom_card.dart';
import '../controllers/quran_notes_controller.dart';

class QuranNotesScreen extends StatelessWidget {
  final QuranNotesController controller = Get.put(QuranNotesController());
  final AppThemeSwitchController themeController = Get.find();

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = themeController.isDarkMode.value;
    final textColor = isDarkMode ? AppColors.white : AppColors.black;
    return Scaffold(
      backgroundColor: isDarkMode ? AppColors.black : AppColors.white,
      appBar: AppBar(
        surfaceTintColor: AppColors.transparent,
        foregroundColor: AppColors.transparent,
        centerTitle: false,
        title: CustomText(
          firstText: "Quran",
          secondText: " Notes",
          firstTextColor: isDarkMode ? AppColors.white : AppColors.black,
          secondTextColor: AppColors.primary,
          fontSize: 18.sp,
        ),
        leading: IconButton(
          icon: Icon(
            Icons.west,
            color: themeController.isDarkMode.value
                ? AppColors.white
                : AppColors.black,
          ),
          onPressed: () {
            Get.back();
          },
        ),
        backgroundColor: isDarkMode ? AppColors.black : AppColors.white,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.h),
        child: Column(
          children: [
            CustomCard(
              title: "Reflect & Record",
              subtitle: "Capture your understanding of the Quran",
              imageUrl: isDarkMode ? "assets/images/quran_bg_dark.jpg" : "assets/images/quran_bg_light.jpg",
              titleFontSize: 18.sp,
              subtitleFontSize: 12.sp,
              mergeWithGradientImage: true,
              useLinearGradient: true,
              gradientColors: [
                AppColors.black.withOpacity(0.4),
                AppColors.transparent,
                AppColors.black.withOpacity(0.4),
              ],
            ),
            AppSizedBox.space10h,
            Expanded(
              child: Obx(() {
                // Access controller.expandedIndex.value to make Obx listen to changes
                controller.expandedIndex.value; // This line is crucial!

                return controller.notes.isEmpty
                    ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomText(
                        title: "No Notes Added yet.",
                        fontSize: 16.sp,
                        textColor: textColor,
                      ),
                      AppSizedBox.space5h,
                      CustomText(
                        title: "Tap the + button to add a note.",
                        fontSize: 16.sp,
                        textColor: Colors.grey,
                      ),
                    ],
                  ),
                )
                    : ListView.builder(
                  itemCount: controller.notes.length,
                  itemBuilder: (context, index) {
                    final note = controller.notes[index];
                    final isExpanded = controller.expandedIndex.value == index;
                    return GestureDetector(
                      onTap: () {
                        controller.toggleExpanded(index);
                      },
                      child: Container(
                        margin: EdgeInsets.only(top: 5.h, bottom: 5.h),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.r),
                          color: (index % 2 == 1)
                              ? AppColors.primary.withOpacity(0.09)
                              : AppColors.primary.withOpacity(0.3),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16.w, vertical: 12.h),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        CustomText(
                                          title:
                                          '${quran.getSurahName(note['surah'])} | Ayat ${note['ayah']}',
                                          fontSize: 15.sp,
                                          textColor: textColor,
                                          fontWeight: FontWeight.w500,
                                          textOverflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          capitalize: true,
                                          textAlign: TextAlign.start,
                                        ),
                                        CustomText(
                                          title: "Added on ${note['time']}",
                                          fontSize: 12.sp,
                                          textColor: AppColors.primary,
                                          textAlign: TextAlign.start,
                                          textOverflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Icon(
                                    Icons.keyboard_arrow_down_outlined,
                                    color: isDarkMode
                                        ? AppColors.white
                                        : AppColors.black,
                                  ),
                                ],
                              ),
                            ),
                            if (isExpanded)
                              Padding(
                                  padding: EdgeInsets.all(16.h),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                    CustomText(
                                      title: note['note'],
                                      fontSize: 15.sp,
                                      textColor: textColor,
                                      textAlign: TextAlign.start,
                                      capitalize: true,
                                    ),
                                    IconButton(onPressed: (){controller.deleteNote(index);}, icon: const Icon(Icons.delete,color: AppColors.red,))
                                  ],)

                              ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddNoteBottomSheet(context, controller);
        },
        child: Icon(Icons.add, color: AppColors.white),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  void _showAddNoteBottomSheet(BuildContext context, QuranNotesController controller) {
    bool isDarkMode = themeController.isDarkMode.value;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            width: Get.width,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(20.r), topRight: Radius.circular(20.r)),
            ),
            padding: EdgeInsets.all(16.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      textColor: AppColors.primary,
                      title: "Add Quranic Note",
                      textAlign: TextAlign.start,
                      fontSize: 20.sp,
                      fontFamily: 'grenda',
                    ),
                    AppSizedBox.space10h,
                    GestureDetector(
                      onTap: () {
                        controller.isSurahDialog.value = true;
                        showDialog(
                          context: context,
                          builder: (context) => _buildDropdownDialog(controller),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: isDarkMode ? AppColors.grey.withOpacity(0.1) : AppColors.grey.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(10.r),
                      ),
                        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 16.h),
                        width: double.infinity,
                        child: Obx(()=>CustomText(
                          title:quran.getSurahName(controller.selectedSurah.value),
                          fontSize: 14.sp,
                          textAlign: TextAlign.start,
                          textColor: AppColors.black,
                        ),),
                      ),
                    ),
                    AppSizedBox.space10h,
                    GestureDetector(
                      onTap: () {
                        controller.isSurahDialog.value = false;
                        showDialog(
                          context: context,
                          builder: (context) => _buildDropdownDialog(controller),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: isDarkMode ? AppColors.grey.withOpacity(0.1) : AppColors.grey.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(10.r),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 16.h),
                        width: double.infinity,
                        child: Obx(()=>CustomText(
                          title:'Ayah ${controller.selectedAyah.value}',
                          fontSize: 14.sp,
                          textAlign: TextAlign.start,
                          textColor: AppColors.black,
                        ),),
                      ),
                    ),
                  ],
                ),
                AppSizedBox.space10h,
                TextField(
                  controller: controller.noteController,
                  style: GoogleFonts.quicksand(color: AppColors.black),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.r),
                      borderSide: BorderSide.none,
                    ),
                    hintText: 'Note',
                    fillColor: isDarkMode ? AppColors.grey.withOpacity(0.1) : AppColors.grey.withOpacity(0.2),
                    filled: true,
                    hintStyle: GoogleFonts.quicksand(
                      color: isDarkMode ? AppColors.white : AppColors.black,
                    ),
                  ),
                  maxLines: 3,
                ),
                AppSizedBox.space10h,
                CustomButton(
                  haveBgColor: true,
                  btnTitle: "Save Note",
                  btnTitleColor: AppColors.white,
                  bgColor: AppColors.primary,
                  borderRadius: 45.r,
                  onTap: controller.saveNote,
                  height: 45.h,
                  useGradient: true,
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primary,
                      AppColors.secondry.withOpacity(0.9),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                AppSizedBox.space20h,
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDropdownDialog(QuranNotesController controller) {
    return AlertDialog(
      backgroundColor: AppColors.white,
      title: TextField(
        controller: controller.searchController,
        decoration: InputDecoration(
          labelText: controller.isSurahDialog.value ? 'Search Surah' : 'Search Ayah',
          labelStyle: GoogleFonts.quicksand(),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide: BorderSide.none,
          ),
          fillColor: AppColors.grey.withOpacity(0.2),
          filled: true,

        ),
        style: GoogleFonts.quicksand(color: AppColors.black),
        onChanged: (value) {
          controller.onSearchChanged();
        },
      ),
      content: Container(
        height: 300.h,
        width: 300.w,
        child: Obx(() => ListView.separated(
          itemCount: controller.isSurahDialog.value
              ? controller.filteredSurahs.length
              : quran.getVerseCount(controller.selectedSurah.value),
          separatorBuilder: (context, index) => Divider(
            color: Colors.grey.withOpacity(0.3),
            height: 1.h,
          ),
          itemBuilder: (context, index) {
            final item = controller.isSurahDialog.value
                ? controller.filteredSurahs[index]
                : index + 1;
            return ListTile(
              title: CustomText(
                title: controller.isSurahDialog.value
                    ? quran.getSurahName(item)
                    : 'Ayah $item',
                fontSize: 15.sp,
                textColor: AppColors.black,
                textAlign: TextAlign.start,
              ),
              onTap: () {
                controller.selectItem(item);
                Navigator.pop(context);
              },
            );
          },
        )),
      ),
    );
  }
}