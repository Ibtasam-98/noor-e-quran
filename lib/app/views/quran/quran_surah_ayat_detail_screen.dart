

import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:glowy_borders/glowy_borders.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:marquee/marquee.dart';
import 'package:noor_e_quran/app/config/app_sizedbox.dart';
import 'package:noor_e_quran/app/views/quran/quran_ayat_tafsir_detail_screen.dart';
import 'package:quran/quran.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/services.dart';
import 'package:quran/quran.dart' as quran;
import 'package:share_plus/share_plus.dart';
import '../../config/app_colors.dart';
import '../../controllers/app_theme_switch_controller.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_formated_text.dart';
import '../../widgets/custom_snackbar.dart';
import '../../widgets/custom_text.dart';


class QuranSurahAyatDetailsScreen extends StatefulWidget {
  final String arabicText;
  final int ayahIndex;
  final int surahIndex;
  final String surahName;
  final String surahLatinName;
  final String surahArabicName;
  final String? translation;
  final TextAlign textAlign;

  QuranSurahAyatDetailsScreen({
    super.key,
    required this.arabicText,
    required this.ayahIndex,
    required this.surahIndex,
    required this.surahName,
    required this.surahLatinName,
    this.translation,
    required this.surahArabicName,
    required this.textAlign,
  });

  @override
  State<QuranSurahAyatDetailsScreen> createState() => _QuranSurahAyatDetailsScreenState();
}

class _QuranSurahAyatDetailsScreenState extends State<QuranSurahAyatDetailsScreen> {
  late AudioPlayer audioPlayer;
  bool isPlaying = false;
  bool isLoading = false;
  String? audioUrl;
  double progress = 0.0;
  Duration? audioDuration;
  String? translatedText;
  bool isUrdu = false;
  Set<int> bookmarkedAyahs = {};
  double _currentFontSize = 20.0; // Initial font size
  Duration currentPosition = Duration.zero;

  @override
  void initState() {
    super.initState();

    audioPlayer = AudioPlayer();
    audioPlayer.onPositionChanged.listen((Duration duration) {
      if (audioDuration != null) {
        setState(() {
          progress = duration.inMilliseconds / audioDuration!.inMilliseconds;
        });
      }
    });

    audioPlayer.onDurationChanged.listen((Duration duration) {
      setState(() {
        audioDuration = duration;
      });
    });
  }


  Future<void> _fetchAudioUrl() async {
    try {
      // Fetch audio URL for the specific verse using quran package
      audioUrl = await quran.getAudioURLByVerse(widget.surahIndex, widget.ayahIndex);
    } catch (e) {
      print("Error fetching audio URL: $e");
    }
  }


  void handleAudioPlayback() async {
    if (audioUrl == null) {
      await _fetchAudioUrl();  // Fetch audio URL if not already fetched
    }

    if (audioUrl != null) {
      if (isPlaying) {
        await audioPlayer.pause();  // Pause audio
        if (mounted) {
          setState(() {
            isPlaying = false;  // Set playing state to false
          });
        }
      } else {
        await audioPlayer.stop();  // Stop any current audio
        await audioPlayer.play(UrlSource(audioUrl!));  // Start audio playback
        if (mounted) {
          setState(() {
            isPlaying = true;  // Set playing state to true
          });
        }

        // Real-time position updates
        audioPlayer.onPositionChanged.listen((Duration duration) {
          if (mounted) {
            setState(() {
              currentPosition = duration;
              if (audioDuration != null) {
                progress = currentPosition.inMilliseconds / audioDuration!.inMilliseconds;
              }
            });
          }
        });

        // Update total audio duration when changed
        audioPlayer.onDurationChanged.listen((Duration duration) {
          if (mounted) {
            setState(() {
              audioDuration = duration;
            });
          }
        });

        // Audio completion listener
        audioPlayer.onPlayerStateChanged.listen((state) {
          if (state == PlayerState.completed) {
            if (mounted) {
              setState(() {
                isPlaying = false;
                progress = 0.0;
              });
            }
          }
        });
      }
    }
  }


