import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icons.dart';
import 'package:noor_e_quran/app/config/app_sizedbox.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:whatsapp_unilink/whatsapp_unilink.dart';

import '../../../config/app_colors.dart';
import '../../../controllers/app_theme_switch_controller.dart';
import '../../../widgets/custom_text.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  Future<void> _launchEmail(String email) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: email,
    );
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      Get.snackbar('Could not launch email', 'No email app found.');
    }
  }

  Future<void> _launchWhatsApp(String phoneNumber) async {
    final link = WhatsAppUnilink(
      phoneNumber: phoneNumber.replaceAll('+', '').replaceAll(' ', ''),
    );
    if (await canLaunchUrl(link.asUri())) {
      await launchUrl(link.asUri());
    } else {
      Get.snackbar('Could not launch WhatsApp', 'WhatsApp is not installed on this device.');
    }
  }

  Future<void> _launchWebsite(String websiteUrl) async {
    final Uri websiteUri = Uri.parse(websiteUrl);
    if (await canLaunchUrl(websiteUri)) {
      await launchUrl(websiteUri);
    } else {
      Get.snackbar('Could not launch website', 'Could not open the website.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppThemeSwitchController themeController = Get.find<AppThemeSwitchController>();
    final double listItemIconSize = 20.h;

    return Scaffold(
      backgroundColor: themeController.isDarkMode.value ? AppColors.black : AppColors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: AppBar(
          elevation: 0,
          backgroundColor: themeController.isDarkMode.value ? AppColors.black : AppColors.white,
          surfaceTintColor: AppColors.transparent,
          foregroundColor: themeController.isDarkMode.value ? AppColors.black : AppColors.white,
          title: CustomText(
            firstText: "About",
            secondText: " Us",
            firstTextColor: themeController.isDarkMode.value ? AppColors.white : AppColors.black,
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
              color: themeController.isDarkMode.value ? AppColors.white : AppColors.black,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.center,
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 40.h,
                      backgroundImage: const AssetImage("assets/images/logo.png"),
                    ),
                    AppSizedBox.space10h,
                    CustomText(
                      firstText: "Noor e",
                      secondText: " Quran",
                      firstTextColor: themeController.isDarkMode.value ? AppColors.white : AppColors.black,
                      secondTextColor: AppColors.primary,
                      fontSize: 22.sp,
                    ),
                  ],
                ),
              ),
              AppSizedBox.space20h,
              CustomText(
                title: "Our Mission",
                fontSize: 18.sp,
                textColor: themeController.isDarkMode.value ? AppColors.white : AppColors.primary,
                fontFamily: 'grenda',
                maxLines: 1,
                textOverflow: TextOverflow.ellipsis,
              ),
              AppSizedBox.space10h,
              Container(
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(15.r),
                ),
                child: CustomText(
                  title: "To provide a comprehensive and user-friendly Islamic application encompassing the Holy Quran, Hadith collections, Tasbeeh counter, and many other beneficial features, empowering Muslims in their daily spiritual practices and enhancing their understanding of Islamic teachings.",
                  textColor: themeController.isDarkMode.value ? AppColors.white : AppColors.black,
                  fontSize: 16.sp,
                  textAlign: TextAlign.start,
                ),
              ),
              AppSizedBox.space20h,
              CustomText(
                title: "About Us",
                fontSize: 18.sp,
                textColor: themeController.isDarkMode.value ? AppColors.white : AppColors.primary,
                fontFamily: 'grenda',
                maxLines: 1,
                textOverflow: TextOverflow.ellipsis,
              ),
              AppSizedBox.space10h,
              Container(
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(15.r),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      title: "Developed by AxonEdge Technologies",
                      textColor: themeController.isDarkMode.value ? AppColors.white : AppColors.black,
                      fontSize: 16.sp,
                      textAlign: TextAlign.start,
                    ),
                    AppSizedBox.space10h,
                    CustomText(
                      title: "AxonEdge Technologies crafts innovative digital solutions, specializing in mobile apps, web platforms, and expert consultancy. We focus on user-centric development and strategic guidance to empower businesses in the digital landscape, from concept to support.",
                      textColor: themeController.isDarkMode.value ? AppColors.white : AppColors.black,
                      fontSize: 16.sp,
                      textAlign: TextAlign.start,
                    ),
                  ],
                ),
              ),
              AppSizedBox.space20h,
              CustomText(
                title: "Contact Us",
                fontSize: 18.sp,
                textColor: themeController.isDarkMode.value ? AppColors.white : AppColors.primary,
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
                  children: [
                    InkWell(
                      onTap: () => _launchWebsite("https://axonedgetechnologies.com/"),
                      child: ListTile(
                        leading: Icon(
                          Icons.language_outlined,
                          color: themeController.isDarkMode.value ? AppColors.white : AppColors.black,
                          size: listItemIconSize,
                        ),
                        title: CustomText(
                          title: "https://axonedgetechnologies.com/",
                          fontSize: 14.sp,
                          textAlign: TextAlign.start,
                          textColor: themeController.isDarkMode.value ? AppColors.white : AppColors.black,
                        ),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          size: 10.h,
                          color: themeController.isDarkMode.value ? AppColors.white : AppColors.black,
                        ),
                      ),
                    ),
                    Divider(
                      color: AppColors.primary.withOpacity(0.2),
                      thickness: 0.5,
                    ),
                    InkWell(
                      onTap: () => _launchEmail("hello@axonedgetechnologies.com"),
                      child: ListTile(
                        leading: Icon(
                          Icons.mail_outline,
                          color: themeController.isDarkMode.value ? AppColors.white : AppColors.black,
                          size: listItemIconSize,
                        ),
                        title: CustomText(
                          title: "hello@axonedgetechnologies.com",
                          fontSize: 14.sp,
                          textAlign: TextAlign.start,
                          textColor: themeController.isDarkMode.value ? AppColors.white : AppColors.black,
                        ),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          size: 10.h,
                          color: themeController.isDarkMode.value ? AppColors.white : AppColors.black,
                        ),
                      ),
                    ),
                    Divider(
                      color: AppColors.primary.withOpacity(0.2),
                      thickness: 0.5,
                    ),
                    InkWell(
                      onTap: () => _launchWhatsApp("+92 336 5021360"),
                      child: ListTile(
                        leading: Icon(
                          LineIcons.whatSApp,
                          color: themeController.isDarkMode.value ? AppColors.white : AppColors.black,
                          size: listItemIconSize,
                        ),
                        title: CustomText(
                          title: "+92 336 5021360",
                          fontSize: 14.sp,
                          textAlign: TextAlign.start,
                          textColor: themeController.isDarkMode.value ? AppColors.white : AppColors.black,
                        ),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          size: 10.h,
                          color: themeController.isDarkMode.value ? AppColors.white : AppColors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              AppSizedBox.space20h,
            ],
          ),
        ),
      ),
    );
  }
}