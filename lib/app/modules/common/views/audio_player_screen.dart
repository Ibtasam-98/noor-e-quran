
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:glowy_borders/glowy_borders.dart';
import 'package:marquee/marquee.dart';
import 'package:noor_e_quran/app/config/app_sizedbox.dart';
import 'package:noor_e_quran/app/controllers/app_theme_switch_controller.dart';

import '../../../config/app_colors.dart';
import '../../../widgets/custom_text.dart';



class AudioPlayerScreen extends StatefulWidget {
  final String title;
  final String latinName;
  final String audioUrl;
  double titleFontSize;

  AudioPlayerScreen({
    super.key,
    this.title = '',
    this.latinName = '',
    required this.audioUrl,
    required this.titleFontSize,
  });

  @override
  _AudioPlayerScreenState createState() => _AudioPlayerScreenState();
}

class _AudioPlayerScreenState extends State<AudioPlayerScreen> {
  AudioPlayer audioPlayer = AudioPlayer();
  bool isPlaying = false;
  double currentPosition = 0.0;
  double totalDuration = 0.0;

  @override
  void initState() {
    super.initState();

    audioPlayer.onDurationChanged.listen((Duration duration) {
      if (mounted) {  // Check if the widget is still mounted
        setState(() {
          totalDuration = duration.inMilliseconds.toDouble();
        });
      }
    });

    audioPlayer.onPositionChanged.listen((Duration position) {
      if (mounted) {  // Check if the widget is still mounted
        setState(() {
          currentPosition = position.inMilliseconds.toDouble();
        });
      }
    });

    audioPlayer.onPlayerComplete.listen((_) {
      if (mounted) {  // Check if the widget is still mounted
        setState(() {
          isPlaying = false;
        });
      }
    });
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  // Play or Pause Audio
  void toggleAudio() async {
    // Check internet connection before attempting to play audio
    // var connectivityResult = await (Connectivity().checkConnectivity());
    //
    // if (connectivityResult == ConnectivityResult.none) {
    //   // Show dialog to prompt user to connect to the internet
    //   _showNoInternetDialog();
    //   return;
    // }

    try {
      if (isPlaying) {
        await audioPlayer.pause();
      } else {
        if (widget.audioUrl.startsWith('http') || widget.audioUrl.startsWith('https')) {
          await audioPlayer.play(UrlSource(widget.audioUrl));
        } else {
          await audioPlayer.play(AssetSource(widget.audioUrl));
        }
      }

      setState(() {
        isPlaying = !isPlaying;
      });
    } catch (e) {
      print("Error playing audio: $e");
    }
  }

  // Format the time from milliseconds to mm:ss
  String formatDuration(double duration) {
    int minutes = (duration / 1000 / 60).floor();
    int seconds = ((duration / 1000) % 60).floor();
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  // Show a dialog if no internet connection
  void _showNoInternetDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,  // Prevent dismissing the dialog
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('No Internet Connection'),
          content: Text('Please connect to the internet and try again.'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  final AppThemeSwitchController themeController = Get.put(AppThemeSwitchController());

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(themeController.isDarkMode.value ? 'assets/images/quran_bg_dark.jpg' : 'assets/images/quran_bg_light.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: AppColors.transparent,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.west, color: Colors.white),
            onPressed: () {
              Get.back();
            },
          ),
          backgroundColor: Colors.transparent,
          centerTitle: false,
          elevation: 0,
          title: isPlaying
              ? Container(
            height: 30,  // Set a fixed height for the Marquee
            child: Marquee(
              text: "Playing " + widget.title + " " + widget.latinName,
              style: TextStyle(color: AppColors.white, fontSize: 20.sp, fontFamily: 'grenda'),
              scrollAxis: Axis.horizontal,
              crossAxisAlignment: CrossAxisAlignment.start,
              blankSpace: 200.0,
              velocity: 50.0,
            ),
          )
              : CustomText(
            title: widget.latinName,
            fontSize: 18.sp,
            textColor: AppColors.white,
          ),
        ),
        body: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Arabic and Latin Name
                  CustomText(
                    title: widget.title,
                    fontSize: widget.titleFontSize,
                    maxLines: 2,
                    textColor: AppColors.white,
                  ),
                  CustomText(
                    title: widget.latinName,
                    fontSize: 20.sp,
                    maxLines: 2,
                    textColor: AppColors.white,
                  ),
                  AppSizedBox.space20h,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Audio Progress Slider
                      Slider(
                        value: currentPosition,
                        activeColor: AppColors.primary,
                        max: totalDuration,
                        onChanged: (value) {
                          setState(() {
                            currentPosition = value;
                          });
                          audioPlayer.seek(Duration(milliseconds: value.toInt()));
                        },
                      ),
                      AppSizedBox.space15h,
                      // Duration labels (Start and End)
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomText(
                              title: formatDuration(currentPosition),
                              textColor: AppColors.white,
                              fontSize: 16.sp,
                            ),
                            CustomText(
                              title: formatDuration(totalDuration),
                              textColor: AppColors.white,
                              fontSize: 16.sp,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  AppSizedBox.space25h,
                  InkWell(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    onTap: toggleAudio,
                    child: AnimatedGradientBorder(
                      borderSize: isPlaying ? 0.5 : 0.0, // Conditional size for animation
                      glowSize: isPlaying ? 0.5 : 0.0, // Conditional glow for animation
                      gradientColors: isPlaying
                          ? const [
                        Color(0xFFFFD700), // Golden Yellow
                        Color(0xFFFFA500), // Soft Orange
                        Color(0xFFF4E2D8), // Light Cream
                        Color(0xFFE09F3E), // Warm Honey
                        Color(0xFFB65D25), // Muted Brownish Orange
                      ]
                          : [AppColors.primary], // Static color when not playing
                      borderRadius: BorderRadius.all(Radius.circular(555.r)),
                      child: Padding(
                        padding: EdgeInsets.all(8.w),
                        child: CircleAvatar(
                          backgroundColor: AppColors.primary,
                          radius: 45.r,
                          child: Icon(
                            isPlaying ? Icons.pause : Icons.play_arrow,
                            size: 50,
                            color: AppColors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
