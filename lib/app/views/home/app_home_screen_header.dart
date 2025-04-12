import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:noor_e_quran/app/config/app_colors.dart';
import 'package:noor_e_quran/app/widgets/custom_text.dart';
import '../../controllers/flying_bird_animation_controller.dart';
import '../../controllers/app_theme_switch_controller.dart';
import '../../controllers/user_location_premission_controller.dart';

class HomeScreenHeader extends StatelessWidget {
  final FlyingBirdAnimationController birdController;

  const HomeScreenHeader({Key? key, required this.birdController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AppThemeSwitchController themeController = Get.find<AppThemeSwitchController>();
    final UserPermissionController locationPermissionScreenController = Get.find<UserPermissionController>();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 150.w,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(() => CustomText(
                title: "Location",
                textColor: themeController.isDarkMode.value ? AppColors.white : AppColors.black,
                fontSize: 15.sp,
                fontFamily: 'grenda',
                maxLines: 1,
                textOverflow: TextOverflow.ellipsis,
              )),
              Obx(() => locationPermissionScreenController.locationAccessed.value
                  ? CustomText(
                title: "${locationPermissionScreenController.cityName}, ${locationPermissionScreenController.countryName}",
                textColor: AppColors.primary,
                fontSize: 12.sp,
                maxLines: 1,
                textAlign: TextAlign.start,
                textOverflow: TextOverflow.ellipsis,
              )
                  : CustomText(
                title: 'Access Denied',
                textColor: AppColors.primary,
                fontSize: 12.sp,
                maxLines: 1,
                textOverflow: TextOverflow.ellipsis,
              )),
            ],
          ),
        ),
        AnimatedBuilder(
          animation: birdController.animationController,
          builder: (context, child) {
            return Stack(
              alignment: Alignment.centerLeft,
              children: [
                for (int i = 0; i < 3; i++)
                  Transform.translate(
                    offset: Offset(
                      MediaQuery.of(context).size.width * birdController.positionAnimation.value + (i == 1 ? 50.w : 0),
                      i * 16.0 - 20.0,
                    ),
                    child: Opacity(
                      opacity: birdController.opacityAnimation.value,
                      child: Image.asset(
                        'assets/anim/bird.gif',
                        width: 50.w,
                        height: 50.h,
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}