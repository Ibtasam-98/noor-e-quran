import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../config/app_colors.dart';
import '../../config/app_sizedbox.dart';
import '../../controllers/app_theme_switch_controller.dart';
import '../../widgets/custom_frame.dart';
import '../../widgets/custom_text.dart';

class ProphetMiracleDetailScreen extends StatelessWidget {
  final String prophetName;
  final AppThemeSwitchController themeController = Get.find<AppThemeSwitchController>();

  ProphetMiracleDetailScreen({Key? key, required this.prophetName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = themeController.isDarkMode.value;
    final iconColor = isDarkMode ? AppColors.white : AppColors.black;
    final textColor = isDarkMode ? AppColors.white : AppColors.black;

    return Scaffold(
      backgroundColor: isDarkMode ? AppColors.black : AppColors.white,
      appBar: AppBar(
        surfaceTintColor: AppColors.transparent,
        foregroundColor: AppColors.transparent,
        centerTitle: false,
        title: CustomText(
          firstText: "Prophet",
          secondText: " $prophetName",
          fontSize: 18.sp,
          firstTextColor: isDarkMode ? AppColors.white : AppColors.black,
          secondTextColor: AppColors.primary,
        ),
        backgroundColor: isDarkMode ? AppColors.black : AppColors.white,
        leading: InkWell(
          splashColor: AppColors.transparent,
          highlightColor: AppColors.transparent,
          onTap: () {
            Get.back();
          },
          child: Icon(
            Icons.west,
            color: iconColor,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                decoration: BoxDecoration(
                  color: isDarkMode ? AppColors.black : AppColors.white,
                  borderRadius: BorderRadius.circular(1.r),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.5),
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomFrame(
                      leftImageAsset: "assets/frames/topLeftFrame.png",
                      rightImageAsset: "assets/frames/topRightFrame.png",
                      imageHeight: 65.h,
                      imageWidth: 65.w,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10.w, right: 10.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Obx(() => CustomText(
                            title: "Did Prophet Muhammad Perform Miracles ?",
                            fontSize: 16.sp * themeController.fontSizeFactor.value,
                            textAlign: TextAlign.start,
                            fontWeight: FontWeight.w600,
                          ),),
                          AppSizedBox.space10h,
                          Obx(() => CustomText(
                            textColor: textColor,
                            fontSize: 16.sp * themeController.fontSizeFactor.value,
                            title: "Yes, Prophet Muhammad (PBUH) performed several miracles, which are considered some of the most significant signs of his prophethood. Now, we will present them in detail—get ready for an exciting journey, as you will discover how these miracles were not just extraordinary events, but carried profound spiritual messages that highlight the greatness of Allah and affirm the truth of Prophet Muhammad’s mission. Additionally, the importance of the Last Two Verses of Surah Al-Baqarah cannot be overlooked, as they offer powerful guidance and protection for the believer, reinforcing the connection with Allah and the teachings of Islam.",
                            textAlign: TextAlign.start,
                          )),
                          AppSizedBox.space10h,
                          Obx(()=>CustomText(
                            title: "The Great Miracles of Prophet Muhammad",
                            fontSize: 16.sp * themeController.fontSizeFactor.value,
                            textAlign: TextAlign.start,
                            fontWeight: FontWeight.w600,
                          ),),
                          AppSizedBox.space10h,
                          Obx(() => CustomText(
                            textColor: textColor,
                            fontSize: 16.sp * themeController.fontSizeFactor.value,
                            title: "Prophet Muhammad (PBUH) performed numerous miracles throughout his life, each one serving as a divine sign of his prophethood. Here are some of the most remarkable miracles:",
                            textAlign: TextAlign.start,
                          )),
                          AppSizedBox.space10h,
                          Obx(()=> CustomText(
                            title: "The Holy Quran",
                            fontSize: 16.sp * themeController.fontSizeFactor.value,
                            textAlign: TextAlign.start,
                            fontWeight: FontWeight.w600,
                          ),),
                          AppSizedBox.space10h,
                          Obx(() => CustomText(
                            textColor: textColor,
                            fontSize: 16.sp * themeController.fontSizeFactor.value,
                            title: "The Holy Quran is not only the first and greatest miracle of the Prophet Muhammad (PBUH), but it also stands as a timeless testament to divine revelation. As highlighted in Surah Al-Isra (17:88), the Quran challenges humanity and jinn alike to produce a work comparable to it, declaring their inability to do so even with mutual support \n\nThis miraculous nature of the Quran guarantees its preservation unchanged until the Day of Judgment, ensuring it remains a guiding light for Muslims across the globe, offering wisdom and direction in every aspect of life.",
                            textAlign: TextAlign.start,
                          )),
                          AppSizedBox.space10h,
                          Obx(()=> CustomText(
                            title: "Splitting the Moon",
                            fontSize: 16.sp * themeController.fontSizeFactor.value,
                            textAlign: TextAlign.start,
                            fontWeight: FontWeight.w600,
                          ),),
                          AppSizedBox.space10h,
                          Obx(() => CustomText(
                            textColor: textColor,
                            fontSize: 16.sp * themeController.fontSizeFactor.value,
                            title: "One of the most remarkable miracles attributed to Prophet Muhammad (peace be upon him) is the splitting of the moon, which took place in Mecca when the disbelievers challenged him to perform a sign of his prophethood. \n\nIn response to their demand, the Prophet ﷺ, guided by divine inspiration, pointed at the moon, which astonishingly split into two distinct halves. This supernatural occurrence remained visible for a significant time before the halves converged back together. \n\nAs narrated by Anas ibn Malik (may Allah be pleased with him), the people of Mecca witnessed this extraordinary event, which left them in disbelief, dismissing it as mere ‘magic.’ However, the miracle was a clear and powerful testament to the truth of Muhammad’s mission. \n\nWith the Hira’ mountain appearing prominently between the two split halves, it served as undeniable proof of his prophethood. This event not only solidified the faith of his followers but also challenged the skeptics to reconsider their understanding of the natural world, marking a pivotal moment in the history of Islam.",
                            textAlign: TextAlign.start,
                          )),
                          AppSizedBox.space10h,
                         Obx(()=>  CustomText(
                           title: "The Miracle of Food",
                           fontSize: 16.sp * themeController.fontSizeFactor.value,
                           textAlign: TextAlign.start,
                           fontWeight: FontWeight.w600,
                         ),),
                          AppSizedBox.space10h,
                          Obx(() => CustomText(
                            textColor: textColor,
                            fontSize: 16.sp * themeController.fontSizeFactor.value,
                            title: "One remarkable miracle occurred when one of the Prophet Muhammad’s (peace be upon him) companions invited him to a meal intended for a small group. The Prophet accepted the invitation and, much to the host’s surprise, called upon a thousand of his companions to join them at the table. \n\nDespite the host’s concerns, Muhammad (peace be upon him) personally served the food, ensuring that each guest received their portion until everyone was satisfied. \n\nWhat was truly astonishing was that the tray of food remained as full at the end of the meal as it was at the beginning, with no visible decrease in the quantity! This miraculous event was a clear blessing from God and occurred multiple times throughout the Prophet’s life. \n\nIt exemplifies the generosity and compassion of the Prophet, highlighting that he received divine support in all aspects of his life, including sustenance.",
                            textAlign: TextAlign.start,
                          )),
                          AppSizedBox.space10h,
                         Obx(() =>  CustomText(
                           title: "Isra and Miraj: The Night Journey and Ascension",
                           fontSize: 16.sp * themeController.fontSizeFactor.value,
                           textAlign: TextAlign.start,
                           fontWeight: FontWeight.w600,
                         ),),
                          AppSizedBox.space10h,
                          Obx(() => CustomText(
                            textColor: textColor,
                            fontSize: 16.sp * themeController.fontSizeFactor.value,
                            title: "The journey known as Isra, celebrated as a miraculous event, marks the night when the Prophet Muhammad (peace be upon him) was taken from Masjid al-Haram in Mecca to Masjid al-Aqsa in Jerusalem. As described in the Qur’an:",
                            textAlign: TextAlign.start,
                          )),
                          AppSizedBox.space10h,
                          Container(
                            padding: EdgeInsets.only(right: 10.w, top: 10.h, bottom: 10.h, left: 10.w),
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.39),
                              borderRadius: BorderRadius.circular(15.r),
                            ),
                            child: Obx(() => CustomText(
                              title: "بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ سُبْحَٰنَ ٱلَّذِىٓ أَسْرَىٰ بِعَبْدِهِۦ لَيْلًا مِّنَ ٱلْمَسْجِدِ ٱلْحَرَامِ إِلَى ٱلْمَسْجِدِ ٱلْأَقْصَا ٱلَّذِى بَٰرَكْنَا حَوْلَهُۥ لِنُرِيَهُۥ مِنْ ءَايَٰتِنَآ إِنَّهُۥ هُوَ ٱلسَّمِيعُ ٱلْبَصِيرُ",
                              fontSize:16.sp * themeController.fontSizeFactor.value,
                              textColor: AppColors.primary,
                              textAlign: TextAlign.end,
                            )),
                          ),
                          AppSizedBox.space10h,
                          Obx(() => CustomText(
                            textColor: textColor,
                            fontSize: 16.sp * themeController.fontSizeFactor.value,
                            title: "Glory be to the Most Perfect One Who took His servant for a journey on a (blessed) night from Masjid al-Haram to Masjid al-Aqsa, where We have blessed the surrounding area, so that We may show him some of Our signs. Indeed, He alone is the One who hears all and sees all.",
                            textAlign: TextAlign.start,
                          )),
                          AppSizedBox.space10h,
                          CustomText(
                            title: 'Surah Al-Isra (17:1)',
                            textColor: AppColors.primary,
                            fontWeight: FontWeight.w700,
                            fontSize: 12.sp,
                            textAlign: TextAlign.start,
                            textStyle: TextStyle(
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                          AppSizedBox.space10h,
                          Obx(() => CustomText(
                            textColor: textColor,
                            fontSize: 16.sp * themeController.fontSizeFactor.value,
                            title: "This journey occurred shortly before the Prophet’s migration to Medina and involved the Angel Gabriel. The distance traveled during this journey was humanly impossible to cover in such a brief time, underscoring its miraculous nature. \n\nFollowing the Isra, the Prophet Muhammad (peace be upon him) experienced the Miraj, where he ascended to the heavens. During this divine communion, he was given the opportunity to speak with God. Remarkably, when he returned to Mecca, it was still night, emphasizing the miraculous speed and nature of his journey. This extraordinary event solidifies the Prophet’s role as a messenger of God and serves as a profound testament to his spiritual significance in Islam.",
                            textAlign: TextAlign.start,
                          )),
                          AppSizedBox.space10h,
                        ],
                      ),
                    ),
                    CustomFrame(
                      leftImageAsset: "assets/frames/bottomLeftFrame.png",
                      rightImageAsset: "assets/frames/bottomRightFrame.png",
                      imageHeight: 65.h,
                      imageWidth: 65.w,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Obx(
            () => BottomAppBar(
          color: isDarkMode ? AppColors.black : AppColors.white,
          child: Row(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 16.w),
                child: CustomText(
                  textColor: textColor,
                  fontSize: 15.sp,
                  title: "Font Size",
                ),
              ),
              Expanded(
                child: Slider(
                  value: themeController.currentFontSize.value,
                  min: 12.0,
                  max: 30.0,
                  divisions: 18,
                  label: "${themeController.currentFontSize.value.toStringAsFixed(1)}",
                  activeColor: AppColors.primary,
                  inactiveColor: AppColors.grey,
                  onChanged: (value) {
                    themeController.updateFontSize(value);
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 16.w),
                child: CustomText(
                  textColor: textColor,
                  fontSize: 15.sp,
                  title: themeController.currentFontSize.value.toStringAsFixed(1),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}