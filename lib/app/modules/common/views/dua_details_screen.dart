


import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:glowy_borders/glowy_borders.dart';
import 'package:line_icons/line_icons.dart';
import 'package:share_plus/share_plus.dart';
import '../../../config/app_colors.dart';
import '../../../config/app_sizedbox.dart';
import '../../../controllers/app_theme_switch_controller.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_frame.dart';
import '../../../widgets/custom_snackbar.dart';
import '../../../widgets/custom_text.dart';

class DuaDetailCommonScreen extends StatefulWidget {
  String engFirstTitle, arabicDua, duaTranslation, duaUrduTranslation, audioUrl;
  String? engSecondTitle;
  String? latinTitle;
  String? surahName, verseNumber, surahNumber;
  bool showAudiotWidgets;
  bool isComingFromAllahNameScreen;
  DuaDetailCommonScreen({
    required this.arabicDua,
    required this.audioUrl,
    required this.duaTranslation,
    required this.duaUrduTranslation,
    required this.engFirstTitle,
    this.latinTitle,
    this.engSecondTitle,
    required this.showAudiotWidgets,
    this.surahNumber,
    this.verseNumber,
    this.surahName,
    required this.isComingFromAllahNameScreen
  });

  @override
  State<DuaDetailCommonScreen> createState() => _DuaDetailCommonScreenState();
}

class _DuaDetailCommonScreenState extends State<DuaDetailCommonScreen> {
  final AppThemeSwitchController themeController = Get.put(AppThemeSwitchController());
  AudioPlayer audioPlayer = AudioPlayer();
  bool isPlaying = false;
  bool isLoading = false;
  String? audioUrl;
  double progress = 0.0;
  Duration? audioDuration;
  String? translatedText;
  bool isUrdu = false;
  Set<int> bookmarkedAyahs = {};
  double _currentFontSize = 20.0; // Initial font size
  double currentPosition = 0.0;
  double totalDuration = 0.0;


