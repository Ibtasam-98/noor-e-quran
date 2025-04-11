import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icons.dart';
import 'package:noor_e_quran/app/config/app_sizedbox.dart';
import 'package:noor_e_quran/app/views/quran/quran_surah_ayat_detail_screen.dart';
import 'package:noor_e_quran/app/views/quran/quran_surah_setting_screen.dart';
import 'package:quran/quran.dart' as quran;
import 'package:quran/quran_text.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../config/app_colors.dart';
import '../../controllers/app_theme_switch_controller.dart';
import '../../widgets/custom_snackbar.dart';
import '../../widgets/custom_text.dart';
import '../common/audio_player_screen.dart';

class QuranSurahDetailScreen extends StatefulWidget {
  final int surahNumber;
  final int? ayatNumber;

  QuranSurahDetailScreen({required this.surahNumber, this.ayatNumber});

  @override
  _QuranSurahDetailScreenState createState() => _QuranSurahDetailScreenState();
}

class _QuranSurahDetailScreenState extends State<QuranSurahDetailScreen>
    with SingleTickerProviderStateMixin {
  final AppThemeSwitchController themeController = Get.put(AppThemeSwitchController());
  bool isDarkMode = false;
  bool isTranslationEnabled = false;
  quran.Translation selectedTranslation = quran.Translation.enSaheeh;
  double arabicFontSize = 18.0;
  String selectedFontStyle = 'amiri';
  double selectedWordSpacing = 2.0;
  String selectedTranslationFontFamily = 'Roboto';
  double translationSpacing = 1.0;
  double translationFontSize = 18.0;
  final GetStorage _storage = GetStorage();
  bool _isSavingAyah = false;
  ScrollController _scrollController = ScrollController();
  int? _highlightedAyah;
  late AnimationController animationController;
  late Animation<double> scaleAnimation;
  double _scrollProgress = 0.0;
  bool _isFavorite = false;
  Timer? _debounceTimer;


  @override
  void initState() {
    super.initState();
    isDarkMode = themeController.isDarkMode.value;
    _loadSettings();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    scaleAnimation = Tween<double>(begin: 0.86, end: 1.0).animate(
      CurvedAnimation(parent: animationController, curve: Curves.easeInOut),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.ayatNumber != null) {
        _scrollToAyah(widget.ayatNumber!);
      }
    });

    _scrollController.addListener(_updateScrollProgress); // Added listener
    _checkFavoriteStatus();
  }

  @override
  void dispose() {
    animationController.dispose();
    _scrollController.removeListener(_updateScrollProgress); // Remove listener
    _scrollController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _updateScrollProgress() {
    if (_scrollController.hasClients) {
      double maxScrollExtent = _scrollController.position.maxScrollExtent;
      double currentScrollPosition = _scrollController.position.pixels;
      if (maxScrollExtent > 0) {
        double newScrollProgress = currentScrollPosition / maxScrollExtent;
        // Only update if the progress has significantly changed.
        if ((newScrollProgress - _scrollProgress).abs() > 0.005) {
          setState(() {
            _scrollProgress = newScrollProgress;
          });
        }
      }
    }
  }

  void _scrollToAyah(int ayahNumber) {
    if (_scrollController.hasClients) {
      double itemHeight = 100.h;
      double offset = (ayahNumber - 1) * itemHeight;
      double screenHeight = MediaQuery.of(context).size.height;
      double centerOffset = offset - screenHeight / 2 + itemHeight / 2;

      _scrollController.animateTo(
        centerOffset > 0 ? centerOffset : 0,
        duration: Duration(milliseconds: 1000),
        curve: Curves.easeInOut,
      );

      setState(() {
        _highlightedAyah = ayahNumber;
      });

      animationController.repeat(reverse: true);
      Timer(Duration(seconds: 10), () {
        if (mounted) {
          setState(() {
            animationController.stop();
          });
        }
      });
    }
  }

  void _updateSettings(Map<String, dynamic> settings) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isTranslationEnabled', settings['isTranslationEnabled']);
    await prefs.setString('selectedTranslation', settings['selectedTranslation'].toString());
    await prefs.setDouble('arabicWordSpacing', settings['arabicWordSpacing']);
    await prefs.setString('arabicFontFamily', settings['arabicFontFamily']);
    await prefs.setString('translationFontFamily', settings['translationFontFamily']);
    await prefs.setDouble('translationSpacing', settings['translationSpacing']);
    await prefs.setDouble('arabicFontSize', settings['arabicFontSize']);
    await prefs.setDouble('translationFontSize', settings['translationFontSize']);

    setState(() {
      isTranslationEnabled = settings['isTranslationEnabled'];
      selectedTranslation = settings['selectedTranslation'];
      selectedWordSpacing = settings['arabicWordSpacing'];
      selectedFontStyle = settings['arabicFontFamily'];
      selectedTranslationFontFamily = settings['translationFontFamily'];
      translationSpacing = settings['translationSpacing'];
      arabicFontSize = settings['arabicFontSize'];
      translationFontSize = settings['translationFontSize'];
    });
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isTranslationEnabled = prefs.getBool('isTranslationEnabled') ?? false;
      selectedTranslation = quran.Translation.values.firstWhere(
            (element) => element.toString() ==
            (prefs.getString('selectedTranslation') ??
                quran.Translation.enSaheeh.toString()),
        orElse: () => quran.Translation.enSaheeh,
      );
      arabicFontSize = prefs.getDouble('arabicFontSize') ?? 18.0;
      selectedFontStyle = prefs.getString('fontStyle') ?? 'AmiriQuran';
      selectedWordSpacing = prefs.getDouble('wordSpacing') ?? 2.0;
      selectedTranslationFontFamily =
          prefs.getString('translationFontFamily') ?? 'Roboto';
      translationSpacing = prefs.getDouble('translationSpacing') ?? 1.0;
      translationFontSize = prefs.getDouble('translationFontSize') ?? 18.0;
    });
  }

  Future<void> _checkFavoriteStatus() async {
    final favorites = _storage.read('favoriteSurahs') ?? [];
    setState(() {
      _isFavorite = favorites.contains(widget.surahNumber);
    });
  }

  Future<void> _toggleFavorite() async {
    final favorites = _storage.read('favoriteSurahs') ?? [];
    if (_isFavorite) {
      favorites.remove(widget.surahNumber);
      CustomSnackbar.show(
        title: "Removed",
        subtitle: "${quran.getSurahNameEnglish(widget.surahNumber)} removed from favorites",
        icon: Icon(Icons.favorite_border, color: AppColors.white),
        backgroundColor: Colors.red,
        textColor: AppColors.white,
      );
    } else {
      favorites.add(widget.surahNumber);
      CustomSnackbar.show(
        title: "Added",
        subtitle: "${quran.getSurahNameArabic(widget.surahNumber)} added to favorites",
        icon: Icon(Icons.favorite, color: AppColors.white),
        backgroundColor: AppColors.green,
        textColor: AppColors.white,
      );
    }
    await _storage.write('favoriteSurahs', favorites);
    setState(() {
      _isFavorite = !_isFavorite;
    });
  }


  @override
  Widget build(BuildContext context) {
    final textColor = isDarkMode ? AppColors.white : AppColors.black;
    final iconColor = isDarkMode ? AppColors.white : AppColors.black;
    return Scaffold(
      backgroundColor: isDarkMode ? AppColors.black : AppColors.white,
      appBar: AppBar(
        surfaceTintColor: AppColors.transparent,
        backgroundColor: isDarkMode ? AppColors.black : AppColors.white,
        title: CustomText(
          title: "﷽",
          textColor: textColor,
          fontSize: 20.sp,
          maxLines: 1,
          fontWeight: FontWeight.w400,
          textOverflow: TextOverflow.ellipsis,
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.west,
            color: iconColor,
          ),
        ),
        actions: [
          IconButton(
            splashColor: AppColors.transparent,
            highlightColor: AppColors.transparent,
            hoverColor: AppColors.transparent,
            onPressed: _toggleFavorite,
            icon:  SvgPicture.asset(
              _isFavorite
                  ? 'assets/images/heart_filled.svg'
                  : 'assets/images/heart.svg',
              height: 21.h, // You can scale the SVG image like an icon
              width: 21.w, // You can also use this to control the width
              color: AppColors.dayColor
            ),
          ),
          AppSizedBox.space5w,
          InkWell(
            onTap: () async {
              final settings = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => QuranSurahSettingScreen(
                    currentTranslation: selectedTranslation,
                    isTranslationEnabled: isTranslationEnabled,
                    currentFontSize: arabicFontSize,
                    currentWordSpacing: selectedWordSpacing,
                    currentArabicFontFamily: selectedFontStyle,
                    currentTranslationFontFamily: selectedTranslationFontFamily,
                  ),
                ),
              );
              if (settings != null) {
                _updateSettings(settings);
              }
            },
            child: Padding(
              padding: EdgeInsets.only(right: 15.w),
              child: Icon(
                LineIcons.cog,
                color: iconColor,
                size: 18.h,
              ),
            ),
          )
        ],
      ),
      body: Padding(
          padding: EdgeInsets.only(left: 10.w, right: 10.w),
          child: Column(
            children: [
              LinearProgressIndicator( // Added progress bar
                value: _scrollProgress,
                backgroundColor: AppColors.grey.withOpacity(0.1),
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
              ),
              AppSizedBox.space10h,
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 3.0),
                    child: CustomText(
                      title: quran.getSurahNameArabic(widget.surahNumber),
                      fontSize: 30.sp,
                      textColor: AppColors.primary,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 3.0),
                    child: CustomText(
                      title: "${quran.getSurahNameEnglish(widget.surahNumber)}",
                      fontSize: 16.sp,
                      textColor: textColor,
                      fontFamily: 'quicksand',
                    ),
                  )
                ],
              ),
              AppSizedBox.space10h,
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: quran.getVerseCount(widget.surahNumber),
                  itemBuilder: (context, index) {
                    final verseNumber = index + 1;
                    String verseText = quran.getVerse(widget.surahNumber, verseNumber, verseEndSymbol: false);
                    String? translationText;
                    if (isTranslationEnabled) {
                      try {
                        translationText = quran.getVerseTranslation(widget.surahNumber, verseNumber,
                            translation: selectedTranslation);
                      } catch (e) {
                        translationText = "Translation not available.";
                      }
                    }
                    TextStyle arabicTextStyle;
                    if (selectedFontStyle == 'AmiriQuran') {
                      arabicTextStyle = GoogleFonts.amiriQuran(fontSize: arabicFontSize, wordSpacing: selectedWordSpacing,color: textColor);
                    } else if (selectedFontStyle == 'Amiri') {
                      arabicTextStyle = GoogleFonts.amiri(fontSize: arabicFontSize, wordSpacing: selectedWordSpacing,color: textColor);
                    } else if (selectedFontStyle == 'Quicksand') {
                      arabicTextStyle = GoogleFonts.quicksand(fontSize: arabicFontSize, wordSpacing: selectedWordSpacing,color: textColor);
                    } else {
                      arabicTextStyle = GoogleFonts.amiriQuran(fontSize: arabicFontSize, wordSpacing: selectedWordSpacing,color: textColor);
                    }

                    TextStyle translationTextStyle;
                    if (selectedTranslationFontFamily == 'Roboto') {
                      translationTextStyle = GoogleFonts.roboto(color: textColor, height: translationSpacing, fontSize: translationFontSize);
                    } else {
                      translationTextStyle = TextStyle(
                        fontFamily: 'Times New Roman',
                        color: textColor,
                        height: translationSpacing,
                        fontSize: translationFontSize,
                      );
                    }

                    TextAlign textAlign = selectedTranslation == 'urdu'
                        ? TextAlign.end
                        : TextAlign.start;

                    return InkWell(
                      splashColor: AppColors.transparent,
                      onTap: (){
                        print(verseNumber);
                        print(widget.surahNumber);
                        Get.to(QuranSurahAyatDetailsScreen(
                          arabicText: verseText,
                          ayahIndex: verseNumber,
                          surahIndex: widget.surahNumber,
                          surahLatinName: quran.getSurahNameEnglish(widget.surahNumber),
                          translation: translationText,
                          surahArabicName: quran.getSurahNameArabic(widget.surahNumber),
                          textAlign: textAlign,
                          surahName: '',
                        ));
                      },
                      onLongPress: () async {
                        if (_isSavingAyah) return;

                        setState(() {
                          _isSavingAyah = true;
                        });

                        final uniqueAyahKey = 'savedAyah_${widget.surahNumber}_$verseNumber';

                        if (_storage.read(uniqueAyahKey) != null) {
                          CustomSnackbar.show(
                            title: "Error",
                            subtitle: "This Ayah is already saved!",
                            icon: Icon(Icons.error, color: AppColors.white),
                            backgroundColor: Colors.red,
                            textColor: AppColors.white,
                          );
                          setState(() {
                            _isSavingAyah = false;
                          });
                          return;
                        }

                        final audioUrl = await quran.getAudioURLByVerse(widget.surahNumber, verseNumber);
                        final currentDate = DateFormat('dd MMMM yyyy').format(DateTime.now()); // Added year for more uniqueness
                        final currentTime = DateFormat('hh:mm a').format(DateTime.now());

                        await _storage.write(uniqueAyahKey, {
                          'timestamp': currentTime,
                          'date': currentDate,
                          'surahIndex': widget.surahNumber,
                          'surahArabicName': quran.getSurahNameArabic(widget.surahNumber),
                          'surahLatinName': quran.getSurahNameEnglish(widget.surahNumber),
                          'ayahArabicText': verseText,
                          'ayatNumber': verseNumber,
                          'audioUrl': audioUrl,
                        });

                        CustomSnackbar.show(
                          title: "Success",
                          subtitle: "Ayah saved successfully!",
                          icon: Icon(Icons.check_circle, color: AppColors.white),
                          backgroundColor: AppColors.green,
                          textColor: AppColors.white,
                        );

                        setState(() {
                          _isSavingAyah = false;
                        });
                      },
                      child: AnimatedBuilder(
                        animation: animationController,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: _highlightedAyah == verseNumber
                                ? scaleAnimation.value
                                : 1.0,
                            child: child,
                          );
                        },
                        child: Container(
                          margin: EdgeInsets.only(bottom: 5, top: 10.h),
                          padding: EdgeInsets.all(18.h),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.r),
                            color: (index % 2 == 1)
                                ? AppColors.primary.withOpacity(0.29)
                                : AppColors.primary.withOpacity(0.1),

                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                          fontSize: 10.sp,
                                          textColor: textColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Expanded(
                                    child: Text(
                                      verseText,
                                      textAlign: TextAlign.right,
                                      style: arabicTextStyle,
                                    ),
                                  ),
                                ],
                              ),
                              if (isTranslationEnabled && translationText != null)
                                Padding(
                                  padding: EdgeInsets.only(top: 8.h),
                                  child: Text(
                                    translationText,
                                    style: translationTextStyle,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              )
            ],
          )
      ),
      bottomNavigationBar: InkWell(
        splashColor:  AppColors.transparent,
        highlightColor:  AppColors.transparent,
        onTap: (){
          Get.to(AudioPlayerScreen(
            title: quran.getSurahNameArabic(widget.surahNumber),
            latinName: quran.getSurahNameEnglish(widget.surahNumber),
            audioUrl: quran.getAudioURLBySurah(widget.surahNumber),
            titleFontSize: 60.sp,
          )
          );
        },
        child: Container(
          margin: EdgeInsets.only(top: 10.h),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.2),
                blurRadius: 10,
              ),
            ],
          ),
          child: BottomAppBar(
            color: isDarkMode ? AppColors.black : AppColors.white,
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Icon(
                    Icons.play_arrow,
                    color: isDarkMode ? AppColors.white : AppColors.black,
                  ),
                  Expanded(
                    child: CustomText(
                      textColor: isDarkMode ? AppColors.white : AppColors.black,
                      fontSize: 15.sp,
                      title: "Play Complete Audio of " + quran.getSurahName(widget.surahNumber),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}