import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:noor_e_quran/app/modules/home/views/app_home_base_screen.dart';
import 'package:quran/quran.dart' as quran;
import 'package:noor_e_quran/app/controllers/flying_bird_animation_controller.dart';
import '../../home/views/app_home_screen_header.dart';
import '../controllers/hadith_collection_controller.dart';
class HadithCollectionScreen extends StatelessWidget {
  final Map<String, dynamic>? userData;
  // No need to put the controller here anymore
  final HadithCollectionController controller = Get.put(HadithCollectionController());

  HadithCollectionScreen({super.key, this.userData});
  @override
  Widget build(BuildContext context) {
    final FlyingBirdAnimationController _hadithBirdController = Get.find<FlyingBirdAnimationController>();

    return AppHomeBaseScreen(
      titleFirstPart: "Noor e",
      titleSecondPart: " Quran",
      birdController: _hadithBirdController,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HomeScreenHeader(birdController: _hadithBirdController),
          CircleAvatar(backgroundColor: Colors.orange,)
        ],
      ),
    );
  }
}