// hadith_collection_detail_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hadith/classes.dart';
import 'package:hadith/hadith.dart';
import 'app_theme_switch_controller.dart';

class HadithCollectionDetailController extends GetxController {
  final Collections collection;
  HadithCollectionDetailController(this.collection);

  TextEditingController searchController = TextEditingController();
  final AppThemeSwitchController themeController = Get.find();
  var isSearchVisible = false.obs;
  var books = <Book>[].obs;
  var filteredBooks = <Book>[].obs;
  ScrollController scrollController = ScrollController();
  var scrollProgress = 0.0.obs;
  var isScrolling = false.obs;

  @override
  void onInit() {
    super.onInit();
    books.assignAll(getBooks(collection));
    filteredBooks.assignAll(books.where((book) => book.bookNumber.isNotEmpty));
    scrollController.addListener(_updateScrollProgress);
  }

  @override
  void onClose() {
    scrollController.removeListener(_updateScrollProgress);
    scrollController.dispose();
    searchController.dispose();
    super.onClose();
  }

  void _updateScrollProgress() {
    if (scrollController.hasClients) {
      scrollProgress.value = scrollController.position.pixels /
          scrollController.position.maxScrollExtent;
      isScrolling.value = scrollController.position.pixels > 0;
    }
  }

  void toggleSearchVisibility() {
    isSearchVisible.value = !isSearchVisible.value;
    if (!isSearchVisible.value) {
      searchController.clear();
      filteredBooks.assignAll(books.where((book) => book.bookNumber.isNotEmpty));
    }
  }

  void filterBooks(String query) {
    final keywords = query.toLowerCase().split(' ');
    filteredBooks.assignAll(
      books.where((book) {
        final bookName = book.book.first.name.toLowerCase();
        return keywords.every((keyword) => bookName.contains(keyword));
      }).toList(),
    );
  }
}
