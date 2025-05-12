import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:noor_e_quran/app/widgets/custom_snackbar.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'dart:async';
import 'package:get_storage/get_storage.dart'; // Import GetStorage

import '../../../config/app_colors.dart';
import '../../../config/app_sizedbox.dart';
import '../../../controllers/app_theme_switch_controller.dart';
import '../../../widgets/custom_text.dart';


class QuranPdfViewer extends StatefulWidget {
  @override
  _QuranPdfViewerState createState() => _QuranPdfViewerState();
}

class _QuranPdfViewerState extends State<QuranPdfViewer> {
  String? pdfPath;
  bool isLoading = true;
  int totalPages = 0;
  int currentPage = 0;
  PDFViewController? pdfViewController;
  DateTime? lastSignificantPageChangeTime;
  int lastSignificantPage = 0;
  Timer? debounceTimer;
  final box = GetStorage(); // Initialize GetStorage
  final AppThemeSwitchController themeController = Get.find();

  @override
  void initState() {
    super.initState();
    loadPdf();
  }

  Future<void> loadPdf() async {
    final cachedPdfPath = box.read('quranPdfPath');

    if (cachedPdfPath != null && File(cachedPdfPath).existsSync()) {
      setState(() {
        pdfPath = cachedPdfPath;
        isLoading = false;
      });
      return;
    }

    try {
      final url =
          'https://drive.google.com/uc?export=download&id=1EQKXq4uOfyPyw5U6FFOFN-mfDJLHwK7n';
      final response = await http.get(Uri.parse(url));
      final bytes = response.bodyBytes;

      final directory = await getApplicationDocumentsDirectory();
      final file = File(path.join(directory.path, 'quran.pdf'));
      await file.writeAsBytes(bytes);

      box.write('quranPdfPath', file.path); // Cache the file path

      setState(() {
        pdfPath = file.path;
        isLoading = false;
      });
    } catch (e) {
      print('Error loading PDF: $e');
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error loading PDF")));
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = themeController.isDarkMode.value;
    final textColor = isDarkMode ? AppColors.white : AppColors.black;
    final iconColor = isDarkMode ? AppColors.white : AppColors.black;
    return Scaffold(
      backgroundColor: isDarkMode ? AppColors.black : AppColors.white,
      appBar: AppBar(
        surfaceTintColor: AppColors.transparent,
        foregroundColor: AppColors.transparent,
        centerTitle: false,
        title: CustomText(
          firstText: "Digital",
          secondText: " Quran",
          fontSize: 18.sp,
          firstTextColor: isDarkMode ? AppColors.white : AppColors.black,
          secondTextColor: AppColors.primary,
        ),
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
        backgroundColor: isDarkMode ? AppColors.black : AppColors.white,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 15.w),
            child: Text(
              '${currentPage + 1}/$totalPages',
              style: TextStyle(
                color: textColor,
                fontSize: 18.sp,
              ),
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(4.0),
          child: isLoading
              ? SizedBox.shrink()
              : LinearProgressIndicator(
            value: totalPages > 0 ? (currentPage + 1) / totalPages : 0,
            backgroundColor: Colors.grey.withOpacity(0.3),
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
          ),
        ),
      ),
      body: isLoading
          ? Center(
        child: CircularProgressIndicator(
          color: AppColors.primary,
        ),
      )
          : pdfPath != null
          ? Column(
        children: [
          AppSizedBox.space10h,
          Center(
            child: CustomText(
              fontSize: 25.sp,
              title: "﷽",
              textColor: textColor,
            ),
          ),
          AppSizedBox.space10h,
          Expanded(
            child: PDFView(
              filePath: pdfPath!,
              onRender: (pages) {
                setState(() {
                  totalPages = pages ?? 0;
                });
              },
              onViewCreated: (PDFViewController pdfViewController) {
                setState(() {
                  this.pdfViewController = pdfViewController;
                });
              },
              onPageChanged: (page, _) {
                if (debounceTimer?.isActive ?? false) {
                  debounceTimer?.cancel();
                }
                debounceTimer = Timer(Duration(milliseconds: 250), () {
                  final now = DateTime.now();
                  if (lastSignificantPageChangeTime != null &&
                      now.difference(lastSignificantPageChangeTime!).inSeconds < 1 &&
                      (page! - lastSignificantPage).abs() >= 3) {
                    CustomSnackbar.show(
                      backgroundColor: AppColors.blue,
                      title: "Gentle Reading",
                      subtitle: "Please read with respect, do not rush.",
                      icon: Icon(Icons.info_outline),
                    );
                  }
                  setState(() {
                    currentPage = page ?? 0;
                    if (lastSignificantPageChangeTime == null ||
                        now.difference(lastSignificantPageChangeTime!).inSeconds >= 1 ||
                        (page! - lastSignificantPage).abs() >= 3) {
                      lastSignificantPageChangeTime = now;
                      lastSignificantPage = page ?? 0;
                    }
                  });
                });
              },
            ),
          ),
        ],
      )
          : Center(child: Text('Failed to load PDF')),
    );
  }
}