import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:noor_e_quran/app/config/app_colors.dart';
import 'package:noor_e_quran/app/config/app_sizedbox.dart';
import 'package:share_plus/share_plus.dart';
import '../../../controllers/app_theme_switch_controller.dart';
import '../../../widgets/custom_frame.dart';
import '../../../widgets/custom_text.dart';

class FivePillarIslamScreen extends StatelessWidget {
  final AppThemeSwitchController themeController = Get.put(AppThemeSwitchController());
  final FivePillarsController pillarsController = Get.put(FivePillarsController());

  @override
  Widget build(BuildContext context) {
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
          firstText: "Islamic ",
          secondText: "Pillars",
          fontSize: 18.sp,
          firstTextColor: textColor,
          secondTextColor: AppColors.primary,
        ),
        backgroundColor: isDarkMode ? AppColors.black : AppColors.white,
        leading: InkWell(
          splashColor: AppColors.transparent,
          highlightColor: AppColors.transparent,
          onTap: () {
            Get.back();
          },
          child: Icon(
            Icons.west,
            color: iconColor,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.share, color: iconColor),
            onPressed: () {
              final pillar = pillarsController.pillars[pillarsController.currentPageNotifier.value];
              final shareText =
                  "Pillar Number ${pillar['Id']}\n\n"
                  "${pillar['name']}\n\n"
                  "${pillar['arabic']}\n\n"
                  "${pillar['translation']}\n\n"
                  "${pillar['urduDesc']}\n\n"
                  "Share from Noor e Quran App";
              Share.share(shareText);
            },
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: pillarsController.pageController,
              itemCount: pillarsController.pillars.length,
              itemBuilder: (context, index) {
                var pillar = pillarsController.pillars[index];
                return Container(
                  margin: EdgeInsets.all(10.w),
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomFrame(
                        leftImageAsset: "assets/frames/topLeftFrame.png",
                        rightImageAsset: "assets/frames/topRightFrame.png",
                        imageHeight: 65.h,
                        imageWidth: 65.w,
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomText(
                                  title: pillar['name'].toString(),
                                  fontSize: 20.sp,
                                  textColor: AppColors.primary,
                                  fontFamily: 'grenda',
                                  maxLines: 5000,
                                  textAlign: TextAlign.start,
                                ),
                                AppSizedBox.space15h,
                                Container(
                                  width: Get.width,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.r),
                                      color: AppColors.primary.withOpacity(0.39)),
                                  child: Padding(
                                    padding: EdgeInsets.all(20.w),
                                    child: Obx(() => CustomText(
                                      title: pillar['arabic'].toString(),
                                      fontSize: pillarsController.currentFontSize.value,
                                      textColor: textColor,
                                      textAlign: TextAlign.end,
                                      maxLines: 5000,
                                    )),
                                  ),
                                ),
                                AppSizedBox.space10h,
                                CustomText(
                                  textColor: AppColors.primary,
                                  fontSize: pillarsController.currentFontSize.value,
                                  maxLines: 2,
                                  textAlign: TextAlign.start,
                                  title: "Translation",
                                  fontFamily: 'grenda',
                                ),
                                AppSizedBox.space10h,
                                Obx(() => CustomText(
                                  title: pillar['translation'].toString(),
                                  fontSize: pillarsController.currentFontSize.value,
                                  textColor: textColor,
                                  textAlign: TextAlign.start,
                                  maxLines: 500000,
                                )),
                                AppSizedBox.space15h,
                                Obx(() => CustomText(
                                  title: pillar['description'].toString(),
                                  fontSize: pillarsController.currentFontSize.value,
                                  textColor: textColor,
                                  textAlign: TextAlign.justify,
                                  maxLines: 500000,
                                )),
                                AppSizedBox.space15h,
                                Obx(() => CustomText(
                                  title: pillar['urduDesc'].toString(),
                                  fontSize: pillarsController.currentFontSize.value,
                                  textColor: textColor,
                                  textAlign: TextAlign.end,
                                  maxLines: 500000,
                                )),
                              ],
                            ),
                          ),
                        ),
                      ),
                      CustomFrame(
                        leftImageAsset: "assets/frames/bottomLeftFrame.png",
                        rightImageAsset: "assets/frames/bottomRightFrame.png",
                        imageHeight: 65.h,
                        imageWidth: 65.w,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          ValueListenableBuilder<int>(
            valueListenable: pillarsController.currentPageNotifier,
            builder: (context, currentPage, _) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  pillarsController.pillars.length,
                      (index) => GestureDetector(
                    onTap: () => pillarsController.onDotTapped(index),
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      width: 8.w,
                      height: 8.h,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: currentPage == index
                            ? AppColors.primary
                            : AppColors.grey,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          AppSizedBox.space25h,
          BottomAppBar(
            color: AppColors.transparent,
            child: Row(
              children: [
                CustomText(
                  textColor: textColor,
                  fontSize: 18.sp,
                  title: "Font Size",
                ),
                Expanded(
                  child: Obx(() => Slider(
                    value: pillarsController.currentFontSize.value,
                    min: 12.0,
                    max: 40.0,
                    onChanged: (newValue) {
                      pillarsController.updateFontSize(newValue);
                    },
                    activeColor: AppColors.primary,
                    inactiveColor: AppColors.primary,
                  ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}



class FivePillarsController extends GetxController {
  final List<Map<String, Object>> pillars = [
    // Your pillars data here
    {
      'Id': 1,
      'name': 'Shahada (Testimony of Faith)',
      'arabic': 'لَا إِلَٰهَ إِلَّا ٱللَّٰهُ مُحَمَّدٌ رَسُولُ ٱللَّٰهِ',
      'translation': 'There is no god but Allah, and Muhammad is the messenger of Allah.',
      'description': 'The Shahada is the Islamic creed declaring belief in the oneness of God (Allah) and the acceptance of Muhammad as God\'s prophet.',
      'urduDesc': 'شہادہ اسلام کا بنیادی عقیدہ ہے جو اللہ کی وحدانیت اور محمد صلی اللہ علیہ وسلم کو اللہ کا رسول ماننے کا اعلان کرتا ہے۔',
    },
    {
      'Id': 2,
      'name': 'Salat (Prayer)',
      'arabic': 'الصلاة',
      'translation': 'Prayer',
      'description': 'Muslims are required to pray five times a day, facing the Kaaba in Mecca.',
      'urduDesc': 'مسلمانوں کو دن میں پانچ بار مکہ میں کعبہ کی طرف منہ کرکے نماز ادا کرنے کی ضرورت ہے۔',
    },
    {
      'Id': 3,
      'name': 'Zakat (Charity)',
      'arabic': 'الزكاة',
      'translation': 'Charity',
      'description': 'Zakat is the practice of charitable giving, based on accumulated wealth. It is obligatory for all Muslims who meet the necessary criteria of wealth.',
      'urduDesc': 'زکوٰۃ جمع شدہ دولت پر مبنی خیراتی عطیہ کی مشق ہے۔ یہ ان تمام مسلمانوں کے لیے فرض ہے جو دولت کے ضروری معیار پر پورا اترتے ہیں۔',
    },
    {
      'Id': 4,
      'name': 'Sawm (Fasting)',
      'arabic': 'الصوم',
      'translation': 'Fasting',
      'description': 'During the month of Ramadan, Muslims abstain from food and drink from dawn until sunset.',
      'urduDesc': 'رمضان کے مہینے میں مسلمان طلوع فجر سے غروب آفتاب تک کھانے پینے سے پرہیز کرتے ہیں۔',
    },
    {
      'Id': 5,
      'name': 'Hajj (Pilgrimage)',
      'arabic': 'الحج',
      'translation': 'Pilgrimage',
      'description': 'If physically and financially able, Muslims are required to make a pilgrimage to Mecca at least once in their lifetime.',
      'urduDesc': 'اگر جسمانی اور مالی طور پر قابل ہو تو مسلمانوں کو زندگی میں کم از کم ایک بار مکہ مکرمہ کا حج کرنا ضروری ہے۔',
    },
    // Add other pillars here
  ];

  late PageController pageController;
  late ValueNotifier<int> currentPageNotifier;
  RxDouble currentFontSize = 20.0.obs;

  @override
  void onInit() {
    super.onInit();
    initPageController();
  }

  void initPageController() {
    pageController = PageController();
    currentPageNotifier = ValueNotifier<int>(0);
    pageController.addListener(() {
      if (pageController.page?.toInt() != currentPageNotifier.value) {
        currentPageNotifier.value = pageController.page?.toInt() ?? 0;
      }
    });
  }

  void disposePageController() {
    currentPageNotifier.dispose();
    pageController.dispose();
  }

  void onDotTapped(int index) {
    pageController.animateToPage(
      index,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void updateFontSize(double newValue) {
    currentFontSize.value = newValue;
  }
}