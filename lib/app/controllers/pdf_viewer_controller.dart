import 'package:get/get.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:flutter/services.dart';

class PdfViewerController extends GetxController {
  RxString pdfPath = "".obs;
  RxInt currentPage = 0.obs;
  RxInt totalPages = 0.obs;
  RxBool isLoading = true.obs;
  PDFViewController? pdfController;

  Future<void> loadPdf(String assetPath) async {
    isLoading.value = true;
    final ByteData data = await rootBundle.load(assetPath);
    final List<int> bytes = data.buffer.asUint8List();
    final tempDir = await getTemporaryDirectory();
    final file = File("${tempDir.path}/${assetPath.split('/').last}");
    await file.writeAsBytes(bytes, flush: true);
    pdfPath.value = file.path;
    isLoading.value = false;
  }
}