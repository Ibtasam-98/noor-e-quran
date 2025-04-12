import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:glowy_borders/glowy_borders.dart';
import 'package:marquee/marquee.dart';
import 'package:noor_e_quran/app/config/app_colors.dart';
import 'package:noor_e_quran/app/config/app_sizedbox.dart';
import '../../widgets/custom_text.dart';
import 'package:just_audio/just_audio.dart'; // Import just_audio

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
  final AudioPlayer _audioPlayer = AudioPlayer(); // Use just_audio's AudioPlayer
  bool isPlaying = false;
  Duration _currentPosition = Duration.zero;
  Duration _totalDuration = Duration.zero;

  @override
  void initState() {
    super.initState();
    _initAudioPlayer();
  }

  Future<void> _initAudioPlayer() async {
    try {
      await _audioPlayer.setAsset(widget.audioUrl); // Use setAsset with the asset path

      _audioPlayer.playerStateStream.listen((playerState) {
        setState(() {
          isPlaying = playerState.playing;
        });
      });

      _audioPlayer.durationStream.listen((duration) {
        if (mounted) {
          setState(() {
            _totalDuration = duration ?? Duration.zero;
          });
        }
      });

      _audioPlayer.positionStream.listen((position) {
        if (mounted) {
          setState(() {
            _currentPosition = position;
          });
        }
      });
    } catch (e) {
      print("Error initializing audio player: $e");
    }
  }
  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  // Play or Pause Audio
  void toggleAudio() async {
    if (isPlaying) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.play();
    }
  }

  // Format the time from Duration to mm:ss
  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final String minutes = twoDigits(duration.inMinutes.remainder(60));
    final String seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
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
                Colors.black.withOpacity(0.9), // Dark shadow at bottom
                Colors.transparent, // Fade to transparent at top
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
            title: isPlaying
                ? Container(
              height: 30,
              child: Marquee(
                text: "Playing " + " " + widget.title + " ( " + widget.latinName + " ) ",
                style: TextStyle(color: AppColors.white, fontSize: 20.sp, fontFamily: 'grenda'),
                scrollAxis: Axis.horizontal,
                crossAxisAlignment: CrossAxisAlignment.start,
                blankSpace: 200.0,
                velocity: 50.0,
              ),
            )
                : CustomText(
              title: widget.latinName,
              fontSize: 25.sp,
              textColor: AppColors.white,
            ),
          ),
          body: Stack(
            children: [
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomText(
                      title: widget.title,
                      fontSize: widget.titleFontSize,
                      maxLines: 2,
                      capitalize: true,
                      textColor: AppColors.white,
                    ),
                    CustomText(
                      title: widget.latinName,
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
                          value: _currentPosition.inMilliseconds.toDouble().clamp(0, _totalDuration.inMilliseconds.toDouble()),
                          activeColor: AppColors.primary,
                          max: _totalDuration.inMilliseconds.toDouble(),
                          onChanged: (value) {
                            setState(() {
                              _currentPosition = Duration(milliseconds: value.toInt());
                            });
                            _audioPlayer.seek(Duration(milliseconds: value.toInt()));
                          },
                        ),
                        AppSizedBox.space15h,
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CustomText(
                                title: formatDuration(_currentPosition),
                                textColor: AppColors.white,
                                fontSize: 16.sp,
                              ),
                              CustomText(
                                title: formatDuration(_totalDuration),
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
                        borderSize: isPlaying ? 0.5 : 0.0,
                        glowSize: isPlaying ? 0.5 : 0.0,
                        gradientColors: isPlaying
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
      ],
    );
  }
}