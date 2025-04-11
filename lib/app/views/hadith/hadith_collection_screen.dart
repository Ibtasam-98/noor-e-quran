import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hadith/classes.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icons.dart';
import 'package:marquee/marquee.dart';
import 'package:noor_e_quran/app/config/app_sizedbox.dart';
import 'package:noor_e_quran/app/controllers/flying_bird_animation_controller.dart';
import 'package:noor_e_quran/app/views/hadith/hadith_collection_detail_screen.dart';
import 'package:hadith/hadith.dart';
import 'package:noor_e_quran/app/views/hadith/hadith_collection_specific_book_detail_screen.dart';
import 'package:noor_e_quran/app/widgets/custom_button.dart';
import 'package:shimmer/shimmer.dart';
import '../../config/app_colors.dart';
import '../../controllers/app_home_screen_controller.dart';
import '../../controllers/app_theme_switch_controller.dart';
import '../../controllers/hadith_collection_controller.dart';
import '../../controllers/user_location_premission_controller.dart';
import '../../widgets/custom_card.dart';
import '../../widgets/custom_drawer.dart';
import '../../widgets/custom_formated_text.dart';
import '../../widgets/custom_frame.dart';
import '../../widgets/custom_marquee.dart';
import '../../widgets/custom_text.dart';
import '../../widgets/flying_bird_animtion.dart';
import '../home/app_home_screen_header.dart';
import '../home/base_home_screen.dart';
import '../home/last_access_surah_list_screen.dart';
import 'hadith_detail_screen.dart';
import 'last_accessed_hadith_screen.dart';


class HadithCollectionScreen extends StatefulWidget {

  final Map<String, dynamic>? userData;

  HadithCollectionScreen({super.key, this.userData});

  @override
  State<HadithCollectionScreen> createState() => _HadithCollectionScreenState();
}

class _HadithCollectionScreenState extends State<HadithCollectionScreen> {
  final HadithCollectionController controller = Get.put(HadithCollectionController());
  final FlyingBirdAnimationController _hadithBirdController = Get.put(FlyingBirdAnimationController(), tag: 'hadith_bird');
  final UserPermissionController locationPermissionScreenController = Get.find<UserPermissionController>();
  final AppHomeScreenController homeScreenController = Get.find<AppHomeScreenController>();
  final AppThemeSwitchController themeController = Get.find<AppThemeSwitchController>();