  void toggleAudio() async {
    try {
      if (isPlaying) {
        await audioPlayer.pause();
        setState(() {
          isPlaying = false;
        });
      } else {
        setState(() {
          isLoading = true;
        });
        await audioPlayer.play(AssetSource(widget.audioUrl));
        setState(() {
          isPlaying = true;
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error playing audio: $e");
    }
  }


  @override
  void initState() {
    super.initState();

    audioPlayer.onDurationChanged.listen((Duration duration) {
      setState(() {
        totalDuration = duration.inMilliseconds.toDouble();
      });
    });


    audioPlayer.onPositionChanged.listen((Duration position) {
      setState(() {
        currentPosition = position.inMilliseconds.toDouble();
        if (totalDuration > 0) {
          progress = currentPosition / totalDuration; // Normalize progress
        }
      });
    });

    audioPlayer.onPlayerComplete.listen((_) {
      setState(() {
        isPlaying = false;
      });
    });
  }


  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  String formatDuration(double duration) {
    int minutes = (duration / 1000 / 60).floor();
    int seconds = ((duration / 1000) % 60).floor();
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
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
          firstText: widget.engFirstTitle?.isNotEmpty == true ? widget.engFirstTitle : "Dua",
          secondText: widget.engSecondTitle?.isNotEmpty == true ? widget.engSecondTitle : " Detail",
          fontSize: 18.sp,
          firstTextColor: isDarkMode ? AppColors.white : AppColors.black,
          secondTextColor: AppColors.primary,
        ),

        backgroundColor: themeController.isDarkMode.value ? AppColors.black : AppColors.white,
        leading: InkWell(
          splashColor: AppColors.transparent,
          highlightColor: AppColors.transparent,
          onTap: () { Get.back(); },
          child: Icon(
            Icons.west,
            color: iconColor,
          ),
        ),
        actions: [
          AppSizedBox.space10w,
          InkWell(
            splashColor: AppColors.transparent,
            highlightColor: AppColors.transparent,
            onTap: () {
              if (widget.isComingFromAllahNameScreen) {
                Share.share(
                    'Check out this Allah name Attribute: ${widget.arabicDua} \n${widget.engFirstTitle} \n${widget.duaTranslation} \nShare from Noor e Quran App!'
                );
              } else {
                Share.share(
                    'Check out this Dua: ${widget.latinTitle} \n${widget.arabicDua} ${widget.duaTranslation}\n${widget.duaUrduTranslation} \nShare from Noor e Quran App!'
                );
              }
            },
            child: Icon(
              Icons.share,
              color: iconColor,
              size: 17.h,
            ),
          ),

          AppSizedBox.space10w,
          InkWell(
            splashColor: AppColors.transparent,
            highlightColor: AppColors.transparent,
            onTap: (){
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
                        title: 'Long-pressing Dua will copy its Text.',
                        fontSize: 14.sp,
                        textColor: textColor,
                        maxLines: 15,
                        textAlign: TextAlign.start,
                        textOverflow: TextOverflow.ellipsis,
                      ),
                      AppSizedBox.space10h,
                      CustomText(
                        title: 'You can use two fingers to zoom in on the Arabic Text or adjust the font size using the slider below.',
                        fontSize: 14.sp,
                        textColor: textColor,
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
            },child: Padding(
            padding: EdgeInsets.only(right: 10.w),
            child: Icon(LineIcons.infoCircle,color: iconColor,size: 20.sp,),
          ),

          ),
        ],
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
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    CustomFrame(
                      leftImageAsset: "assets/frames/topLeftFrame.png",
                      rightImageAsset: "assets/frames/topRightFrame.png",
                      imageHeight: 65.h,
                      imageWidth: 65.w,
                    ),
                    Padding(
                        padding: EdgeInsets.only(left: 10.w, right: 10.w),
                        child:Column(
                          children: [
                            Align(
                              alignment:Alignment.topRight,
                              child: CustomText(
                                textColor: isDarkMode ? AppColors.white : AppColors.black,
                                fontSize: 26.sp,
                                title: widget.latinTitle,
                                textAlign: TextAlign.end,
                              ),
                            ),
                            AppSizedBox.space10h,
                            Container(
                              padding: EdgeInsets.only(right: 10.w, top: 10.h, bottom: 10.h),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: AppColors.primary.withOpacity(0.39),
                                borderRadius: BorderRadius.circular(15.r),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    AppSizedBox.space5w,
                                    Expanded(
                                      child: InteractiveViewer(
                                        maxScale: 10.0,
                                        minScale: 1.0,
                                        child: InkWell(
                                          splashColor: AppColors.transparent,
                                          hoverColor: AppColors.transparent,
                                          highlightColor: AppColors.transparent,
                                          onLongPress: (){
                                            String arabicText = widget.arabicDua;
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
                                            widget.arabicDua,
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
                                      widget.isComingFromAllahNameScreen ?
                                      CustomText(
                                        textColor: AppColors.primary,
                                        fontSize: _currentFontSize,
                                        maxLines: 2,
                                        textAlign: TextAlign.start,
                                        title:  "Description",
                                        fontFamily: 'grenda',
                                      )
                                          : CustomText(
                                        textColor: AppColors.primary,
                                        fontSize: _currentFontSize,
                                        maxLines: 2,
                                        textAlign: TextAlign.start,
                                        title:  "Translation",
                                        fontFamily: 'grenda',
                                      ),
                                      AppSizedBox.space5h,
                                      CustomText(
                                        textColor: textColor,
                                        fontSize: _currentFontSize,
                                        maxLines: 50000,
                                        textAlign: TextAlign.start,
                                        title:  widget.duaTranslation,
                                      ),
                                      AppSizedBox.space10h,
                                      Align(
                                        alignment: Alignment.bottomRight,
                                        child:  CustomText(
                                          title: widget.duaUrduTranslation,
                                          fontSize: _currentFontSize,
                                          maxLines: 50000,
                                          textAlign: TextAlign.end,
                                          textColor: textColor,
                                        ),
                                      )
                                    ]
                                )
                            ),
                          ],
                        )
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
          widget.showAudiotWidgets
              ? Align(
            alignment: Alignment.bottomCenter,
            child: Stack(
              children: [
                Container(
                  height: 150.h,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(isDarkMode
                          ? 'assets/images/quran_bg_dark.jpg'
                          : 'assets/images/quran_bg_light.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: isDarkMode
                            ? [
                          AppColors.black,
                          Colors.black.withOpacity(0.5),
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
                          title:widget.latinTitle,
                          textColor: textColor,
                          fontSize: 32.0,
                        ),
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CustomText(
                                  title: formatDuration(currentPosition),
                                  textColor: textColor,
                                  fontSize: 16.sp,
                                ),
                                CustomText(
                                  title: formatDuration(totalDuration ),
                                  textColor: textColor,
                                  fontSize: 16.sp,
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
                                if (totalDuration > 0) {
                                  final newPosition = totalDuration * newValue;
                                  audioPlayer.seek(Duration(milliseconds: newPosition.toInt()));
                                }
                              },

                            ),
                            // Play/Pause Button
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
                                    radius: 35.r,
                                    child: Icon(
                                      isPlaying ? Icons.pause : Icons.play_arrow,
                                      size: 40.r,
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
                ),
              ],
            ),
          )
              : SizedBox.shrink(),


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
