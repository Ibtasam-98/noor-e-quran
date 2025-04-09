import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../config/app_colors.dart';
import '../config/app_sizedbox.dart';
import '../views/home/islamic_calender_event_list_screen.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_snackbar.dart';
import '../widgets/custom_text.dart';

class IslamicCalendarController extends GetxController {
  final _storage = GetStorage();
  RxList<Map<String, dynamic>> events = <Map<String, dynamic>>[].obs;
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    loadEvents();
  }

  Future<void> loadEvents() async {
    final storedEvents = _storage.read('events');
    if (storedEvents != null) {
      events.assignAll(List<Map<String, dynamic>>.from(jsonDecode(storedEvents)));
    }
  }

  Future<void> saveEvents() async {
    await _storage.write('events', jsonEncode(events));
    CustomSnackbar.show(
      title: "Success",
      subtitle: "Your event is added",
      icon: const Icon(Icons.check),
      backgroundColor: AppColors.green,
    );
  }

  void showAddEventBottomSheet(BuildContext context, DateTime selectedDate) {
    showModalBottomSheet(
      backgroundColor: AppColors.white,
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return SizedBox(
              height: constraints.maxHeight * 0.9,
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                  left: 16.w,
                  right: 16.w,
                  top: 16.h,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      CustomText(
                        textColor: AppColors.primary,
                        title:
                        'Add Event for ${DateFormat('dd-MM-yyyy').format(selectedDate)}',
                        textAlign: TextAlign.start,
                        fontSize: 20.sp,
                        fontFamily: 'grenda',
                      ),
                      AppSizedBox.space10h,
                      TextField(
                        controller: titleController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.r),
                            borderSide: BorderSide.none,
                          ),
                          labelText: 'Title',
                          labelStyle: GoogleFonts.quicksand(
                            color: AppColors.black,
                          ),
                          fillColor: AppColors.grey.withOpacity(0.2),
                          filled: true,
                          hintStyle: GoogleFonts.quicksand(
                            color: AppColors.black,
                          ),
                        ),
                      ),
                      AppSizedBox.space10h,
                      TextField(
                        controller: descriptionController,
                        maxLines: 3, // Allows for multiple lines of description
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.r),
                            borderSide: BorderSide.none,
                          ),
                          labelText: 'Description',
                          labelStyle: GoogleFonts.quicksand(
                            color: AppColors.black,
                          ),
                          hintStyle: GoogleFonts.quicksand(
                            color: AppColors.black,
                          ),
                          fillColor: AppColors.grey.withOpacity(0.2),
                          filled: true,
                        ),
                      ),
                      AppSizedBox.space20h,
                      CustomButton(
                        haveBgColor: true,
                        btnTitle: "Add Event",
                        btnTitleColor: AppColors.white,
                        bgColor: AppColors.primary,
                        borderRadius: 45.r,
                        onTap: () {
                          if (titleController.text.isEmpty ||
                              descriptionController.text.isEmpty) {
                            CustomSnackbar.show(
                              title: "Error",
                              subtitle: "Both title and description are required.",
                              icon: const Icon(Icons.error),
                              backgroundColor: AppColors.red,
                            );
                            return;
                          }

                          final now = DateTime.now();
                          final newEvent = {
                            'date': selectedDate.toIso8601String(),
                            'title': titleController.text,
                            'description': descriptionController.text,
                            'addedTime': now.toIso8601String(),
                          };
                          if (events.any((event) =>
                          event['date'] == selectedDate.toIso8601String())) {
                            CustomSnackbar.show(
                              title: "Warning",
                              subtitle: "An event already exists for this date.",
                              icon: const Icon(Icons.warning),
                              backgroundColor: AppColors.red,
                            );
                            Navigator.pop(context);
                            return;
                          }
                          events.add(newEvent);
                          titleController.clear();
                          descriptionController.clear();
                          saveEvents();
                          Navigator.pop(context);
                        },
                        height: 45.h,
                      ),
                      AppSizedBox.space20h,
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void showEventsList(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => IslamicCalenderEventsListScreen(
          events: events,
          onEventUpdated: (updatedEvents) {
            events.assignAll(updatedEvents);
            saveEvents();
          },
        ),
      ),
    );
  }
}