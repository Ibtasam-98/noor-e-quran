import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:noor_e_quran/app/config/app_colors.dart';
import 'package:noor_e_quran/app/widgets/custom_snackbar.dart';


class ConnectivityController extends GetxController with SingleGetTickerProviderMixin {
  final RxBool isConnected = false.obs;
  final RxBool isLoading = false.obs;
  final RxBool internetCheckCompleted = false.obs;
  var showNextButton = false.obs;
  late AnimationController animationController;
  late Animation<Offset> slideAnimation;

  final InternetConnectionChecker internetConnectionChecker = InternetConnectionChecker.createInstance();

  @override
  void onInit() {
    super.onInit();

    animationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: const Offset(0, 0),
    ).animate(CurvedAnimation(
      parent: animationController,
      curve: Curves.easeOut,
    ));

    Future.delayed(const Duration(seconds: 5), () {
      showNextButton.value = true;
      animationController.forward();
    });
  }

  @override
  void onClose() {
    animationController.dispose();
    super.onClose();
  }

  Future<void> checkConnectivity() async {
    try {
      isLoading(true);
      isConnected.value = await internetConnectionChecker.hasConnection;
    } catch (e) {
      isConnected.value = false;
      CustomSnackbar.show(
        backgroundColor: AppColors.red,
          title: "Connectivity Error",
          subtitle: "Failed to check internet connection. Please try again.",
          icon: Icon(Icons.error),);
    } finally {
      isLoading(false);
    }
  }

}