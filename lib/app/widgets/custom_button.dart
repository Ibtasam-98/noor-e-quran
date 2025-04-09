import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../config/app_sizedbox.dart';
import 'custom_text.dart';
class CustomButton extends StatelessWidget {
  final String btnTitle;
  final Color btnTitleColor;
  final Color? btnBorderColor;
  final Color bgColor;
  final bool haveBgColor;
  final bool useGradient;
  final Gradient? gradient;
  final double borderRadius;
  final IconData? icon;
  final Color? iconColor;
  final double? iconSize;
  final double? height;
  final VoidCallback? onTap;
  final bool isLoading;


  const CustomButton({
    super.key,
    required this.haveBgColor,
    required this.btnTitle,
    required this.btnTitleColor,
    this.btnBorderColor,
    required this.bgColor,
    this.icon,
    this.iconColor,
    this.iconSize,
    this.gradient,
    this.useGradient = true,
    required this.borderRadius,
    this.height,
    this.onTap,
    this.isLoading = false, // Default is false
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isLoading ? null : onTap, // Disable tap if loading
      borderRadius: BorderRadius.circular(borderRadius),
      child: Container(
        height: height ?? 60.h,
        decoration: BoxDecoration(
          color: haveBgColor ? bgColor : null,
          gradient: useGradient && gradient != null ? gradient : null,
          border: Border.all(
            color: btnBorderColor ?? Colors.transparent,
            width: 0.5,
          ),
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: Center(
          child: isLoading
              ? CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          )
              : Row(
            mainAxisAlignment:
            icon == null ? MainAxisAlignment.center : MainAxisAlignment.start,
            children: [
              AppSizedBox.space10w,
              Expanded(
                child: CustomText(
                  textColor: btnTitleColor,
                  fontSize: 14.sp,
                  title: btnTitle,
                  maxLines: 1,
                  textOverflow: TextOverflow.ellipsis,
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (icon != null) ...[
                AppSizedBox.space10w,
                Icon(
                  icon,
                  color: iconColor ?? Colors.black,
                  size: iconSize ?? 24.0,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
