import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import '../config/app_colors.dart';

Widget buildShimmerContainer({double? widthFactor, double? height, double? borderRadius}) {
  return Container(
    width: widthFactor != null ? Get.width * widthFactor : null,
    height: height,
    decoration: BoxDecoration(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(borderRadius ?? 10.r),
    ),
  );
}

BoxDecoration shimmerBoxDecoration({double? borderRadius}) {
  return BoxDecoration(
    borderRadius: BorderRadius.circular(borderRadius ?? 15.r),
    color: AppColors.white,
  );
}