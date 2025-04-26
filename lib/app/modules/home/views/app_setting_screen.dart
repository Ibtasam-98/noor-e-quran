import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:noor_e_quran/app/config/app_colors.dart';
import 'package:noor_e_quran/app/config/app_sizedbox.dart';
import 'package:noor_e_quran/app/controllers/user_location_premission_controller.dart';
import 'package:noor_e_quran/app/modules/home/views/privacy_policy_screen.dart';
import 'package:noor_e_quran/app/modules/home/views/user_feedback_screen.dart';
import '../../../controllers/app_theme_switch_controller.dart';
import '../../../widgets/custom_text.dart';
import 'export_data_screen.dart';
import 'frequently_ask_question_screen.dart';

class MiscItem {
  final String title;
  final IconData icon;
  final Widget destinationScreen;

  const MiscItem({
    required this.title,
    required this.icon,
    required this.destinationScreen,
  });
}

class AppSettingsScreen extends StatelessWidget {
  const AppSettingsScreen({super.key});

  static final List<MiscItem> _miscItems = [
     MiscItem(
      title: "Export Prayer Time",
      icon: Icons.picture_as_pdf_outlined,
      destinationScreen: ExportPrayerTime(),

    ),
     MiscItem(
      title: "FAQ",
      icon: Icons.quiz_outlined,
      destinationScreen: FAQScreen(),
    ),
     MiscItem(
      title: "Feedback",
      icon: Icons.feedback_outlined,
      destinationScreen: UserFeedbackScreen(),
    ),
     MiscItem(
      title: "Privacy Policy",
      icon: Icons.privacy_tip_outlined,
      destinationScreen: PrivacyPolicyScreen(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final AppThemeSwitchController themeController = Get.find<
        AppThemeSwitchController>();
    final UserPermissionController locationController = Get.find<
        UserPermissionController>();

    return Obx(() {
      final bool isDarkMode = themeController.isDarkMode.value;
      final Color dynamicTextColor = isDarkMode ? AppColors.white : AppColors
          .black;
      final Color dynamicIconColor = isDarkMode ? AppColors.white : AppColors
          .black;
      final Color dynamicBackgroundColor = isDarkMode
          ? AppColors.black
          : AppColors.white;
      final Color dynamicSectionHeaderColor = isDarkMode
          ? AppColors.white
          : AppColors.primary;
      final Color dynamicContainerColor = AppColors.primary.withOpacity(0.1);
      final double listItemIconSize = 16.h;
      final double listItemFontSize = 14.sp;

      return Scaffold(
        backgroundColor: dynamicBackgroundColor,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: AppBar(
            elevation: 0,
            backgroundColor: dynamicBackgroundColor,
            surfaceTintColor: AppColors.transparent,
            foregroundColor: dynamicIconColor,
            title: CustomText(
              firstText: "Personalized",
              secondText: " Settings",
              firstTextColor: dynamicTextColor,
              secondTextColor: AppColors.primary,
              fontSize: 18.sp,
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
                color: dynamicIconColor,
              ),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  title: "Location",
                  fontSize: 18.sp,
                  textColor: dynamicSectionHeaderColor,
                  fontFamily: 'grenda',
                  maxLines: 1,
                  textOverflow: TextOverflow.ellipsis,
                ),
                AppSizedBox.space10h,
                Container(
                  padding: EdgeInsets.symmetric(vertical: 5.h),
                  decoration: BoxDecoration(
                    color: dynamicContainerColor,
                    borderRadius: BorderRadius.circular(15.r),
                  ),
                  child: ListTile(
                    leading: Icon(
                      Icons.location_on_outlined,
                      color: dynamicIconColor,
                      size: listItemIconSize,
                    ),
                    title: CustomText(
                      title: "Enable Location",
                      fontSize: listItemFontSize,
                      textAlign: TextAlign.start,
                      textColor: dynamicTextColor,
                    ),
                    trailing: Transform.scale(
                      scale: 0.8,
                      child: SwitchTheme(
                        data: SwitchThemeData(
                          trackOutlineColor: MaterialStateProperty.resolveWith<
                              Color?>(
                                (Set<MaterialState> states) {
                              if (states.contains(MaterialState.selected)) {
                                return AppColors.primary;
                              }
                              return AppColors.black;
                            },
                          ),
                        ),
                        child: Switch(
                          value: locationController.locationAccessed.value,
                          inactiveThumbColor: AppColors.primary,
                          activeColor: AppColors.primary,
                          inactiveTrackColor: AppColors.white,
                          onChanged: (newValue) async {
                            // Set the UI to reflect the change immediately
                            locationController.locationAccessed(newValue);
                            // If the switch is turned on, try to access location again
                            if (newValue) {
                              await locationController.accessLocation();
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                AppSizedBox.space15h,
                CustomText(
                  title: "Theme",
                  fontSize: 18.sp,
                  textColor: dynamicSectionHeaderColor,
                  fontFamily: 'grenda',
                  maxLines: 1,
                  textOverflow: TextOverflow.ellipsis,
                ),
                AppSizedBox.space10h,
                Container(
                  padding: EdgeInsets.all(5.w),
                  decoration: BoxDecoration(
                    color: dynamicContainerColor,
                    borderRadius: BorderRadius.circular(15.r),
                  ),
                  child: Column(
                    children: [
                      _buildThemeOptionRow(
                        title: "Light Mode",
                        value: false,
                        groupValue: isDarkMode,
                        themeController: themeController,
                        textColor: dynamicTextColor,
                        icon: Icons.light_mode_outlined,
                        iconSize: listItemIconSize,
                        fontSize: listItemFontSize,
                      ),
                      Divider(
                        color: AppColors.primary,
                        thickness: 0.1,
                      ),
                      _buildThemeOptionRow(
                        title: "Dark Mode",
                        value: true,
                        groupValue: isDarkMode,
                        themeController: themeController,
                        textColor: dynamicTextColor,
                        icon: Icons.dark_mode_outlined,
                        iconSize: listItemIconSize,
                        fontSize: listItemFontSize,
                      ),
                    ],
                  ),
                ),
                AppSizedBox.space15h,
                CustomText(
                  title: "Misc",
                  fontSize: 18.sp,
                  textColor: dynamicSectionHeaderColor,
                  fontFamily: 'grenda',
                  maxLines: 1,
                  textOverflow: TextOverflow.ellipsis,
                ),
                AppSizedBox.space10h,
                Container(
                  padding: EdgeInsets.symmetric(vertical: 5.h),
                  decoration: BoxDecoration(
                    color: dynamicContainerColor,
                    borderRadius: BorderRadius.circular(15.r),
                  ),
                  child: Column(
                    children: _miscItems.map((item) {
                      return Column(
                        children: [
                          InkWell(
                            onTap: () => Get.to(() => item.destinationScreen),
                            child: ListTile(
                              leading: Icon(
                                item.icon,
                                size: listItemIconSize,
                                color: dynamicIconColor,
                              ),
                              title: CustomText(
                                title: item.title,
                                fontSize: listItemFontSize,
                                textAlign: TextAlign.start,
                                textColor: dynamicTextColor,
                              ),
                              trailing: Icon(
                                Icons.arrow_forward_ios,
                                size: listItemIconSize - 4.h,
                                color: dynamicIconColor,
                              ),
                            ),
                          ),
                          if (item != _miscItems.last)
                            Divider(
                              color: AppColors.primary.withOpacity(0.2),
                              thickness: 0.5,
                            ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _buildThemeOptionRow({
    required String title,
    required bool value,
    required bool groupValue,
    required AppThemeSwitchController themeController,
    required Color textColor,
    required IconData icon,
    required double iconSize,
    required double fontSize,
  }) {
    return ListTile(
      leading: Icon(icon, color: textColor, size: iconSize),
      title: CustomText(
        title: title,
        textColor: textColor,
        fontSize: fontSize,
        textAlign: TextAlign.start,
        maxLines: 1,
        textOverflow: TextOverflow.ellipsis,
      ),
      trailing: Radio<bool>(
        value: value,
        activeColor: AppColors.primary,
        groupValue: groupValue,
        onChanged: (bool? newValue) {
          if (newValue != null && newValue != groupValue) {
            themeController.toggleTheme();
          }
        },
      ),
      onTap: () {
        if (value != groupValue) {
          themeController.toggleTheme();
        }
      }, // Make the whole row tappable to change theme
    );
  }
}