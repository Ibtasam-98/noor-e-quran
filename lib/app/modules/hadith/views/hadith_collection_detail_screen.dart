import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hadith/hadith.dart';
import 'package:noor_e_quran/app/config/app_sizedbox.dart';
import '../../../config/app_colors.dart';
import '../../../controllers/app_theme_switch_controller.dart';
import '../../../widgets/custom_card.dart';
import '../../../widgets/custom_text.dart';
import '../controllers/hadith_collection_detail_screen_controller.dart';
import 'hadith_collection_specific_book_detail_screen.dart';

class HadithCollectionDetailScreen extends StatelessWidget {
  final Collections collection;
  final bool shouldStartFromFirstIndex;

  HadithCollectionDetailScreen({required this.collection, required this.shouldStartFromFirstIndex});

  @override
  Widget build(BuildContext context) {
    final hadithCollectionDetailController = Get.put(HadithCollectionDetailController(collection));

    final themeController = Get.find<AppThemeSwitchController>();

    return Scaffold(
      backgroundColor: themeController.isDarkMode.value ? AppColors.black : AppColors.white,
      appBar: AppBar(
        surfaceTintColor: AppColors.transparent,
        foregroundColor: AppColors.transparent,
        centerTitle: false,
        automaticallyImplyLeading: false,
        title: Obx(() => CustomText(
          firstText: "Book ",
          secondText: collection.name,
          capitalize: true,
          fontSize: 18.sp,
          firstTextColor: themeController.isDarkMode.value ? AppColors.white : AppColors.black,
          secondTextColor: AppColors.primary,
        )),
        backgroundColor: themeController.isDarkMode.value ? AppColors.black : AppColors.white,
        leading: InkWell(
          onTap: () => Get.back(),
          child: Icon(Icons.west, color: themeController.isDarkMode.value ? AppColors.white : AppColors.black),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 20.w),
            child: InkWell(
              splashColor: AppColors.transparent,
              highlightColor: AppColors.transparent,
              onTap: hadithCollectionDetailController.toggleSearchVisibility,
              child: Obx(() => SvgPicture.asset(
                hadithCollectionDetailController.isSearchVisible.value
                    ? 'assets/images/remove.svg'
                    : 'assets/images/search.svg',
                height: 14.h,
                width: 14.w,
                color: themeController.isDarkMode.value ? AppColors.white : AppColors.black,
              )),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Obx(() => LinearProgressIndicator(
            value: hadithCollectionDetailController.scrollProgress.value,
            backgroundColor: AppColors.grey.withOpacity(0.1),
            valueColor: AlwaysStoppedAnimation<Color>(
              hadithCollectionDetailController.isScrolling.value ? AppColors.primary : AppColors.grey,
            ),
            minHeight: 3.h,
          )),
          AppSizedBox.space10h,
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: Column(
                children: [
                  CustomCard(
                    title: "Pearls of Hadith",
                    subtitle: "Profound Teachings of the Prophet Muhammad",
                    imageUrl: 'assets/images/hadith_wallpaper.jpg',
                    titleFontSize: 18.sp,
                    subtitleFontSize: 12.sp,
                    mergeWithGradientImage: true,
                  ),
                  AppSizedBox.space15h,
                  Obx(() => hadithCollectionDetailController.isSearchVisible.value
                      ? TextField(
                    controller: hadithCollectionDetailController.searchController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.r),
                        borderSide: BorderSide.none,
                      ),
                      hintText: 'Search Hadith',
                      fillColor: themeController.isDarkMode.value
                          ? AppColors.grey.withOpacity(0.1)
                          : AppColors.grey.withOpacity(0.2),
                      filled: true,
                      hintStyle: GoogleFonts.quicksand(
                        color: themeController.isDarkMode.value ? AppColors.white : AppColors.black,
                      ),
                    ),
                    onChanged: hadithCollectionDetailController.filterBooks,
                  )
                      : SizedBox.shrink()),
                  Expanded(
                    child: Obx(() => hadithCollectionDetailController.filteredBooks.isEmpty
                        ? Center(
                      child: CustomText(
                        title: "No book found",
                        fontSize: 18.sp,
                        textColor: AppColors.white,
                      ),
                    )
                        : ListView.builder(
                      controller: hadithCollectionDetailController.scrollController,
                      itemCount: hadithCollectionDetailController.filteredBooks.length,
                      itemBuilder: (context, index) {
                        final book = hadithCollectionDetailController.filteredBooks[index];
                        final bookNumberInt = int.tryParse(book.bookNumber) ?? 1;

                        return Container(
                          margin: EdgeInsets.only(bottom: 5, top: 10.h),
                          padding: EdgeInsets.only(right: 5.w, top: 5.h),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.r),
                            color: (index % 2 == 1)
                                ? AppColors.primary.withOpacity(0.39)
                                : AppColors.primary.withOpacity(0.1),
                          ),
                          child: ListTile(
                            leading: CustomText(
                              title: bookNumberInt.toString(),
                              fontSize: 14.sp,
                              textColor: themeController.isDarkMode.value ? AppColors.white : AppColors.black,
                            ),
                            title: Html(
                              data: "<div>${book.book.first.name}</div>",
                              style: {
                                "div": Style(
                                  textAlign: TextAlign.left,
                                  margin: Margins.zero,
                                  padding: HtmlPaddings.zero,
                                  maxLines: 1,
                                  fontSize: FontSize(14.0),
                                  fontFamily: 'quicksand',
                                  fontWeight: FontWeight.w600,
                                  color: themeController.isDarkMode.value ? AppColors.white : AppColors.black,
                                ),
                              },
                            ),

                            trailing: Icon(Icons.arrow_forward_ios_rounded, size: 10.h,color: themeController.isDarkMode.value ? AppColors.white : AppColors.black,),
                            onTap: () {
                              Get.to(HadithCollectionSpecificBookDetailScreen(
                                collection: collection,
                                bookNumber: bookNumberInt,
                                bookFirstName: book.book.first.name,
                                bookLastName: book.book.last.name,
                                totalHadith:book.numberOfHadith ,
                              ));
                            },
                          ),
                        );
                      },
                    )),
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
