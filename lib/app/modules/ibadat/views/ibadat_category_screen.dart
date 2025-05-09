import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:noor_e_quran/app/controllers/flying_bird_animation_controller.dart';
import 'package:noor_e_quran/app/controllers/user_location_premission_controller.dart';

import '../../home/controllers/app_home_screen_controller.dart';
import '../../home/views/app_home_base_screen.dart';
import '../../home/views/app_home_screen_header.dart';


class IbadatCategoryScreen extends StatelessWidget {
  final Map<String, dynamic>? userData;
  IbadatCategoryScreen({super.key, this.userData});

  @override
  Widget build(BuildContext context) {
    final FlyingBirdAnimationController _ibadatBirdController = Get.find<FlyingBirdAnimationController>();

    return AppHomeBaseScreen(
      titleFirstPart: "Noor e",
      titleSecondPart: " Quran",
      birdController: _ibadatBirdController,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HomeScreenHeader(birdController: _ibadatBirdController),
          CircleAvatar(backgroundColor: Colors.tealAccent,)
        ],
      ),
    );
  }
}