import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:noor_e_quran/app/config/app_colors.dart';
import 'package:quran/quran.dart' as quran;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:noor_e_quran/app/config/app_sizedbox.dart';
import 'package:noor_e_quran/app/widgets/custom_text.dart';

class NavigteExploreSurahsController extends GetxController with SingleGetTickerProviderMixin {
  late TabController tabController;

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 3, vsync: this);
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }

  void showQuranInfoSheet(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: AppColors.white,
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(top: 20.w, left: 10.w, right: 5.w,bottom: 25.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  firstText: "Quran e ",
                  secondText: "Kareem",
                  fontFamily: 'grenda',
                  firstTextColor: AppColors.black,
                  secondTextColor: AppColors.primary,
                  fontSize: 18.sp,
                ),
                AppSizedBox.space15h,
                _buildInfoTile("Sajdah Count", "15",
                    cardColor: AppColors.primary.withOpacity(0.1)),
                _buildInfoTile("Madani Surahs", quran.totalMadaniSurahs.toString(),
                    cardColor: AppColors.primary.withOpacity(0.39)),
                _buildInfoTile("Makki Surahs", quran.totalMakkiSurahs.toString(),
                    cardColor: AppColors.primary.withOpacity(0.1)),
                _buildInfoTile("Total Surahs", quran.totalSurahCount.toString(),
                    cardColor: AppColors.primary.withOpacity(0.39)),
                _buildInfoTile("Total Verses", quran.totalVerseCount.toString(),
                    cardColor: AppColors.primary.withOpacity(0.1)),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildInfoTile(String title, String value, {Color? cardColor}) {
    return Container(
      margin: EdgeInsets.only(bottom: 5),
      padding: EdgeInsets.all(25.h),
      width: Get.width,
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: CustomText(
              title: title,
              fontSize: 16.sp,
              textColor: AppColors.black,
              fontWeight: FontWeight.w500,
              textOverflow: TextOverflow.ellipsis,
              maxLines: 1,
              textAlign: TextAlign.start,
            ),
          ),
          Expanded(
            child: CustomText(
              title: value,
              fontSize: 14.sp,
              textColor: AppColors.primary,
              textAlign: TextAlign.end,
              textOverflow: TextOverflow.ellipsis,
              fontWeight: FontWeight.w500,
              maxLines: 1,
            ),
          )
        ],
      ),
    );
  }
}