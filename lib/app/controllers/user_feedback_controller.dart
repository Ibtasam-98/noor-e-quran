import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:noor_e_quran/app/config/app_colors.dart';
import 'package:noor_e_quran/app/widgets/custom_snackbar.dart';
import 'package:url_launcher/url_launcher.dart';

class UserFeedbackController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final suggestionController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    // No need to re-initialize controllers here.
  }

  Future<void> sendFeedback() async {
    if (formKey.currentState!.validate()) {
      final username = usernameController.text;
      final email = emailController.text;
      final suggestion = suggestionController.text;

      final Uri emailLaunchUri = Uri(
        scheme: 'mailto',
        path: 'ibtasam.rehman98@gmail.com',
        queryParameters: {
          'subject': 'App Feedback',
          'body': 'Username: $username\nEmail: $email\nSuggestion: $suggestion',
        },
      );

      try {
        await launchUrl(emailLaunchUri);
        CustomSnackbar.show(
          backgroundColor: AppColors.green,
          title: "Success",
          subtitle: "Your suggestion has been sent to the developer",
          icon: Icon(Icons.check),
        );
      } catch (e) {
        CustomSnackbar.show(
          backgroundColor: AppColors.red,
          title: "Error",
          subtitle: "Failed to send feedback. Please try again.",
          icon: Icon(Icons.warning),
        );
      }
    }
  }

  @override
  void onClose() {
    // It's generally a good practice to dispose of TextEditingController
    // when they are no longer needed to prevent memory leaks.
    usernameController.dispose();
    emailController.dispose();
    suggestionController.dispose();
    super.onClose();
  }
}