  @override
  Widget build(BuildContext context) {
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


    return BaseHomeScreen(
      titleFirstPart: "Noor e",
      titleSecondPart: " Quran",
      birdController: _hadithBirdController,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HomeScreenHeader(birdController: _hadithBirdController),
          CustomMarquee(),
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
                        fontSize: 18.sp,
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
                          fontSize: 14.sp,
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
                    children: hadithNumberKeys.asMap().entries.toList()
                        .reversed.take(3)
                        .map<Widget>((entry) {
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
                        print('Attempting to read keys with index: $hadithIndex');
                        final hadithNumber = box.read(hadithNumberKey);
                        final hadithFirstBody = box.read(hadithFirstBodyKey);
                        final hadithLastBody = box.read(hadithLastBodyKey);
                        final hadithGrade = box.read(hadithGradeKey);
                        final bookNumber = box.read(bookNumberKey);
                        final bookLastName = box.read(bookLastNameKey);
                        final bookFirstName = box.read(bookFirstNameKey);
                        final collectionName = box.read(collectionNameKey);
                        final timestampString = box.read(timestampKey);

                        print('Read data: {hadithNumber: $hadithNumber, hadithFirstBody: $hadithFirstBody, ...}');

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
                              fontSize: 15.sp,
                              textColor: themeController.isDarkMode.value ? AppColors.white : AppColors.black,
                              fontWeight: FontWeight.w500,
                              textOverflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              textAlign: TextAlign.start,
                            ),),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomText(
                                  title: '${collectionName} | Book ${bookNumber}',
                                  fontSize: 14.sp,
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
                        print('Error parsing hadithIndex: $e');
                        print('Key causing the error: <span class="math-inline">hadithNumberKey');
                        return SizedBox.shrink();
                      }
                    }).toList(),
                  ),
                ),
              ],
            ),
          AppSizedBox.space10h,
          Obx(()=>CustomText(
              title: "Hadith Of The Hour",
              textColor: themeController.isDarkMode.value ? AppColors.white : AppColors.black,
              fontSize: 18.sp,
              fontFamily: 'grenda',
              maxLines: 1,
              textOverflow: TextOverflow.ellipsis,),
          ),
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
                      hadithNumber: controller.currentHadith.hadithNumber,
                      hadithFirstBody: controller.currentHadith.hadith.first.body,
                      hadithLastBody: controller.currentHadith.hadith.last.body,
                      grade: "",
                      bookLastName: controller.currentHadith.hadith.last.chapterTitle,
                      bookFirstName: controller.currentHadith.hadith.first.chapterTitle,
                      bookNumber: int.tryParse(controller.currentHadith.bookNumber) ?? 0,
                      collectionName: controller.currentHadith.collection,
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
                                  controller.currentHadith.hadith.first.body, 1,
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
                                    title: '${controller.currentHadith.collection} | Hadith No. ${controller.currentHadith.hadithNumber} | Book ${controller.currentHadith.bookNumber}',
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
          Obx(()=>CustomText(
            title: "Explore by Books",
            textColor: themeController.isDarkMode.value? AppColors.white : AppColors.black,
            fontSize: 18.sp,
            fontFamily: 'grenda',
            maxLines: 1,
            textAlign: TextAlign.start,
            textOverflow: TextOverflow.ellipsis,
          ),),
          AppSizedBox.space10h,
          Column(
            children: [
              for (int listIndex = 0; listIndex < 2; listIndex++)
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(
                      3, (itemIndex) {
                        final collectionIndex = listIndex * 3 + itemIndex;
                        if (firstSixCollections.isNotEmpty && collectionIndex < firstSixCollections.length) {
                          final collection = firstSixCollections[collectionIndex];
                          final books = getFirstSixBooks(collection);

                          if (books.isNotEmpty) {
                            final book = books[controller.random.nextInt(books.length)]; // Corrected line

                            return InkWell(
                              onTap: () {
                                String bookFirstName = book.book.isNotEmpty ? book.book.first.name : 'Unknown';
                                String bookLastName = book.book.isNotEmpty ? book.book.last.name : 'Unknown';
                                int bookNumber = int.tryParse(book.bookNumber) ?? 0;

                                Get.to(
                                  HadithCollectionSpecificBookDetailScreen(
                                    collection: collection,
                                    bookNumber: bookNumber,
                                    bookFirstName: bookFirstName,
                                    bookLastName: bookLastName,
                                    totalHadith:book.numberOfHadith ,
                                  ),
                                );
                              },
                              child: Container(
                                width: 180.w,
                                padding: EdgeInsets.all(10.w),
                                margin: EdgeInsets.only(right: 8.w, bottom: 10.h),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.r),
                                  color: (listIndex % 2 == 0)
                                      ? (itemIndex % 2 == 1)
                                      ? AppColors.primary.withOpacity(0.29)
                                      : AppColors.primary.withOpacity(0.1)
                                      : (itemIndex % 2 == 1)
                                      ? AppColors.primary.withOpacity(0.1)
                                      : AppColors.primary.withOpacity(0.29),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.zero,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Obx(()=>CustomText(
                                        title: collection.name,
                                        textColor: themeController.isDarkMode.value ? AppColors.white : AppColors.black,
                                        capitalize: true,
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.w500,
                                        textOverflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        textAlign: TextAlign.start,
                                      ),),
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
                                      Obx(()=>CustomText(
                                        title: "Total Hadith ${book.numberOfHadith.toString()}",
                                        textAlign: TextAlign.start,
                                        capitalize: true,
                                        maxLines: 1,
                                        fontSize: 12.sp,
                                        textColor: themeController.isDarkMode.value ? AppColors.grey : AppColors.black,
                                        textOverflow: TextOverflow.ellipsis,
                                        fontWeight: FontWeight.w500,
                                      ),),
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
            ],
          ),
          AppSizedBox.space5h,
          Obx(()=>CustomText(
            title: "All Collections",
            textColor: themeController.isDarkMode.value ? AppColors.white : AppColors.black,
            fontSize: 18.sp,
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
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1,
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
                          margin: EdgeInsets.all(5.h),
                          decoration: BoxDecoration(
                            color: themeController.isDarkMode.value ? AppColors.black : AppColors.white,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withOpacity(0.2),
                                spreadRadius: 1,
                                blurRadius: 4,
                              ),
                            ],
                          ),
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
                                    fontSize: 18.sp,
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


//
// class HadithCollectionScreen extends StatelessWidget {
//   final HadithCollectionController controller = Get.put(HadithCollectionController());
//
//   HadithCollectionScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final AppThemeSwitchController themeController = Get.find<AppThemeSwitchController>();
//     final AppHomeScreenController homeScreenController = Get.find<AppHomeScreenController>();
//     final UserPermissionController locationPermissionScreenController = Get.find<UserPermissionController>();
//     bool isDarkMode = themeController.isDarkMode.value;
//     final textColor = isDarkMode ? AppColors.white : AppColors.black;
//
//     List<Collections> getFirstSixCollections() {
//       final allCollections = Collections.values.toList();
//       return allCollections.take(6).toList();
//     }
//
//     final firstSixCollections = getFirstSixCollections();
//
//     List<Book> getFirstSixBooks(Collections collection) {
//       final books = getBooks(collection);
//       if (books.length <= 6) {
//         return books;
//       } else {
//         return books.take(6).toList();
//       }
//     }
//
//     final collections = getCollections();
//
//     final box = GetStorage();
//     final keys = box.getKeys().cast<String>().toList();
//
//     final hadithNumberKeys = keys.where((key) {
//       if (key is String && key.startsWith('lastAccessedHadithNumber') && key.length > 'lastAccessedHadithNumber'.length) {
//         return true;
//       }
//       return false;
//     }).toList();
//
//
//     return Obx(() {
//       bool isDarkMode = themeController.isDarkMode.value;
//       final iconColor = isDarkMode ? AppColors.white : AppColors.black;
//
//       return AdvancedDrawer(
//         backdrop: Container(
//           width: double.infinity,
//           height: double.infinity,
//           decoration: BoxDecoration(
//             color: isDarkMode ? AppColors.black : AppColors.white,
//           ),
//         ),
//         controller: homeScreenController.advancedDrawerController,
//         animationCurve: Curves.easeInOut,
//         animationDuration: const Duration(milliseconds: 300),
//         animateChildDecoration: true,
//         rtlOpening: false,
//         disabledGestures: false,
//         childDecoration: BoxDecoration(
//           borderRadius: const BorderRadius.all(Radius.circular(16)),
//           boxShadow: isDarkMode
//               ? [
//             BoxShadow(
//               color: AppColors.primary.withOpacity(0.8),
//               blurRadius: 20,
//             ),
//           ]
//               : [
//             BoxShadow(
//               color: AppColors.primary.withOpacity(0.8),
//               blurRadius: 20,
//             ),
//           ],
//         ),
//         drawer: CustomDrawer(isDarkMode: isDarkMode),
//         child: Scaffold(
//           backgroundColor: isDarkMode ? AppColors.black : AppColors.white,
//           appBar: AppBar(
//             foregroundColor: AppColors.black,
//             surfaceTintColor: AppColors.transparent,
//             leading: IconButton(
//               splashColor: AppColors.transparent,
//               hoverColor: AppColors.transparent,
//               onPressed: homeScreenController.handleMenuButtonPressed,
//               icon: ValueListenableBuilder<AdvancedDrawerValue>(
//                 valueListenable: homeScreenController.advancedDrawerController,
//                 builder: (_, value, __) {
//                   homeScreenController.isIconOpen = !value.visible;
//                   return AnimatedSwitcher(
//                     duration: const Duration(milliseconds: 250),
//                     child: Image.asset(
//                       homeScreenController.isIconOpen
//                           ? "assets/images/menu_open_dark.png"
//                           : "assets/images/menu_close_dark.png",
//                       key: ValueKey<bool>(homeScreenController.isIconOpen),
//                       color: iconColor,
//                       width: 22.w,
//                       height: 22.h,
//                     ),
//                   );
//                 },
//               ),
//             ),
//             backgroundColor: isDarkMode ? AppColors.black : AppColors.white,
//             centerTitle: false,
//             iconTheme: const IconThemeData(
//               color: AppColors.black,
//             ),
//             title: CustomText(
//               firstText: "Noor e",
//               secondText: " Quran",
//               fontSize: 18.sp,
//               firstTextColor: isDarkMode ? AppColors.white : AppColors.black,
//               secondTextColor: AppColors.primary,
//             ),
//             actions: [
//
//               IconButton(
//                 icon: SvgPicture.asset(
//                   isDarkMode
//                       ? 'assets/images/isha.svg'
//                       : 'assets/images/dhuhr.svg',
//                   color: iconColor,
//                   width: 18.w,
//                   height: 18.h,
//                 ),
//                 onPressed: themeController.toggleTheme,
//               ),
//             ],
//           ),
//           body: SingleChildScrollView(
//           )
//         )
//
//       );
//     });
//   }
// }


/*SingleChildScrollView(
      child: Obx(
            () => homeScreenController.isLoading.value
            ? Shimmer.fromColors(
              period: const Duration(milliseconds: 1000),
              baseColor: themeController.isDarkMode.value
                  ? AppColors.black.withOpacity(0.02)
                  : AppColors.black.withOpacity(0.2),
              highlightColor: themeController.isDarkMode.value
                  ? AppColors.lightGrey.withOpacity(0.1)
                  : AppColors.grey.withOpacity(0.2),
              child: Padding(
                padding: EdgeInsets.only(left: 12.w, bottom: 5.h, right: 12.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  // Location Shimmer
                  Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(
                    2,
                        (index) => Container(
                      width: index == 0 ? Get.width * 0.4 : Get.width * 0.3,
                      height: index == 0 ? 18.sp : 14.sp,
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                    ),
                  ),
                ),
                AppSizedBox.space10h,
                // Marquee Shimmer
                Container(
                  height: 45.h,
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
                AppSizedBox.space10h,
                // Last Accessed Hadith Header Shimmer
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(
                    2,
                        (index) => Container(
                      width: index == 0 ? Get.width * 0.4 : Get.width * 0.2,
                      height: index == 0 ? 18.sp : 14.sp,
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                    ),
                  ),
                ),
                AppSizedBox.space10h,
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(
                      3,
                          (index) => Container(
                        width: 280.w,
                        margin: EdgeInsets.only(right: 8.w),
                        child: Container(
                          padding: EdgeInsets.all(6.h),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.r),
                            color: AppColors.white,
                          ),
                          child: ListTile(
                            contentPadding: EdgeInsets.zero,
                            dense: true,
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: Get.width * 0.4,
                                  height: 15.sp,
                                  decoration: BoxDecoration(
                                    color: AppColors.white,
                                    borderRadius: BorderRadius.circular(10.r),
                                  ),
                                ),
                                AppSizedBox.space5h,
                                Container(
                                  width: Get.width * 0.5,
                                  height: 14.sp,
                                  decoration: BoxDecoration(
                                    color: AppColors.white,
                                    borderRadius: BorderRadius.circular(10.r),
                                  ),
                                ),
                              ],
                            ),
                            subtitle: Container(
                              width: Get.width * 0.3,
                              height: 12.sp,
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                            ),
                            trailing: Container(
                              width: 25.sp,
                              height: 25.sp,
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                AppSizedBox.space10h,
                // Hadith of the Hour Header Shimmer
                Container(
                  width: Get.width * 0.4,
                  height: 18.sp,
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
                AppSizedBox.space10h,
                // Hadith of the Hour Container Shimmer
                Container(
                  width: double.infinity,
                  height: 150.h,
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(15.r),
                  ),
                ),
                AppSizedBox.space10h,
                // Explore by Books Header Shimmer
                Container(
                  width: Get.width * 0.4,
                  height: 18.sp,
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
                AppSizedBox.space10h,
                // Explore by Books List Shimmer
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(
                      3,
                          (index) => Container(
                        width: 200.w,
                        margin: EdgeInsets.only(right: 8.w),
                        child: Container(
                          padding: EdgeInsets.all(6.h),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.r),
                            color: AppColors.white,
                          ),
                          child: ListTile(
                            contentPadding: EdgeInsets.zero,
                            dense: true,
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: Get.width * 0.4,
                                  height: 15.sp,
                                  decoration: BoxDecoration(
                                    color: AppColors.white,
                                    borderRadius: BorderRadius.circular(10.r),
                                  ),
                                ),
                                AppSizedBox.space5h,
                                Container(
                                  width: Get.width * 0.5,
                                  height: 14.sp,
                                  decoration: BoxDecoration(
                                    color: AppColors.white,
                                    borderRadius: BorderRadius.circular(10.r),
                                  ),
                                ),
                              ],
                            ),
                            subtitle: Container(
                              width: Get.width * 0.3,
                              height: 12.sp,
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                            ),
                            trailing: Container(
                              width: 25.sp,
                              height: 25.sp,
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                // All Collections Shimmer
                AppSizedBox.space10h,
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(
                      3,
                          (index) => Container(
                        width: 200.w,
                        margin: EdgeInsets.only(right: 8.w),
                        child: Container(
                          padding: EdgeInsets.all(6.h),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.r),
                            color: AppColors.white,
                          ),
                          child: ListTile(
                            contentPadding: EdgeInsets.zero,
                            dense: true,
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: Get.width * 0.4,
                                  height: 15.sp,
                                  decoration: BoxDecoration(
                                    color: AppColors.white,
                                    borderRadius: BorderRadius.circular(10.r),
                                  ),
                                ),
                                AppSizedBox.space5h,
                                Container(
                                  width: Get.width * 0.5,
                                  height: 14.sp,
                                  decoration: BoxDecoration(
                                    color: AppColors.white,
                                    borderRadius: BorderRadius.circular(10.r),
                                  ),
                                ),
                              ],
                            ),
                            subtitle: Container(
                              width: Get.width * 0.3,
                              height: 12.sp,
                              decoration: BoxDecoration(
                                  color: AppColors.white,
                                  borderRadius: BorderRadius.circular(10.r),
                            ),
                          ),
                          trailing: Container(
                            width: 25.sp,
                            height: 25.sp,
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                )
              ],
            ),
      )
          )
            : Padding(
              padding: EdgeInsets.only(left: 10.w, bottom: 5.h, right: 10.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(() {
                    return Row(
                      children: [
                        SizedBox(
                          width: 150.w,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(
                                title: "Location",
                                textColor: isDarkMode ? AppColors.white : AppColors.black,
                                fontSize: 18.sp,
                                fontFamily: 'grenda',
                                maxLines: 1,
                                textOverflow: TextOverflow.ellipsis,
                              ),
                              locationPermissionScreenController.locationAccessed.value
                                  ? CustomText(
                                title: locationPermissionScreenController.cityName.toString() + ", " + locationPermissionScreenController.countryName.toString(),
                                textColor: AppColors.primary,
                                fontSize: 14.sp,
                                maxLines: 1,
                                textAlign: TextAlign.start,
                                textOverflow: TextOverflow.ellipsis,
                              )
                                  : CustomText(
                                title: 'Access Denied',
                                textColor: AppColors.primary,
                                fontSize: 14.sp,
                                maxLines: 1,
                                textOverflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        GetBuilder<FlyingBirdAnimationControllerForHadith>(
                          init: FlyingBirdAnimationControllerForHadith(),
                          builder: (controller) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: List.generate(
                                2,
                                    (index) => FlyingBird(
                                  positionAnimation: controller.positionAnimation,
                                  opacityAnimation: controller.opacityAnimation,
                                  offsetMultiplier: index == 0 ? 0.01 : 0.1,
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    );
                  }),
                  AppSizedBox.space15h,
                  Obx(() {
                    if (locationPermissionScreenController.locationAccessed.value) {
                      if (homeScreenController.getCurrentDate().isNotEmpty &&
                          locationPermissionScreenController.cityName.isNotEmpty &&
                          homeScreenController.getIslamicDate().isNotEmpty) {
                        return Container(
                          height: 45.h,
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(left: 8.w, right: 8.w),
                            child: Marquee(
                              text:
                              'As of ${homeScreenController.getCurrentDate()}, in ${locationPermissionScreenController.cityName}, the Islamic date is ${homeScreenController.getIslamicDate()}',
                              style: GoogleFonts.quicksand(
                                color: AppColors.primary,
                                fontSize: 14.sp,
                                fontStyle: FontStyle.italic,
                              ),
                              scrollAxis: Axis.horizontal,
                              blankSpace: 10.0,
                              velocity: 30.0,
                              pauseAfterRound: const Duration(seconds: 2),
                              startPadding: 10.0,
                              accelerationDuration: const Duration(seconds: 1),
                              accelerationCurve: Curves.easeIn,
                              decelerationDuration: const Duration(milliseconds: 500),
                              decelerationCurve: Curves.easeOut,
                            ),
                          ),
                        );
                      } else {
                        return const SizedBox.shrink(); // Don't show Marquee if data is empty
                      }
                    } else {
                      return const SizedBox.shrink(); // Don't show Marquee if location access is denied
                    }
                  }),
                  if (hadithNumberKeys.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppSizedBox.space15h,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: CustomText(
                                title: "Last Accessed Hadith",
                                textColor: isDarkMode ? AppColors.white : AppColors.black,
                                fontSize: 18.sp,
                                fontFamily: 'grenda',
                                maxLines: 1,
                                textAlign: TextAlign.start,
                                textOverflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Expanded(
                              child: InkWell(
                                splashColor: AppColors.transparent,
                                onTap: () => Get.to(() => LastAccessedHadithsScreen()),
                                child: CustomText(
                                  title: "View All",
                                  textColor: isDarkMode ? AppColors.primary : AppColors.black,
                                  fontSize: 14.sp,
                                  fontFamily: 'quicksand',
                                  textAlign: TextAlign.end,
                                  fontWeight: FontWeight.w600,
                                  textOverflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ],
                        ),
                        AppSizedBox.space15h,
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: hadithNumberKeys.asMap().entries.toList()
                                .reversed.take(3)
                                .map<Widget>((entry) {
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
                                print('Attempting to read keys with index: $hadithIndex');
                                final hadithNumber = box.read(hadithNumberKey);
                                final hadithFirstBody = box.read(hadithFirstBodyKey);
                                final hadithLastBody = box.read(hadithLastBodyKey);
                                final hadithGrade = box.read(hadithGradeKey);
                                final bookNumber = box.read(bookNumberKey);
                                final bookLastName = box.read(bookLastNameKey);
                                final bookFirstName = box.read(bookFirstNameKey);
                                final collectionName = box.read(collectionNameKey);
                                final timestampString = box.read(timestampKey);

                                print('Read data: {hadithNumber: $hadithNumber, hadithFirstBody: $hadithFirstBody, ...}');

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
                                    title: CustomText(
                                      title: "Hadith ${hadithNumber}",
                                      fontSize: 15.sp,
                                      textColor: isDarkMode ? AppColors.white : AppColors.black,
                                      fontWeight: FontWeight.w500,
                                      textOverflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      textAlign: TextAlign.start,
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        CustomText(
                                          title: '${collectionName} | Book ${bookNumber}',
                                          fontSize: 14.sp,
                                          textColor: AppColors.primary,
                                          capitalize: true,
                                          textAlign: TextAlign.start,
                                          textOverflow: TextOverflow.ellipsis,
                                          fontWeight: FontWeight.w500,
                                          maxLines: 1,
                                        ),
                                        AppSizedBox.space5h,
                                        CustomText(
                                          title: 'Last Accessed: ${DateFormat('yyyy-MM-dd HH:mm').format(timestamp!)}',
                                          fontSize: 12.sp,
                                          textAlign: TextAlign.start,
                                          textColor: isDarkMode ? AppColors.grey : AppColors.black,
                                        ),
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
                                print('Error parsing hadithIndex: $e');
                                print('Key causing the error: <span class="math-inline">hadithNumberKey');
                                return SizedBox.shrink();
                              }
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  AppSizedBox.space15h,
                  CustomText(
                      title: "Hadith Of The Hour",
                      textColor: isDarkMode ? AppColors.white : AppColors.black,
                      fontSize: 18.sp,
                      fontFamily: 'grenda',
                      maxLines: 1,
                      textOverflow: TextOverflow.ellipsis),
                  AppSizedBox.space15h,
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(isDarkMode
                            ? "assets/images/quran_bg_dark.jpg"
                            : "assets/images/quran_bg_light.jpg"),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(15.r),
                      boxShadow: [
                        BoxShadow(
                          color: isDarkMode ? AppColors.primary.withOpacity(0.3) : AppColors.transparent,
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
                              hadithNumber: controller.currentHadith.hadithNumber,
                              hadithFirstBody: controller.currentHadith.hadith.first.body,
                              hadithLastBody: controller.currentHadith.hadith.last.body,
                              grade: "",
                              bookLastName: controller.currentHadith.hadith.last.chapterTitle,
                              bookFirstName: controller.currentHadith.hadith.first.chapterTitle,
                              bookNumber: int.tryParse(controller.currentHadith.bookNumber) ?? 0,
                              collectionName: controller.currentHadith.collection,
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
                                          controller.currentHadith.hadith.first.body, 1,
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
                                            title: '  ${controller.currentHadith.collection} | Hadith No. ${controller.currentHadith.hadithNumber} | Book ${controller.currentHadith.bookNumber}',
                                            fontSize: 13.sp,
                                            textColor: AppColors.white,
                                            maxLines: 1000,
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
                  ),
                  AppSizedBox.space15h,
                  CustomText(
                    title: "Explore by Books",
                    textColor: isDarkMode ? AppColors.white : AppColors.black,
                    fontSize: 18.sp,
                    fontFamily: 'grenda',
                    maxLines: 1,
                    textAlign: TextAlign.start,
                    textOverflow: TextOverflow.ellipsis,
                  ),
                  AppSizedBox.space15h,
                  Column(
                    children: [
                      for (int listIndex = 0; listIndex < 2; listIndex++)
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: List.generate(
                              3,
                                  (itemIndex) {
                                final collectionIndex = listIndex * 3 + itemIndex;
                                if (firstSixCollections.isNotEmpty && collectionIndex < firstSixCollections.length) {
                                  final collection = firstSixCollections[collectionIndex];
                                  final books = getFirstSixBooks(collection);

                                  if (books.isNotEmpty) {
                                    final book = books[controller.random.nextInt(books.length)]; // Corrected line

                                    return InkWell(
                                      onTap: () {
                                        String bookFirstName = book.book.isNotEmpty ? book.book.first.name : 'Unknown';
                                        String bookLastName = book.book.isNotEmpty ? book.book.last.name : 'Unknown';
                                        int bookNumber = int.tryParse(book.bookNumber) ?? 0;

                                        Get.to(
                                          HadithCollectionSpecificBookDetailScreen(
                                            collection: collection,
                                            bookNumber: bookNumber,
                                            bookFirstName: bookFirstName,
                                            bookLastName: bookLastName,
                                            totalHadith:book.numberOfHadith ,
                                          ),
                                        );
                                      },
                                      child: Container(
                                        width: 180.w,
                                        padding: EdgeInsets.all(10.w),
                                        margin: EdgeInsets.only(right: 8.w, bottom: 10.h),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10.r),
                                          color: (listIndex % 2 == 0)
                                              ? (itemIndex % 2 == 1)
                                              ? AppColors.primary.withOpacity(0.29)
                                              : AppColors.primary.withOpacity(0.1)
                                              : (itemIndex % 2 == 1)
                                              ? AppColors.primary.withOpacity(0.1)
                                              : AppColors.primary.withOpacity(0.29),
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.zero,
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              CustomText(
                                                title: collection.name,
                                                textColor: isDarkMode ? AppColors.white : AppColors.black,
                                                capitalize: true,
                                                fontSize: 15.sp,
                                                fontWeight: FontWeight.w500,
                                                textOverflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                                textAlign: TextAlign.start,
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
                                              CustomText(
                                                title: "Total Hadith ${book.numberOfHadith.toString()}",
                                                textAlign: TextAlign.start,
                                                capitalize: true,
                                                maxLines: 1,
                                                fontSize: 12.sp,
                                                textColor: isDarkMode ? AppColors.grey : AppColors.black,
                                                textOverflow: TextOverflow.ellipsis,
                                                fontWeight: FontWeight.w500,
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
                    ],
                  ),
                  AppSizedBox.space5h,
                  CustomText(
                    title: "All Collections",
                    textColor: isDarkMode ? AppColors.white : AppColors.black,
                    fontSize: 18.sp,
                    fontFamily: 'grenda',
                    maxLines: 1,
                    textAlign: TextAlign.start,
                    textOverflow: TextOverflow.ellipsis,
                  ),
                  AppSizedBox.space10h,
                  Column(
                    children: [
                      SingleChildScrollView(
                        child: GridView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 1,
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
                                child: Container(
                                  margin: EdgeInsets.all(5.h),
                                  decoration: BoxDecoration(
                                    color: isDarkMode ? AppColors.black : AppColors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.primary.withOpacity(0.2),
                                        spreadRadius: 1,
                                        blurRadius: 4,
                                      ),
                                    ],
                                  ),
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
                                            fontSize: 18.sp,
                                            textColor:  isDarkMode ? AppColors.white : AppColors.black,
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
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  )
                ],
              ),
            )
      )
          )*/