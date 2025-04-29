import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:noor_e_quran/app/widgets/custom_button.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../config/app_colors.dart';
import '../../../config/app_sizedbox.dart';
import '../../../controllers/app_theme_switch_controller.dart';
import '../../../widgets/custom_text.dart';

class OrganizationProfileScreen extends StatelessWidget {
  final AppThemeSwitchController themeController = Get.find<AppThemeSwitchController>();
  final String _instagramUrl =
      "https://www.instagram.com/rah.e.haqofficial?igsh=MTk0YndmaHJzbGUzMQ==";

  // Payment details data
  final List<Map<String, String>> _paymentDetails = [
    {
      "title": "Bank AL Habib Limited",
      "accountName": "Title: Syed Shehroz Amin",
      "accountNumber": "Account Number: PK51 BAHL 0049 0095 0121 8501",
      "bgColor": "0.1",
    },
    {
      "title": "Easypaisa/SadaPay",
      "accountName": "Syed Muhammad Rayyan Babar",
      "accountNumber": "Number: 0336 9587167",
      "otherDetail": "RAH-E- HAQ",
      "bgColor": "0.29",
    },
  ];

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = themeController.isDarkMode.value;
    final iconColor = isDarkMode ? AppColors.white : AppColors.black;

    return Scaffold(
      backgroundColor: isDarkMode ? AppColors.black : AppColors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: isDarkMode ? AppColors.black : AppColors.white,
        surfaceTintColor: AppColors.transparent,
        foregroundColor: AppColors.transparent,
        title: CustomText(
          firstText: "Rah e",
          secondText: " Haq",
          fontSize: 18.sp,
          firstTextColor: isDarkMode ? AppColors.white : AppColors.black,
          secondTextColor: AppColors.primary,
        ),
        centerTitle: false,
        leading: InkWell(
          onTap: () {
            Get.back();
          },
          child: Icon(
            Icons.west,
            color: iconColor,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.primary, width: 1),
                    borderRadius: BorderRadius.circular(500),
                  ),
                  child: CircleAvatar(
                    radius: 80,
                    backgroundImage:
                    const AssetImage("assets/images/donation_org1.png"),
                  ),
                ),
              ),
              AppSizedBox.space10h,
              CustomText(
                title: "About Us",
                textColor: isDarkMode ? AppColors.white : AppColors.black,
                fontSize: 18.sp,
                fontFamily: 'grenda',
                maxLines: 1,
                textAlign: TextAlign.start,
                textOverflow: TextOverflow.ellipsis,
              ),
              AppSizedBox.space10h,
              CustomText(
                title:
                "We are a non-profit organization dedicated to making a positive impact in our community. Our mission is to support underprivileged individuals and families by providing essential resources and services. We believe in transparency, accountability, and the power of collective action.  We strive to create sustainable solutions and empower those we serve to build better futures.",
                textColor: isDarkMode ? AppColors.white : AppColors.black,
                fontSize: 15.sp,
                maxLines: 100,
                textAlign: TextAlign.start,
                textOverflow: TextOverflow.ellipsis,
              ),
              AppSizedBox.space10h,
              CustomText(
                title: "Donate",
                textColor: isDarkMode ? AppColors.white : AppColors.black,
                fontSize: 18.sp,
                fontFamily: 'grenda',
                maxLines: 1,
                textAlign: TextAlign.start,
                textOverflow: TextOverflow.ellipsis,
              ),
              AppSizedBox.space10h,
              // Loop through payment details
              ..._paymentDetails.map((details) {
                return Container(
                  width: Get.width,
                  margin: EdgeInsets.only(bottom: 5, top: 5.h),
                  padding: EdgeInsets.all(10.h),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.r),
                    color: AppColors.primary
                        .withOpacity(double.parse(details["bgColor"] ?? "0.1")),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        title: details["title"] ?? "",
                        textColor:
                        isDarkMode ? AppColors.white : AppColors.black,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        textAlign: TextAlign.start,
                      ),
                      AppSizedBox.space5h,
                      CustomText(
                        title: details["accountName"] ?? "",
                        textColor:
                        isDarkMode ? AppColors.white : AppColors.black,
                        fontSize: 14.sp,
                        textAlign: TextAlign.start,
                      ),
                      AppSizedBox.space5h,
                      CustomText(
                        title: details["accountNumber"] ?? "",
                        textColor:
                        isDarkMode ? AppColors.white : AppColors.black,
                        fontSize: 14.sp,
                        textAlign: TextAlign.start,
                      ),
                      if (details["otherDetail"] != null) ...[
                        AppSizedBox.space5h,
                        CustomText(
                          title: details["otherDetail"] ?? "",
                          textColor:
                          isDarkMode ? AppColors.white : AppColors.black,
                          fontSize: 14.sp,
                          textAlign: TextAlign.start,
                        ),
                      ],
                    ],
                  ),
                );
              }).toList(),
              SizedBox(height: 20.h), // Added some bottom spacing instead of Spacer
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: CustomButton(
                  haveBgColor: true,
                  btnTitle: "Contact Us",
                  btnTitleColor: Colors.white,
                  bgColor: AppColors.primary,
                  borderRadius: 45.r,
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
                  onTap: () {
                    _launchInstagram();
                  },
                ),
              ),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _launchInstagram() async {
    final Uri _url = Uri.parse(_instagramUrl);
    if (!await launchUrl(_url)) {
      throw 'Could not launch $_url';
    }
  }
}