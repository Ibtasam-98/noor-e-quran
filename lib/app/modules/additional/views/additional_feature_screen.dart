import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:noor_e_quran/app/modules/home/views/app_home_base_screen.dart';
import 'package:quran/quran.dart' as quran;
import '../../../widgets/custom_frame.dart';
import 'package:noor_e_quran/app/controllers/flying_bird_animation_controller.dart';
import '../../home/views/app_home_screen_header.dart';

class AdditionalFeatureScreen extends StatelessWidget {
  final Map<String, dynamic>? userData;
  // No need to put the controller here anymore

  AdditionalFeatureScreen({super.key, this.userData});

  @override
  Widget build(BuildContext context) {
    final FlyingBirdAnimationController _additionalBirdController =  Get.find<FlyingBirdAnimationController>();

    return AppHomeBaseScreen(
      titleFirstPart: "Noor e",
      titleSecondPart: " Quran",
      birdController: _additionalBirdController,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HomeScreenHeader(birdController: _additionalBirdController),
          CircleAvatar(backgroundColor: Colors.red,)
        ],
      ),
    );
  }
}