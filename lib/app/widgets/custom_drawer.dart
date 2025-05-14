
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icons.dart';
import 'package:noor_e_quran/app/config/app_sizedbox.dart';
import '../config/app_colors.dart';
import '../modules/settings/views/app_setting_screen.dart';
import 'custom_text.dart';

class CustomDrawer extends StatelessWidget {
  final bool isDarkMode;
  CustomDrawer({super.key, required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    final iconColor = isDarkMode ? AppColors.white : AppColors.black;
    final textColor = isDarkMode ? AppColors.white : AppColors.black;
    String username = "Hey Guest 👋";
    String welcomeMsg = "Welcome";

    return SafeArea(
      child: Container(
        child: ListTileTheme(
          textColor: Colors.white,
          iconColor: Colors.white,
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    AppSizedBox.space25h,
                    ListTile(
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            textColor: isDarkMode ? AppColors.primary : AppColors.black,
                            fontSize: 20.sp,
                            title: username,
                            maxLines: 1,
                            textOverflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.start,
                            fontFamily: 'grenda',
                          ),
                          CustomText(
                            textColor: textColor,
                            fontSize: 12.sp,
                            title: welcomeMsg,
                            maxLines: 1,
                            textOverflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.start,
                            textStyle: GoogleFonts.quicksand(),
                          ),
                        ],
                      ),
                    ),
                    AppSizedBox.space15h,
                    ListTile(
                      splashColor: AppColors.transparent,
                      hoverColor: AppColors.transparent,
                      onTap: () {},
                      leading: Icon(LineIcons.home, size: 16.h, color: iconColor),
                      title: CustomText(
                        textColor: textColor,
                        fontSize: 14.sp,
                        title: "Home",
                        maxLines: 2,
                        textOverflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.start,
                        textStyle: GoogleFonts.quicksand(color: textColor),
                      ),
                      trailing: Icon(Icons.arrow_forward_ios_outlined, size: 10.h, color: iconColor),
                    ),
                    // ListTile(
                    //   splashColor: AppColors.transparent,
                    //   hoverColor: AppColors.transparent,
                    //   onTap: () {
                    //       Get.to(SavedHadithScreen());
                    //   },
                    //   leading: Icon(LineIcons.bookmark, size: 16.h, color: iconColor),
                    //   title: CustomText(
                    //     textColor: textColor,
                    //     fontSize: 14.sp,
                    //     title: "Saved Hadith",
                    //     maxLines: 2,
                    //     textOverflow: TextOverflow.ellipsis,
                    //     textAlign: TextAlign.start,
                    //     textStyle: GoogleFonts.quicksand(color: textColor),
                    //   ),
                    //   trailing: Icon(Icons.arrow_forward_ios_outlined, size: 10.h, color: iconColor),
                    // ),
                    // ListTile(
                    //   splashColor: AppColors.transparent,
                    //   hoverColor: AppColors.transparent,
                    //   onTap: () {
                    //      Get.to(QuranSavedAyatBookmarkScreen());
                    //   },
                    //   leading: Icon(LineIcons.bookmark, size: 16.h, color: iconColor),
                    //   title: CustomText(
                    //     textColor: textColor,
                    //     fontSize: 14.sp,
                    //     title: "Saved Ayat",
                    //     maxLines: 2,
                    //     textOverflow: TextOverflow.ellipsis,
                    //     textAlign: TextAlign.start,
                    //     textStyle: GoogleFonts.quicksand(color: textColor,),
                    //   ),
                    //   trailing: Icon(Icons.arrow_forward_ios_outlined, size: 10.h, color: iconColor),
                    // ),
                    ListTile(
                      splashColor: AppColors.transparent,
                      hoverColor: AppColors.transparent,
                      onTap: () {
                          Get.to(AppSettingsScreen());
                      },
                      leading: Icon(LineIcons.cog, size: 16.h, color: iconColor),
                      title: CustomText(
                        textColor: textColor,
                        fontSize: 14.sp,
                        title: "Setting",
                        maxLines: 2,
                        textOverflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.start,
                        textStyle: GoogleFonts.quicksand(color: textColor),
                      ),
                      trailing: Icon(Icons.arrow_forward_ios_outlined, size: 10.h, color: iconColor),
                    ),
                    ListTile(
                      splashColor: AppColors.transparent,
                      hoverColor: AppColors.transparent,
                      onTap: () {
                         // Get.to(AboutUsScreen());
                      },
                      leading: Icon(LineIcons.infoCircle, size: 16.h, color: iconColor),
                      title: CustomText(
                        textColor: textColor,
                        fontSize: 14.sp,
                        title: "About",
                        maxLines: 2,
                        textOverflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.start,
                        textStyle: GoogleFonts.quicksand(color: textColor),
                      ),
                      trailing: Icon(Icons.arrow_forward_ios_outlined, size: 10.h, color: iconColor),
                    ),
                  ],
                ),
              ),
              ListTile(
                splashColor: AppColors.transparent,
                hoverColor: AppColors.transparent,
                leading: Icon(Icons.rocket_launch, size: 16.h, color: iconColor),
                title: CustomText(
                  textColor: textColor,
                  fontSize: 14.sp,
                  title: "App Version 1.0",
                  maxLines: 2,
                  textOverflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.start,
                  textStyle: GoogleFonts.quicksand(color: textColor),
                ),
              ),
              AppSizedBox.space35h,
            ],
          ),
        ),
      ),
    );
  }
}
