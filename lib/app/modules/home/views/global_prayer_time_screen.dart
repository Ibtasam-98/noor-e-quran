import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:noor_e_quran/app/widgets/custom_button.dart';
import 'package:shimmer/shimmer.dart';

import '../../../config/app_colors.dart';
import '../../../config/app_sizedbox.dart';
import '../../../controllers/app_theme_switch_controller.dart';
import '../../../controllers/user_location_premission_controller.dart';
import '../../../widgets/custom_shimmer.dart';
import '../../../widgets/custom_text.dart';
import '../controllers/global_prayer_time_screen_controller.dart';
import '../controllers/view_all_prayer_screen_controller.dart';

class GlobalPrayerTimeScreen extends StatelessWidget {
  final userPermissionController = Get.find<UserPermissionController>();
  final AppThemeSwitchController themeController = Get.find<AppThemeSwitchController>();
  final GlobalPrayerTimeScreenController controller = Get.put(GlobalPrayerTimeScreenController());
  final NamazController namazController = Get.find<NamazController>();

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = themeController.isDarkMode.value;

    return Scaffold(
      backgroundColor: isDarkMode ? AppColors.black : AppColors.white,
      appBar: AppBar(
        centerTitle: false,
        title: CustomText(
          firstText: "Global",
          secondText: " Prayer",
          fontSize: 18.sp,
          firstTextColor: isDarkMode ? AppColors.white : AppColors.black,
          secondTextColor: AppColors.primary,
          textColor: isDarkMode ? AppColors.white : AppColors.black,
        ),
        leading: IconButton(
          icon: Icon(Icons.west, color: isDarkMode ? AppColors.white : AppColors.black),
          onPressed: () => Get.back(),
        ),
        backgroundColor: isDarkMode ? AppColors.black : AppColors.white,
        elevation: 0,
        surfaceTintColor: AppColors.transparent,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        child: Obx(() {
          if (controller.isFetchingCountries.value) {
            return _buildShimmerLoader(isDarkMode);
          }
          return Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Country Dropdown
                _buildCountryDropdown(isDarkMode),
                AppSizedBox.space10h,

                // City Dropdown (only visible when country is selected)
                if (controller.selectedCountry.isNotEmpty)
                  _buildCityDropdown(isDarkMode),
                if (controller.selectedCountry.isNotEmpty)
                  AppSizedBox.space10h,

                // Calculation Method Dropdown (only visible when city is selected)
                if (controller.selectedCity.isNotEmpty)
                  _buildMethodDropdown(isDarkMode),
                if (controller.selectedCity.isNotEmpty)
                  AppSizedBox.space10h,

                // Get Prayer Times Button
                // Get Prayer Times Button
                CustomButton(
                  onTap: () {
                    if (controller.selectedCountry.isEmpty) {
                      Get.snackbar(
                        'Error',
                        'Please select a country',
                        snackPosition: SnackPosition.BOTTOM,
                      );
                    } else if (controller.selectedCity.isEmpty) {
                      Get.snackbar(
                        'Error',
                        'Please select a city',
                        snackPosition: SnackPosition.BOTTOM,
                      );
                    } else {
                      controller.fetchPrayerTimes(
                        controller.selectedCity.value,
                        controller.selectedCountry.value,
                      );
                    }
                  },
                  btnTitle: 'Get Prayer Times',
                  haveBgColor: true,
                  btnTitleColor: AppColors.white,
                  bgColor: AppColors.primary,
                  borderRadius: 45.r,
                  height: 45.h,
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primary,
                      AppColors.secondry.withOpacity(0.9),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                AppSizedBox.space20h,

                // Prayer Times List
                _buildPrayerTimesList(isDarkMode),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildCountryDropdown(bool isDarkMode) {
    return DropdownButtonFormField<String>(
      value: controller.selectedCountry.value.isEmpty ? null : controller.selectedCountry.value,
      onChanged: controller.onCountryChanged,
      menuMaxHeight: 350.h,
      alignment: Alignment.center,
      dropdownColor: AppColors.white,
      itemHeight: 50.h,
      items: controller.countries.map((String country) {
        return DropdownMenuItem<String>(
          value: country,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: CustomText(
              title: country,
              fontSize: 16.sp,
              textColor:AppColors.black,
              textAlign: TextAlign.start,
            ),
          ),
        );
      }).toList(),
      style: TextStyle(
        color: isDarkMode ? AppColors.white : Colors.black,
        fontSize: 16.sp,
      ),
      decoration: InputDecoration(
        hintText: 'Select Country',
        hintTextDirection: TextDirection.ltr,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: isDarkMode ? AppColors.white : AppColors.grey.withOpacity(0.1),
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        hintStyle: GoogleFonts.quicksand(
          color: AppColors.white,
          fontSize: 16.sp,
        ),
      ),
      validator: (value) => value == null ? 'Please select a country' : null,
      isExpanded: true,
    );
  }

  Widget _buildCityDropdown(bool isDarkMode) {
    if (controller.isFetchingCities.value) {
      return Shimmer.fromColors(
        baseColor: isDarkMode ? AppColors.black.withOpacity(0.02) : AppColors.black.withOpacity(0.2),
        highlightColor: isDarkMode ? AppColors.lightGrey.withOpacity(0.1) : AppColors.grey.withOpacity(0.2),
        child: Container(
          height: 60.h,
          decoration: BoxDecoration(
            color: isDarkMode ? AppColors.grey : AppColors.white,
            borderRadius: BorderRadius.circular(8.r),
          ),
        ),
      );
    }

    return DropdownButtonFormField<String>(
      value: controller.selectedCity.value.isEmpty ? null : controller.selectedCity.value,
      onChanged: controller.onCityChanged,
      menuMaxHeight: 350.h,
      itemHeight: 50.h,
      dropdownColor: AppColors.white,
      items: controller.cities.map((String city) {
        return DropdownMenuItem<String>(
          value: city,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: CustomText(
              title: city,
              fontSize: 16.sp,
              textColor: AppColors.black,
            ),
          ),
        );
      }).toList(),
      style: TextStyle(
        color: AppColors.black,
        fontSize: 16.sp,
      ),
      decoration: InputDecoration(
        hintText: 'Select City',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: isDarkMode ? AppColors.white : AppColors.grey.withOpacity(0.1),
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        hintStyle: TextStyle(
          color: AppColors.white,
          fontSize: 16.sp,
        ),
        enabled: controller.cities.isNotEmpty,
      ),
      validator: (value) => value == null ? 'Please select a city' : null,
      isExpanded: true,
    );
  }

  Widget _buildMethodDropdown(bool isDarkMode) {
    return DropdownButtonFormField<int>(
      value: namazController.selectedCalculationMethod.value,
      onChanged: namazController.onCalculationMethodChanged,
      menuMaxHeight: 350.h,
      itemHeight: 50.h,
      dropdownColor: AppColors.white,
      items: namazController.calculationMethods.map((method) {
        return DropdownMenuItem<int>(
          value: method['id'],
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: CustomText(
              title: method['name'],
              fontSize: 16.sp,
              textColor: AppColors.black,
              textAlign: TextAlign.start,
            ),
          ),
        );
      }).toList(),
      style: TextStyle(
        color: AppColors.black,
        fontSize: 16.sp,
      ),
      decoration: InputDecoration(
        hintText: 'Select Calculation Method (Optional)',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: isDarkMode ? AppColors.white : AppColors.grey.withOpacity(0.1),
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        hintStyle: TextStyle(
          color: AppColors.black,
          fontSize: 16.sp,
        ),
      ),
      isExpanded: true,
    );
  }

  Widget _buildPrayerTimesList(bool isDarkMode) {
    if (controller.isFetchingPrayerTimes.value) {
      return Center(child: CircularProgressIndicator(color: AppColors.primary,));
    } else if (controller.prayerTimes.isNotEmpty) {
      return Expanded(
        child: ListView.builder(
          itemCount: controller.prayerTimes.length,
          itemBuilder: (context, index) {
            final prayerName = controller.prayerTimes.keys.toList()[index];
            final prayerTime = controller.prayerTimes.values.toList()[index];
            final iconName = prayerName.toLowerCase();

            return Container(
              padding: EdgeInsets.all(10.h),
              margin: EdgeInsets.only(top: 5.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.r),
                color: (index % 2 == 1)
                    ? AppColors.primary.withOpacity(0.29)
                    : AppColors.primary.withOpacity(0.1),
                boxShadow: [
                  BoxShadow(
                    color: isDarkMode ? AppColors.black.withOpacity(0.2) : AppColors.grey.withOpacity(0.1),
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: ListTile(
                title: Row(
                  children: [
                    SvgPicture.asset(
                      "assets/images/$iconName.svg",
                      width: 14.w,
                      height: 14.h,
                      color: isDarkMode ? AppColors.white : AppColors.black,
                    ),
                    AppSizedBox.space15w,
                    CustomText(
                      title: prayerName,
                      textColor: isDarkMode ? AppColors.white : AppColors.black,
                      fontSize: 14.sp,
                      textAlign: TextAlign.start,
                    ),
                  ],
                ),
                trailing: CustomText(
                  title: prayerTime,
                  fontSize: 14.sp,
                  textColor: isDarkMode ? AppColors.white : AppColors.black,
                  textAlign: TextAlign.end,
                ),
              ),
            );
          },
        ),
      );
    } else {
      return Center(
        child: CustomText(
          title: 'Select a country and city\nto see prayer times.',
          textColor: isDarkMode ? AppColors.white : AppColors.black,
          fontSize: 16.sp,
          textAlign: TextAlign.center,
        ),
      );
    }
  }

  Widget _buildShimmerLoader(bool isDarkMode) {
    return Shimmer.fromColors(
      baseColor: isDarkMode ? AppColors.black.withOpacity(0.02) : AppColors.black.withOpacity(0.2),
      highlightColor: isDarkMode ? AppColors.lightGrey.withOpacity(0.1) : AppColors.grey.withOpacity(0.2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            height: 60.h,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          AppSizedBox.space10h,
          Container(
            width: double.infinity,
            height: 60.h,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          AppSizedBox.space10h,
          Container(
            width: double.infinity,
            height: 60.h,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          AppSizedBox.space10h,
          Container(
            width: double.infinity,
            height: 45.h,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(45),
            ),
          ),
        ],
      ),
    );
  }
}