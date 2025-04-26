
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hadith/classes.dart';
import 'package:hadith/hadith.dart';
import 'package:url_launcher/url_launcher.dart';

class HadithCollectionSpecificBookDetailController extends GetxController with GetSingleTickerProviderStateMixin {
  final Collections collection;
  final int bookNumber;
  final String bookFirstName;
  final String bookLastName;

  HadithCollectionSpecificBookDetailController({
    required this.collection,
    required this.bookNumber,
    required this.bookFirstName,
    required this.bookLastName,
  });

  TextEditingController searchController = TextEditingController();
  bool isSearchVisible = false;
  List<Hadith> cachedHadiths = [];
  bool isLoading = true;
  String? errorMessage;
  late AnimationController animationController;
  late Animation<double> scaleAnimation;
  final ScrollController scrollController = ScrollController();
  double scrollProgress = 0.0;
  bool isScrolling = false;

  @override
  void onInit() {
    super.onInit();
    fetchHadiths();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
    scaleAnimation = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(parent: animationController, curve: Curves.easeInOut),
    );

    animationController.repeat(reverse: true);
    scrollController.addListener(updateScrollProgress);
  }

  @override
  void onClose() {
    animationController.dispose();
    scrollController.removeListener(updateScrollProgress);
    scrollController.dispose();
    super.onClose();
  }

  void updateScrollProgress() {
    if (scrollController.hasClients) {
      scrollProgress = scrollController.position.pixels / scrollController.position.maxScrollExtent;
      isScrolling = scrollController.position.pixels > 0;
      update();
    }
  }

  Future<void> fetchHadiths() async {
    isLoading = true;
    errorMessage = null;
    update();

    try {
      await Future.delayed(const Duration(milliseconds: 300));
      List<Hadith>? hadiths = getHadiths(collection, bookNumber);
      if (hadiths != null) {
        cachedHadiths = hadiths;
      } else {
        errorMessage = "Unable to fetch Hadiths. Please try again.";
      }
    } catch (e) {
      errorMessage = "Unable to fetch Hadiths. Please try again.";
    } finally {
      isLoading = false;
      update();
    }
  }

  List<Hadith> filterHadiths(String query) {
    if (query.isEmpty) {
      return cachedHadiths;
    }

    return cachedHadiths.where((hadith) {
      final hadithNumberMatch = hadith.hadithNumber.toString().contains(query);

      final hadithBodyMatch = (hadith.hadith.isNotEmpty &&
          (hadith.hadith.first.body?.toLowerCase().contains(query.toLowerCase()) ?? false)) ||
          (hadith.hadith.isNotEmpty &&
              (hadith.hadith.last.body?.toLowerCase().contains(query.toLowerCase()) ?? false));

      return hadithNumberMatch || hadithBodyMatch;
    }).toList();
  }

  void toggleSearchVisibility() {
    isSearchVisible = !isSearchVisible;
    if (!isSearchVisible) searchController.clear();
    update();
  }

  Future<void> launchBookUrl() async {
    String url = getBookURL(collection, bookNumber);
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }

  void saveLastAccessedHadith({
    required String hadithNumber,
    required String hadithFirstBody,
    required String hadithLastBody,
    required String grade,
    required int bookNumber,
    required String bookLastName,
    required String bookFirstName,
    required String collectionName,
  }) async {
    final box = GetStorage();
    final now = DateTime.now().toIso8601String();

    final hadithCount = box.getKeys().where((String key) => key.startsWith('lastAccessedHadithNumber')).length;

    await box.write('lastAccessedHadithNumber$hadithCount', hadithNumber);
    await box.write('lastAccessedHadithFirstBody$hadithCount', hadithFirstBody);
    await box.write('lastAccessedHadithLastBody$hadithCount', hadithLastBody);
    await box.write('lastAccessedHadithGrade$hadithCount', grade);
    await box.write('lastAccessedBookNumber$hadithCount', bookNumber);
    await box.write('lastAccessedBookLastName$hadithCount', bookLastName);
    await box.write('lastAccessedBookFirstName$hadithCount', bookFirstName);
    await box.write('lastAccessedCollectionName$hadithCount', collectionName);
    await box.write('lastAccessedTimestamp$hadithCount', now);

    print('Last accessed Hadith saved successfully: {hadithNumber: $hadithNumber, hadithFirstBody: $hadithFirstBody, hadithLastBody: $hadithLastBody, grade: $grade, bookNumber: $bookNumber, bookFirstName: $bookFirstName, bookLastName: $bookLastName, collectionName: $collectionName}');
  }
}
