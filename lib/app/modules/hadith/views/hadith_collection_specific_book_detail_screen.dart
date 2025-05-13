
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hadith/hadith.dart';
import 'package:noor_e_quran/app/config/app_sizedbox.dart';
import 'package:noor_e_quran/app/widgets/custom_button.dart';
import 'package:shimmer/shimmer.dart';
import '../controllers/hadith_collection_specific_book_detail_controller.dart';
import 'hadith_detail_screen.dart';
import 'package:noor_e_quran/app/config/app_colors.dart';
import 'package:noor_e_quran/app/controllers/app_theme_switch_controller.dart';
import 'package:noor_e_quran/app/widgets/custom_card.dart';
import 'package:noor_e_quran/app/widgets/custom_text.dart';

class HadithCollectionSpecificBookDetailScreen extends StatelessWidget {
  final Collections collection;
  final int bookNumber, totalHadith;
  final String bookFirstName;
  final String bookLastName;

  HadithCollectionSpecificBookDetailScreen({
    required this.collection,
    required this.bookNumber,
    required this.bookFirstName,
    required this.bookLastName,
    required this.totalHadith
  });

  final AppThemeSwitchController themeController = Get.find();

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HadithCollectionSpecificBookDetailController(
      collection: collection,
      bookNumber: bookNumber,
      bookFirstName: bookFirstName,
      bookLastName: bookLastName,
    ));

    return GetBuilder<HadithCollectionSpecificBookDetailController>(
      builder: (controller) {
        return Scaffold(
          backgroundColor: themeController.isDarkMode.value ? AppColors.black : AppColors.white,
          appBar: _buildAppBar(context, controller),
          body: _buildBody(context, controller),
        );
      },
    );
  }

  AppBar _buildAppBar(BuildContext context, HadithCollectionSpecificBookDetailController controller) {
    bool isDarkMode = themeController.isDarkMode.value;
    final iconColor = isDarkMode ? AppColors.white : AppColors.black;

    return AppBar(
      surfaceTintColor: AppColors.transparent,
      title: CustomText(
        firstText: "Book ",
        secondText: controller.collection.name,
        capitalize: true,
        fontSize: 18.sp,
        firstTextColor: isDarkMode ? AppColors.white : AppColors.black,
        secondTextColor:AppColors.primary,
      ),
      backgroundColor: themeController.isDarkMode.value ? AppColors.black : AppColors.white,
      leading: IconButton(
        hoverColor: AppColors.transparent,
        highlightColor: AppColors.transparent,
        splashColor: AppColors.transparent,
        icon: Icon(Icons.west, color: isDarkMode ? AppColors.white : AppColors.black),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      actions: controller.cachedHadiths.isNotEmpty && controller.errorMessage == null
          ? [
        Padding(
          padding: EdgeInsets.only(right: 20.w),
          child: InkWell(
            onTap: controller.toggleSearchVisibility,
            hoverColor: AppColors.transparent,
            highlightColor: AppColors.transparent,
            splashColor: AppColors.transparent,
            child: SvgPicture.asset(
              controller.isSearchVisible ? 'assets/images/remove.svg' : 'assets/images/search.svg',
              height: 14.h,
              width: 14.w,
              color: isDarkMode ? AppColors.white : AppColors.black,
            ),
          ),
        ),
        InkWell(
          onTap: controller.launchBookUrl,
          child: SvgPicture.asset(
            "assets/images/web.svg",
            height: 15.h,
            width: 15.w,
            color: iconColor,
          ),
        ),
        AppSizedBox.space15w,
      ]
          : null,
    );
  }

  Widget _buildBody(BuildContext context, HadithCollectionSpecificBookDetailController controller) {
    return Column(
      children: [
        if (controller.scrollController.hasClients && controller.scrollController.position.maxScrollExtent > 0)
          LinearProgressIndicator(
            value: controller.scrollProgress,
            backgroundColor:AppColors.grey.withOpacity(0.1),
            valueColor: AlwaysStoppedAnimation<Color>(
              controller.isScrolling ? AppColors.primary : AppColors.grey,
            ),
            minHeight: 3.h,
          ),
        AppSizedBox.space10h,
        Expanded(
          child: controller.isLoading
              ? _buildLoadingState(context, controller)
              : controller.errorMessage != null
              ? _buildErrorState(context, controller)
              : _buildDataState(context, controller),
        ),
      ],
    );
  }

  Widget _buildLoadingState(BuildContext context, HadithCollectionSpecificBookDetailController controller) {
    return Padding(
      padding: EdgeInsets.only(left: 10.w, right: 10.w),
      child: Column(
        children: [
          CustomCard(
            title: controller.bookFirstName.isNotEmpty ? controller.bookFirstName : 'Unknown',
            subtitle: "Book Number " + controller.bookNumber.toString(),
            imageUrl: 'assets/images/hadith_wallpaper.jpg',
            titleFontSize: 18.sp,
            subtitleFontSize: 12.sp,
            mergeWithGradientImage: true,
          ),
          AppSizedBox.space10h,
          Expanded(
            child: Shimmer.fromColors(
              period: const Duration(milliseconds: 1000),
              baseColor: themeController.isDarkMode.value
                  ? AppColors.black.withOpacity(0.1)
                  : AppColors.black.withOpacity(0.2),
              highlightColor: themeController.isDarkMode.value
                  ? AppColors.lightGrey.withOpacity(0.1)
                  : AppColors.grey.withOpacity(0.2),
              child: ListView.builder(
                itemCount: 5,
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.only(bottom: 10.h),
                    width: double.infinity,
                    height: 130.h,
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(15.r),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, HadithCollectionSpecificBookDetailController controller) {
    return Center(
      child: Padding(
        padding: EdgeInsets.only(left: 20.w, right: 20.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(),
            AnimatedBuilder(
              animation: controller.scaleAnimation,
              builder: (build, context) {
                return Transform.scale(
                  scale: 1.0 + (controller.scaleAnimation.value * 0.1),
                  child: Container(
                    height: 250.h,
                    width: 250.w,
                    decoration: BoxDecoration(
                      color: AppColors.red.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(25.r),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          color: AppColors.white,
                          size: 45.h,
                        ),
                        AppSizedBox.space15h,
                        CustomText(
                          title: "Data Unavailable",
                          fontSize: 22.sp,
                          textColor: AppColors.white,
                          maxLines: 2,
                          fontFamily: 'grenda',
                        ),
                        AppSizedBox.space5h,
                        CustomText(
                          title: controller.errorMessage!,
                          fontSize: 16.sp,
                          textColor: AppColors.white,
                          maxLines: 2,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            CustomButton(
              onTap: controller.launchBookUrl,
              haveBgColor: true,
              btnTitle: "View Book",
              btnTitleColor: AppColors.white,
              bgColor: AppColors.primary,
              borderRadius: 50.r,
              height: 45.h,
            ),
            SizedBox(),
          ],
        ),
      ),
    );
  }

  Widget _buildDataState(BuildContext context, HadithCollectionSpecificBookDetailController controller) {
    bool isDarkMode = themeController.isDarkMode.value;
    final textColor = isDarkMode ? AppColors.white : AppColors.black;
    final iconColor = isDarkMode ? AppColors.white : AppColors.black;

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(left: 10.w, right: 10.w, bottom: 10.h),
          child: Column(
            children: [
              CustomCard(
                title: controller.bookFirstName.isNotEmpty ? controller.bookFirstName : 'Unknown',
                subtitle: "Book Number " + controller.bookNumber.toString()+  " Total Hadith " + " "+ totalHadith.toString(),
                imageUrl: 'assets/images/hadith_wallpaper.jpg',
                titleFontSize: 18.sp,
                subtitleFontSize: 12.sp,
                mergeWithGradientImage: true,
              ),
              AppSizedBox.space10h,
              if (controller.isSearchVisible)
                TextField(
                  controller: controller.searchController,
                  style: TextStyle(color: isDarkMode ? AppColors.white : AppColors.black),
                  decoration: InputDecoration(
                    hintText: 'Search Hadith',
                    hintMaxLines: 3,
                    hintStyle: GoogleFonts.quicksand(
                      color: isDarkMode ? AppColors.white : AppColors.black,
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: isDarkMode ? AppColors.black.withOpacity(0.5) : AppColors.black.withOpacity(0.1), width: 1),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                  onChanged: (query) {
                    controller.update();
                  },
                ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            controller: controller.scrollController,
            itemCount: controller.filterHadiths(controller.searchController.text).length,
            itemBuilder: (context, index) {
              final hadith = controller.filterHadiths(controller.searchController.text)[index];
              return Container(

                margin: EdgeInsets.only(left: 10.w, right: 10.w, bottom: 5, top: 5.h),
                padding: EdgeInsets.only(right: 10.w, top: 10.h, bottom: 10.h, left: 10.w),
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.r),
                  color: (index % 2 == 1)
                      ? AppColors.primary.withOpacity(0.29)
                      : AppColors.primary.withOpacity(0.1),
                ),
                child: ListTile(
                  splashColor: AppColors.transparent,
                  hoverColor: AppColors.transparent,
                  focusColor: AppColors.transparent,
                  title: Row(
                    children: [
                      Container(
                        width: 18.w,
                        height: 18.h,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/images/ayat_marker.png'),
                          ),
                        ),
                      ),
                      AppSizedBox.space5w,
                      CustomText(
                        title: 'Hadith ${hadith.hadithNumber}',
                        fontSize: 16.sp,
                        textColor: textColor,
                        fontWeight: FontWeight.w500,
                        textOverflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        textAlign: TextAlign.start,
                      ),
                    ],
                  ),
                  subtitle: Html(
                    data: hadith.hadith.isNotEmpty
                        ? (hadith.hadith.first.body ?? '')
                        : '',
                    shrinkWrap: true,
                    style: {
                      "body": Style(
                        color: AppColors.primary,
                        fontSize: FontSize(15.sp),
                        maxLines: 2,
                        fontWeight: FontWeight.w700,
                        textOverflow: TextOverflow.ellipsis,
                        margin: Margins(left: Margin.zero()),
                        fontFamily: 'quicksand',
                      ),
                    },
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 10.h,
                    color: iconColor,
                  ),
                  onTap: () {
                    controller.saveLastAccessedHadith(
                      hadithNumber: hadith.hadithNumber.toString(),
                      hadithFirstBody: hadith.hadith.isNotEmpty ? hadith.hadith.first.body ?? '' : '',
                      hadithLastBody: hadith.hadith.isNotEmpty ? hadith.hadith.last.body ?? '' : '',
                      grade: hadith.hadith.isNotEmpty && hadith.hadith.first.grades != null ? hadith.hadith.first.grades.toString() : '',
                      bookNumber: controller.bookNumber,
                      bookLastName: controller.bookLastName,
                      bookFirstName: controller.bookFirstName,
                      collectionName: controller.collection.name,
                    );

                    Get.to(HadithDetailScreen(
                      hadithNumber: hadith.hadithNumber.toString(),
                      hadithFirstBody: hadith.hadith.isNotEmpty ? hadith.hadith.first.body ?? '' : '',
                      hadithLastBody: hadith.hadith.isNotEmpty ? hadith.hadith.last.body ?? '' : '',
                      grade: hadith.hadith.isNotEmpty && hadith.hadith.first.grades != null ? hadith.hadith.first.grades.toString() : '',
                      bookNumber: controller.bookNumber,
                      bookLastName: controller.bookLastName,
                      bookFirstName: controller.bookFirstName,
                      collectionName: controller.collection.name,
                    ));
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}