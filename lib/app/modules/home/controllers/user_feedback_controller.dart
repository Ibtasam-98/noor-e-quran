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
  }

  String? validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your username';
    }
    if (RegExp(r'[0-9!@#%^&*(),.?":{}|<>]').hasMatch(value)) {
      return 'Username should not contain digits or special characters';
    }
    return null;
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    if (!RegExp(r"^[a-zA-Z0-9.+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]+$")
        .hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? validateSuggestion(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your suggestion';
    }
    return null;
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
    usernameController.dispose();
    emailController.dispose();
    suggestionController.dispose();
    super.onClose();
  }
}