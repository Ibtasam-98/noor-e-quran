import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:glowy_borders/glowy_borders.dart';
import 'package:marquee/marquee.dart';
import 'package:noor_e_quran/app/config/app_colors.dart';
import 'package:noor_e_quran/app/config/app_sizedbox.dart';
import '../../controllers/audio_player_controller.dart';
import '../../widgets/custom_snackbar.dart';
import '../../widgets/custom_text.dart';

class AudioPlayerScreen extends StatelessWidget {
  final String title;
  final String latinName;
  final String audioUrl;
  final double titleFontSize;

  AudioPlayerScreen({
    super.key,
    required this.title,
    required this.latinName,
    required this.audioUrl,
    required this.titleFontSize,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AudioPlayerController(
      title: title,
      latinName: latinName,
      audioUrl: audioUrl,
      titleFontSize: titleFontSize,
    ));

    // Listen for audio completion and display Snackbar
    controller.audioPlayer.onPlayerComplete.listen((_) {
      CustomSnackbar.show(
        backgroundColor: AppColors.green,
        title: "Ma Sha Allah",
        subtitle: "You have listened complete ${controller.title}",
        icon: Icon(Icons.check_circle, color: AppColors.white),
      );
    });

    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/quran_bg_audio.jpg"),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                Colors.black.withOpacity(0.9),
                Colors.transparent,
              ],
            ),
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.west, color: Colors.white),
              onPressed: () {
                Get.back();
              },
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: controller.isPlaying.value
                ? Container(
              height: 30,
              width: Get.width,
              child: Marquee(
                text: "Playing  ${controller.title} " " ${controller.latinName}",
                style: TextStyle(color: AppColors.white, fontSize: 17.sp,),
                scrollAxis: Axis.horizontal,
                numberOfRounds: null, // Infinite scrolling
                crossAxisAlignment: CrossAxisAlignment.start,
                blankSpace: 200.0,
                velocity: 50.0,
              )
            )
                : CustomText(
              title: "${controller.title} ${controller.latinName}",
              fontSize: 20.sp,
              textColor: AppColors.white,
            ),
          ),
          body: Obx(
                () => Stack(
              children: [
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomText(
                        title: controller.title,
                        fontSize: controller.titleFontSize,
                        maxLines: 2,
                        capitalize: true,
                        textColor: AppColors.white,
                      ),
                      CustomText(
                        title: controller.latinName,
                        fontSize: 20.sp,
                        capitalize: true,
                        maxLines: 2,
                        textColor: AppColors.white,
                      ),
                      AppSizedBox.space20h,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Slider(
                            value: controller.currentPosition.value.clamp(0.0, controller.totalDuration.value), // Add clamp here
                            activeColor: AppColors.primary,
                            max: controller.totalDuration.value,
                            onChanged: (value) {
                              controller.currentPosition.value = value;
                              controller.audioPlayer.seek(Duration(milliseconds: value.toInt()));
                            },
                          ),
                          AppSizedBox.space15h,
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CustomText(
                                  title: controller.formatDuration(controller.currentPosition.value),
                                  textColor: AppColors.white,
                                  fontSize: 16.sp,
                                ),
                                CustomText(
                                  title: controller.formatDuration(controller.totalDuration.value),
                                  textColor: AppColors.white,
                                  fontSize: 16.sp,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      AppSizedBox.space25h,
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          if (controller.isLoading.value)
                            CircularProgressIndicator(color: AppColors.white)
                          else
                            InkWell(
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              onTap: controller.toggleAudio,
                              child: AnimatedGradientBorder(
                                borderSize: controller.isPlaying.value ? 0.5 : 0.0,
                                glowSize: controller.isPlaying.value ? 0.5 : 0.0,
                                gradientColors: controller.isPlaying.value
                                    ? const [
                                  Color(0xFFFFD700),
                                  Color(0xFFFFA500),
                                  Color(0xFFF4E2D8),
                                  Color(0xFFE09F3E),
                                  Color(0xFFB65D25),
                                ]
                                    : [AppColors.primary],
                                borderRadius: BorderRadius.all(Radius.circular(555.r)),
                                child: Padding(
                                  padding: EdgeInsets.all(8.w),
                                  child: CircleAvatar(
                                    backgroundColor: AppColors.primary,
                                    radius: 45.r,
                                    child: Icon(
                                      controller.isPlaying.value ? Icons.pause : Icons.play_arrow,
                                      size: 50,
                                      color: AppColors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}