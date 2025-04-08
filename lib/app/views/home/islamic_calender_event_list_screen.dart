import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../config/app_colors.dart';
import '../../config/app_sizedbox.dart';
import '../../controllers/app_theme_switch_controller.dart';
import '../../controllers/islamic_calender_events_list_controller.dart';
import '../../widgets/custom_text.dart';

class IslamicCalenderEventsListScreen extends StatelessWidget {
  final RxList<Map<String, dynamic>> events;
  final Function(List<Map<String, dynamic>>) onEventUpdated;
  final IslamicCalenderEventsListController islamicCalenderEventsListController =
  Get.put(IslamicCalenderEventsListController());

  IslamicCalenderEventsListScreen(
      {required this.events, required this.onEventUpdated});

  @override
  Widget build(BuildContext context) {
    final AppThemeSwitchController themeController =
    Get.find<AppThemeSwitchController>();
    bool isDarkMode = themeController.isDarkMode.value;
    final textColor = isDarkMode ? AppColors.white : AppColors.black;

    return Scaffold(
        backgroundColor: isDarkMode ? AppColors.black : AppColors.white,
        appBar: AppBar(
          surfaceTintColor: AppColors.transparent,
          foregroundColor: AppColors.transparent,
          centerTitle: false,
          title: CustomText(
            firstText: "Your",
            secondText: " Events",
            firstTextColor: isDarkMode ? AppColors.white : AppColors.black,
            secondTextColor: AppColors.primary,
            fontSize: 18.sp,
          ),
          backgroundColor: isDarkMode ? AppColors.black : AppColors.white,
          leading: InkWell(
            onTap: () => Get.back(),
            child: Icon(Icons.west,
                color: isDarkMode ? AppColors.white : AppColors.black),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.all(12.w),
          child: Column(
            children: [
              AppSizedBox.space10h,
              Expanded(
                child: Obx(() {
                  if (events.isEmpty) {
                    return Center(
                      child: CustomText(
                        title: "No events added yet.",
                        fontSize: 16.sp,
                        textColor: textColor,
                      ),
                    );
                  } else {
                    return ListView.builder(
                      itemCount: events.length,
                      itemBuilder: (context, index) {
                        final event = events[index];
                        return Container(
                          margin: EdgeInsets.only(top: 5.h, bottom: 5.h),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.r),
                            color: (index % 2 == 1)
                                ? AppColors.primary.withOpacity(0.09)
                                : AppColors.primary.withOpacity(0.3),
                          ),
                          child: ListTile(
                            title: CustomText(
                              title: event['title'],
                              fontSize: 17.sp,
                              textColor: textColor,
                              textAlign: TextAlign.start,
                            ),
                            subtitle: CustomText(
                              title: event['description'],
                              fontSize: 13.sp,
                              textColor: textColor,
                              textAlign: TextAlign.start,
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.edit,
                                      color: isDarkMode
                                          ? AppColors.white
                                          : AppColors.black),
                                  onPressed: () =>
                                      islamicCalenderEventsListController
                                          .showEditEventBottomSheet(
                                          context,
                                          index,
                                          events,
                                          onEventUpdated),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: AppColors.red),
                                  onPressed: () {
                                    List<Map<String, dynamic>> updatedEvents =
                                    List.from(events);
                                    updatedEvents.removeAt(index);
                                    onEventUpdated(updatedEvents);
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }
                }),
              )
            ],
          ),
        ));
  }
}