import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quran/quran.dart' as quran;
import '../../config/app_colors.dart';
import '../../config/app_sizedbox.dart';
import '../../controllers/app_theme_switch_controller.dart';
import '../../controllers/prophet_miracle_detail_controller.dart';
import '../../widgets/custom_frame.dart';
import '../../widgets/custom_text.dart';

class ProphetMiracleDetailScreen extends StatelessWidget {
  final String prophetName;
  final ProphetMiracleDetailController controller;
  final String audioUrl = quran.getAudioURLByVerse(17, 1);

  ProphetMiracleDetailScreen({Key? key, required this.prophetName})
      : controller = Get.put(ProphetMiracleDetailController(prophetName: prophetName)),
        super(key: key);

  final AppThemeSwitchController themeController = Get.find<AppThemeSwitchController>();

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = themeController.isDarkMode.value;
    final iconColor = isDarkMode ? AppColors.white : AppColors.black;
    final textColor = isDarkMode ? AppColors.white : AppColors.black;

    return Scaffold(
      backgroundColor: isDarkMode ? AppColors.black : AppColors.white,
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        foregroundColor: Colors.transparent,
        centerTitle: false,
        title: CustomText(
          firstText: "Prophet",
          secondText: " $prophetName",
          fontSize: 18.sp,
          firstTextColor: textColor,
          secondTextColor: AppColors.primary,
        ),
        backgroundColor: isDarkMode ? AppColors.black : AppColors.white,
        leading: InkWell(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
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
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Obx(
                                () => CustomText(
                              title: "Did Prophet Muhammad Perform Miracles ?",
                              fontSize: 16.sp * themeController.fontSizeFactor.value,
                              textAlign: TextAlign.start,
                              textColor: AppColors.primary,
                            ),
                          ),
                          AppSizedBox.space10h,
                          Obx(
                                () => CustomText(
                              textColor: textColor,
                              fontSize: 16.sp * themeController.fontSizeFactor.value,
                              title:
                              "Yes, Prophet Muhammad (PBUH) performed several miracles, which are considered some of the most significant signs of his prophethood. Now, we will present them in detail—get ready for an exciting journey, as you will discover how these miracles were not just extraordinary events, but carried profound spiritual messages that highlight the greatness of Allah and affirm the truth of Prophet Muhammad’s mission. Additionally, the importance of the Last Two Verses of Surah Al-Baqarah cannot be overlooked, as they offer powerful guidance and protection for the believer, reinforcing the connection with Allah and the teachings of Islam.",
                              textAlign: TextAlign.start,
                            ),
                          ),
                          AppSizedBox.space10h,
                          Obx(
                                () => CustomText(
                              title: "The Great Miracles of Prophet Muhammad",
                              fontSize: 16.sp * themeController.fontSizeFactor.value,
                              textAlign: TextAlign.start,
                              textColor: AppColors.primary,
                            ),
                          ),
                          AppSizedBox.space10h,
                          Obx(
                                () => CustomText(
                              textColor: textColor,
                              fontSize: 16.sp * themeController.fontSizeFactor.value,
                              title:
                              "Prophet Muhammad (PBUH) performed numerous miracles throughout his life, each one serving as a divine sign of his prophethood. Here are some of the most remarkable miracles:",
                              textAlign: TextAlign.start,
                            ),
                          ),
                          AppSizedBox.space10h,
                          Obx(
                                () => CustomText(
                              title: "The Holy Quran",
                              fontSize: 16.sp * themeController.fontSizeFactor.value,
                              textAlign: TextAlign.start,
                              textColor: AppColors.primary,
                            ),
                          ),
                          AppSizedBox.space10h,
                          Obx(
                                () => CustomText(
                              textColor: textColor,
                              fontSize: 16.sp * themeController.fontSizeFactor.value,
                              title:
                              "The Holy Quran is not only the first and greatest miracle of the Prophet Muhammad (PBUH), but it also stands as a timeless testament to divine revelation. As highlighted in Surah Al-Isra (17:88), the Quran challenges humanity and jinn alike to produce a work comparable to it, declaring their inability to do so even with mutual support \n\nThis miraculous nature of the Quran guarantees its preservation unchanged until the Day of Judgment, ensuring it remains a guiding light for Muslims across the globe, offering wisdom and direction in every aspect of life.",
                              textAlign: TextAlign.start,
                            ),
                          ),
                          AppSizedBox.space10h,
                          Obx(
                                () => CustomText(
                              title: "Splitting the Moon",
                              fontSize: 16.sp * themeController.fontSizeFactor.value,
                              textAlign: TextAlign.start,
                              textColor: AppColors.primary,
                            ),
                          ),
                          AppSizedBox.space10h,
                          Obx(
                                () => CustomText(
                              textColor: textColor,
                              fontSize: 16.sp * themeController.fontSizeFactor.value,
                              title:
                              "One of the most remarkable miracles attributed to Prophet Muhammad (peace be upon him) is the splitting of the moon, which took place in Mecca when the disbelievers challenged him to perform a sign of his prophethood. \n\nIn response to their demand, the Prophet ﷺ, guided by divine inspiration, pointed at the moon, which astonishingly split into two distinct halves. This supernatural occurrence remained visible for a significant time before the halves converged back together. \n\nAs narrated by Anas ibn Malik (may Allah be pleased with him), the people of Mecca witnessed this extraordinary event, which left them in disbelief, dismissing it as mere ‘magic.’ However, the miracle was a clear and powerful testament to the truth of Muhammad’s mission. \n\nWith the Hira’ mountain appearing prominently between the two split halves, it served as undeniable proof of his prophethood. This event not only solidified the faith of his followers but also challenged the skeptics to reconsider their understanding of the natural world, marking a pivotal moment in the history of Islam.",
                              textAlign: TextAlign.start,
                            ),
                          ),
                          AppSizedBox.space10h,
                          Obx(
                                () => CustomText(
                              title: "The Miracle of Food",
                              fontSize: 16.sp * themeController.fontSizeFactor.value,
                              textAlign: TextAlign.start,
                              textColor: AppColors.primary,
                            ),
                          ),
                          AppSizedBox.space10h,
                          Obx(
                                () => CustomText(
                              textColor: textColor,
                              fontSize: 16.sp * themeController.fontSizeFactor.value,
                              title:
                              "One remarkable miracle occurred when one of the Prophet Muhammad’s (peace be upon him) companions invited him to a meal intended for a small group. The Prophet accepted the invitation and, much to the host’s surprise, called upon a thousand of his companions to join them at the table. \n\nDespite the host’s concerns, Muhammad (peace be upon him) personally served the food, ensuring that each guest received their portion until everyone was satisfied. \n\nWhat was truly astonishing was that the tray of food remained as full at the end of the meal as it was at the beginning, with no visible decrease in the quantity! This miraculous event was a clear blessing from God and occurred multiple times throughout the Prophet’s life. \n\nIt exemplifies the generosity and compassion of the Prophet, highlighting that he received divine support in all aspects of his life, including sustenance.",
                              textAlign: TextAlign.start,
                            ),
                          ),
                          AppSizedBox.space10h,
                          Obx(
                                () => CustomText(
                              title: "Isra and Miraj: The Night Journey and Ascension",
                              fontSize: 16.sp * themeController.fontSizeFactor.value,
                              textAlign: TextAlign.start,
                              textColor: AppColors.primary,
                            ),
                          ),
                          AppSizedBox.space10h,
                          Obx(
                                () => CustomText(
                              textColor: textColor,
                              fontSize: 16.sp * themeController.fontSizeFactor.value,
                              title:
                              "The journey known as Isra, celebrated as a miraculous event, marks the night when the Prophet Muhammad (peace be upon him) was taken from Masjid al-Haram in Mecca to Masjid al-Aqsa in Jerusalem. As described in the Qur’an:",
                              textAlign: TextAlign.start,
                            ),
                          ),
                          AppSizedBox.space10h,
                          Container(
                            padding: EdgeInsets.all(10.w),
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(15.r),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 32.w,
                                  decoration: const BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage("assets/images/ayat_marker.png"),
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                  child: Center(
                                    child: Padding(
                                      padding: EdgeInsets.only(top: 6.h, bottom: 6.h),
                                      child: Text(
                                        "17",
                                        style: TextStyle(
                                          fontSize: 10.sp,
                                          color: textColor,
                                        ),
                                        textAlign: TextAlign.end,
                                      ),
                                    ),
                                  ),
                                ),

                                Obx(() => Expanded(
                                  child: CustomText(
                                    title: quran.getVerse(17, 1),
                                    fontSize: 16.sp * themeController.fontSizeFactor.value,
                                    textColor: AppColors.primary,
                                    textAlign: TextAlign.end,
                                    maxLines: 50000,
                                    textOverflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                ),
                              ],
                            )
                          ),
                          AppSizedBox.space10h,
                          Obx(() => CustomText(
                              textColor: AppColors.grey,
                              fontSize: 16.sp * themeController.fontSizeFactor.value,
                              title: quran.getVerseTranslation(17, 1),
                              textAlign: TextAlign.start,
                              textStyle: TextStyle(fontStyle: FontStyle.italic),
                            ),
                          ),
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
                          Obx(
                                () => Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50.r),
                                color: AppColors.primary.withOpacity(0.2),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(6.w),
                                child: Row(
                                  children: [
                                    IconButton(
                                      icon: Icon(controller.isPlaying.value ? Icons.pause : Icons.play_arrow,color: iconColor,),
                                      onPressed: () => controller.playPauseAudio(audioUrl),
                                    ),
                                    Expanded(
                                      child: Slider(
                                        min: 0,
                                        activeColor: AppColors.primary,
                                        inactiveColor: AppColors.grey.withOpacity(0.4),
                                        max: controller.duration.value.inMilliseconds.toDouble(),
                                        value: controller.position.value.inMilliseconds.toDouble(),
                                        onChanged: (value) => controller.seekAudio(value),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 8.0),
                                      child: CustomText(
                                        title: controller.formatDuration(controller.position.value),
                                        fontSize: 12.sp,
                                        textColor: textColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          AppSizedBox.space10h,
                          Obx(() => CustomText(
                              textColor: textColor,
                              fontSize: 16.sp * themeController.fontSizeFactor.value,
                              title:
                              "This journey occurred shortly before the Prophet’s migration to Medina and involved the Angel Gabriel. The distance traveled during this journey was humanly impossible to cover in such a brief time, underscoring its miraculous nature. \n\nFollowing the Isra, the Prophet Muhammad (peace be upon him) experienced the Miraj, where he ascended to the heavens. During this divine communion, he was given the opportunity to speak with God. Remarkably, when he returned to Mecca, it was still night, emphasizing the miraculous speed and nature of his journey. This extraordinary event solidifies the Prophet’s role as a messenger of God and serves as a profound testament to his spiritual significance in Islam.",
                              textAlign: TextAlign.start,
                            ),),
                          AppSizedBox.space10h,
                          Obx(() => CustomText(
                              title: "The Miracle of Water",
                              fontSize: 16.sp * themeController.fontSizeFactor.value,
                              textAlign: TextAlign.start,
                              textColor: AppColors.primary,
                            ),
                          ),
                          AppSizedBox.space10h,
                          Obx(
                                () => CustomText(
                              textColor: textColor,
                              fontSize: 16.sp * themeController.fontSizeFactor.value,
                              title: "During one of his travels, the Prophet Muhammad (peace be upon him) and his companions faced a critical situation when their water supply ran out. In this moment of need, the Prophet had a small container of water. When he placed his hand in it, a miraculous event occurred: \n\nwater began to gush forth between his fingers as if it were springing from multiple sources. His companions described how they were able to drink and perform their ablutions (ritual cleansing) with this abundant water. Remarkably, they noted that even if they had been a hundred thousand in number, the water would have sufficed for all, as they were only 1,500. \n\nSuch miraculous occurrences were not isolated events; they happened numerous times throughout the life of the Prophet Muhammad (peace be upon him), illustrating the divine support he received during his mission.",
                              textAlign: TextAlign.start,
                            ),
                          ),
                          AppSizedBox.space10h,
                          Obx(() => CustomText(
                            title: "The Miracle of Prayers Answered",
                            fontSize: 16.sp * themeController.fontSizeFactor.value,
                            textAlign: TextAlign.start,
                            textColor: AppColors.primary,
                          ),
                          ),
                          AppSizedBox.space10h,
                          Obx(() => CustomText(
                            title: "During a severe drought that gripped Arabia, one of the companions of the Prophet Muhammad (peace be upon him) earnestly requested him to pray for rain. In response, the Prophet raised his hands in supplication, and almost immediately, a cloud emerged on the horizon, moving toward them. One companion recalled, “When it reached the center of the sky, it spread out and began to rain.\n\nBy God, we could not see the sun for an entire week.” After seven continuous days of rain, another companion approached the Prophet and pleaded for him to ask God to cease the downpour, as it had become overwhelming.\n\nIn response, the Prophet again raised his hands in prayer, and shortly after, the sun began to break through as the clouds receded, providing relief to the people. This incident showcases the power of the Prophet’s prayers and the immediate response from Allah, demonstrating his special connection to the divine.",
                              textColor: textColor,
                              fontSize: 16.sp * themeController.fontSizeFactor.value,
                              textAlign: TextAlign.start,
                            ),
                          ),
                          AppSizedBox.space10h,
                          Obx(() => CustomText(
                            title: "Foretelling the Future",
                            fontSize: 16.sp * themeController.fontSizeFactor.value,
                            textAlign: TextAlign.start,
                            textColor: AppColors.primary,
                          ),
                          ),
                          AppSizedBox.space10h,
                          Obx(() => CustomText(
                            title: "Beyond his physical miracles, the Prophet Muhammad (peace be upon him) had the remarkable ability to foretell future events. One of his notable prophecies described a time when shepherds would compete in constructing tall buildings.\n\nThis prediction is clearly observable today, particularly in the Arab Gulf region. Until just a century ago, the Arabs in this area lived a much simpler, shepherd-like lifestyle compared to the rest of the world. However, with the discovery of oil in the mid-20th century, a wealth influx transformed the region, leading to an impressive skyline filled with skyscrapers.\n\nThis prophecy is just one of many that illustrate the Prophet’s extraordinary connection to God and affirm the authenticity of his prophethood. While recounting these miraculous events is significant, experiencing them firsthand would have had an even greater impact. In His infinite mercy and justice, God bestowed upon Muhammad (peace be upon him) an everlasting miracle that remains relevant to humanity throughout time: the final revelation, the Quran.\n\nThis divine text serves as a guide for all people, ensuring that the teachings and messages of Islam endure for generations to come.",
                            textColor: textColor,
                            fontSize: 16.sp * themeController.fontSizeFactor.value,
                            textAlign: TextAlign.start,
                          ),
                          ),
                          AppSizedBox.space10h,
                          Obx(() => CustomText(
                            title: "Healing the Sick",
                            fontSize: 16.sp * themeController.fontSizeFactor.value,
                            textAlign: TextAlign.start,
                            textColor: AppColors.primary,
                          ),
                          ),
                          AppSizedBox.space10h,
                          Obx(() => CustomText(
                            title: "The Prophet Muhammad (peace be upon him) demonstrated the power of divine healing through miraculous acts. One notable instance involved his cousin Ali, who was suffering from an eye infection. In this moment of need, the Prophet gently spat on Ali’s eyes while invoking blessings for his recovery.\n\nRemarkably, Ali was healed instantly, as if he had never experienced any ailment at all. This miraculous healing not only showcased the Prophet’s compassion but also highlighted his extraordinary connection with God, affirming his role as a healer and a messenger of divine mercy.",
                            textColor: textColor,
                            fontSize: 16.sp * themeController.fontSizeFactor.value,
                            textAlign: TextAlign.start,
                          ),
                          ),
                          AppSizedBox.space10h,
                          Obx(() => CustomText(
                            title: "The Tree Trunk Crying",
                            fontSize: 16.sp * themeController.fontSizeFactor.value,
                            textAlign: TextAlign.start,
                            textColor: AppColors.primary,
                          ),
                          ),
                          AppSizedBox.space10h,
                          Obx(() => CustomText(
                            title: "During his time, the Prophet Muhammad (peace be upon him) would often deliver his Friday sermons while standing on a tree trunk. When a companion offered to construct a proper pulpit for him, the Prophet accepted the gesture. \n\nHowever, during his first sermon from the new pulpit, a profound and sorrowful sound emerged from the tree trunk, resembling the cries of a child. Many companions witnessed this extraordinary event and were moved by the sound. \n\nSeeing the trunk in distress, the Prophet descended from the pulpit and embraced it until its weeping ceased. He later explained to his companions that the tree trunk was mourning for the religious teachings it missed hearing in its previous position. \n\nThis remarkable incident exemplified the deep emotional connection that existed between the Prophet and all of creation, highlighting one of the many miracles granted to him—an ability to evoke feelings even in inanimate objects.",
                            textColor: textColor,
                            fontSize: 16.sp * themeController.fontSizeFactor.value,
                            textAlign: TextAlign.start,
                          )),
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