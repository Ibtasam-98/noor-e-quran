import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:glowy_borders/glowy_borders.dart';
import 'package:intl/intl.dart';
import 'package:noor_e_quran/app/config/app_sizedbox.dart';
import 'package:noor_e_quran/app/modules/quran/views/quran_ayat_tafsir_detail_screen.dart';
import 'package:flutter/services.dart';
import 'package:quran/quran.dart' as quran;
import 'package:share_plus/share_plus.dart';
import 'package:just_audio/just_audio.dart';

import '../../../config/app_colors.dart';
import '../../../controllers/app_theme_switch_controller.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_formated_text.dart';
import '../../../widgets/custom_snackbar.dart';
import '../../../widgets/custom_text.dart'; // Import just_audio

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
  final AudioPlayer _audioPlayer = AudioPlayer(); // Use just_audio's AudioPlayer
  bool isPlaying = false;
  bool isLoading = false;
  String? audioUrl;
  double progress = 0.0;
  Duration _audioDuration = Duration.zero;
  String? translatedText;
  bool isUrdu = false;
  Set<int> bookmarkedAyahs = {};
  double _currentFontSize = 20.0; // Initial font size
  Duration _currentPosition = Duration.zero;

  @override
  void initState() {
    super.initState();
    _initAudioPlayer();
  }

  Future<void> _initAudioPlayer() async {
    try {
      setState(() {
        isLoading = true;
      });
      audioUrl = await quran.getAudioURLByVerse(widget.surahIndex, widget.ayahIndex);
      if (audioUrl != null) {
        await _audioPlayer.setUrl(audioUrl!);
        _audioPlayer.playerStateStream.listen((playerState) {
          if (mounted) {
            setState(() {
              isPlaying = playerState.playing;
            });
          }
        });

        _audioPlayer.durationStream.listen((duration) {
          if (mounted) {
            setState(() {
              _audioDuration = duration ?? Duration.zero;
            });
          }
        });

        _audioPlayer.positionStream.listen((position) {
          if (mounted) {
            setState(() {
              _currentPosition = position;
              if (_audioDuration.inMilliseconds > 0) {
                progress = _currentPosition.inMilliseconds / _audioDuration.inMilliseconds;
              } else {
                progress = 0.0;
              }
            });
          }
        });
      } else {
        if (mounted) {
          CustomSnackbar.show(
            title: "Error",
            subtitle: "Failed to fetch audio URL.",
            backgroundColor: Colors.red,
            textColor: Colors.white,
            icon: Icon(Icons.error_outline),
          );
        }
      }
    } catch (e) {
      print("Error initializing audio player: $e");
      if (mounted) {
        CustomSnackbar.show(
          title: "Error",
          subtitle: "Failed to initialize audio player.",
          backgroundColor: Colors.red,
          textColor: Colors.white,
          icon: Icon(Icons.error_outline),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  void handleAudioPlayback() async {
    if (isLoading || audioUrl == null) return;

    if (isPlaying) {
      await _audioPlayer.pause();
    } else {
      try {
        await _audioPlayer.play();
      } catch (e) {
        print("Error playing audio: $e");
        CustomSnackbar.show(
          title: "Error",
          subtitle: "Failed to play audio.",
          backgroundColor: Colors.red,
          textColor: Colors.white,
          icon: Icon(Icons.error_outline),
        );

      }
    }
  }

  final GetStorage _storage = GetStorage();
  final AppThemeSwitchController themeController = Get.put(AppThemeSwitchController());


  @override
  Widget build(BuildContext context){
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
          firstText: "Verse",
          secondText: " Detail",
          fontSize: 18.sp,
          firstTextColor: textColor,
          secondTextColor: AppColors.primary,
        ),
        backgroundColor: isDarkMode ? AppColors.black : AppColors.white,
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
              final key = 'savedAyah{widget.ayahIndex}';
              if (_storage.read(key) != null) {
                CustomSnackbar.show(
                  title: "Error",
                  subtitle: "This Ayah has already been saved!",
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  icon: Icon(Icons.error_outline),
                );
                return;
              }

              final now = DateTime.now();
              final currentDate = DateFormat('dd MMMM', 'en_US').format(now);
              final currentTime = DateFormat('hh:mm a').format(now);

              await _storage.write(key, {
                'timestamp': currentTime,
                'date': currentDate,
                'surahIndex': widget.surahIndex,
                'surahArabicName': widget.surahName,
                'surahLatinName': widget.surahLatinName,
                'ayahArabicText': widget.arabicText,
                'ayatNumber': widget.ayahIndex,
              });

              CustomSnackbar.show(
                title: "Success",
                subtitle: "Ayah saved successfully!",
                backgroundColor: Colors.green,
                textColor: Colors.white,
                icon: Icon(Icons.check),
              );
            },
            child: Padding(
              padding: EdgeInsets.only(right: 10.w),
              child: Icon(
                _storage.read('savedAyah_${widget.ayahIndex}') != null
                    ? Icons.bookmark
                    : Icons.bookmark_border,
                color: iconColor,
                size: 17.h,
              ),
            ),
          ),
          AppSizedBox.space5w,
          InkWell(
            splashColor: AppColors.transparent,
            highlightColor: AppColors.transparent,
            onTap: () {
              Share.share('${widget.arabicText} ${widget.translation ?? ""} ${widget.surahLatinName}');
            },
            child: Padding(
              padding: EdgeInsets.only(right: 5.w),
              child: Icon(
                Icons.share,
                color: iconColor,
                size: 17.h,
              ),
            ),
          ),
          AppSizedBox.space10w,
          InkWell(
            splashColor: AppColors.transparent,
            highlightColor: AppColors.transparent,
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  backgroundColor: AppColors.white,
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
                      onTap: () async {
                        Navigator.of(context).pop();
                      },
                      child: CustomButton(
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
              child: Icon(
                Icons.info_outline_rounded,
                color: iconColor,
                size: 20.sp,
              ),
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
                              onTap: () {
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
                        padding: const EdgeInsets.all(8.0),
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
                                  onTap: () {
                                    Get.to(QuranAyatTafsirDetailScreen(
                                      ayahNumber: widget.ayahIndex,
                                      surahNumber: widget.surahIndex,
                                      ayat: widget.arabicText,
                                      surahName: widget.surahLatinName,
                                      surahArabicName: widget.surahArabicName,
                                    ));
                                  },
                                  onLongPress: () {
                                    Clipboard.setData(ClipboardData(text: widget.arabicText));
                                    CustomSnackbar.show(
                                      title: "Success",
                                      subtitle: "Arabic Text copied to clipboard",
                                      icon: const Icon(Icons.check),
                                      backgroundColor: AppColors.green,
                                      textColor: AppColors.white,
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
                            title: "Translation",
                            fontFamily: 'grenda',
                          ),
                          AppSizedBox.space5w,
                          CustomText(
                            textColor: textColor,
                            fontSize: _currentFontSize,
                            maxLines: 50000,
                            textAlign: widget.textAlign,
                            title: (widget.translation?.toString() ?? "").isEmpty
                                ? "Enable translation from Quran setting!"
                                : widget.translation.toString()!,
                          ),],
                      ),
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
                        stops: const [0, 1],
                      ),
                    ),
                  ),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomText(
                          title: widget.surahName,
                          fontSize: 24.sp,
                          textColor: textColor,
                        ),
                        AppSizedBox.space10h,
                        CustomText(
                          title: 'Surah Number ${widget.surahIndex} | Ayat ${widget.ayahIndex}',
                          fontSize: 17.sp,
                          textColor: textColor,
                        ),
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  formatDuration(_currentPosition),
                                  style: TextStyle(color: textColor, fontSize: 16.0),
                                ),
                                Text(
                                  formatDuration(_audioDuration),
                                  style: TextStyle(color: textColor, fontSize: 16.0),
                                ),
                              ],
                            ),
                            Slider(
                              activeColor: AppColors.white,
                              inactiveColor: AppColors.primary,
                              value: progress.clamp(0.0, 1.0),
                              min: 0.0,
                              max: 1.0,
                              onChanged: (newValue) {
                                setState(() {
                                  progress = newValue;
                                  _currentPosition = _audioDuration * newValue;
                                });
                                _audioPlayer.seek(_currentPosition);
                              },
                            ),
                            // Play/Pause Button
                            AnimatedGradientBorder(
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
                              borderRadius: const BorderRadius.all(Radius.circular(555.0)),
                              child: Padding(
                                padding: EdgeInsets.all(8.w),
                                child: CircleAvatar(
                                  radius: 30.0,
                                  backgroundColor: AppColors.primary,
                                  child: isLoading
                                      ? const CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.white),
                                  )
                                      : IconButton(
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
        color: isDarkMode ? AppColors.black : AppColors.white,
        child: Row(
          children: [
            CustomText(
              textColor: textColor,
              fontSize: 15.sp,
              title: "Font Size",
            ),
            Expanded(
              child: Slider(
                value: _currentFontSize.clamp(12.0, 60.0),
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
        ),
      ),
    );
  }
}