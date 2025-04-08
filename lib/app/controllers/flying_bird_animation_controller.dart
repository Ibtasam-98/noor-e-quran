
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FlyingBirdAnimationController extends GetxController with SingleGetTickerProviderMixin {
  late AnimationController animationController;
  late Animation<double> positionAnimation;
  late Animation<double> opacityAnimation;
  @override
  void onInit() {
    super.onInit();
    // Initialize the animation controller
    animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 6),
    );
    // Position animation: Moves the bird GIF from off-screen (1.5) to position aligned with "Location" Text (0.0)
    positionAnimation = Tween<double>(begin: 1.5, end: 0.0).animate(
      CurvedAnimation(parent: animationController, curve: Curves.easeInOut),
    );
    // Opacity animation: Gradually changes from fully opaque (1.0) to transparent (0.0)
    opacityAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: animationController, curve: Curves.easeInOut),
    );
    // Start the animation
    animationController.repeat(reverse: false);
  }
  @override
  void onClose() {
    animationController.dispose();
    super.onClose();
  }
}



class FlyingBirdAnimationControllerForHadith extends GetxController with SingleGetTickerProviderMixin {
  late AnimationController animationController;
  late Animation<double> positionAnimation;
  late Animation<double> opacityAnimation;
  @override
  void onInit() {
    super.onInit();
    // Initialize the animation controller
    animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 6),
    );
    // Position animation: Moves the bird GIF from off-screen (1.5) to position aligned with "Location" Text (0.0)
    positionAnimation = Tween<double>(begin: 1.5, end: 0.0).animate(
      CurvedAnimation(parent: animationController, curve: Curves.easeInOut),
    );
    // Opacity animation: Gradually changes from fully opaque (1.0) to transparent (0.0)
    opacityAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: animationController, curve: Curves.easeInOut),
    );
    // Start the animation
    animationController.repeat(reverse: false);
  }
  @override
  void onClose() {
    animationController.dispose();
    super.onClose();
  }
}



class FlyingBirdAnimationControllerForIbadat extends GetxController with SingleGetTickerProviderMixin {
  late AnimationController animationController;
  late Animation<double> positionAnimation;
  late Animation<double> opacityAnimation;
  @override
  void onInit() {
    super.onInit();
    // Initialize the animation controller
    animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 6),
    );
    // Position animation: Moves the bird GIF from off-screen (1.5) to position aligned with "Location" Text (0.0)
    positionAnimation = Tween<double>(begin: 1.5, end: 0.0).animate(
      CurvedAnimation(parent: animationController, curve: Curves.easeInOut),
    );
    // Opacity animation: Gradually changes from fully opaque (1.0) to transparent (0.0)
    opacityAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: animationController, curve: Curves.easeInOut),
    );
    // Start the animation
    animationController.repeat(reverse: false);
  }
  @override
  void onClose() {
    animationController.dispose();
    super.onClose();
  }
}


class FlyingBirdAnimationControllerForHistory extends GetxController with SingleGetTickerProviderMixin {
  late AnimationController animationController;
  late Animation<double> positionAnimation;
  late Animation<double> opacityAnimation;
  @override
  void onInit() {
    super.onInit();
    // Initialize the animation controller
    animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 6),
    );
    // Position animation: Moves the bird GIF from off-screen (1.5) to position aligned with "Location" Text (0.0)
    positionAnimation = Tween<double>(begin: 1.5, end: 0.0).animate(
      CurvedAnimation(parent: animationController, curve: Curves.easeInOut),
    );
    // Opacity animation: Gradually changes from fully opaque (1.0) to transparent (0.0)
    opacityAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: animationController, curve: Curves.easeInOut),
    );
    // Start the animation
    animationController.repeat(reverse: false);
  }
  @override
  void onClose() {
    animationController.dispose();
    super.onClose();
  }
}
