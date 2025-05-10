import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:noor_e_quran/app/widgets/custom_snackbar.dart';
import '../../../config/app_colors.dart';
import '../../../config/app_sizedbox.dart';
import '../../../controllers/app_theme_switch_controller.dart';
import '../../../widgets/custom_text.dart';
import '../controllers/digital_quran_screen_controller.dart';

class QuranDigitalScreen extends StatelessWidget {
  final DigitalQuranScreenController controller = Get.put(DigitalQuranScreenController());
  final AppThemeSwitchController themeController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isDarkMode = themeController.isDarkMode.value;
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
            firstTextColor: textColor,
            secondTextColor: AppColors.primary,
          ),
          leading: IconButton(
            icon: Icon(Icons.west, color: iconColor),
            onPressed: () => Get.back(),
          ),
          backgroundColor: isDarkMode ? AppColors.black : AppColors.white,
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 15.w),
              child: Text(
                '${controller.currentPage.value + 1}/${controller.totalPages.value}',
                style: TextStyle(
                  color: textColor,
                  fontSize: 18.sp,
                ),
              ),
            ),
          ],
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(4.0),
            child: controller.isLoading.value
                ? SizedBox.shrink()
                : LinearProgressIndicator(
              value: controller.totalPages.value > 0
                  ? (controller.currentPage.value + 1) / controller.totalPages.value
                  : 0,
              backgroundColor: Colors.grey.withOpacity(0.3),
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
          ),
        ),
        body: controller.isLoading.value
            ? Center(child: CircularProgressIndicator(color: AppColors.primary))
            : controller.pdfPath.value.isNotEmpty
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
                filePath: controller.pdfPath.value,
                enableSwipe: true,
                swipeHorizontal: false,
                nightMode: isDarkMode,
                defaultPage: controller.currentPage.value,
                onRender: (pages) => controller.totalPages.value = pages ?? 0,
                onPageChanged: (page, _) {
                  if (page != null) {
                    controller.handlePageChange(page);
                  }
                },
                onError: (error) {
                  CustomSnackbar.show(
                    title: "Error",
                    subtitle: "Failed to load PDF page",
                    backgroundColor: Colors.red,
                    icon: Icon(Icons.error),
                  );
                },
              ),
            ),
          ],
        )
            : Center(
          child: CustomText(
            title: "Failed to load PDF",
            textColor: textColor,
            fontSize: 18.sp,
          ),
        ),
      );
    });
  }
}