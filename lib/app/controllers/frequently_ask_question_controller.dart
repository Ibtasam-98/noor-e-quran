import 'package:get/get.dart';

class FrequentlyAskQuenstionAndPrivacyPolicyController extends GetxController {
  final List<ExpandableItem> _privacyPolicyItems = [
    ExpandableItem(
      title: "Privacy Policy",
      content:
      "This privacy policy describes how this application handles your data. We respect your privacy and are committed to protecting your personal information.",
    ),
    ExpandableItem(
      title: "Local Storage Only",
      content:
      "All user data, including preferences such as bookmarks of Hadith and Ayat, is stored exclusively on your device's local storage. We do not collect or transmit any of this data to external servers or databases.",
    ),
    ExpandableItem(
      title: "No Data Collection",
      content:
      "We do not collect any personally identifiable information from you. Your usage of this application remains entirely private.",
    ),
    ExpandableItem(
      title: "Permissions",
      content:
      "This application may request certain permissions to function correctly. These permissions are used solely for the intended functionality and are not used to collect or transmit any personal data.",
    ),
    ExpandableItem(
      title: "Updates to this Policy",
      content:
      "We may update this privacy policy from time to time. Any changes will be posted within the application.",
    ),
    ExpandableItem(
      title: "Contact Us",
      content:
      "If you have any questions or concerns about this privacy policy, please contact us at quantumbytes.tech@gmail.com.",
    ),
  ];

  List<ExpandableItem> get privacyPolicyItems => _privacyPolicyItems;

  int? _expandedIndex;

  int? get expandedIndex => _expandedIndex;

  void toggleExpanded(int index) {
    if (_expandedIndex == index) {
      _expandedIndex = null;
    } else {
      _expandedIndex = index;
    }
    update();
  }

  // FAQ Items
  final List<FAQItem> _faqItems = [
    FAQItem(
      question: 'Why Namaz timings are not visible?',
      answer: 'To view Namaz timings, please ensure the following:\n\n'
          '● Verify location services are enabled on your device. This setting can usually be found in your device settings under "Location" or a similar term.\n\n'
          '● Confirm that the app has permission to access your device\'s location. You may need to check your app permissions in your device settings.\n\n'
          '● Ensure you have an active internet connection.\n\n'
          '● If using cellular data, make sure the app is allowed to use cellular data for location services.',
    ),
    FAQItem(
      question: 'Why is Quran audio not working?',
      answer:
      'This app requires an internet connection to stream Quran audio. Please make sure you are connected to the internet.',
    ),
    FAQItem(
      question: 'How do I change the app\'s theme?',
      answer:
      'You can change the app\'s theme in the settings menu. Look for the "Theme" option and select your preferred theme.',
    ),
    FAQItem(
      question: 'Can I use the app offline?',
      answer:
      'You can use the app offline with some features like Tasbeeh, daily Azkar, supplications, etc. However, for Quran, Hadith, and accurate Namaz timings, you need to be online.',
    ),
    // Qibla FAQs
    FAQItem(
      question: 'Why is the Qibla direction inaccurate?',
      answer:
      'Qibla direction accuracy can be affected by several factors:\n\n'
          '●   **Magnetic Interference:** Move away from metal objects, electronics, and power lines.\n'
          '●   **Calibration:** Calibrate your device\'s compass by moving it in a figure-eight motion.\n'
          '●   **Location Permissions:** Ensure the app has permission to access your device\'s location.\n'
          '●   **Device Sensors:** Some devices have less accurate compass sensors.',
    ),
    FAQItem(
      question: 'How do I calibrate my device\'s compass?',
      answer:
      'Most devices can be calibrated by moving them in a figure-eight motion several times. You can also find calibration instructions in your device\'s settings or user manual.',
    ),
    FAQItem(
      question: 'Does the Qibla direction require location permission?',
      answer:
      'Yes, the Qibla direction feature uses your device\'s location to calculate the direction accurately. Please allow the app to access your location when prompted or in your device\'s settings.',
    ),
    FAQItem(
      question: 'The Qibla direction seems to be pointing to the wrong place.',
      answer:
      'If the Qibla direction is consistently incorrect, try the following:\n\n'
          '●   Restart the app and your device.\n'
          '●   Ensure your device\'s location services are accurate (e.g., by checking in a maps app).\n'
          '●   Check for updates to the app, as fixes and improvements are regularly released.',
    ),
  ];

  List<FAQItem> get faqItems => _faqItems;
}

class FAQItem {
  final String question;
  final String answer;

  FAQItem({required this.question, required this.answer});
}

class ExpandableItem {
  final String title;
  final String content;

  ExpandableItem({required this.title, required this.content});
}