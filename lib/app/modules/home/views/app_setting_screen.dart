
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:noor_e_quran/app/config/app_colors.dart';
import 'package:noor_e_quran/app/config/app_sizedbox.dart';
import 'package:noor_e_quran/app/controllers/user_location_premission_controller.dart';
import '../../../controllers/app_theme_switch_controller.dart';
import '../../../widgets/custom_text.dart';
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
    //  destinationScreen: ExportPrayerTime(),
      destinationScreen: Placeholder(),
    ),
    MiscItem(
      title: "FAQ",
      icon: Icons.quiz_outlined,
       // destinationScreen: FAQScreen(),
      destinationScreen: Placeholder(),
    ),
    MiscItem(
      title: "Feedback",
      icon: Icons.feedback_outlined,
      // destinationScreen: UserFeedbackScreen(),
      destinationScreen: Placeholder(),
    ),
    MiscItem(
      title: "Privacy Policy",
      icon: Icons.privacy_tip_outlined,
      // destinationScreen: PrivacyPolicyScreen(),
      destinationScreen: Placeholder(),
    ),
    MiscItem(
      title: "Delete Data",
      icon: Icons.delete_outline,
      // destinationScreen: DeleteDataScreen(),
      destinationScreen: Placeholder(),
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

      return Scaffold(
        backgroundColor: isDarkMode ? AppColors.black : AppColors.white,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: AppBar(
            elevation: 0,
            backgroundColor: isDarkMode ? AppColors.black : AppColors.white,
            surfaceTintColor: AppColors.transparent,
            foregroundColor: isDarkMode ? AppColors.white : AppColors.black,
            title: CustomText(
              firstText: "Personalized",
              secondText: " Settings",
              firstTextColor: isDarkMode ? AppColors.white : AppColors.black,
              secondTextColor: AppColors.primary,
              fontSize: 18.sp,
            ),
            centerTitle: false,
            leading: IconButton(
              icon: Icon(Icons.west, color:  isDarkMode ? AppColors.white : AppColors.black,),
              onPressed: () {
                Get.back();
              },
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
                  textColor: AppColors.primary,
                  fontFamily: 'grenda',
                  maxLines: 1,
                  textOverflow: TextOverflow.ellipsis,
                ),
                AppSizedBox.space10h,
                Container(
                  padding: EdgeInsets.symmetric(vertical: 5.h),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(15.r),
                  ),
                  child: ListTile(
                    leading: Icon(
                      Icons.location_on_outlined,
                      color: isDarkMode ? AppColors.white : AppColors.black,
                      size: 16.h,
                    ),
                    title: CustomText(
                      title: "Enable Location",
                      fontSize: 14.sp,
                      textAlign: TextAlign.start,
                      textColor: isDarkMode ? AppColors.white : AppColors.black,
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
                  textColor: AppColors.primary,
                  fontFamily: 'grenda',
                  maxLines: 1,
                  textOverflow: TextOverflow.ellipsis,
                ),
                AppSizedBox.space10h,
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(15.r),
                  ),
                  child: Column(
                    children: [
                      AppSizedBox.space5h,
                      _buildThemeOptionRow(
                        title: "Light Mode",
                        value: false,
                        groupValue: isDarkMode,
                        themeController: themeController,
                        textColor: isDarkMode ? AppColors.white : AppColors.black,
                        icon: Icons.light_mode_outlined,
                        iconSize: 16.h,
                        fontSize: 14.sp,
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
                        textColor: isDarkMode ? AppColors.white : AppColors.black,
                        icon: Icons.dark_mode_outlined,
                        iconSize: 16.h,
                        fontSize: 14.sp,
                      ),
                      AppSizedBox.space5h,
                    ],
                  ),
                ),
                AppSizedBox.space15h,
                CustomText(
                  title: "Misc",
                  fontSize: 18.sp,
                  textColor: AppColors.primary,
                  fontFamily: 'grenda',
                  maxLines: 1,
                  textOverflow: TextOverflow.ellipsis,
                ),
                AppSizedBox.space10h,
                Container(
                  padding: EdgeInsets.symmetric(vertical: 5.h),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
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
                                size: 16.h,
                                color: isDarkMode ? AppColors.white : AppColors.black,
                              ),
                              title: CustomText(
                                title: item.title,
                                fontSize: 14.sp,
                                textAlign: TextAlign.start,
                                textColor: isDarkMode ? AppColors.white : AppColors.black,
                              ),
                              trailing: Icon(
                                Icons.arrow_forward_ios,
                                size: 10.h,
                                color: isDarkMode ? AppColors.white : AppColors.black,
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
                AppSizedBox.space15h,
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
