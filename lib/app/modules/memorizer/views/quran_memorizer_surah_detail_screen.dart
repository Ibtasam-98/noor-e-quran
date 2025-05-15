import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:glowy_borders/glowy_borders.dart';
import 'package:noor_e_quran/app/widgets/custom_snackbar.dart';
import 'package:quran/quran.dart' as quran;
import 'package:google_fonts/google_fonts.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icons.dart';
import 'package:vibration/vibration.dart';
import 'package:audioplayers/audioplayers.dart';

import '../../../config/app_colors.dart';
import '../../../config/app_sizedbox.dart';
import '../../../controllers/app_theme_switch_controller.dart';
import '../../../widgets/custom_frame.dart';
import '../../../widgets/custom_text.dart';

class QuranMemorizerSurahDetailScreen extends StatefulWidget {
  final int surahNumber;

  QuranMemorizerSurahDetailScreen({required this.surahNumber});

  @override
  _QuranMemorizerSurahDetailScreenState createState() =>
      _QuranMemorizerSurahDetailScreenState();
}

class _QuranMemorizerSurahDetailScreenState
    extends State<QuranMemorizerSurahDetailScreen> {
  late PageController _pageController;
  int _currentPage = 0;
  int _totalVerses = 0;
  final RxSet<String> _memorizedVerses = <String>{}.obs;
  final AppThemeSwitchController themeController = Get.find<AppThemeSwitchController>();
  final GetStorage _storage = GetStorage();
  final String _memorizedVersesKey = 'memorizedVerses';
  final String _lastAccessedSurahKey = 'lastAccessedSurah';
  final String _totalVersesKey = 'totalVerses';
  final String _lastAccessedTimeKey = 'lastAccessedTime';
  final String _surahNameKey = 'surahName';
  final String _lastViewedPageKey = 'lastViewedPage';
  final String _showTranslationKey = 'showTranslation';
  final String _arabicFontSizeKey = 'arabicFontSize';
  final String _translationFontSizeKey = 'translationFontSize';

  late List<String> _verses;
  bool _isSurahFullyMemorized = false;

  final RxBool _showTranslation = true.obs;
  final RxDouble _arabicFontSize = 22.0.obs;
  final RxDouble _translationFontSize = 20.0.obs;

  // Audio player variables
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  int? _currentlyPlayingVerse;

  @override
  void initState() {
    super.initState();
    // For debugging/logging
    _audioPlayer.onLog.listen((event) {
      print('AudioPlayer log: $event');
    });
    _totalVerses = quran.getVerseCount(widget.surahNumber);
    _currentPage =
        _storage.read<int?>('$_lastViewedPageKey${widget.surahNumber}') ?? 0;
    _pageController = PageController(initialPage: _currentPage);

    // Load settings and ensure they are within the valid range
    _showTranslation.value = _storage.read<bool?>(_showTranslationKey) ?? true;
    _arabicFontSize.value =
        (_storage.read<double?>(_arabicFontSizeKey) ?? 22.0).clamp(16.0, 60.0);
    _translationFontSize.value =
        (_storage.read<double?>(_translationFontSizeKey) ?? 20.0).clamp(
            16.0, 60.0);

    _loadMemorizedVerses();
    _saveLastAccessedSurah();
    _saveTotalVerses();
    _saveSurahName();
    _loadVerses();

    // Set up audio player listeners
    _audioPlayer.onPlayerStateChanged.listen((state) {
      if (mounted) {
        setState(() {
          _isPlaying = state == PlayerState.playing;
          if (!_isPlaying) {
            _currentlyPlayingVerse = null;
          }
        });
      }
    });

    _audioPlayer.onPlayerComplete.listen((_) {
      if (mounted) {
        setState(() {
          _isPlaying = false;
          _currentlyPlayingVerse = null;
        });
      }
    });
  }

  void _loadVerses() {
    _verses = List.generate(
      _totalVerses,
          (index) => quran.getVerse(widget.surahNumber, index + 1),
    );
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _loadMemorizedVerses() async {
    final memorized = _storage.read(_memorizedVersesKey) ?? <String>[];
    if (memorized is List) {
      _memorizedVerses.addAll(memorized.cast<String>());
    } else {
      _memorizedVerses.clear();
    }
  }

  Future<void> _saveMemorizedVerses() async {
    await _storage.write(_memorizedVersesKey, _memorizedVerses.toList());
  }

  Future<void> _saveLastAccessedSurah() async {
    final now = DateTime.now();
    final formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
    await _storage.write(_lastAccessedSurahKey, formattedDate);
    await _storage.write('lastAccessedSurahNumber', widget.surahNumber);
    await _storage.write(_lastAccessedTimeKey, formattedDate);
  }

  Future<void> _saveTotalVerses() async {
    await _storage.write('$_totalVersesKey${widget.surahNumber}', _totalVerses);
  }

  Future<void> _saveSurahName() async {
    final surahName = quran.getSurahName(widget.surahNumber);
    await _storage.write('$_surahNameKey${widget.surahNumber}', surahName);
  }

  void _goToPreviousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _goToNextPage() {
    if (_currentPage < _totalVerses - 1) {
      _pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _toggleMemorized(int verseNumber) async {
    final verseKey = '${widget.surahNumber}:${verseNumber}';
    if (_memorizedVerses.contains(verseKey)) {
      _memorizedVerses.remove(verseKey);
    } else {
      _memorizedVerses.add(verseKey);
    }
    _saveMemorizedVerses();
    setState(() {
      _isSurahFullyMemorized = _memorizedVerses
          .where((v) => v.startsWith('${widget.surahNumber}:'))
          .length == _totalVerses;
    });

    if (await Vibration.hasVibrator() ?? false) {
      Vibration.vibrate(duration: 50);
    }
  }

  Future<void> _playVerseAudio(int verseNumber) async {
    try {
      if (_isPlaying && _currentlyPlayingVerse == verseNumber) {
        // Pause if same verse is playing
        await _audioPlayer.pause();
        if (mounted) {
          setState(() {
            _isPlaying = false;
            _currentlyPlayingVerse = null;
          });
        }
      } else {
        // Stop any current playback and start new one
        await _audioPlayer.stop();

        // Get audio URL for this verse
        final audioUrl = quran.getAudioURLByVerse(widget.surahNumber, verseNumber);

        // Play with error handling
        try {
          await _audioPlayer.play(UrlSource(audioUrl));
          if (mounted) {
            setState(() {
              _isPlaying = true;
              _currentlyPlayingVerse = verseNumber;
            });
          }
        } catch (e) {
          print('Playback error: $e');
          if (mounted) {
            setState(() {
              _isPlaying = false;
              _currentlyPlayingVerse = null;
            });
          }
          CustomSnackbar.show(
            title: "Playback Error",
            subtitle: "Could not play audio",
            icon: Icon(Icons.error, color: AppColors.white),
            backgroundColor: AppColors.red,
          );
        }
      }
    } catch (e) {
      print('Audio player error: $e');
      if (mounted) {
        setState(() {
          _isPlaying = false;
          _currentlyPlayingVerse = null;
        });
      }
      CustomSnackbar.show(
        title: "Error",
        subtitle: "Audio player encountered an error",
        icon: Icon(Icons.error, color: AppColors.white),
        backgroundColor: AppColors.red,
      );
    }
  }

  void _showSettingsBottomSheet() {
    Get.bottomSheet(
      Obx(() => Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.r),
            topRight: Radius.circular(20.r),
          ),
        ),
        padding: EdgeInsets.all(20.w),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                firstText: "Display ",
                secondText: "Setting",
                fontFamily: 'grenda',
                firstTextColor: AppColors.black,
                secondTextColor: AppColors.primary,
                fontSize: 18.sp,
                textAlign: TextAlign.start,
              ),
              AppSizedBox.space10h,

              // Translation Toggle
              Container(
                margin: EdgeInsets.only(bottom: 10.h),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: SwitchListTile(
                  inactiveTrackColor: AppColors.white,
                  trackOutlineColor: MaterialStateProperty.resolveWith<Color?>(
                        (Set<MaterialState> states) {
                      if (states.contains(MaterialState.selected)) {
                        return AppColors.primary;
                      }
                      return AppColors.grey;
                    },
                  ),
                  title: CustomText(
                    title: _showTranslation.value ? "Hide Translation" : "Show Translation",
                    fontSize: 14.sp,
                    textColor: AppColors.black,
                    textAlign: TextAlign.start,
                  ),
                  value: _showTranslation.value,
                  onChanged: (value) {
                    _showTranslation.value = value;
                    _storage.write(_showTranslationKey, value);
                  },
                  activeColor: AppColors.primary,
                ),
              ),

              // Arabic Font Size Slider
              Container(
                padding: EdgeInsets.all(12.h),
                margin: EdgeInsets.only(bottom: 10.h),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      title: "Arabic Font Size: ${_arabicFontSize.value.toInt()}",
                      fontSize: 14.sp,
                      textColor: AppColors.black,
                    ),
                    Slider(
                      value: _arabicFontSize.value,
                      min: 16.0,
                      max: 60.0,
                      divisions: 44,
                      onChanged: (value) {
                        _arabicFontSize.value = value;
                        _storage.write(_arabicFontSizeKey, value);
                      },
                      activeColor: AppColors.primary,
                      inactiveColor: AppColors.grey.withOpacity(0.4),
                    ),
                  ],
                ),
              ),

              // Translation Font Size Slider
              Container(
                padding: EdgeInsets.all(12.h),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      title: "Translation Font Size: ${_translationFontSize.value.toInt()}",
                      fontSize: 14.sp,
                      textColor: AppColors.black,
                    ),
                    Slider(
                      value: _translationFontSize.value,
                      min: 16.0,
                      max: 60.0,
                      divisions: 44,
                      onChanged: (value) {
                        _translationFontSize.value = value;
                        _storage.write(_translationFontSizeKey, value);
                      },
                      activeColor: AppColors.primary,
                      inactiveColor: AppColors.grey.withOpacity(0.4),
                    ),
                  ],
                ),
              ),

              AppSizedBox.space20h,
            ],
          ),
        ),
      )),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: themeController.isDarkMode.value ? AppColors.black : AppColors.white,
      appBar: AppBar(
        backgroundColor: themeController.isDarkMode.value ? AppColors.black : AppColors.white,
        title: CustomText(
          firstText: "Surah ",
          secondText: quran.getSurahName(widget.surahNumber),
          secondTextColor: AppColors.primary,
          fontSize: 18.sp,
          textColor: themeController.isDarkMode.value ? AppColors.white : AppColors.black,
        ),
        centerTitle: false,
        leading: IconButton(
          onPressed: () {
            // Stop audio when navigating back
            _audioPlayer.stop();
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.west,
            color: themeController.isDarkMode.value ? AppColors.white : AppColors.black,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(LineIcons.cog),
            onPressed: _showSettingsBottomSheet,
            color: themeController.isDarkMode.value ? AppColors.white : AppColors.black,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: _totalVerses,
              onPageChanged: (int page) {
                setState(() {
                  _currentPage = page;
                  _storage.write('$_lastViewedPageKey${widget.surahNumber}', page);
                });
              },
              itemBuilder: (context, index) {
                final verseNumber = index + 1;
                return Container(
                  margin: EdgeInsets.all(10.h),
                  decoration: BoxDecoration(
                    color: themeController.isDarkMode.value ? AppColors.black : AppColors.white,
                    borderRadius: BorderRadius.circular(10.r),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 2,
                      ),
                    ],
                  ),
                  height: MediaQuery.of(context).size.height,
                  child: Padding(
                    padding: EdgeInsets.all(8.w),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomFrame(
                          leftImageAsset: "assets/frames/topLeftFrame.png",
                          rightImageAsset: "assets/frames/topRightFrame.png",
                          imageHeight: 60.h,
                          imageWidth: 60.w,
                        ),
                        Flexible(
                          child: SingleChildScrollView(
                            child: Row(
                              children: [
                                IconButton(
                                  icon: Icon(Icons.arrow_left, size: 33.h),
                                  onPressed: _currentPage > 0 ? _goToPreviousPage : null,
                                  iconSize: 40,
                                  color: _currentPage > 0
                                      ? (themeController.isDarkMode.value ? AppColors.white : AppColors.black)
                                      : Colors.grey,
                                ),
                                Expanded(
                                  child: Column(
                                    children: [
                                      Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          Image.asset(
                                            "assets/images/ayat_marker.png",
                                            width: 36.w,
                                            height: 36.h,
                                            fit: BoxFit.contain,
                                          ),
                                          Positioned(
                                            child: CustomText(
                                              title: verseNumber.toString(),
                                              fontSize: 12.sp,
                                              textColor: themeController.isDarkMode.value ? AppColors.white : AppColors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                      AppSizedBox.space10h,
                                      Obx(() => CustomText(
                                        title: quran.getVerse(widget.surahNumber, verseNumber),
                                        textColor: _memorizedVerses.contains('${widget.surahNumber}:${verseNumber}')
                                            ? AppColors.green
                                            : (themeController.isDarkMode.value ? AppColors.white : AppColors.black),
                                        textStyle: GoogleFonts.amiri(height: 2),
                                        textAlign: TextAlign.center,
                                        fontSize: _arabicFontSize.value.sp,)),
                                      Obx(() {
                                        if (_showTranslation.value) {
                                          return Column(
                                            children: [
                                              AppSizedBox.space10h,
                                              CustomText(
                                                title: quran.getVerseTranslation(widget.surahNumber, verseNumber, translation: quran.Translation.enSaheeh) ?? "Translation not available",
                                                fontSize: _translationFontSize.value.sp,
                                                textColor: _memorizedVerses.contains('${widget.surahNumber}:${verseNumber}')
                                                    ? AppColors.green
                                                    : (themeController.isDarkMode.value
                                                    ? AppColors.white
                                                    : AppColors.black),
                                                textAlign: TextAlign.center,
                                              ),
                                            ],
                                          );
                                        }
                                        return SizedBox.shrink();
                                      }),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(Icons.arrow_right, size: 33.h),
                                  onPressed: _currentPage < _totalVerses - 1 ? _goToNextPage : null,
                                  iconSize: 40,
                                  color: _currentPage < _totalVerses - 1
                                      ? (themeController.isDarkMode.value ? AppColors.white : AppColors.black)
                                      : Colors.grey,
                                ),
                              ],
                            ),
                          ),
                        ),
                        AnimatedGradientBorder(
                          borderSize: (_isPlaying && _currentlyPlayingVerse == verseNumber) ? 3.r : 0.0,
                          glowSize: (_isPlaying && _currentlyPlayingVerse == verseNumber) ? 8.r : 0.0,
                          gradientColors: (_isPlaying && _currentlyPlayingVerse == verseNumber)
                              ? const [
                            Color(0xFFFFD700),
                            Color(0xFFFFA500),
                            Color(0xFFF4E2D8),
                            Color(0xFFE09F3E),
                            Color(0xFFB65D25),
                          ]
                              : [AppColors.transparent], // Use transparent when not playing
                          borderRadius: BorderRadius.circular(30.r + 8.r),
                          child: InkWell(
                            onTap: () => _playVerseAudio(verseNumber),
                            borderRadius: BorderRadius.circular(30.r),
                            child: CircleAvatar(
                              radius: 30.r,
                              backgroundColor: AppColors.primary,
                              child: Icon(
                                (_isPlaying && _currentlyPlayingVerse == verseNumber)
                                    ? Icons.pause
                                    : Icons.play_arrow,
                                color: AppColors.white,
                                size: 30.sp,
                              ),
                            ),
                          ),
                        ),
                        CustomFrame(
                          leftImageAsset: "assets/frames/bottomLeftFrame.png",
                          rightImageAsset: "assets/frames/bottomRightFrame.png",
                          imageHeight: 60.h,
                          imageWidth: 60.w,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 10),
            child: Container(
              margin: EdgeInsets.only(bottom: 10.h),
              child: Obx(() => IconButton(
                icon: _memorizedVerses.contains('${widget.surahNumber}:${_currentPage + 1}')
                    ? Icon(LineIcons.checkCircle, color: AppColors.green, size: 40.sp)
                    : Icon(LineIcons.checkCircle, color: AppColors.grey, size: 40.sp),
                onPressed: () {
                  _toggleMemorized(_currentPage + 1);
                  if (_isSurahFullyMemorized) {
                    CustomSnackbar.show(
                      title: "Ma Sha Allah",
                      subtitle: "You have memorized Surah ${quran.getSurahName(widget.surahNumber)}!",
                      icon: Icon(LineIcons.checkCircle, color: AppColors.white),
                      backgroundColor: AppColors.green,
                    );
                  }
                },
                iconSize: 40.sp,
              )),
            ),
          ),
        ],
      ),
    );
  }
}