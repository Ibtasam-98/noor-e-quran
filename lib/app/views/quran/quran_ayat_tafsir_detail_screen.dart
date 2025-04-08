
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icons.dart';
import 'package:noor_e_quran/app/config/app_sizedbox.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shimmer/shimmer.dart';
import '../../config/app_colors.dart';
import '../../controllers/app_theme_switch_controller.dart';
import '../../controllers/quran_ayat_tafsir_detail_controller.dart';
import '../../widgets/custom_text.dart';

class QuranAyatTafsirDetailScreen extends StatefulWidget {
  final int surahNumber;
  final int ayahNumber;
  final String surahName, ayat, surahArabicName;

  const QuranAyatTafsirDetailScreen({
    Key? key,
    required this.surahNumber,
    required this.ayahNumber,
    required this.surahName,
    required this.ayat,
    required this.surahArabicName
  }) : super(key: key);

  @override
  _QuranAyatTafsirDetailScreenState createState() => _QuranAyatTafsirDetailScreenState();
}

class _QuranAyatTafsirDetailScreenState extends State<QuranAyatTafsirDetailScreen> {
  late AyatTafsirController controller;
  late AppThemeSwitchController themeController;

  @override
  void initState() {
    super.initState();
    controller = Get.put(AyatTafsirController(
      surahNumber: widget.surahNumber,
      ayahNumber: widget.ayahNumber,
    ));
    themeController = Get.put(AppThemeSwitchController());
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   _showFilterBottomSheet(context);
    // });
  }

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
        backgroundColor: isDarkMode ? AppColors.black : AppColors.white,
        centerTitle: false,
        title: CustomText(
          firstText: "Ayat ",
          secondText: "Tafsir",
          fontSize: 18.sp,
          firstTextColor: textColor,
          secondTextColor: AppColors.primary,
        ),
        leading: IconButton(
          icon: Icon(Icons.west, color: iconColor),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          InkWell(
            onTap: (){
              Share.share('Check out this Ayah tafsir: \nSurah Name ${widget.surahArabicName} \n\n Ayat \n${widget.ayat} Tasfir\n\n${controller.tafsirText.value}');
            },
            child: Icon(
              Icons.share,
              color: iconColor,
              size: 17.h,
            ),
          ),
          IconButton(
            icon: Icon(LineIcons.filter, color: iconColor,size: 20.h,),
            onPressed: () {
              _showFilterBottomSheet(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.only(left: 10.w, bottom: 15.h, right: 10.w),
        child: Obx(() {
          if (controller.selectedLanguageSlug.value == null) {
            return _buildInitialState(context, textColor);
          } else {
            return _buildTafsirContent(context, textColor);
          }
        }),
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
            Obx(() => Expanded(
              child: Slider(
                value: controller.currentFontSize.value,
                min: 12.0,
                max: 60.0,
                divisions: 14,
                label: "${controller.currentFontSize.value.toStringAsFixed(1)}",
                activeColor: AppColors.primary,
                inactiveColor: AppColors.primary,
                onChanged: (value) {
                  controller.updateFontSize(value);
                },
              ),
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildInitialState(BuildContext context, Color textColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                  textColor: textColor,
                  fontSize: 18.sp,
                  title: widget.surahName,
                  fontFamily: 'grenda',
                  capitalize: true,
                ),
                CustomText(
                  textColor: textColor,
                  fontSize: 18.sp,
                  title: widget.surahArabicName,
                  fontFamily: 'grenda',
                  capitalize: true,
                ),
              ],
            ),
            CustomText(
              textColor: AppColors.primary,
              fontSize: 15.sp,
              title:
              'Surah Number ${widget.surahNumber} | Ayat ${widget.ayahNumber}',
              fontFamily: 'quicksand',
              capitalize: true,
              fontWeight: FontWeight.bold,
            ),
          ],
        ),
        AppSizedBox.space10h,
        Container(
          padding: EdgeInsets.all(10.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.r),
            color: AppColors.primary.withOpacity(0.39),
          ),
          child: ListTile(
            splashColor: AppColors.transparent,
            hoverColor: AppColors.transparent,
            focusColor: AppColors.transparent,
            leading: Container(
              width: 32.w,
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
                    widget.ayahNumber.toString(),
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: textColor,
                    ),
                    textAlign: TextAlign.end,
                  ),
                ),
              ),
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                CustomText(
                  title: widget.ayat,
                  textAlign: TextAlign.end,
                  fontSize: controller.currentFontSize.value,
                  textColor: textColor,
                ),
              ],
            ),
          ),
        ),
        AppSizedBox.space25h,
        Center(
          child: CustomText(
            title: "Click on top right \nicon to select tafsir",
            fontSize: 14.sp,
            textColor: textColor,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _buildTafsirContent(BuildContext context, Color textColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                  textColor: textColor,
                  fontSize: 18.sp,
                  title: widget.surahName,
                  fontFamily: 'grenda',
                  capitalize: true,
                ),
                CustomText(
                  textColor: textColor,
                  fontSize: 18.sp,
                  title: widget.surahArabicName,
                  fontFamily: 'grenda',
                  capitalize: true,
                ),
              ],
            ),
            CustomText(
              textColor: AppColors.primary,
              fontSize: 15.sp,
              title:
              'Surah Number ${widget.surahNumber} | Ayat ${widget.ayahNumber}',
              fontFamily: 'quicksand',
              capitalize: true,
              fontWeight: FontWeight.bold,
            ),
          ],
        ),
        AppSizedBox.space10h,
        Container(
          padding: EdgeInsets.all(10.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.r),
            color: AppColors.primary.withOpacity(0.39),
          ),
          child: ListTile(
            splashColor: AppColors.transparent,
            hoverColor: AppColors.transparent,
            focusColor: AppColors.transparent,
            leading: Container(
              width: 32.w,
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
                    widget.ayahNumber.toString(),
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: textColor,
                    ),
                    textAlign: TextAlign.end,
                  ),
                ),
              ),
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  widget.ayat,
                  textAlign: TextAlign.end,
                  style: TextStyle(color: textColor),
                ),
              ],
            ),
          ),
        ),
        AppSizedBox.space10h,
        controller.isLoading.value
            ? Center(
          child: Shimmer.fromColors(
            period: Duration(milliseconds: 1000),
            baseColor: themeController.isDarkMode.value
                ? AppColors.black.withOpacity(0.1)
                : AppColors.black.withOpacity(0.2),
            highlightColor: themeController.isDarkMode.value
                ? AppColors.lightGrey.withOpacity(0.3)
                : AppColors.grey.withOpacity(0.4),
            child: Container(
              width: Get.width,
              height: 250.h,
              decoration: BoxDecoration(
                color: themeController.isDarkMode.value
                    ? AppColors.black.withOpacity(0.2)
                    : AppColors.white.withOpacity(0.5),
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
          ),
        )
            : Expanded(
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(15.r),
              ),
              child: CustomText(
                title: controller.tafsirText.value,
                textAlign: controller.isUrdu ||
                    controller.selectedLanguageSlug.value
                        ?.startsWith("ar") ==
                        true
                    ? TextAlign.right
                    : TextAlign.left,
                fontSize: controller.currentFontSize.value,
                textColor: textColor,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor:AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                  left: 16.w,
                  right: 16.w,
                  top: 20.h,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    buildDropdown(
                      title: "Select Author",
                      hint: "Choose an Author",
                      value: controller.selectedAuthor.value,
                      items: controller.tafsirData
                          .map((item) => item["author"].toString())
                          .toSet()
                          .toList(),
                      onChanged: (value) {
                        controller.onAuthorSelected(value);
                        setState(() {});
                      },
                    ),
                    if (controller.selectedAuthor.value != null) ...[
                      AppSizedBox.space20h,
                      buildDropdown(
                        title: "Select Tafsir",
                        hint: "Choose a Tafsir",
                        value: controller.selectedTafsir.value,
                        items: controller.availableTafsir,
                        onChanged: (value) {
                          controller.onTafsirSelected(value);
                          setState(() {});
                        },
                      ),
                    ],
                    if (controller.selectedTafsir.value != null) ...[
                      AppSizedBox.space20h,
                      buildDropdown(
                        title: "Select Language",
                        hint: "Choose a Language",
                        value: controller.selectedLanguage.value,
                        items: controller.availableLanguages,
                        onChanged: (value) {
                          controller.onLanguageSelected(value);
                          Navigator.pop(context);
                        },
                      ),
                    ],
                    AppSizedBox.space50h
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget buildDropdown({
    required String title,
    required String hint,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    final AppThemeSwitchController controller =
    Get.put(AppThemeSwitchController());

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(15.r),
          ),
          child: DropdownButtonFormField<String>(
            isExpanded: true,
            value: items.contains(value) ? value : null,
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.zero,
              border: InputBorder.none,
            ),
            alignment: Alignment.center,
            dropdownColor: AppColors.white,
            hint: Align(
              alignment: Alignment.centerLeft,
              child: CustomText(
                title: hint,
                textAlign: TextAlign.start,
                fontSize: 15.sp,
                textColor: AppColors.primary,
              ),
            ),
            items: items
                .map(
                  (item) => DropdownMenuItem<String>(
                value: item,
                child: CustomText(
                  title: item,
                  fontSize: 15.sp,
                  textColor: AppColors.primary,
                  textAlign: TextAlign.start,
                ),
              ),
            )
                .toList(),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}