  final GetStorage _storage = GetStorage();

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }
  final AppThemeSwitchController themeController = Get.put(AppThemeSwitchController());

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = themeController.isDarkMode.value;
    final iconColor = isDarkMode ? AppColors.white : AppColors.black;
    final textColor = isDarkMode ? AppColors.white : AppColors.black;
    return Scaffold(
      backgroundColor: themeController.isDarkMode.value ? AppColors.black : AppColors.white,
      appBar: AppBar(
        surfaceTintColor: AppColors.transparent,
        foregroundColor: AppColors.transparent,
        centerTitle: false,
        title: CustomText(
          firstText: "Verse",
          secondText: " Detail",
          fontSize: 18.sp,
          firstTextColor: isDarkMode ? AppColors.white : AppColors.black,
          secondTextColor: AppColors.primary,
        ),
        backgroundColor: themeController.isDarkMode.value ? AppColors.black : AppColors.white,
        leading: IconButton(
          icon: Icon(Icons.west, color: iconColor),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          InkWell(
            splashColor: AppColors.transparent,
            highlightColor: AppColors.transparent,
            onTap: () async {
              if (_storage.read('savedAyah_${widget.ayahIndex}') != null) {
                // Show error snackbar
                Get.snackbar(
                  "Error",
                  "This Ayah has already been saved!",
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                  duration: Duration(seconds: 2),
                );
                return;
              }

              // Get current date and time
              String currentDate = DateFormat('dd MMMM yyyy').format(DateTime.now());
              String currentTime = DateFormat('hh:mm a').format(DateTime.now());

              // Save the Ayah details in GetStorage
              await _storage.write('savedAyah_${widget.ayahIndex}', {
                'timestamp': currentTime,
                'date': currentDate,
                'surahIndex': widget.surahIndex,
                'surahArabicName': widget.surahName,
                'surahLatinName': widget.surahLatinName,
                'ayahArabicText': widget.arabicText,
                'ayatNumber': widget.ayahIndex,
              });

              // Show success snackbar
              Get.snackbar(
                "Success",
                "Ayah saved successfully!",
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.green,
                colorText: Colors.white,
                duration: Duration(seconds: 2),
              );

            },
            child: Padding(
              padding:  EdgeInsets.only(right:10.w),
              child: Icon(
                _storage.read('savedAyah_${widget.ayahIndex}') != null
                    ? Icons.bookmark
                    : Icons.bookmark_border,
                color: iconColor, size: 17.h,
              ),
            ),
          ),
          AppSizedBox.space5w,
          InkWell(
            splashColor: AppColors.transparent,
            highlightColor: AppColors.transparent,
            onTap: (){
              Share.share('Check out this Ayah: ${widget.arabicText} ${widget.translation} ${widget.surahLatinName}');
            },
            child: Padding(
              padding:  EdgeInsets.only(right:5.w),
              child: Icon(
                Icons.share,color: iconColor, size: 17.h,
              ),
            ),
          ),
          AppSizedBox.space10w,
          InkWell(
            splashColor: AppColors.transparent,
            highlightColor: AppColors.transparent,
            onTap: (){
              showDialog(
                context: context,
                builder: (context) =>  AlertDialog(
                  backgroundColor:  AppColors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  title: CustomText(
                    title: 'Information',
                    fontSize: 20.sp,
                    textColor: AppColors.primary,
                    textAlign: TextAlign.start,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'grenda',
                  ),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        title: 'Long-pressing ayat will copy its Text.',
                        fontSize: 14.sp,
                        textColor: AppColors.black,
                        maxLines: 15,
                        textAlign: TextAlign.start,
                        textOverflow: TextOverflow.ellipsis,
                      ),
                      AppSizedBox.space10h,
                      CustomText(
                        title: 'You can use two fingers to zoom in on the Arabic Text or adjust the font size using the slider below.',
                        fontSize: 14.sp,
                        textColor: AppColors.black,
                        maxLines: 15,
                        textAlign: TextAlign.start,
                        textOverflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                  actions: [
                    InkWell(
                      onTap:() async{
                        Navigator.of(context).pop();
                      },child:CustomButton(
                      height: 40.h,
                      haveBgColor: true,
                      borderRadius: 10,
                      btnTitle: 'Got It',
                      btnTitleColor: AppColors.white,
                      btnBorderColor: AppColors.primary,
                      bgColor: AppColors.primary,
                    ),
                    )
                  ],
                ),
              );
            },
            child: Padding(
              padding: EdgeInsets.only(right: 20.w),
              child: Icon(Icons.info_outline_rounded,color: iconColor,size: 20.sp,),
            ),

          ),
        ],
      ),

      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.only(left: 10.w, right: 10.w, bottom: 25.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              textColor: textColor,
                              fontSize: 20.sp,
                              title: widget.surahLatinName,
                              fontFamily: 'grenda',
                              capitalize: true,
                            ),
                            CustomText(
                              textColor: AppColors.primary,
                              fontSize: 13.sp,
                              title: 'Surah Number ${widget.surahIndex} | Ayat ${widget.ayahIndex}',
                              fontFamily: 'quicksand',
                              capitalize: true,
                              fontWeight: FontWeight.bold,
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            CustomText(
                              textColor: textColor,
                              fontSize: 18.sp,
                              title: widget.surahArabicName,
                              fontFamily: 'grenda',
                              capitalize: true,
                            ),
                            InkWell(
                              onTap: (){
                                Get.to(QuranAyatTafsirDetailScreen(
                                  ayahNumber: widget.ayahIndex,
                                  surahNumber: widget.surahIndex,
                                  ayat: widget.arabicText,
                                  surahName: widget.surahLatinName,
                                  surahArabicName: widget.surahArabicName,
                                ));

                              },
                              child: CustomText(
                                textColor: AppColors.primary,
                                fontSize: 15.sp,
                                title: "View Tafseer",
                                fontFamily: 'quicksand',
                                capitalize: true,
                                fontWeight: FontWeight.bold,
                                textAlign: TextAlign.end,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                    AppSizedBox.space10h,
                    Container(
                      padding: EdgeInsets.only(right: 10.w, top: 10.h, bottom: 10.h),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.25),
                        borderRadius: BorderRadius.circular(15.r),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            AppSizedBox.space5w,
                            Container(
                              width: 32.w,
                              height: 32.h,
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage("assets/images/ayat_marker.png"),
                                  fit: BoxFit.contain,
                                ),
                              ),
                              child: Center(
                                child: Padding(
                                  padding: EdgeInsets.only(top: 3.h, bottom: 3.h),
                                  child: Text(
                                    widget.ayahIndex.toString(),
                                    style: TextStyle(
                                      fontSize: 13.sp,
                                      color: textColor,
                                    ),
                                    textAlign: TextAlign.end,
                                  ),
                                ),
                              ),
                            ),
                            AppSizedBox.space5w,
                            Expanded(
                              child: InteractiveViewer(
                                maxScale: 10.0,
                                minScale: 1.0,
                                child: InkWell(
                                  splashColor: AppColors.transparent,
                                  hoverColor: AppColors.transparent,
                                  highlightColor: AppColors.transparent,
                                  onTap: (){
                                    Get.to(QuranAyatTafsirDetailScreen(
                                      ayahNumber: widget.ayahIndex,
                                      surahNumber: widget.surahIndex,
                                      ayat: widget.arabicText,
                                      surahName: widget.surahLatinName,
                                      surahArabicName: widget.surahArabicName,
                                    ));
                                  },
                                  onLongPress: (){
                                    String arabicText = widget.arabicText;
                                    Clipboard.setData(ClipboardData(text: arabicText));
                                    CustomSnackbar.show(
                                        title:"Success",
                                        subtitle: "Arabic Text copied to clipboard",
                                        icon: Icon(Icons.check),
                                        backgroundColor: AppColors.green,
                                        textColor: AppColors.white
                                    );
                                  },
                                  child: Text(
                                    widget.arabicText,
                                    style: TextStyle(
                                      fontSize: _currentFontSize,
                                      color: textColor,
                                    ),
                                    textAlign: TextAlign.end,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    AppSizedBox.space10h,

                    Padding(
                        padding: EdgeInsets.only(left: 10.w, right: 10.w),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(
                                textColor: AppColors.primary,
                                fontSize: _currentFontSize,
                                maxLines: 2,
                                textAlign: TextAlign.start,
                                title:  "Translation",
                                fontFamily: 'grenda',
                              ),
                              AppSizedBox.space5w,
                              CustomText(
                                textColor: isDarkMode ? AppColors.white : AppColors.black,
                                fontSize: _currentFontSize,
                                maxLines: 50000,
                                textAlign: widget.textAlign,
                                title: (widget.translation?.toString() ?? "").isEmpty
                                    ? "Enable translation from Quran setting!" // Your default text here
                                    : widget.translation.toString()!,
                              ),
                            ]
                        )
                    ),
                  ],
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Stack(
              children: [
                Container(
                  height: 150.h,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(isDarkMode ? 'assets/images/quran_bg_dark.jpg' : 'assets/images/quran_bg_light.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: isDarkMode
                            ? [
                          AppColors.black,
                          AppColors.black.withOpacity(0.5),
                        ]
                            : [
                          AppColors.white,
                          AppColors.white.withOpacity(0.04),
                        ],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        stops: [0, 1],
                      ),
                    ),
                  ),
                ),
                Center(
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomText(
                          title:widget.surahName,
                          fontSize: 24.sp,
                          textColor: textColor,
                        ),
                        AppSizedBox.space10h,
                        CustomText(
                          title:'Surah Number ${widget.surahIndex} | Ayat ${widget.ayahIndex}',
                          fontSize: 17.sp,
                          textColor: textColor,
                        ),
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  formatDuration(currentPosition),
                                  style: TextStyle(color: textColor, fontSize: 16.0),
                                ),
                                Text(
                                  audioDuration != null
                                      ? formatDuration(audioDuration!)
                                      : '00:00',
                                  style: TextStyle(color: textColor, fontSize: 16.0),
                                ),
                              ],
                            ),
                            Slider(
                              activeColor: AppColors.white,
                              inactiveColor: AppColors.primary,
                              value: progress,
                              min: 0.0,
                              max: 1.0,
                              onChanged: (newValue) {
                                setState(() {
                                  progress = newValue;
                                });
                                if (audioDuration != null) {
                                  final position = audioDuration!.inMilliseconds * newValue;
                                  audioPlayer.seek(Duration(milliseconds: position.toInt()));
                                }
                              },
                            ),
                            // Play/Pause Button
                            AnimatedGradientBorder(
                              borderSize: isPlaying ? 0.5 : 0.0, // Conditional size for animation
                              glowSize: isPlaying ? 0.5 : 0.0, // Conditional glow for animation
                              gradientColors: isPlaying
                                  ? const [
                                Color(0xFFFFD700), // Golden Yellow
                                Color(0xFFFFA500), // Soft Orange
                                Color(0xFFF4E2D8), // Light Cream (for a smooth transition)
                                Color(0xFFE09F3E), // Warm Honey
                                Color(0xFFB65D25), // Muted Brownish Orange
                              ]
                                  : [AppColors.primary], // Static color when not playing
                              borderRadius: BorderRadius.all(Radius.circular(555.r)),
                              child: Padding(
                                padding: EdgeInsets.all(8.w),
                                child:  CircleAvatar(
                                  radius: 30.0,
                                  backgroundColor: AppColors.primary,
                                  child: IconButton(
                                    onPressed: handleAudioPlayback,
                                    icon: Icon(
                                      isPlaying ? Icons.pause : Icons.play_arrow,
                                      color: AppColors.white,
                                    ),
                                    iconSize: 30.0,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
          color: themeController.isDarkMode.value ? AppColors.black : AppColors.white,
          child: Row(
            children: [
              CustomText(
                textColor: textColor,
                fontSize: 15.sp,
                title: "Font Size",
              ),
              Expanded(
                child: Slider(
                  value: _currentFontSize,
                  min: 12.0,
                  max: 60.0,
                  divisions: 14,
                  label: "${_currentFontSize.toStringAsFixed(1)}",
                  activeColor: AppColors.primary,
                  inactiveColor: AppColors.primary,
                  onChanged: (value) {
                    setState(() {
                      _currentFontSize = value;
                    });
                  },
                ),
              ),
            ],
          )
      ),
    );
  }
}