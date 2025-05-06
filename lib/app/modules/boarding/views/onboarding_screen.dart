
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:noor_e_quran/app/config/app_contants.dart';
import 'package:noor_e_quran/app/modules/boarding/views/user_permission_screen.dart';
import 'package:noor_e_quran/app/widgets/custom_button.dart';
import '../../../config/app_colors.dart';
import '../../../config/app_sizedbox.dart';
import '../../../widgets/custom_text.dart';
import '../controllers/onboarding_controller.dart';

class OnBoardingScreen extends StatelessWidget {
  final OnboardingScreenController onBoardingController = Get.put(OnboardingScreenController());

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            "assets/images/welcome_screen_wallpaper.jpg",
            fit: BoxFit.cover,
          ),
        ),
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.black,
                  AppColors.transparent,
                ],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            ),
          ),
        ),
        Scaffold(
          backgroundColor: AppColors.transparent,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 15.w, right: 15.w),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: CustomText(
                        title: "Spiritual",
                        fontSize: 14.sp,
                        isGlass: true,
                        maxLines: 1,
                        textColor: AppColors.white,
                        glassPadding: EdgeInsets.all(10.h),
                      ),
                    ),
                    AppSizedBox.space15h,
                    Align(
                      alignment: Alignment.centerLeft,
                      child: CustomText(
                        title: "Faith",
                        fontSize: 14.sp,
                        isGlass: true,
                        maxLines: 1,
                        glassPadding: EdgeInsets.all(10.h),
                        textColor: AppColors.white,
                      ),
                    ),
                    AppSizedBox.space25h,
                    Align(
                      alignment: Alignment.center,
                      child: CustomText(
                        title: "Imaan",
                        fontSize: 14.sp,
                        isGlass: true,
                        maxLines: 1,
                        textColor: AppColors.white,
                        glassPadding: EdgeInsets.all(10.h),
                      ),
                    ),
                    AppSizedBox.space30h,
                    Align(
                      alignment: Alignment.centerLeft,
                      child: CustomText(
                        title: "Deen",
                        fontSize: 14.sp,
                        maxLines: 1,
                        textColor: AppColors.white,
                        isGlass: true,
                        glassPadding: EdgeInsets.all(10.h),
                      ),
                    ),
                  ],
                ),
              ),
              AppSizedBox.space10h,
              Padding(
                padding: EdgeInsets.only(left: 10.w, right: 10.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      fontSize: 30.sp,
                      title: AppConstants.onboardingTitle,
                      textColor: AppColors.white,
                      textAlign: TextAlign.start,
                      fontFamily: 'grenda',
                      maxLines: 2,
                    ),
                    AppSizedBox.space5h,
                    CustomText(
                      fontSize: 16.sp,
                      title: AppConstants.onboardingSubtitle,
                      textAlign: TextAlign.start,
                      textColor: AppColors.white,
                      maxLines: 5,
                    ),
                    AppSizedBox.space25h,

                    Obx(() {
                      return AnimatedOpacity(
                        opacity: onBoardingController.showGuestButton.value ? 1.0 : 0.0,
                        duration: const Duration(seconds: 1),
                        child: SlideTransition(
                          position: onBoardingController.slideAnimation,
                          child: InkWell(
                            hoverColor: AppColors.transparent,
                            highlightColor: AppColors.transparent,
                            splashColor: AppColors.transparent,
                            onTap: () async {
                              Get.to(() => UserPermissionScreen());
                            },
                            child: CustomButton(
                              haveBgColor: true,
                              btnTitle: "Let's Get Started",
                              btnTitleColor: AppColors.white,
                              bgColor: AppColors.transparent,
                              btnBorderColor: AppColors.white,
                              borderRadius: 50.r,
                              height: 45.h,
                            ),
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
