import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:noor_e_quran/app/config/app_colors.dart';
import 'package:noor_e_quran/app/config/app_sizedbox.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../controllers/app_theme_switch_controller.dart';
import '../../../widgets/custom_snackbar.dart';
import '../../../widgets/custom_text.dart';
import 'package:intl/intl.dart';
import 'hadith_detail_screen.dart';

class SavedHadithScreen extends StatefulWidget {
  const SavedHadithScreen({super.key});

  @override
  State<SavedHadithScreen> createState() => _SavedHadithScreenState();
}

class _SavedHadithScreenState extends State<SavedHadithScreen> {
  final GetStorage storage = GetStorage();
  List<dynamic> savedHadiths = [];
  final AppThemeSwitchController themeController = Get.find(); // Use Get.find()

  @override
  void initState() {
    super.initState();
    _loadSavedHadiths();
  }

  void _loadSavedHadiths() {
    savedHadiths = storage.read<List>('savedHadiths') ?? [];
    savedHadiths.sort((a, b) {
      DateTime dateA = _parseDate(a['savedAt']);
      DateTime dateB = _parseDate(b['savedAt']);
      return dateB.compareTo(dateA);
    });
    setState(() {});
  }

  DateTime _parseDate(String dateString) {
    final DateFormat dateFormat = DateFormat('dd MMM<ctrl3348>, hh:mm a');
    try {
      return dateFormat.parse(dateString);
    } catch (e) {
      print('Error parsing date: $e');
      return DateTime.now();
    }
  }

  void deleteHadith(String hadithNumber) {
    setState(() {
      savedHadiths.removeWhere((hadith) => hadith['hadithNumber'] == hadithNumber);
      storage.write('savedHadiths', savedHadiths); // Save updated list to storage
      CustomSnackbar.show(
        title: "Removed",
        subtitle: "Hadith removed from bookmarks",
        icon: const Icon(Icons.check),
        backgroundColor: AppColors.red,
      );
    });
  }

  String cleanText(String text) {
    return text.replaceAll(RegExp(r'\[.*?\]'), '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: themeController.isDarkMode.value ? AppColors.black : AppColors.white,
      appBar: AppBar(
        surfaceTintColor: AppColors.transparent,
        centerTitle: false,
        title: CustomText(
          firstText: "Saved ",
          secondText: "Hadith",
          fontSize: 18.sp,
          secondTextColor: AppColors.primary,
          firstTextColor: themeController.isDarkMode.value ? AppColors.white : AppColors.black,
          capitalize: true,
        ),
        backgroundColor: themeController.isDarkMode.value ? AppColors.black : AppColors.white,
        leading: IconButton(
          icon: Icon(
            Icons.west,
            color: themeController.isDarkMode.value ? AppColors.white : AppColors.black,
          ),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: savedHadiths.isEmpty
          ? Center(
        child: CustomText(
          title: 'No Saved Hadiths',
          fontSize: 18.sp,
          textColor: themeController.isDarkMode.value ? AppColors.white : AppColors.black,
        ),
      )
          : ListView.builder(
        itemCount: savedHadiths.length,
        itemBuilder: (context, index) {
          final hadith = savedHadiths[index];
          return Container(
            margin: EdgeInsets.only(left: 10.w, right: 10.w, bottom: 5, top: 10.h),
            padding: EdgeInsets.all(10.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.r),
              color: (index % 2 == 0)
                  ? AppColors.primary.withOpacity(0.25)
                  : AppColors.primary.withOpacity(0.09),
            ),
            child: ListTile(
              splashColor: AppColors.transparent,
              hoverColor: AppColors.transparent,
              focusColor: AppColors.transparent,
              title: CustomText(
                title: 'Book ${hadith['bookNumber']} Hadith ${hadith['hadithNumber']} ',
                fontSize: 16.sp,
                textColor: AppColors.primary,
                textAlign: TextAlign.start,
                fontFamily: 'grenda',
                fontWeight: FontWeight.w500,
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  AppSizedBox.space5h,
                  Html(
                    data: cleanText(hadith['bookFirstName']), // Cleaned text
                    style: {
                      "body": Style(
                        fontSize: FontSize(14.sp),
                        color: themeController.isDarkMode.value ? AppColors.white : AppColors.black,
                        textAlign: TextAlign.left, // Ensure text alignment is left
                        fontWeight: FontWeight.w600,
                        fontFamily: 'quicksand',
                        margin: Margins(left: Margin.zero()),
                        maxLines: 2,
                      ),
                    },
                  ),
                  Html(
                    data: cleanText(hadith['hadithFirstBody']), // Cleaned text
                    style: {
                      "body": Style(
                        fontSize: FontSize(14.sp),
                        color: themeController.isDarkMode.value ? AppColors.white : AppColors.black,
                        textAlign: TextAlign.left, // Ensure text alignment is left
                        fontWeight: FontWeight.normal,
                        fontFamily: 'quicksand',
                        margin: Margins(left: Margin.zero()),
                        maxLines: 2,
                      ),
                    },
                  ),
                  CustomText(
                    title: 'Saved at: ${hadith['savedAt']}',
                    textAlign: TextAlign.start,
                    textColor: themeController.isDarkMode.value ? AppColors.white : AppColors.black,
                    fontSize: 12.sp,
                  ),
                  AppSizedBox.space5h,
                ],
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: AppColors.red),
                onPressed: () => deleteHadith(hadith['hadithNumber']),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HadithDetailScreen(
                      hadithNumber: hadith['hadithNumber'],
                      hadithFirstBody: hadith['hadithFirstBody'],
                      hadithLastBody: hadith['hadithLastBody'],
                      grade: hadith['grade'],
                      bookNumber: hadith['bookNumber'],
                      bookLastName: hadith['bookLastName'],
                      bookFirstName: hadith['bookFirstName'],
                      collectionName: hadith['collectionName'],
                      isFromSavedHadithList: true,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}