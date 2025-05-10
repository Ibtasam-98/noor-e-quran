import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'dart:io';

class DigitalQuranScreenController extends GetxController with WidgetsBindingObserver {
  final GetStorage box = GetStorage();
  final RxString pdfPath = RxString('');
  final RxBool isLoading = true.obs;
  final RxInt totalPages = 0.obs;
  final RxInt currentPage = 0.obs;
  final RxBool hasShownSnackbar = false.obs;

  DateTime? lastPageChangeTime;
  int lastPage = 0;
  Timer? pageChangeTimer;
  bool _isDisposed = false;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    loadPdf();
    _loadLastPage();
  }

  @override
  void onClose() {
    _isDisposed = true;
    WidgetsBinding.instance.removeObserver(this);
    pageChangeTimer?.cancel();
    _saveCurrentPage();
    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive ||
        state == AppLifecycleState.detached) {
      _saveCurrentPage();
    }
  }

  Future<void> _loadLastPage() async {
    final lastPage = box.read<int>('lastQuranPage');
    if (lastPage != null && lastPage > 0) {
      await Future.delayed(Duration(milliseconds: 500));
      if (!_isDisposed) {
        currentPage.value = lastPage;
      }
    }
  }

  Future<void> _saveCurrentPage() async {
    if (!_isDisposed) {
      await box.write('lastQuranPage', currentPage.value);
    }
  }

  Future<void> loadPdf() async {
    try {
      final cachedPdfPath = box.read('quranPdfPath');

      if (cachedPdfPath != null && File(cachedPdfPath).existsSync()) {
        pdfPath.value = cachedPdfPath;
        isLoading.value = false;
        return;
      }

      final url = 'https://drive.google.com/uc?export=download&id=1EQKXq4uOfyPyw5U6FFOFN-mfDJLHwK7n';
      final response = await http.get(Uri.parse(url));
      final bytes = response.bodyBytes;

      final directory = await getApplicationDocumentsDirectory();
      final file = File(path.join(directory.path, 'quran.pdf'));
      await file.writeAsBytes(bytes);

      box.write('quranPdfPath', file.path);
      pdfPath.value = file.path;
      isLoading.value = false;
    } catch (e) {
      print('Error loading PDF: $e');
      isLoading.value = false;
      Get.snackbar(
        'Error',
        'Failed to load PDF',
        backgroundColor: Colors.red,
        icon: Icon(Icons.error, color: Colors.white),
      );
    }
  }

  void handlePageChange(int page) {
    final now = DateTime.now();
    final pageDiff = (page - lastPage).abs();

    pageChangeTimer?.cancel();
    currentPage.value = page;
    _saveCurrentPage();

    if (lastPageChangeTime != null &&
        now.difference(lastPageChangeTime!).inMilliseconds < 500 &&
        pageDiff >= 5) {
      if (!hasShownSnackbar.value) {
        hasShownSnackbar.value = true;
        Get.snackbar(
          'Gentle Reading',
          'Please read with respect and devotion',
          backgroundColor: Colors.blue,
          icon: Icon(Icons.info, color: Colors.white),
        );

        Future.delayed(Duration(seconds: 10), () => hasShownSnackbar.value = false);
      }
    }

    lastPageChangeTime = now;
    lastPage = page;
  }
}