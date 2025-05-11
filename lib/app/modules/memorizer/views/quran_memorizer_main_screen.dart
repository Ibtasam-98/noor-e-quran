import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:noor_e_quran/app/modules/home/views/app_home_base_screen.dart';
import 'package:quran/quran.dart' as quran;
import 'package:noor_e_quran/app/controllers/flying_bird_animation_controller.dart';
import '../../../config/app_colors.dart';
import '../../../config/app_sizedbox.dart';
import '../../../widgets/custom_text.dart';
import '../../home/controllers/app_home_screen_controller.dart';
import '../../home/views/app_home_screen_header.dart';

class QuranMemorizerMainScreen extends StatelessWidget {
  final Map<String, dynamic>? userData;

  QuranMemorizerMainScreen({super.key, this.userData});
  @override
  Widget build(BuildContext context) {
    final FlyingBirdAnimationController _hifzBirdController = Get.find<FlyingBirdAnimationController>();
    final AppHomeScreenController controller = Get.put(AppHomeScreenController());

    return AppHomeBaseScreen(
      titleFirstPart: "Noor e",
      titleSecondPart: " Quran",
      birdController: _hifzBirdController,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HomeScreenHeader(birdController: _hifzBirdController),
          Obx(() => CustomText(
            title: "Holy Quran Memorizer",
            textColor: controller.themeController.isDarkMode.value ? AppColors.white : AppColors.black,
            fontSize: 14.sp,
            fontFamily: 'grenda',
            textAlign: TextAlign.start,
            maxLines: 1,
            textOverflow: TextOverflow.ellipsis,
          )),
          AppSizedBox.space10h,
        ],
      ),
    );
  }
}