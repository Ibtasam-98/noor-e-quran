
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:noor_e_quran/app/config/app_sizedbox.dart';
import '../../config/app_colors.dart';
import '../../controllers/app_theme_switch_controller.dart';
import '../../widgets/custom_card.dart';
import '../../widgets/custom_text.dart';
import '../common/dua_details_screen.dart';

class FastingMenuScreen extends StatelessWidget {
  final AppThemeSwitchController themeController = Get.put(AppThemeSwitchController());

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = themeController.isDarkMode.value;
    final iconColor = isDarkMode ? AppColors.white : AppColors.black;
    final textColor = isDarkMode ? AppColors.white : AppColors.black;

    // Reusable item for the list
    Widget fastingItem({
      required String title,
      required String arabicDua,
      required String urduTitle,
      required String duaTranslationUrdu,
      required String duaTranslaionEng,
      required String index,
      required Color backgroundColor,
    }) {
      return InkWell(
        splashColor: AppColors.transparent,
        highlightColor: AppColors.transparent,
        onTap: () {
          Get.to(
              DuaDetailCommonScreen(
                arabicDua:  arabicDua,
                audioUrl:"",
                duaTranslation: duaTranslaionEng,
                duaUrduTranslation: duaTranslationUrdu,
                engFirstTitle:  "Fasting",
                engSecondTitle: " Dua ${index}",
                showAudiotWidgets: false,
                latinTitle: urduTitle,
                isComingFromAllahNameScreen: false,

              )
          );

        },
        child: Container(
          margin: EdgeInsets.only(left: 10.w,right: 10.w,bottom: 5,top: 5.h),
          padding: EdgeInsets.all(25.w),
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.r),
            color: backgroundColor,
          ),
          child: Column(
            children: [
              Row(
                children: [
                  CustomText(
                    textColor: textColor,
                    fontSize: 15.sp,
                    title: index,
                    maxLines: 2,
                    textOverflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.start,
                    fontWeight: FontWeight.w500,
                  ),
                  AppSizedBox.space10w,
                  Expanded(
                    child: CustomText(
                      title: title,
                      fontSize: 16.sp,
                      textColor: textColor,
                      fontWeight: FontWeight.w500,
                      textOverflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      textAlign: TextAlign.start,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: themeController.isDarkMode.value ? AppColors.black : AppColors.white,
      appBar: AppBar(
        backgroundColor: themeController.isDarkMode.value ? AppColors.black : AppColors.white,
        surfaceTintColor: AppColors.transparent,
        foregroundColor: AppColors.transparent,
        title: CustomText(
          firstText: "Fasting ",
          secondText: " Discipline",
          fontSize: 18.sp,
          firstTextColor: isDarkMode ? AppColors.white : AppColors.black,
          secondTextColor: AppColors.primary,
        ),
        centerTitle: false,
        leading: InkWell(
          splashColor: AppColors.transparent,
          highlightColor: AppColors.transparent,
          onTap: () { Get.back(); },
          child: Icon(
            Icons.west,
            color: iconColor,
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 10.w, right: 10.w, bottom: 10.h,),
            child: CustomCard(
              title: "Fasting Collection",
              subtitle: "Blessings and strength for Fasting.",
              imageUrl: 'assets/images/fasting_bg.png',
              mergeWithGradientImage: true,
              titleFontSize: 18.sp,
              subtitleFontSize: 12.sp,
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  fastingItem(
                      index: "1",
                      title: "Dua of Opening Fast",
                      arabicDua: " ذَهَبَ الظَّمَأُ وَابْتَلَّتِ الْعُرُوقُ وَثَبَتَ الأَجْرُ إِنْ شَاءَ اللَّهُُ",
                      urduTitle: "",
                      duaTranslationUrdu: "",
                      duaTranslaionEng: "The thirst has gone and the veins are quenched, and reward is confirmed, if Allah wills",
                      backgroundColor: AppColors.primary.withOpacity(0.39)
                  ),

                  fastingItem(
                    index: "2",
                    title: "Dua for Keeping Fast",
                    arabicDua: "وَبِصَوْمِ غَدٍ نَّوَيْتُ مِنْ شَهْرِ رَمَضَانََ",
                    urduTitle: "",
                    duaTranslationUrdu: "",
                    duaTranslaionEng: "I intend to fast tomorrow in the month of Ramadan.",
                    backgroundColor: AppColors.primary.withOpacity(0.1),
                  ),

                  fastingItem(
                    index: "3",
                    title: "Dua for Breaking Fast",
                    arabicDua: "ذَهَبَ الظَّمَأُ وَابْتَلَّتِ الْعُرُوقُ وَثَبَتَ الأَجْرُ إِنْ شَاءَ اللَّهُُ",
                    urduTitle: "",
                    duaTranslationUrdu: "",
                    duaTranslaionEng: "The thirst has gone and the veins are quenched, and reward is confirmed, if Allah wills",
                    backgroundColor: AppColors.primary.withOpacity(0.39),
                  ),

                  fastingItem(
                    index: "4",
                    title: "Dua for forgiveness",
                    arabicDua: "ٱلَّذِينَ يَقُولُونَ رَبَّنَآ إِنَّنَآ ءَامَنَّافَٱغْفِرْ لَنَا ذُنُوبَنَا وَقِنَا عَذَابَ ٱلنَّارِ",
                    urduTitle: "",
                    duaTranslationUrdu:"",
                    duaTranslaionEng: "Our Lord! Surely we believe, therefore forgive us our faults and save us from the chastisement of the fire",
                    backgroundColor: AppColors.primary.withOpacity(0.1),
                  ),

                  fastingItem(
                    index: "5",
                    title: "Dua for protection from hellfire",
                    arabicDua: "اللَّهُمَّ إِنِّي أَسْأَلُكَ رِضَاكَ وَالجَنَّةَ ، وَأَعُوذُ بِكَ مِنْ سَخَطِكَ وَالنَّارِ",
                    urduTitle: "",
                    duaTranslationUrdu: "",
                    duaTranslaionEng: "O Allah, I ask of Your pleasure and for Paradise, and I seek refuge from Your displeasure and from the Hellfire.",
                    backgroundColor: AppColors.primary.withOpacity(0.39),
                  ),

                  AppSizedBox.space25h,
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
