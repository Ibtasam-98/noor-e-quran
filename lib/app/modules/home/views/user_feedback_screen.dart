import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:noor_e_quran/app/config/app_sizedbox.dart';
import '../../../config/app_colors.dart';
import '../../../controllers/app_theme_switch_controller.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_text.dart';
import '../../../widgets/custom_textfiield.dart';
import '../controllers/user_feedback_controller.dart';

class UserFeedbackScreen extends StatelessWidget {
  final UserFeedbackController userFeedbackController =
  Get.put(UserFeedbackController());

  UserFeedbackScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AppThemeSwitchController themeController = Get.find();
    final isDarkMode = themeController.isDarkMode.value;
    return Scaffold(
      backgroundColor:
      themeController.isDarkMode.value ? AppColors.black : AppColors.white,
      appBar: AppBar(
        backgroundColor: isDarkMode ? AppColors.black : AppColors.white,
        surfaceTintColor: AppColors.transparent,
        foregroundColor: AppColors.transparent,
        title: CustomText(
          firstText: "User",
          secondText: " Feedback",
          fontSize: 18.sp,
          firstTextColor: isDarkMode ? AppColors.white : AppColors.black,
          secondTextColor: AppColors.primary,
        ),
        centerTitle: false,
        leading: InkWell(
          splashColor: AppColors.transparent,
          highlightColor: AppColors.transparent,
          onTap: () {
            Get.back();
          },
          child: Icon(
            Icons.west,
            color: isDarkMode ? AppColors.white : AppColors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Form(
            key: userFeedbackController.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                CustomTextField(
                  controller: userFeedbackController.usernameController,
                  hintText: 'Username',
                  validator: userFeedbackController.validateUsername, // Use the new validation method
                ),
                AppSizedBox.space10h,
                CustomTextField(
                  controller: userFeedbackController.emailController,
                  hintText: 'Email',
                  validator: userFeedbackController.validateEmail, // Use the new validation method
                ),
                AppSizedBox.space10h,
                CustomTextField(
                  controller: userFeedbackController.suggestionController,
                  hintText: 'Suggestion',
                  maxLines: 5,
                  validator: userFeedbackController.validateSuggestion, // Use the new validation method
                ),
                AppSizedBox.space25h,
                CustomButton(
                  haveBgColor: true,
                  btnTitle: "Send Feedback",
                  btnTitleColor: AppColors.white,
                  bgColor: AppColors.primary,
                  borderRadius: 45.r,
                  onTap: userFeedbackController.sendFeedback,
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}