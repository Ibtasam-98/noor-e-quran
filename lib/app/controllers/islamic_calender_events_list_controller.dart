import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../config/app_colors.dart';
import '../config/app_sizedbox.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_snackbar.dart';
import '../widgets/custom_text.dart';
import 'app_theme_switch_controller.dart';

class IslamicCalenderEventsListController extends GetxController {
  final TextEditingController editTitleController = TextEditingController();
  final TextEditingController editDescriptionController =
  TextEditingController();

  void showEditEventBottomSheet(
      BuildContext context,
      int index,
      RxList<Map<String, dynamic>> events,
      Function(List<Map<String, dynamic>>) onEventUpdated) {
    final AppThemeSwitchController themeController =
    Get.find<AppThemeSwitchController>();

    editTitleController.text = events[index]['title'];
    editDescriptionController.text = events[index]['description'];
    bool isDarkMode = themeController.isDarkMode.value;
    showModalBottomSheet(
      backgroundColor: AppColors.white,
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                CustomText(
                  textColor: AppColors.primary,
                  title: 'Edit Event',
                  textAlign: TextAlign.start,
                  fontSize: 20.sp,
                  fontFamily: 'grenda',
                ),
                AppSizedBox.space10h,
                TextField(
                  controller: editTitleController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.r),
                      borderSide: BorderSide.none,
                    ),
                    hintText: 'Title',
                    fillColor: isDarkMode
                        ? AppColors.grey.withOpacity(0.1)
                        : AppColors.grey.withOpacity(0.2),
                    filled: true,
                    hintStyle: GoogleFonts.quicksand(
                      color: isDarkMode ? AppColors.white : AppColors.black,
                    ),
                  ),
                ),
                AppSizedBox.space10h,
                TextField(
                  controller: editDescriptionController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.r),
                      borderSide: BorderSide.none,
                    ),
                    hintText: 'Description',
                    fillColor: isDarkMode
                        ? AppColors.grey.withOpacity(0.1)
                        : AppColors.grey.withOpacity(0.2),
                    filled: true,
                    hintStyle: GoogleFonts.quicksand(
                      color: isDarkMode ? AppColors.white : AppColors.black,
                    ),
                  ),
                ),
                AppSizedBox.space10h,
                CustomButton(
                  haveBgColor: true,
                  btnTitle: "Update Event",
                  btnTitleColor: AppColors.white,
                  bgColor: AppColors.primary,
                  borderRadius: 45.r,
                  onTap: () {
                    // Create a copy of the events list
                    List<Map<String, dynamic>> updatedEvents =
                    List.from(events);
                    // Modify the copy
                    if (editTitleController.text.isEmpty ||
                        editDescriptionController.text.isEmpty) {
                      CustomSnackbar.show(
                        title: "Error",
                        subtitle: "Both fields are required.",
                        icon: const Icon(Icons.error),
                        backgroundColor: AppColors.red,
                      );
                      return;
                    }
                    updatedEvents[index]['title'] =
                        editTitleController.text;
                    updatedEvents[index]['description'] =
                        editDescriptionController.text;
                    // Update the original list with the modified copy
                    onEventUpdated(updatedEvents);
                    Navigator.pop(context);
                    CustomSnackbar.show(
                      title: "Success",
                      subtitle: "Event edited successfully.",
                      icon: const Icon(Icons.check),
                      backgroundColor: AppColors.green,
                    );
                  },
                  height: 45.h,
                ),
                AppSizedBox.space20h,
              ],
            ),
          ),
        );
      },
    );
  }
}