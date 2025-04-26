
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:noor_e_quran/app/config/app_colors.dart';
import 'package:noor_e_quran/app/config/app_sizedbox.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../controllers/app_theme_switch_controller.dart';
import '../../../data/models/name_of_Allah.dart';
import '../../../widgets/custom_card.dart';
import '../../../widgets/custom_frame.dart';
import '../../../widgets/custom_text.dart';
import '../../common/views/audio_player_screen.dart';
import '../../common/views/dua_details_screen.dart';

class NameOfAllahScreen extends StatelessWidget {
  final List<NameOfAllah> names = parseJson(jsonData);
  NameOfAllahScreen({super.key});

  final AppThemeSwitchController themeController = Get.put(AppThemeSwitchController());

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = themeController.isDarkMode.value;
    final textColor = isDarkMode ? AppColors.white : AppColors.black;
    final iconColor = isDarkMode ? AppColors.white : AppColors.black;

    return Scaffold(
      backgroundColor: isDarkMode ? AppColors.black : AppColors.white,
      appBar: AppBar(
        surfaceTintColor: AppColors.transparent,
        foregroundColor: AppColors.transparent,
        title:  CustomText(
          firstText: "Asma",
          secondText: " Ul Husna",
          fontSize: 18.sp,
          firstTextColor: isDarkMode ? AppColors.white : AppColors.black,
          secondTextColor: AppColors.primary,
        ),
        centerTitle: false,
        backgroundColor: isDarkMode ? AppColors.black : AppColors.white,
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
        padding: EdgeInsets.only(left: 10.w, right: 10.w, bottom: 10.h),
        child: Column(
          children: [
            CustomCard(
              title: "Divine Attributes of Allah",
              subtitle: 'Wisdom Behind Each Name of Allah',
              imageUrl: 'assets/images/quran.jpeg',
              mergeWithGradientImage: true,
              titleFontSize: 18.sp,
              subtitleFontSize: 12.sp,
            ),
            AppSizedBox.space15h,
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: MediaQuery.of(context).size.width > 600 ? 4 : 2,
                  childAspectRatio: 1,
                ),
                itemCount: names.length,
                itemBuilder: (context, index) {
                  var name = names[index];
                  return InkWell(
                    onTap: () {
                      Get.to(DuaDetailCommonScreen(
                        arabicDua: name.arabicName,
                        audioUrl: "",
                        duaTranslation: name.paragraph,
                        duaUrduTranslation: "",
                        engFirstTitle: name.englishName,
                        showAudiotWidgets: false,
                        engSecondTitle: "",
                        latinTitle: "",
                        isComingFromAllahNameScreen: true,
                      ));
                    },
                    child: Container(
                      margin: EdgeInsets.all(5.h),
                      decoration: BoxDecoration(
                        color: isDarkMode ? AppColors.black: AppColors.white,
                        borderRadius: BorderRadius.circular(1.r),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.2),
                            blurRadius: 10,
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
                          Expanded(
                            child: CustomText(
                              title: name.arabicName,
                              fontSize: 35.sp,
                              textColor: textColor,
                              fontWeight: FontWeight.normal,
                              textOverflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              maxLines: 20,
                              fontFamily: 'grenda',
                            ),
                          ),
                          Expanded(
                            child: CustomText(
                              title: name.englishName,
                              fontSize: 18.sp,
                              textColor: AppColors.primary,
                              fontWeight: FontWeight.w400,
                              textAlign: TextAlign.center,
                              textOverflow: TextOverflow.ellipsis,
                              maxLines: 20,
                            ),
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
                  );
                },
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: InkWell(
        splashColor: AppColors.transparent,
        highlightColor: AppColors.transparent,
        onTap: (){
          Get.to(
              AudioPlayerScreen(
                  title: "Names of Allah",
                  audioUrl: "assets/audios/AllahNames.mp3",
                  latinName: "اَلاسْمَاءُ الْحُسناى",
                  titleFontSize:35.sp
              ));
        },
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.5), // Shadow color
                blurRadius: 20, // Softening the shadow
                offset: Offset(0, -2), // Positioning the shadow above the BottomAppBar
              ),
            ],
          ),
          child: BottomAppBar(
            color: themeController.isDarkMode.value ? AppColors.black : AppColors.white,
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Icon(
                    Icons.play_arrow,
                    color: iconColor,
                  ),
                  AppSizedBox.space5w,
                  Expanded(
                    child: CustomText(
                      textColor: textColor,
                      fontSize: 18.sp,
                      title: "Play Asma ul Husna ",
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
