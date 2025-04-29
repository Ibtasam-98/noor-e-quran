import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../config/app_colors.dart';
import '../../../config/app_sizedbox.dart';
import '../../../controllers/app_theme_switch_controller.dart';
import '../../../data/models/grid_item_model.dart';
import '../../../widgets/custom_card.dart';
import '../../../widgets/custom_frame.dart';
import '../../../widgets/custom_text.dart';
import 'donation_organization_profile_screen.dart';



class DonationScreen extends StatelessWidget {
  final AppThemeSwitchController themeController = Get.find<AppThemeSwitchController>();

  DonationScreen({Key? key}) : super(key: key);

  final List<GridItem> donationOrganization = [
    GridItem(
      title: "Rah e Haq",
      subtitle: "Making Difference",
      destination:  OrganizationProfileScreen(),
    ),
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
          firstText: "Donate",
          secondText: " Generously",
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
      body: Padding(
        padding: EdgeInsets.only(left: 10.w, right: 10.w, bottom: 5.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomCard(
              title: "Make a Difference Today",
              subtitle: 'Your donation can change a life',
              imageUrl: 'assets/images/donation_bg.jpg',
              mergeWithGradientImage: true,
            ),
            AppSizedBox.space15h,
            CustomText(
              title: "Importance of Charity",
              textColor: isDarkMode ? AppColors.white : AppColors.black,
              fontSize: 18.sp,
              fontFamily: 'grenda',
              maxLines: 1,
              textAlign: TextAlign.start,
              textOverflow: TextOverflow.ellipsis,
            ),
            AppSizedBox.space15h,
            Container(
              width: Get.width - 30,
              padding: EdgeInsets.all(20.w),
              margin: EdgeInsets.only(right: 10.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.r),
                color: AppColors.primary.withOpacity(0.1),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText(
                    title:
                    "مَّثَلُ ٱلَّذِينَ يُنفِقُونَ أَمْوَٰلَهُمْ فِى سَبِيلِ ٱللَّهِ كَمَثَلِ حَبَّةٍ أَنۢبَتَتْ سَبْعَ سَنَابِلَ فِى كُلِّ سُنۢبُلَةٍۢ مِّا۟ئَةُ حَبَّةٍۢ ۗ وَٱللَّهُ يُضَـٰعِفُ لِمَن يَشَآءُ ۗ وَٱللَّهُ وَٰسِعٌ عَلِيمٌ",
                    fontSize: 15.sp,
                    fontFamily: 'alquran', // Corrected to alquran
                    textAlign: TextAlign.end,
                    textColor: isDarkMode ? AppColors.white : AppColors.black,
                  ),
                  AppSizedBox.space10h,
                  CustomText(
                    title:
                    "The example of those who spend their wealth in the way of Allāh is like a seed [of grain] which grows seven spikes; in each spike is a hundred grains. And Allāh multiplies [His reward] for whom He wills. And Allāh is all-Encompassing and Knowing.",
                    fontSize: 14.sp,
                    fontFamily: 'quicksand',
                    textAlign: TextAlign.start,
                    textColor: isDarkMode ? AppColors.white : AppColors.black,
                  ),
                  AppSizedBox.space10h,
                  Align(
                    alignment: Alignment.centerLeft,
                    child: CustomText(
                      title: "Al Baqarah Ayat 261",
                      fontSize: 12.sp,
                      fontFamily: 'quicksand',
                      textAlign: TextAlign.start,
                      textColor: isDarkMode
                          ? AppColors.white.withOpacity(0.3)
                          : AppColors.black,
                      textStyle: const TextStyle(fontStyle: FontStyle.italic),
                    ),
                  ),
                ],
              ),
            ),
            AppSizedBox.space15h,
            CustomText(
              title: "Zakat & Sadaqah",
              textColor: isDarkMode ? AppColors.white : AppColors.black,
              fontSize: 18.sp,
              fontFamily: 'grenda',
              maxLines: 1,
              textAlign: TextAlign.start,
              textOverflow: TextOverflow.ellipsis,
            ),
            AppSizedBox.space10h,
            SingleChildScrollView(
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2,
                  childAspectRatio: 1,
                ),
                itemCount: donationOrganization.length,
                itemBuilder: (context, index) {
                  final item = donationOrganization[index];
                  return Obx(() => InkWell(
                    splashColor: AppColors.transparent,
                    highlightColor: AppColors.transparent,
                    hoverColor: AppColors.transparent,
                    onTap: () {
                      Get.to(OrganizationProfileScreen());
                    },
                    child: GridTile(
                      child: Container(
                        margin: EdgeInsets.all(5.h),
                        decoration: BoxDecoration(
                          color: themeController.isDarkMode.value
                              ? AppColors.black
                              : AppColors.white,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withOpacity(0.2),
                              spreadRadius: 1,
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomFrame(
                              leftImageAsset: "assets/frames/topLeftFrame.png",
                              rightImageAsset: "assets/frames/topRightFrame.png",
                              imageHeight: 30.h,
                              imageWidth: 30.w,
                            ),
                            Column(
                              children: [
                                Obx(() => CustomText(
                                  title: item.title,
                                  fontSize: 18.sp,
                                  textColor: themeController.isDarkMode.value
                                      ? AppColors.white
                                      : AppColors.black,
                                  fontWeight: FontWeight.normal,
                                  textOverflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                  capitalize: true,
                                  maxLines: 2,
                                  fontFamily: 'grenda',
                                )),
                                AppSizedBox.space5h,
                                CustomText(
                                  title: item.subtitle,
                                  fontSize: 12.sp,
                                  textColor: AppColors.primary,
                                  fontWeight: FontWeight.w500,
                                  textAlign: TextAlign.center,
                                  textOverflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                ),
                              ],
                            ),
                            CustomFrame(
                              leftImageAsset: "assets/frames/bottomLeftFrame.png",
                              rightImageAsset: "assets/frames/bottomRightFrame.png",
                              imageHeight: 30.h,
                              imageWidth: 30.w,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
