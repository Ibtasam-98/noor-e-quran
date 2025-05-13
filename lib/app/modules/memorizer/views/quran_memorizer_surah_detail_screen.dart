import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:noor_e_quran/app/widgets/custom_snackbar.dart';
import 'package:quran/quran.dart' as quran;
import 'package:google_fonts/google_fonts.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icons.dart';
import '../../../controllers/app_theme_switch_controller.dart';
import '../../../widgets/custom_text.dart';
import '../../../config/app_colors.dart';
import '../../../config/app_sizedbox.dart';
import '../../../widgets/custom_frame.dart';
import 'package:vibration/vibration.dart'; // Import the vibration package.

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
  final String _lastViewedPageKey = 'lastViewedPage'; // Key for last viewed page
  final String _lastPageViewKey =
      'lastPageView'; // Key for last page view position
  late List<String> _verses;
  bool _isSurahFullyMemorized = false; // Track Surah memorization status


  @override
  void initState() {
    super.initState();
    _totalVerses = quran.getVerseCount(widget.surahNumber);
    // Initialize page controller with saved page, or default to 0
    _currentPage =
        _storage.read<int?>('$_lastViewedPageKey${widget.surahNumber}') ?? 0;
    _pageController = PageController(initialPage: _currentPage);

    _loadMemorizedVerses();
    _saveLastAccessedSurah();
    _saveTotalVerses();
    _saveSurahName();
    _loadVerses();
  }

  // Function to load all verses of the surah
  void _loadVerses() {
    _verses = List.generate(
      _totalVerses,
          (index) => quran.getVerse(widget.surahNumber, index + 1),
    );
  }

  @override
  void dispose() {
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
    print("Loaded memorized verses: $_memorizedVerses");
  }

  Future<void> _saveMemorizedVerses() async {
    print("Saving memorized verses: $_memorizedVerses");
    await _storage.write(_memorizedVersesKey, _memorizedVerses.toList());
  }

  Future<void> _saveLastAccessedSurah() async {
    final now = DateTime.now();
    final formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
    print(
        "Saving last accessed surah: $formattedDate, surahNumber: ${widget
            .surahNumber}");
    await _storage.write(_lastAccessedSurahKey, formattedDate);
    await _storage.write('lastAccessedSurahNumber', widget.surahNumber);
    await _storage.write(_lastAccessedTimeKey, formattedDate);
  }

  Future<void> _saveTotalVerses() async {
    print(
        "Saving total verses: $_totalVerses for surahNumber: ${widget
            .surahNumber}");
    await _storage.write(
        '$_totalVersesKey${widget.surahNumber}', _totalVerses);
  }

  Future<void> _saveSurahName() async {
    final surahName = quran.getSurahName(widget.surahNumber);
    print(
        "Saving surah name: $surahName for surahNumber: ${widget.surahNumber}");
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
    // Make the function async to use await
    final verseKey = '${widget.surahNumber}:${verseNumber}';
    print("Toggling memorization for verse: $verseKey");
    if (_memorizedVerses.contains(verseKey)) {
      _memorizedVerses.remove(verseKey);
      print("Verse removed. Current memorized verses: $_memorizedVerses");
    } else {
      _memorizedVerses.add(verseKey);
      print("Verse added. Current memorized verses: $_memorizedVerses");
    }
    _saveMemorizedVerses();
    setState(() {
      // Check if the whole surah is memorized
      if (_memorizedVerses
          .where((v) => v.startsWith('${widget.surahNumber}:'))
          .length ==
          _totalVerses) {
        _isSurahFullyMemorized = true;
      } else {
        _isSurahFullyMemorized = false;
      }
    });

    // Add vibration feedback
    if (await Vibration.hasVibrator() ?? false) {
      Vibration.vibrate(duration: 50); // Vibrate for 50 milliseconds
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
      themeController.isDarkMode.value ? AppColors.black : AppColors.white,
      appBar: AppBar(
        backgroundColor:
        themeController.isDarkMode.value ? AppColors.black : AppColors.white,
        title: CustomText(
          title: quran.getSurahName(widget.surahNumber),
          fontSize: 18.sp,
          textColor:
          themeController.isDarkMode.value ? AppColors.white : AppColors.black,
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.west,
            color: themeController.isDarkMode.value
                ? AppColors.white
                : AppColors.black,
          ),
        ),
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
                  _storage.write(
                      '$_lastViewedPageKey${widget.surahNumber}',
                      page); // Save current page
                });
              },
              itemBuilder: (context, index) {
                final verseNumber = index + 1;
                final verseKey = '${widget.surahNumber}:${verseNumber}';
                final isMemorized = _memorizedVerses.contains(verseKey);
                return Container(
                   margin: EdgeInsets.all(10.h),
                  decoration: BoxDecoration(
                    color: themeController.isDarkMode.value
                        ? AppColors.black
                        : AppColors.white,
                    borderRadius: BorderRadius.circular(10.r),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 2,
                      ),
                    ],
                  ),
                  height: MediaQuery.of(context).size.height, // Use full height
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomFrame(
                          leftImageAsset: "assets/frames/topLeftFrame.png",
                          rightImageAsset: "assets/frames/topRightFrame.png",
                          imageHeight: 60.h,
                          imageWidth: 60.w,
                        ),
                        Flexible( // Use Flexible instead of Expanded
                          child: SingleChildScrollView( // Add nested scroll for the content if needed
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
                                CustomText(
                                  title: quran.getVerse(widget.surahNumber, verseNumber),
                                  textColor: isMemorized ? AppColors.green : (themeController.isDarkMode.value ? AppColors.white : AppColors.black),
                                  textStyle: GoogleFonts.amiri(height: 2,),
                                  textAlign: TextAlign.center,
                                  fontSize: 22.sp,
                                ),
                                AppSizedBox.space10h,
                                CustomText(
                                  title: quran.getVerseTranslation(widget.surahNumber, verseNumber,
                                      translation: quran.Translation.enSaheeh) ?? "Translation not available",
                                  fontSize: 16.sp,
                                  textColor: isMemorized
                                      ? AppColors.green
                                      : (themeController.isDarkMode.value
                                      ? AppColors.white
                                      : AppColors.black),
                                  textAlign: TextAlign.center,
                                ),
                              ],
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
            padding: EdgeInsets.symmetric(vertical: 20.0,horizontal: 10),
            child: Container(
              margin: EdgeInsets.only(bottom: 10.h),
              decoration: BoxDecoration(
                color: themeController.isDarkMode.value
                    ? AppColors.black
                    : AppColors.white,
                borderRadius: BorderRadius.circular(12.r),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 2,
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.arrow_left,
                      size: 33.h,
                    ),
                    onPressed: _goToPreviousPage,
                    iconSize: 40,
                    color: themeController.isDarkMode.value
                        ? AppColors.white
                        : AppColors.black,
                  ),
                  Obx(
                        () =>
                        IconButton(
                          icon: _memorizedVerses.contains(
                              '${widget.surahNumber}:${_currentPage + 1}')
                              ? Icon(LineIcons.checkCircle,
                              color: AppColors.green)
                              : Icon(LineIcons.checkCircle,
                              color: AppColors.grey),
                          onPressed: () {
                            _toggleMemorized(_currentPage + 1);
                            if (_isSurahFullyMemorized) {
                              // Show snackbar
                              CustomSnackbar.show(
                                title: "Ma Sha Allah",
                                subtitle: "You have memorized Surah ${quran.getSurahName(widget.surahNumber)}!",
                                icon: Icon(LineIcons.checkCircle,),
                                backgroundColor: AppColors.green,
                              );
                            }
                          },
                          iconSize: 40,
                        ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.arrow_right,
                      size: 33.h,
                    ),
                    onPressed: _goToNextPage,
                    iconSize: 40,
                    color: themeController.isDarkMode.value
                        ? AppColors.white
                        : AppColors.black,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

