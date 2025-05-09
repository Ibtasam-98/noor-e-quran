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
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: _buildGlassText("Spiritual"),
                    ),

                    AppSizedBox.space15h,
                    _buildGlassText("Faith", alignment: Alignment.centerLeft),
                    AppSizedBox.space25h,
                    _buildGlassText("Imaan", alignment: Alignment.center),
                    AppSizedBox.space30h,
                    _buildGlassText("Deen", alignment: Alignment.centerLeft),
                  ],

                ),
                AppSizedBox.space10h,
                Column(
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
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGlassText(String text, {Alignment alignment = Alignment.centerRight}) {
    return Align(
      alignment: alignment,
      child: CustomText(
        title: text,
        fontSize: 14.sp,
        isGlass: true,
        maxLines: 1,
        textColor: AppColors.white,
        glassPadding: EdgeInsets.all(10.h),
      ),
    );
  }
}