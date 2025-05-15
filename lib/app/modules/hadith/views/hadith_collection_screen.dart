import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hadith/classes.dart';
import 'package:hadith/hadith.dart';
import 'package:intl/intl.dart';
import 'package:noor_e_quran/app/modules/home/views/app_home_base_screen.dart';
import 'package:quran/quran.dart' as quran;
import 'package:noor_e_quran/app/controllers/flying_bird_animation_controller.dart';
import '../../../config/app_colors.dart';
import '../../../config/app_sizedbox.dart';
import '../../../controllers/app_theme_switch_controller.dart';
import '../../../widgets/custom_formated_text.dart';
import '../../../widgets/custom_frame.dart';
import '../../../widgets/custom_text.dart';
import '../../home/controllers/app_home_screen_controller.dart';
import '../../home/views/app_home_screen_header.dart';
import 'package:flutter_html/flutter_html.dart';

import '../controllers/hadith_collectinon_screen_controller.dart';
import 'hadith_collection_detail_screen.dart';
import 'hadith_collection_specific_book_detail_screen.dart';
import 'hadith_detail_screen.dart';
import 'last_accessed_hadith_screen.dart';

class HadithCollectionScreen extends StatelessWidget {
  final Map<String, dynamic>? userData;

  HadithCollectionScreen({super.key, this.userData});
  @override
  Widget build(BuildContext context) {
    final FlyingBirdAnimationController _hadithBirdController = Get.find<FlyingBirdAnimationController>();
    final AppHomeScreenController controller = Get.put(AppHomeScreenController());
    final AppThemeSwitchController themeController = Get.find<AppThemeSwitchController>();
    final HadithCollectionController hadithCollectionController = Get.find<HadithCollectionController>();

    List<Collections> getFirstSixCollections() {
      final allCollections = Collections.values.toList();
      return allCollections.take(6).toList();
    }

    final firstSixCollections = getFirstSixCollections();

    List<Book> getFirstSixBooks(Collections collection) {
      final books = getBooks(collection);
      if (books.length <= 6) {
        return books;
      } else {
        return books.take(6).toList();
      }
    }

    final collections = getCollections();

    final box = GetStorage();
    final keys = box.getKeys().cast<String>().toList();

    final hadithNumberKeys = keys.where((key) {
      if (key is String && key.startsWith('lastAccessedHadithNumber') && key.length > 'lastAccessedHadithNumber'.length) {
        return true;
      }
      return false;
    }).toList();

    final screenWidth = MediaQuery.of(context).size.width;
    final bool isTablet = screenWidth > 600;


    return AppHomeBaseScreen(
      titleFirstPart: "Noor e",
      titleSecondPart: " Quran",
      birdController: _hadithBirdController,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HomeScreenHeader(birdController: _hadithBirdController),
          Obx(() => CustomText(
            title: "Hadith of the Hour",
            textColor: controller.themeController.isDarkMode.value ? AppColors.white : AppColors.black,
            fontSize: 16.sp,
            fontFamily: 'grenda',
            textAlign: TextAlign.start,
            maxLines: 1,
            textOverflow: TextOverflow.ellipsis,
          )),
          AppSizedBox.space10h,
          Obx(()=> Container(
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(themeController.isDarkMode.value
                    ? "assets/images/quran_bg_dark.jpg"
                    : "assets/images/quran_bg_light.jpg"),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(15.r),
              boxShadow: [
                BoxShadow(
                  color: themeController.isDarkMode.value ? AppColors.primary.withOpacity(0.3) : AppColors.transparent,
                  blurRadius: 5,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                InkWell(
                  splashColor: AppColors.transparent,
                  highlightColor: AppColors.transparent,
                  onTap: () {
                    Get.to(HadithDetailScreen(
                      hadithNumber: hadithCollectionController.currentHadith.hadithNumber,
                      hadithFirstBody: hadithCollectionController.currentHadith.hadith.first.body,
                      hadithLastBody: hadithCollectionController.currentHadith.hadith.last.body,
                      grade: "",
                      bookLastName: hadithCollectionController.currentHadith.hadith.last.chapterTitle,
                      bookFirstName: hadithCollectionController.currentHadith.hadith.first.chapterTitle,
                      bookNumber: int.tryParse(hadithCollectionController.currentHadith.bookNumber) ?? 0,
                      collectionName: hadithCollectionController.currentHadith.collection,
                    ));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.black.withOpacity(0.5),
                          AppColors.transparent,
                          AppColors.black.withOpacity(0.5),
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(15.r),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(5.h),
                      child:Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Html(
                              data: "<div>${truncateString(
                                  hadithCollectionController.currentHadith.hadith.first.body, 1,
                                  TextStyle(
                                    fontSize: 14.sp,
                                    fontFamily: 'quicksand',
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.white,
                                  ),context)}</div>",
                              style: {
                                "div": Style(
                                  fontSize: FontSize(13.sp),
                                  color: AppColors.white ,
                                  fontFamily: 'quicksand',
                                  fontWeight: FontWeight.w600,
                                  textAlign: TextAlign.start,
                                  maxLines: 2,
                                  margin: Margins.zero, // Remove implicit margins
                                  padding: HtmlPaddings.zero, // Remove implicit padding
                                ),
                              },
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom:8.h,right: 8.w),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: CustomText(
                                    title: '${hadithCollectionController.currentHadith.collection} | Hadith No. ${hadithCollectionController.currentHadith.hadithNumber} | Book ${hadithCollectionController.currentHadith.bookNumber}',
                                    fontSize: 13.sp,
                                    textColor: AppColors.white,
                                    maxLines: 2,
                                    capitalize: true,
                                    textAlign: TextAlign.start,
                                    fontWeight: FontWeight.bold,
                                    textStyle: const TextStyle(fontStyle: FontStyle.italic),
                                  ),
                                ),
                                Icon(Icons.remove_red_eye, color: AppColors.white, size: 15.h),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),),
          AppSizedBox.space10h,
          if (hadithNumberKeys.isNotEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                        child: Obx(()=>CustomText(
                          title: "Last Accessed Hadith",
                          textColor: themeController.isDarkMode.value ? AppColors.white : AppColors.black,
                          fontSize: 16.sp,
                          fontFamily: 'grenda',
                          maxLines: 1,
                          textAlign: TextAlign.start,
                          textOverflow: TextOverflow.ellipsis,
                        ),)
                    ),
                    Expanded(
                      child: InkWell(
                        splashColor: AppColors.transparent,
                        onTap: () => Get.to(() => LastAccessedHadithsScreen()),
                        child: CustomText(
                          title: "View All",
                          textColor: themeController.isDarkMode.value ? AppColors.primary : AppColors.black,
                          fontSize: 12.sp,
                          fontFamily: 'quicksand',
                          textAlign: TextAlign.end,
                          fontWeight: FontWeight.w600,
                          textOverflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                ),
                AppSizedBox.space10h,
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: hadithNumberKeys.asMap().entries.toList().reversed.take(3).map<Widget>((entry) {
                      final index = entry.key;
                      final hadithNumberKey = entry.value;
                      final isEvenIndex = index % 2 == 0;
                      try {
                        final hadithIndex = int.parse(hadithNumberKey.replaceAll('lastAccessedHadithNumber', ''));
                        final hadithFirstBodyKey = 'lastAccessedHadithFirstBody$hadithIndex';
                        final hadithLastBodyKey = 'lastAccessedHadithLastBody$hadithIndex';
                        final hadithGradeKey = 'lastAccessedHadithGrade$hadithIndex';
                        final bookNumberKey = 'lastAccessedBookNumber$hadithIndex';
                        final bookLastNameKey = 'lastAccessedBookLastName$hadithIndex';
                        final bookFirstNameKey = 'lastAccessedBookFirstName$hadithIndex';
                        final collectionNameKey = 'lastAccessedCollectionName$hadithIndex';
                        final timestampKey = 'lastAccessedTimestamp$hadithIndex';
                        final hadithNumber = box.read(hadithNumberKey);
                        final hadithFirstBody = box.read(hadithFirstBodyKey);
                        final hadithLastBody = box.read(hadithLastBodyKey);
                        final hadithGrade = box.read(hadithGradeKey);
                        final bookNumber = box.read(bookNumberKey);
                        final bookLastName = box.read(bookLastNameKey);
                        final bookFirstName = box.read(bookFirstNameKey);
                        final collectionName = box.read(collectionNameKey);
                        final timestampString = box.read(timestampKey);
                        if (hadithNumber == null) {
                          return SizedBox.shrink();
                        }
                        DateTime? timestamp;
                        if (timestampString != null) {
                          timestamp = DateTime.parse(timestampString);
                        }
                        return Container(
                          width: 280.w,
                          margin: EdgeInsets.only(right: 8.w),
                          padding: EdgeInsets.all(6.h),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.r),
                            color: isEvenIndex ? AppColors.primary.withOpacity(0.1) : AppColors.primary.withOpacity(0.29),
                          ),
                          child: ListTile(
                            contentPadding: EdgeInsets.zero,
                            dense: true,
                            title: Obx(()=>CustomText(
                              title: "Hadith ${hadithNumber}",
                              fontSize: 14.sp,
                              textColor: themeController.isDarkMode.value ? AppColors.white : AppColors.black,
                              fontWeight: FontWeight.w800,
                              textOverflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              textStyle: GoogleFonts.montserrat(),
                              textAlign: TextAlign.start,
                            ),),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomText(
                                  title: '${collectionName} | Book ${bookNumber}',
                                  fontSize: 12.sp,
                                  textColor: AppColors.primary,
                                  capitalize: true,
                                  textAlign: TextAlign.start,
                                  textOverflow: TextOverflow.ellipsis,
                                  fontWeight: FontWeight.w500,
                                  maxLines: 1,
                                ),
                                AppSizedBox.space5h,
                                Obx(()=>CustomText(
                                  title: 'Last Accessed ${DateFormat('yyyy-MM-dd HH:mm').format(timestamp!)}',
                                  fontSize: 12.sp,
                                  textAlign: TextAlign.start,
                                  textColor: themeController.isDarkMode.value ? AppColors.grey : AppColors.black,
                                ),),
                              ],
                            ),
                            onTap: () {
                              Get.to(
                                HadithDetailScreen(
                                  hadithNumber: hadithNumber,
                                  hadithFirstBody: hadithFirstBody ?? '',
                                  hadithLastBody: hadithLastBody ?? '',
                                  grade: hadithGrade ?? '',
                                  bookNumber: bookNumber ?? '',
                                  bookLastName: bookLastName ?? '',
                                  bookFirstName: bookFirstName ?? '',
                                  collectionName: collectionName ?? '',
                                ),
                              );
                            },
                          ),
                        );
                      } catch (e) {
                        return SizedBox.shrink();
                      }
                    }).toList(),
                  ),
                ),
              ],
            ),
          AppSizedBox.space10h,
          Obx(()=>CustomText(
            title: "Explore by Books",
            textColor: themeController.isDarkMode.value? AppColors.white : AppColors.black,
            fontSize: 16.sp,
            fontFamily: 'grenda',
            maxLines: 1,
            textAlign: TextAlign.start,
            textOverflow: TextOverflow.ellipsis,
          ),),
          AppSizedBox.space10h,
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(
                isTablet ? firstSixCollections.length : 6,
                    (collectionIndex) {
                  if (firstSixCollections.isNotEmpty &&
                      collectionIndex < firstSixCollections.length) {
                    final collection = firstSixCollections[collectionIndex];
                    final books = getFirstSixBooks(collection);

                    if (books.isNotEmpty) {
                      final book = books[hadithCollectionController.random.nextInt(books.length)];

                      return InkWell(
                        onTap: () {
                          String bookFirstName =
                          book.book.isNotEmpty ? book.book.first.name : 'Unknown';
                          String bookLastName =
                          book.book.isNotEmpty ? book.book.last.name : 'Unknown';
                          int bookNumber = int.tryParse(book.bookNumber) ?? 0;

                          Get.to(HadithCollectionSpecificBookDetailScreen(
                            collection: collection,
                            bookNumber: bookNumber,
                            bookFirstName: bookFirstName,
                            bookLastName: bookLastName,
                            totalHadith: book.numberOfHadith,
                          ),
                          );
                        },
                        child: Container(
                          width: isTablet ? 220.w : 180.w,
                          padding: EdgeInsets.all(10.w),
                          margin: EdgeInsets.only(right: 8.w, bottom: 10.h),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.r),
                            color: (collectionIndex % 2 == 0) ? AppColors.primary.withOpacity(0.29) : AppColors.primary.withOpacity(0.1),
                          ),
                          child: Padding(
                            padding: EdgeInsets.zero,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Obx(() => CustomText(
                                    title: collection.name,
                                    textColor: themeController.isDarkMode.value ? AppColors.white : AppColors.black,
                                    capitalize: true,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500,
                                    textOverflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    textAlign: TextAlign.start,
                                  ),
                                ),
                                CustomText(
                                  title: book.book.first.name,
                                  textAlign: TextAlign.start,
                                  capitalize: true,
                                  maxLines: 1,
                                  fontSize: 12.sp,
                                  textColor: AppColors.primary,
                                  textOverflow: TextOverflow.ellipsis,
                                  fontWeight: FontWeight.w500,
                                ),
                                Obx(() => CustomText(
                                    title: "Total Hadith ${book.numberOfHadith.toString()}",
                                    textAlign: TextAlign.start,
                                    capitalize: true,
                                    maxLines: 1,
                                    fontSize: 12.sp,
                                    textColor: themeController.isDarkMode.value
                                        ? AppColors.grey
                                        : AppColors.black,
                                    textOverflow: TextOverflow.ellipsis,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    } else {
                      return SizedBox.shrink();
                    }
                  } else {
                    return SizedBox.shrink();
                  }
                },
              ),
            ),
          ),
          AppSizedBox.space10h,
          Obx(()=>CustomText(
            title: "Hadith Collections",
            textColor: themeController.isDarkMode.value? AppColors.white : AppColors.black,
            fontSize: 16.sp,
            fontFamily: 'grenda',
            maxLines: 1,
            textAlign: TextAlign.start,
            textOverflow: TextOverflow.ellipsis,
          ),),
          AppSizedBox.space10h,
          Column(
            children: [
              SingleChildScrollView(
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2,
                    childAspectRatio: 1,
                    crossAxisSpacing: 10,
                  ),
                  itemCount: collections.length,
                  itemBuilder: (context, index) {
                    final collection = collections[index];
                    final books = getBooks(Collections.values.firstWhere((e) => e.name == collection.name));

                    return InkWell(
                      splashColor: AppColors.transparent,
                      highlightColor: AppColors.transparent,
                      hoverColor: AppColors.transparent,
                      onTap: () {
                        bool shouldStartFromFirstIndex = collection.name == 'ibnmajah';
                        Get.to(HadithCollectionDetailScreen(
                          collection: Collections.values.firstWhere((c) => c.name == collection.name),
                          shouldStartFromFirstIndex: shouldStartFromFirstIndex,
                        ));
                      },
                      child: GridTile(
                        child: Obx(()=>Container(
                          margin: EdgeInsets.only(bottom: 10.h),
                          decoration: BoxDecoration(
                            color: controller.themeController.isDarkMode.value ? AppColors.black : AppColors.white,
                            borderRadius: BorderRadius.circular(10.r),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withOpacity(0.1),
                                spreadRadius: 1,
                                blurRadius: 2,
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CustomFrame(
                                  leftImageAsset: "assets/frames/topLeftFrame.png",
                                  rightImageAsset: "assets/frames/topRightFrame.png",
                                  imageHeight: 30.h,
                                  imageWidth: 30.w,
                                ),
                                Column(
                                  children: [
                                    CustomText(
                                      title: collection.name,
                                      fontSize: 16.sp,
                                      textColor:  themeController.isDarkMode.value ? AppColors.white : AppColors.black,
                                      fontWeight: FontWeight.normal,
                                      textOverflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.center,
                                      capitalize: true,
                                      maxLines: 2,
                                      fontFamily: 'grenda',
                                    ),
                                    AppSizedBox.space5h,
                                    CustomText(
                                      title: 'Total Hadiths ${collection.totalAvailableHadith} ',
                                      fontSize: 12.sp,
                                      textColor: AppColors.primary,
                                      fontWeight: FontWeight.w500,
                                      textAlign: TextAlign.center,
                                      textOverflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                    ),
                                    CustomText(
                                      title: 'Total Books ${books.length}',
                                      fontSize: 12.sp,
                                      textColor: AppColors.primary,
                                      fontWeight: FontWeight.w500,
                                      textAlign: TextAlign.center,
                                      textOverflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                    ),
                                  ],
                                ),
                                CustomFrame(
                                  leftImageAsset: "assets/frames/bottomLeftFrame.png",
                                  rightImageAsset: "assets/frames/bottomRightFrame.png",
                                  imageHeight: 30.h,
                                  imageWidth: 30.w,
                                ),
                              ],
                            ),
                          ),
                        ),),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}