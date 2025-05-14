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
import '../../../config/app_colors.dart';
import '../../../config/app_sizedbox.dart';
import '../../../controllers/app_theme_switch_controller.dart';
import '../../../widgets/custom_frame.dart';
import '../../../widgets/custom_text.dart';
import 'package:audioplayers/audioplayers.dart';


class QuranMemorizerJuzDetailScreen extends StatefulWidget {
  final int juzNumber;

  QuranMemorizerJuzDetailScreen({required this.juzNumber});

  @override
  _QuranMemorizerJuzDetailScreenState createState() =>
      _QuranMemorizerJuzDetailScreenState();
}

class _QuranMemorizerJuzDetailScreenState
    extends State<QuranMemorizerJuzDetailScreen> {
  late PageController _pageController;
  int _currentPage = 0;
  final RxSet<String> _memorizedVerses = <String>{}.obs;
  final AppThemeSwitchController themeController = Get.find<AppThemeSwitchController>();
  final GetStorage _storage = GetStorage();
  final String _memorizedVersesKey = 'memorizedVerses';
  final String _lastAccessedJuzKey = 'lastAccessedJuz';
  final String _lastAccessedTimeKey = 'lastAccessedTime';
  final String _lastViewedPageKey = 'lastViewedPage';
  final String _showTranslationKey = 'showTranslation';
  final String _arabicFontSizeKey = 'arabicFontSize';
  final String _translationFontSizeKey = 'translationFontSize';

  late List<Map<String, dynamic>> _verses;
  bool _isJuzFullyMemorized = false;

  final RxBool _showTranslation = true.obs;
  final RxDouble _arabicFontSize = 22.0.obs;
  final RxDouble _translationFontSize = 20.0.obs;

  // Audio player variables
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  bool _isLoading = false;
  int? _currentlyPlayingSurah;
  int? _currentlyPlayingVerse;

  @override
  void initState() {
    super.initState();
    _currentPage = _storage.read<int?>('${_lastViewedPageKey}Juz${widget.juzNumber}') ?? 0;
    _pageController = PageController(initialPage: _currentPage);

    // Load settings
    _showTranslation.value = _storage.read<bool?>(_showTranslationKey) ?? true;
    _arabicFontSize.value = (_storage.read<double?>(_arabicFontSizeKey) ?? 22.0).clamp(16.0, 60.0);
    _translationFontSize.value = (_storage.read<double?>(_translationFontSizeKey) ?? 20.0).clamp(16.0, 60.0);

    _loadMemorizedVerses();
    _saveLastAccessedJuz();
    _loadJuzVerses();

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

  void _loadJuzVerses() {
    final juzData = quran.getSurahAndVersesFromJuz(widget.juzNumber);
    _verses = [];

    juzData.forEach((surahNumber, verseRange) {
      final startVerse = verseRange[0];
      final endVerse = verseRange[1];

      for (int verseNumber = startVerse; verseNumber <= endVerse; verseNumber++) {
        _verses.add({
          'surahNumber': surahNumber,
          'verseNumber': verseNumber,
          'text': quran.getVerse(surahNumber, verseNumber),
          'translation': quran.getVerseTranslation(surahNumber, verseNumber,
              translation: quran.Translation.enSaheeh) ??
              "Translation not available",
        });
      }
    });
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

  Future<void> _saveLastAccessedJuz() async {
    final now = DateTime.now();
    final formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
    await _storage.write(_lastAccessedJuzKey, formattedDate);
    await _storage.write('lastAccessedJuzNumber', widget.juzNumber);
    await _storage.write(_lastAccessedTimeKey, formattedDate);
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
    if (_currentPage < _verses.length - 1) {
      _pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _toggleMemorized(int index) async {
    final verse = _verses[index];
    final verseKey = '${verse['surahNumber']}:${verse['verseNumber']}';
    final surahNumber = verse['surahNumber'];

    if (_memorizedVerses.contains(verseKey)) {
      _memorizedVerses.remove(verseKey);
    } else {
      _memorizedVerses.add(verseKey);
    }

    await _saveMemorizedVerses();

    final juzVerses = _verses.map((v) => '${v['surahNumber']}:${v['verseNumber']}').toSet();
    setState(() {
      _isJuzFullyMemorized = juzVerses.every((v) => _memorizedVerses.contains(v));
    });

    if (await Vibration.hasVibrator() ?? false) {
      Vibration.vibrate(duration: 50);
    }

    if (_isJuzFullyMemorized) {
      CustomSnackbar.show(
        title: "Ma Sha Allah",
        subtitle: "You have memorized Juz ${widget.juzNumber}!",
        icon: Icon(LineIcons.checkCircle),
        backgroundColor: AppColors.green,
      );
    }
  }

  Future<void> _playVerseAudio(int verseNumber, int index) async {
    final verse = _verses[index];
    final surahNumber = verse['surahNumber'];
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
        final audioUrl = quran.getAudioURLByVerse(surahNumber, verseNumber);

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
          title: 'Juz ${widget.juzNumber}',
          fontSize: 18.sp,
          textColor: themeController.isDarkMode.value ? AppColors.white : AppColors.black,
        ),
        centerTitle: false,
        leading: IconButton(
          onPressed: () {
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
              itemCount: _verses.length,
              onPageChanged: (int page) {
                setState(() {
                  _currentPage = page;
                  _storage.write('${_lastViewedPageKey}Juz${widget.juzNumber}', page);
                });
              },
              itemBuilder: (context, index) {
                final verse = _verses[index];
                final verseKey = '${verse['surahNumber']}:${verse['verseNumber']}';
                final isMemorized = _memorizedVerses.contains(verseKey);
                final surahName = quran.getSurahName(verse['surahNumber']);
                final isFirstVerseOfSurah = verse['verseNumber'] == 1;
                final isCurrentVersePlaying =
                    _currentlyPlayingSurah == verse['surahNumber'] &&
                        _currentlyPlayingVerse == verse['verseNumber'];

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
                                      if (isFirstVerseOfSurah)
                                        Padding(
                                          padding: EdgeInsets.only(bottom: 8.h),
                                          child: CustomText(
                                            title: surahName,
                                            fontSize: 18.sp,
                                            fontWeight: FontWeight.bold,
                                            textAlign: TextAlign.center,
                                            textColor: themeController.isDarkMode.value
                                                ? AppColors.white
                                                : AppColors.black,
                                          ),
                                        ),
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
                                              title: verse['verseNumber'].toString(),
                                              fontSize: 12.sp,
                                              textColor: themeController.isDarkMode.value
                                                  ? AppColors.white
                                                  : AppColors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                      AppSizedBox.space10h,
                                      Obx(() => CustomText(
                                        title: verse['text'],
                                        textColor: isMemorized
                                            ? AppColors.green
                                            : (themeController.isDarkMode.value
                                            ? AppColors.white
                                            : AppColors.black),
                                        textStyle: GoogleFonts.amiri(height: 2),
                                        textAlign: TextAlign.center,
                                        fontSize: _arabicFontSize.value.sp,
                                      )),
                                      Obx(() {
                                        if (_showTranslation.value) {
                                          return Column(
                                            children: [
                                              AppSizedBox.space10h,
                                              CustomText(
                                                title: verse['translation'],
                                                fontSize: _translationFontSize.value.sp,
                                                textColor: isMemorized
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
                                  onPressed: _currentPage < _verses.length - 1 ? _goToNextPage : null,
                                  iconSize: 40,
                                  color: _currentPage < _verses.length - 1
                                      ? (themeController.isDarkMode.value ? AppColors.white : AppColors.black)
                                      : Colors.grey,
                                ),
                              ],
                            ),
                          ),
                        ),
                        AnimatedGradientBorder(
                          borderSize: (_isPlaying && _currentlyPlayingVerse == verse['verseNumber']) ? 3.r : 0.0,
                          glowSize: (_isPlaying && _currentlyPlayingVerse == verse['verseNumber']) ? 8.r : 0.0,
                          gradientColors: (_isPlaying && _currentlyPlayingVerse == verse['verseNumber'])
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
                            onTap: () => _playVerseAudio(verse['verseNumber'],index ),
                            borderRadius: BorderRadius.circular(30.r),
                            child: CircleAvatar(
                              radius: 30.r,
                              backgroundColor: AppColors.primary,
                              child: Icon(
                                (_isPlaying && _currentlyPlayingVerse == verse['verseNumber'])
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Obx(() => IconButton(
                    icon: _memorizedVerses.contains(
                        '${_verses[_currentPage]['surahNumber']}:${_verses[_currentPage]['verseNumber']}')
                        ? Icon(LineIcons.checkCircle, color: AppColors.green)
                        : Icon(LineIcons.checkCircle, color: AppColors.grey),
                    onPressed: () => _toggleMemorized(_currentPage),
                    iconSize: 40,
                  )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}