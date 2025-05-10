import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icons.dart';
import 'package:noor_e_quran/app/config/app_sizedbox.dart';
import 'package:noor_e_quran/app/modules/quran/views/quran_surah_ayat_detail_screen.dart';
import 'package:noor_e_quran/app/modules/quran/views/quran_surah_setting_screen.dart';
import 'package:quran/quran.dart' as quran;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../config/app_colors.dart';
import '../../../controllers/app_theme_switch_controller.dart';
import '../../../widgets/custom_snackbar.dart';
import '../../../widgets/custom_text.dart';

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
  int? _highlightedAyah;
  late AnimationController animationController;
  late Animation<double> scaleAnimation;
  bool _isFavorite = false;
  Timer? _debounceTimer;
  late PageController _pageController;
  int _currentPage = 0;
  bool _isPageView = true;
  double _scrollProgress = 0.0;
  late ScrollController _listScrollController;

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

    _pageController = PageController(
      initialPage: widget.ayatNumber != null ? widget.ayatNumber! - 1 : 0,
    );
    _currentPage = widget.ayatNumber != null ? widget.ayatNumber! - 1 : 0;

    _listScrollController = ScrollController();
    _listScrollController.addListener(_updateListScrollProgress);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.ayatNumber != null) {
        _highlightAyah(widget.ayatNumber!);
      }
      _updatePageScrollProgress();
    });

    _checkFavoriteStatus();
  }

  @override
  void dispose() {
    animationController.dispose();
    _pageController.dispose();
    _listScrollController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _updatePageScrollProgress() {
    _pageController.addListener(() {
      if (_pageController.position.haveDimensions) {
        setState(() {
          _scrollProgress =
              (_pageController.page! - _pageController.page!.floor()) / 1;
        });
      }
    });
  }

  void _updateListScrollProgress() {
    if (!_listScrollController.hasClients) return;

    final maxScroll = _listScrollController.position.maxScrollExtent;
    final currentScroll = _listScrollController.position.pixels;

    setState(() {
      _scrollProgress = currentScroll / maxScroll;
    });
  }

  void _toggleView() {
    setState(() {
      _isPageView = !_isPageView;
    });
  }

  void _highlightAyah(int ayahNumber) {
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

  void _updateSettings(Map<String, dynamic> settings) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isTranslationEnabled', settings['isTranslationEnabled']);
    await prefs.setString(
        'selectedTranslation', settings['selectedTranslation'].toString());
    await prefs.setDouble('arabicWordSpacing', settings['arabicWordSpacing']);
    await prefs.setString('arabicFontFamily', settings['arabicFontFamily']);
    await prefs.setString(
        'translationFontFamily', settings['translationFontFamily']);
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
            (element) =>
        element.toString() ==
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
        subtitle:
        "${quran.getSurahNameEnglish(widget.surahNumber)} removed from favorites",
        icon: Icon(Icons.favorite_border, color: AppColors.white),
        backgroundColor: Colors.red,
        textColor: AppColors.white,
      );
    } else {
      favorites.add(widget.surahNumber);
      CustomSnackbar.show(
        title: "Added",
        subtitle:
        "${quran.getSurahNameArabic(widget.surahNumber)} added to favorites",
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

  Widget _buildAyahItem(BuildContext context, int verseNumber) {
    final textColor = isDarkMode ? AppColors.white : AppColors.black;
    String verseText =
    quran.getVerse(widget.surahNumber, verseNumber, verseEndSymbol: false);
    String? translationText;
    if (isTranslationEnabled) {
      try {
        translationText = quran.getVerseTranslation(
            widget.surahNumber, verseNumber,
            translation: selectedTranslation);
      } catch (e) {
        translationText = "Translation not available.";
      }
    }

    // Arabic text style with all font options
    TextStyle arabicTextStyle;
    switch (selectedFontStyle) {
      case 'Amiri Quran':
        arabicTextStyle = GoogleFonts.amiriQuran(
            fontSize: arabicFontSize,
            wordSpacing: selectedWordSpacing,
            color: textColor);
        break;
      case 'Amiri':
        arabicTextStyle = GoogleFonts.amiri(
            fontSize: arabicFontSize,
            wordSpacing: selectedWordSpacing,
            color: textColor);
        break;
      case 'Noto Sans Arabic':
        arabicTextStyle = GoogleFonts.notoSansArabic(
            fontSize: arabicFontSize,
            wordSpacing: selectedWordSpacing,
            color: textColor);
        break;
      case 'Noto Naskh Arabic':
        arabicTextStyle = GoogleFonts.notoNaskhArabic(
            fontSize: arabicFontSize,
            wordSpacing: selectedWordSpacing,
            color: textColor);
        break;
      case 'Cairo':
        arabicTextStyle = GoogleFonts.cairo(
            fontSize: arabicFontSize,
            wordSpacing: selectedWordSpacing,
            color: textColor);
        break;
      case 'Tajawal':
        arabicTextStyle = GoogleFonts.tajawal(
            fontSize: arabicFontSize,
            wordSpacing: selectedWordSpacing,
            color: textColor);
        break;
      case 'Lalezar':
        arabicTextStyle = GoogleFonts.lalezar(
            fontSize: arabicFontSize,
            wordSpacing: selectedWordSpacing,
            color: textColor);
        break;
      case 'Lateef':
        arabicTextStyle = GoogleFonts.lateef(
            fontSize: arabicFontSize,
            wordSpacing: selectedWordSpacing,
            color: textColor);
        break;
      case 'Quicksand':
        arabicTextStyle = GoogleFonts.quicksand(
            fontSize: arabicFontSize,
            wordSpacing: selectedWordSpacing,
            color: textColor);
        break;
      default:
        arabicTextStyle = GoogleFonts.amiriQuran(
            fontSize: arabicFontSize,
            wordSpacing: selectedWordSpacing,
            color: textColor);
    }

    // Translation text style with all font options
    TextStyle translationTextStyle;
    switch (selectedTranslationFontFamily) {
      case 'Roboto':
        translationTextStyle = GoogleFonts.roboto(
            color: textColor,
            height: translationSpacing,
            fontSize: translationFontSize);
        break;
      case 'Times New Roman':
        translationTextStyle = TextStyle(
          fontFamily: 'Times New Roman',
          color: textColor,
          height: translationSpacing,
          fontSize: translationFontSize,
        );
        break;
      case 'Montserrat':
        translationTextStyle = GoogleFonts.montserrat(
            color: textColor,
            height: translationSpacing,
            fontSize: translationFontSize);
        break;
      case 'Inter':
        translationTextStyle = GoogleFonts.inter(
            color: textColor,
            height: translationSpacing,
            fontSize: translationFontSize);
        break;
      case 'Comfortaa':
        translationTextStyle = GoogleFonts.comfortaa(
            color: textColor,
            height: translationSpacing,
            fontSize: translationFontSize);
        break;
      case 'Questrial':
        translationTextStyle = GoogleFonts.questrial(
            color: textColor,
            height: translationSpacing,
            fontSize: translationFontSize);
        break;
      case 'Open Sans':
        translationTextStyle = GoogleFonts.openSans(
            color: textColor,
            height: translationSpacing,
            fontSize: translationFontSize);
        break;
      case 'Poppins':
        translationTextStyle = GoogleFonts.poppins(
            color: textColor,
            height: translationSpacing,
            fontSize: translationFontSize);
        break;
      default:
        translationTextStyle = GoogleFonts.roboto(
            color: textColor,
            height: translationSpacing,
            fontSize: translationFontSize);
    }

    return InkWell(
      splashColor: AppColors.transparent,
      onTap: () {
        Get.to(QuranSurahAyatDetailsScreen(
          arabicText: verseText,
          ayahIndex: verseNumber,
          surahIndex: widget.surahNumber,
          surahLatinName: quran.getSurahNameEnglish(widget.surahNumber),
          translation: translationText,
          surahArabicName: quran.getSurahNameArabic(widget.surahNumber),
          textAlign: TextAlign.start,
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

        final audioUrl =
        await quran.getAudioURLByVerse(widget.surahNumber, verseNumber);
        final currentDate = DateFormat('dd MMMM').format(DateTime.now());
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
            scale: _highlightedAyah == verseNumber ? scaleAnimation.value : 1.0,
            child: child,
          );
        },
        child: Container(
          margin: EdgeInsets.only(bottom: 5, top: 10.h),
          padding: EdgeInsets.all(18.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.r),
            color: (verseNumber % 2 == 0) // Use verseNumber instead of index
                ? AppColors.primary.withOpacity(0.29)
                : AppColors.primary.withOpacity(0.1),
          ),
          child: _isPageView
              ? Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
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
                      fontSize: 16.sp,
                      textColor: textColor,
                    ),
                  ),
                ],
              ),
              AppSizedBox.space15h,
              Center(
                child: Text(
                  verseText,
                  textAlign: TextAlign.center,
                  style: arabicTextStyle,
                ),
              ),
              AppSizedBox.space15h,
              if (isTranslationEnabled && translationText != null)
                Center(
                  child: Text(
                    translationText,
                    style: translationTextStyle,
                    textAlign: TextAlign.center,
                  ),
                ),
            ],
          )
              : Row(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                      fontSize: 16.sp,
                      textColor: textColor,
                    ),
                  ),
                ],
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      verseText,
                      textAlign: TextAlign.right,
                      style: arabicTextStyle,
                    ),
                    if (isTranslationEnabled &&
                        translationText != null)
                      Padding(
                        padding: EdgeInsets.only(top: 8.h),
                        child: Text(
                          translationText,
                          style: translationTextStyle,
                          textAlign: TextAlign.left,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textColor = isDarkMode ? AppColors.white : AppColors.black;
    final iconColor = isDarkMode ? AppColors.white : AppColors.black;
    final totalAyahs = quran.getVerseCount(widget.surahNumber);
    const visibleIndicatorCount = 6;

    int startIndex =
        (_currentPage / visibleIndicatorCount).floor() * visibleIndicatorCount;
    int endIndex = startIndex + visibleIndicatorCount;
    if (endIndex > totalAyahs) {
      endIndex = totalAyahs;
      startIndex = max(0, endIndex - visibleIndicatorCount);
    }

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
                    currentTranslationFontFamily:
                    selectedTranslationFontFamily,
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
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 10.w, right: 10.w),
            child: Column(
              children: [
                _isPageView
                    ? SizedBox()
                    : LinearProgressIndicator(
                  value: _scrollProgress,
                  backgroundColor: AppColors.grey.withOpacity(0.1),
                  valueColor:
                  AlwaysStoppedAnimation<Color>(AppColors.primary),
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
              ],
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                _isPageView
                    ? PageView.builder(
                  controller: _pageController,
                  itemCount: totalAyahs,
                  onPageChanged: (int page) {
                    setState(() {
                      _currentPage = page;
                      _scrollProgress = (page + 1) / totalAyahs;
                    });
                  },
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      child: _buildAyahItem(context, index + 1),
                    );
                  },
                )
                    : ListView.builder(
                  controller: _listScrollController,
                  scrollDirection: Axis.vertical,
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  itemCount: totalAyahs,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.only(right: 10.w),
                      child: _buildAyahItem(context, index + 1),
                    );
                  },
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 8.h),
            child: Column(
              children: [
                if (_isPageView)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List<Widget>.generate(
                      visibleIndicatorCount,
                          (index) {
                        final adjustedIndex = startIndex + index;
                        if (adjustedIndex < 0 ||
                            adjustedIndex >= totalAyahs) {
                          return const SizedBox.shrink();
                        }
                        return Container(
                          width: 8.0,
                          height: 8.0,
                          margin: EdgeInsets.symmetric(horizontal: 4.0),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _currentPage == adjustedIndex
                                ? AppColors.primary
                                : (isDarkMode
                                ? AppColors.white.withOpacity(0.4)
                                : AppColors.black.withOpacity(0.4)),
                          ),
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
          AppSizedBox.space10h,
        ],
      ),
    );
  }
}

