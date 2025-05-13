
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import '../../../config/app_colors.dart';
import '../../../config/app_sizedbox.dart';
import '../../../config/prayer_enum.dart';
import '../../../controllers/app_theme_switch_controller.dart';
import '../../../widgets/custom_frame.dart';
import '../../../widgets/custom_text.dart';


class SpecificPrayerDetails extends StatefulWidget {
  final PrayerType prayerType;
  final String prayerName;

  SpecificPrayerDetails(this.prayerType, this.prayerName);

  @override
  _SpecificPrayerDetailsState createState() => _SpecificPrayerDetailsState();
}

class _SpecificPrayerDetailsState extends State<SpecificPrayerDetails> {
  Map<String, dynamic>? prayerDetails;
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    loadPrayerData();
  }

  Future<void> loadPrayerData() async {
    try {
      print('Loading prayer data:');
      print('  prayerName: ${widget.prayerName}');

      String data = await rootBundle.loadString('assets/json/prayer.json');
      Map<String, dynamic> jsonData = json.decode(data);

      String prayerCategory;
      switch (widget.prayerType) {
        case PrayerType.obligatory:
          prayerCategory = 'Obligatory';
          break;
        case PrayerType.sunnah:
          prayerCategory = 'Sunnah';
          break;
        case PrayerType.eid:
          prayerCategory = 'Eid';
          break;
        case PrayerType.friday:
          prayerCategory = 'Friday';
          break;
        case PrayerType.taraweeh:
          prayerCategory = 'Taraweeh';
          break;
        case PrayerType.funeral:
          prayerCategory = 'Funeral';
          break;
        case PrayerType.hajat:
          prayerCategory = 'Hajat';
          break;
        case PrayerType.istikhara:
          prayerCategory = 'Istikhara';
          break;
        default:
          prayerCategory = '';
      }

      print('prayerCategory: $prayerCategory'); //added print statement for debugging

      // Corrected JSON lookup
      if (prayerCategory == widget.prayerName) {
        prayerDetails = jsonData[prayerCategory][widget.prayerName];
      } else {
        prayerDetails = jsonData[prayerCategory][widget.prayerName];
      }

      if (prayerDetails == null) {
        throw Exception(
            'Prayer details not found for ${widget.prayerName} in $prayerCategory. jsonData[prayerCategory]: ${jsonData[prayerCategory]}');
      }

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print('Error loading prayer data: $e');
      setState(() {
        isLoading = false;
        errorMessage = 'Failed to load data: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppThemeSwitchController themeController =
    Get.put(AppThemeSwitchController());
    bool isDarkMode = themeController.isDarkMode.value;
    final iconColor = isDarkMode ? AppColors.white : AppColors.black;
    final textColor = isDarkMode ?  AppColors.white : AppColors.black;

    return Scaffold(
      backgroundColor:
      themeController.isDarkMode.value ? AppColors.black : AppColors.white,
      appBar: AppBar(
        centerTitle: false,
        surfaceTintColor: AppColors.transparent,
        foregroundColor: AppColors.transparent,
        title: CustomText(
          firstText: "Prayer ",
          secondText: "Devotion",
          fontSize: 18.sp,
          firstTextColor: isDarkMode ? AppColors.white : AppColors.black,
          secondTextColor: AppColors.primary,
        ),
        backgroundColor:
        themeController.isDarkMode.value ? AppColors.black : AppColors.white,
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
          InkWell(
            splashColor: AppColors.transparent,
            highlightColor: AppColors.transparent,
            onTap: () {},
            child: Icon(
              Icons.share,
              color: iconColor,
              size: 16.h,
            ),
          ),
          AppSizedBox.space15w,
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
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
                Padding(
                  padding: EdgeInsets.only(left: 16.w, right: 16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        textColor: textColor,
                        fontSize: 20.sp,
                        title: widget.prayerName,
                        fontFamily: 'grenda',
                        capitalize: true,
                      ),
                      AppSizedBox.space10h,
                      Container(
                        width: Get.width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.r),
                          color: AppColors.primary.withOpacity(0.1),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(20.w),
                          child: CustomText(
                            title: prayerDetails != null && prayerDetails!['verse'] != null && prayerDetails!['verse']['verse'] != null
                                ? '"${prayerDetails!['verse']['verse']}"'
                                : 'Verse not found',
                            fontSize: 18.sp,
                            textColor: textColor,
                            textAlign: TextAlign.end,
                          ),
                        ),
                      ),
                      AppSizedBox.space10h,
                      CustomText(
                        title: prayerDetails != null && prayerDetails!['verse'] != null && prayerDetails!['verse']['details'] != null
                            ? '${prayerDetails!['verse']['details']}'
                            : 'Details not found',
                        textColor: textColor,
                        fontSize: 16.sp,
                        textAlign: TextAlign.start,
                      ),
                      AppSizedBox.space5h,
                      CustomText(
                        title: prayerDetails != null && prayerDetails!['verse'] != null && prayerDetails!['verse']['reference'] != null
                            ? '${prayerDetails!['verse']['reference']}'
                            : 'Reference not found',
                        textColor: AppColors.primary,
                        fontWeight: FontWeight.w700,
                        fontSize: 15.sp,
                        textAlign: TextAlign.start,
                        textStyle: TextStyle(
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      AppSizedBox.space10h,
                      CustomText(
                        textColor: textColor,
                        fontSize: 20.sp,
                        title: "Importance",
                        fontFamily: 'grenda',
                        capitalize: true,
                      ),
                      AppSizedBox.space5h,
                      CustomText(
                        textColor: textColor,
                        fontSize: 16.sp,
                        title: prayerDetails != null && prayerDetails!['importance'] != null
                            ? prayerDetails!['importance']
                            : 'Importance not found',
                        capitalize: true,
                        textAlign: TextAlign.start,
                      ),
                      AppSizedBox.space10h,
                    ],
                  ),
                ),
                CustomFrame(
                  leftImageAsset: "assets/frames/bottomLeftFrame.png",
                  rightImageAsset: "assets/frames/bottomRightFrame.png",
                  imageHeight: 65.h,
                  imageWidth: 65.w,
                ),
              ],
            )),
      ),
    );
  }
}
