import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FlyingBirdAnimationController extends GetxController with SingleGetTickerProviderMixin {
  late AnimationController animationController;
  late Animation<double> positionAnimation;
  late Animation<double> opacityAnimation;
  @override
  void onInit() {
    super.onInit();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    );
    positionAnimation = Tween<double>(begin: 1.5, end: 0.0).animate(
      CurvedAnimation(parent: animationController, curve: Curves.easeInOut),
    );
    opacityAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: animationController, curve: Curves.easeInOut),
    );
    animationController.repeat(reverse: false);
  }
  @override
  void onClose() {
    animationController.dispose();
    super.onClose();
  }
}