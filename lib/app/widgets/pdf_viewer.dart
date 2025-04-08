import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:noor_e_quran/app/config/app_sizedbox.dart';
import 'package:noor_e_quran/app/config/app_colors.dart';
import 'package:noor_e_quran/app/controllers/app_theme_switch_controller.dart';
import 'package:noor_e_quran/app/controllers/pdf_viewer_controller.dart';
import 'package:noor_e_quran/app/widgets/custom_text.dart';

class PdfViewer extends StatelessWidget {
  final String assetPath;
  final String firstTitle, secondTitle;

  PdfViewer({required this.assetPath, required this.firstTitle, required this.secondTitle});

  final AppThemeSwitchController themeController = Get.find();
  final PdfViewerController pdfViewerController = Get.put(PdfViewerController());

  @override
  Widget build(BuildContext context) {
    pdfViewerController.loadPdf(assetPath); // Load PDF using controller

    return Obx(() {
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
            firstText: firstTitle,
            secondText: secondTitle,
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
              child: CustomText(
                textColor: textColor,
                fontSize: 18.sp,
                title: "${pdfViewerController.currentPage.value + 1}/${pdfViewerController.totalPages.value}",
              ),
            )
          ],
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(4.0),
            child: pdfViewerController.isLoading.value
                ? LinearProgressIndicator(
              backgroundColor: Colors.grey.withOpacity(0.3),
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
            )
                : LinearProgressIndicator(
              value: pdfViewerController.totalPages.value > 0
                  ? (pdfViewerController.currentPage.value + 1) / pdfViewerController.totalPages.value
                  : 0,
              backgroundColor: Colors.grey.withOpacity(0.3),
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
          ),
        ),
        body: pdfViewerController.isLoading.value
            ? Center(child: CircularProgressIndicator())
            : Column(
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
                backgroundColor: isDarkMode ? AppColors.black : AppColors.white,
                filePath: pdfViewerController.pdfPath.value,
                enableSwipe: false,
                fitEachPage: true,
                swipeHorizontal: false,
                autoSpacing: false,
                pageFling: true,
                onRender: (pages) {
                  pdfViewerController.totalPages.value = pages ?? 0;
                },
                onViewCreated: (PDFViewController controller) {
                  pdfViewerController.pdfController = controller;
                },
                onPageChanged: (page, _) {
                  pdfViewerController.currentPage.value = page ?? 0;
                  //No get storage save.
                },
              ),
            ),
          ],
        ),
      );
    });
  }
}