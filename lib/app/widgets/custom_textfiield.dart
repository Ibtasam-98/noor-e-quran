import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../config/app_colors.dart';
import '../controllers/app_theme_switch_controller.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String? Function(String?)? validator;
  final int? maxLines;

  const CustomTextField({
    Key? key,
    required this.controller,
    required this.hintText,
    this.validator,
    this.maxLines,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AppThemeSwitchController themeController = Get.find();
    final isDarkMode = themeController.isDarkMode.value;
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide.none,
        ),
        hintText: hintText,
        fillColor: isDarkMode
            ? AppColors.grey.withOpacity(0.1)
            : AppColors.grey.withOpacity(0.2),
        filled: true,
        hintStyle: GoogleFonts.quicksand(
          color: isDarkMode ? AppColors.white : AppColors.black,
        ),
      ),
      style: GoogleFonts.quicksand( // Added this style for the input text
        color: isDarkMode ? AppColors.white : AppColors.black,
      ),
      maxLines: maxLines,
      validator: validator,
    );
  }
}