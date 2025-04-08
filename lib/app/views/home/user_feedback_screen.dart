import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:noor_e_quran/app/config/app_sizedbox.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../config/app_colors.dart';
import '../../controllers/app_theme_switch_controller.dart';
import '../../controllers/user_feedback_controller.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text.dart';

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
        surfaceTintColor: AppColors.transparent,
        foregroundColor: AppColors.transparent,
        centerTitle: false,
        title: CustomText(
          firstText: "User",
          secondText: " Feedback",
          firstTextColor: isDarkMode ? AppColors.white : AppColors.black,
          secondTextColor: AppColors.primary,
          fontSize: 18.sp,
        ),
        backgroundColor: isDarkMode ? AppColors.black : AppColors.white,
        leading: InkWell(
          onTap: () {
            userFeedbackController.usernameController.clear();
            userFeedbackController.emailController.clear();
            userFeedbackController.suggestionController.clear();
            Get.back();
          },
          child: Icon(Icons.west,
              color: isDarkMode ? AppColors.white : AppColors.black),
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
                TextFormField(
                  controller: userFeedbackController.usernameController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.r),
                      borderSide: BorderSide.none,
                    ),
                    hintText: 'Username',
                    fillColor: isDarkMode
                        ? AppColors.grey.withOpacity(0.1)
                        : AppColors.grey.withOpacity(0.2),
                    filled: true,
                    hintStyle: GoogleFonts.quicksand(
                      color: isDarkMode ? AppColors.white : AppColors.black,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your username';
                    }
                    return null;
                  },
                ),
                AppSizedBox.space10h,
                TextFormField(
                  controller: userFeedbackController.emailController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.r),
                      borderSide: BorderSide.none,
                    ),
                    hintText: 'Email',
                    fillColor: isDarkMode
                        ? AppColors.grey.withOpacity(0.1)
                        : AppColors.grey.withOpacity(0.2),
                    filled: true,
                    hintStyle: GoogleFonts.quicksand(
                      color: isDarkMode ? AppColors.white : AppColors.black,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!RegExp(
                        r"^[a-zA-Z0-9.+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]+$")
                        .hasMatch(value)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                AppSizedBox.space10h,
                TextFormField(
                  controller: userFeedbackController.suggestionController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.r),
                      borderSide: BorderSide.none,
                    ),
                    hintText: 'Suggestion',
                    fillColor: isDarkMode
                        ? AppColors.grey.withOpacity(0.1)
                        : AppColors.grey.withOpacity(0.2),
                    filled: true,
                    hintStyle: GoogleFonts.quicksand(
                      color: isDarkMode ? AppColors.white : AppColors.black,
                    ),
                  ),
                  maxLines: 5,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your suggestion';
                    }
                    return null;
                  },
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}