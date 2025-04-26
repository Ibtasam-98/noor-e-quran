import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:noor_e_quran/app/config/app_colors.dart';
import 'package:noor_e_quran/app/config/app_sizedbox.dart';
import 'package:noor_e_quran/app/controllers/app_theme_switch_controller.dart';
import 'package:noor_e_quran/app/widgets/custom_card.dart';
import 'package:noor_e_quran/app/widgets/custom_snackbar.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import '../../../widgets/custom_text.dart';
import '../controllers/tasbeeh_controller.dart';


class TasbeehCounterScreen extends StatelessWidget {
  final TasbeehController controller = Get.put(TasbeehController());

  @override
  Widget build(BuildContext context) {
    final AppThemeSwitchController themeSwitchController =
    Get.put(AppThemeSwitchController());
    bool isDarkMode = themeSwitchController.isDarkMode.value;
    final textColor = isDarkMode ? AppColors.white : AppColors.black;

    return WillPopScope(
      onWillPop: () async {
        controller.saveTasbeehState();
        return true;
      },
      child: Scaffold(
        backgroundColor: isDarkMode ? AppColors.black : AppColors.white,
        appBar: AppBar(
          surfaceTintColor: AppColors.transparent,
          foregroundColor: AppColors.transparent,
          centerTitle: false,
          title: CustomText(
            firstText: "Dhikr",
            secondText: " Counter",
            firstTextColor: isDarkMode ? AppColors.white : AppColors.black,
            secondTextColor: AppColors.primary,
            fontSize: 18.sp,
          ),
          leading: IconButton(
            icon: Icon(
              Icons.west,
              color: themeSwitchController.isDarkMode.value
                  ? AppColors.white
                  : AppColors.black,
            ),
            onPressed: () {
              controller.saveTasbeehState();
              Get.back();
            },
          ),
          backgroundColor: isDarkMode ? AppColors.black : AppColors.white,
        ),
        body: InkWell(
          splashColor: AppColors.transparent,
          highlightColor: AppColors.transparent,
          onTap: controller.incrementCount,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: 10.w, right: 10.w),
                  child: Column(
                    children: [
                      CustomCard(
                        title: "Recently Accessed Surahs",
                        subtitle: "Surahs You've Recently Opened",
                        imageUrl: "assets/images/tasbeeh.png",
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
                      InkWell(
                        splashColor: AppColors.transparent,
                        highlightColor: AppColors.transparent,
                        onTap: () {
                          if (controller.selectedTasbeeh?.value != null &&
                              controller.targetCount.value > 0 &&
                              !controller.isCompleted.value) {
                            CustomSnackbar.show(
                              backgroundColor: AppColors.red,
                              title: "Warning",
                              subtitle: "Please complete the current dhikr first.",
                              icon: Icon(Icons.warning),
                            );
                          } else {
                            controller.showSelectTasbeehScreen();
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.all(10.h),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.r),
                            color: AppColors.primary.withOpacity(0.1),
                          ),
                          child: ListTile(
                            leading: CustomText(
                              title: "Select your Dhikr",
                              fontSize: 15.sp,
                              textColor: textColor,
                              fontWeight: FontWeight.w500,
                              textOverflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              textAlign: TextAlign.start,
                            ),
                            trailing: Icon(
                              Icons.arrow_forward_ios,
                              size: 12.h,
                              color: isDarkMode ? AppColors.white : AppColors.black,
                            ),
                          ),
                        ),
                      ),
                      AppSizedBox.space10h,
                      Obx(() => controller.selectedTasbeeh?.value != null &&
                          controller.targetCount.value > 0 &&
                          !controller.isCompleted.value
                          ? Expanded(
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            AnimatedOpacity(
                              opacity: controller.firstImageOpacity.value,
                              duration: Duration(milliseconds: 300),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15.r),
                                child: Image.asset(
                                  "assets/images/quran_bg_audio.jpg",
                                  width: double.infinity,
                                  height: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            if (controller.secondImageOpacity.value > 0) // Conditionally show the second image
                              AnimatedOpacity(
                                opacity: controller.secondImageOpacity.value,
                                duration: Duration(milliseconds: 300),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15.r),
                                  child: Image.asset(
                                    "assets/images/kabah_clock.jpg",
                                    width: double.infinity,
                                    height: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CustomText(
                                  title: controller.selectedTasbeeh?.value!,
                                  fontSize: 30.sp,
                                  textColor: Colors.white,
                                  fontWeight: FontWeight.w400,
                                  capitalize: true,
                                ),
                                AppSizedBox.space10h,
                                CircularPercentIndicator(
                                  radius: 80.0,
                                  lineWidth: 8.0,
                                  percent: controller.currentCount.value /
                                      controller.targetCount.value,
                                  center: CustomText(
                                    title:
                                    '${controller.currentCount.value} / ${controller.targetCount.value}',
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
                                  backgroundColor:
                                  Colors.grey.withOpacity(0.3),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                          : SizedBox()),
                    ],
                  ),
                ),
              ),
              SizedBox(),
              SizedBox(),
            ],
          ),
        ),
        floatingActionButton: Obx(() => !controller.isCompleted.value
            ? SizedBox()
            : FloatingActionButton(
          backgroundColor: AppColors.primary,
          onPressed: controller.showAddTasbeehBottomSheet,
          child: Icon(Icons.add, color: AppColors.white),
        )),
      ),
    );
  }
}



