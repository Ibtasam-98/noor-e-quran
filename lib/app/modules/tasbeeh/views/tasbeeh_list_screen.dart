import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:noor_e_quran/app/config/app_colors.dart';
import 'package:noor_e_quran/app/config/app_sizedbox.dart';
import 'package:noor_e_quran/app/controllers/app_theme_switch_controller.dart';
import 'package:noor_e_quran/app/widgets/custom_card.dart';
import 'package:noor_e_quran/app/widgets/custom_text.dart';

import '../controllers/tasbeeh_list_controller.dart';

class TasbeehListScreen extends StatelessWidget {
  final TasbeehListController controller = Get.put(TasbeehListController());

  @override
  Widget build(BuildContext context) {
    final AppThemeSwitchController themeSwitchController =
    Get.put(AppThemeSwitchController());
    bool isDarkMode = themeSwitchController.isDarkMode.value;
    final textColor = isDarkMode ? AppColors.white : AppColors.black;
    final iconColor = isDarkMode ? AppColors.white : AppColors.black;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor:
        themeSwitchController.isDarkMode.value ? AppColors.black : AppColors.white,
        appBar: AppBar(
          backgroundColor:
          themeSwitchController.isDarkMode.value ? AppColors.black : AppColors.white,
          title: CustomText(
            firstText: "Custom ",
            secondText: "Dhikr",
            firstTextColor:
            themeSwitchController.isDarkMode.value ? AppColors.white : AppColors.black,
            secondTextColor: AppColors.primary,
            fontSize: 18.sp,
          ),
          centerTitle: false,
          leading: InkWell(
            onTap: () {
              Get.back();
            },
            child: Icon(
              Icons.west,
              color: iconColor,
            ),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.only(left: 10.w, right: 10.w),
          child: Column(
            children: [
              CustomCard(
                title: "The Remembrance of Allah",
                subtitle: "Hearts find peace in Dhikr",
                imageUrl: isDarkMode
                    ? "assets/images/quran_bg_dark.jpg"
                    : "assets/images/quran_bg_light.jpg",
                mergeWithGradientImage: true,
                titleFontSize: 18.sp,
                subtitleFontSize: 12.sp,
                decorationColor: AppColors.red,
                addBoxShadow: true,
                useLinearGradient: true,
                gradientColors: [
                  AppColors.black.withOpacity(0.4),
                  AppColors.transparent,
                  AppColors.black.withOpacity(0.4),
                ],
              ),
              AppSizedBox.space10h,
              TabBar(
                dividerColor: Colors.transparent,
                indicatorSize: TabBarIndicatorSize.tab,
                indicatorColor: AppColors.primary,
                labelColor: isDarkMode ? AppColors.white : AppColors.black,
                unselectedLabelColor: textColor,
                labelStyle: GoogleFonts.quicksand(fontSize: 14.sp),
                indicator: BoxDecoration(
                  border: Border.all(color: AppColors.primary, width: 1),
                  borderRadius: BorderRadius.circular(50.r),
                ),
                tabs: [
                  Tab(text: 'Dhikr'),
                  Tab(text: 'Completed'),
                ],
              ),
              AppSizedBox.space10h,
              Expanded(
                child: TabBarView(
                  children: [
                    Obx(
                          () => ListView.builder(
                        itemCount: controller.defaultTasbeehs.length + controller.userTasbeehs.length, // use default and user list.
                        itemBuilder: (context, index) {
                          final allTasbeehs = [
                            ...controller.defaultTasbeehs,
                            ...controller.userTasbeehs,
                          ];

                          return InkWell(
                            onTap: () {
                              Get.back(result: allTasbeehs[index]);
                            },
                            child: Container(
                              margin: EdgeInsets.only(
                                  bottom: 5, top: 5.h, left: 5.w, right: 5.w),
                              padding: EdgeInsets.all(10.h),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15.r),
                                color: (index % 2 == 1)
                                    ? AppColors.primary.withOpacity(0.29)
                                    : AppColors.primary.withOpacity(0.1),
                              ),
                              child: ListTile(
                                title: CustomText(
                                  title: allTasbeehs[index],
                                  fontSize: 15.sp,
                                  capitalize: true,
                                  textColor: textColor,
                                  fontWeight: FontWeight.w500,
                                  textOverflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  textAlign: TextAlign.end,
                                ),
                                trailing: controller.userTasbeehs
                                    .contains(allTasbeehs[index])
                                    ? IconButton(
                                  icon: Icon(Icons.delete, color: iconColor),
                                  onPressed: () {
                                    controller
                                        .removeUserTasbeeh(allTasbeehs[index]);
                                  },
                                )
                                    : null,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Obx(
                          () => controller.completedTasbeehs.isNotEmpty
                          ? ListView.builder(
                        itemCount: controller.completedTasbeehs.length,
                        itemBuilder: (context, index) {
                          final tasbeeh =
                          controller.completedTasbeehs[index];
                          return Container(
                            margin: EdgeInsets.only(
                                bottom: 5,
                                top: 5.h,
                                left: 5.w,
                                right: 5.w),
                            padding: EdgeInsets.all(10.h),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.r),
                              color: (index % 2 == 1)
                                  ? AppColors.primary.withOpacity(0.29)
                                  : AppColors.primary.withOpacity(0.1),
                            ),
                            child: ListTile(
                              title: CustomText(
                                title: tasbeeh['name'],
                                fontSize: 15.sp,
                                capitalize: true,
                                textColor: textColor,
                                fontWeight: FontWeight.w500,
                                textOverflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                textAlign: TextAlign.start,
                              ),
                              subtitle: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  CustomText(
                                    title:
                                    '${tasbeeh['currentCount']} / ${tasbeeh['targetCount']}',
                                    fontSize: 12.sp,
                                    textColor: AppColors.primary,
                                    textAlign: TextAlign.start,
                                    textOverflow:
                                    TextOverflow.ellipsis,
                                    fontWeight: FontWeight.w500,
                                    maxLines: 1,
                                  ),
                                  CustomText(
                                    title: DateFormat('dd MMM, hh:mm a')
                                        .format(DateTime.parse(
                                        tasbeeh['timestamp'])),
                                    fontSize: 10.sp,
                                    textColor: AppColors.grey,
                                    textAlign: TextAlign.start,
                                    textOverflow:TextOverflow.ellipsis,
                                    fontWeight: FontWeight.w400,
                                    maxLines: 1,
                                  ),
                                ],
                              ),
                              trailing: IconButton(
                                icon: Icon(Icons.delete, color: iconColor),
                                onPressed: () {
                                  controller
                                      .removeCompletedTasbeeh(index);
                                },
                              ),
                            ),
                          );
                        },
                      )
                          : Center(
                        child: CustomText(
                          title: "No Dhikr completed yet",
                          fontSize: 16.sp,
                          textColor: textColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}








