import 'dart:io';
import 'dart:typed_data';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_editor_plus/image_editor_plus.dart';
import 'package:image_picker/image_picker.dart';
import 'package:line_icons/line_icons.dart';
import 'package:noor_e_quran/app/config/app_colors.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../config/app_sizedbox.dart';
import '../../controllers/app_theme_switch_controller.dart';
import '../../widgets/custom_text.dart';

class IslamicDesignStudio extends StatefulWidget {
  const IslamicDesignStudio({super.key});

  @override
  createState() => _IslamicDesignStudioState();
}

class _IslamicDesignStudioState extends State<IslamicDesignStudio>
    with SingleTickerProviderStateMixin {
  List<Uint8List?> preloadedImages = [];
  RxList<Uint8List> editedImages = <Uint8List>[].obs;
  late TabController _tabController;
  final GetStorage _storage = GetStorage();
  static const String _editedImagesKey = 'edited_images';
  final double _consistentImageSize = 150.w; // Define consistent image size
  final double _definedEditedImageHeight = 120.h;
  final double _definedEditedImageWidth = 120.w;
  RxBool _isImagesLoading = true.obs;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    loadAssets([
      "img1.jpeg", "img2.jpg", "img3.jpeg", "img4.jpg", "img5.jpg",
      "img6.jpg", "img7.jpg", "img8.jpg", "img9.webp", "img10.jpg",
      "img11.jpg", "img12.jpg", "img13.jpeg", "img14.jpg", "img15.jpg",
      "img16.jpg", "img17.jpg", "img18.jpg", "img19.jpg", "img20.jpg",
    ]);
    _loadEditedImages();
  }

  Future<void> loadAssets(List<String> names) async {
    // Simulate loading delay
    await Future.delayed(const Duration(milliseconds: 500));
    for (final name in names) {
      try {
        var data = await rootBundle.load('assets/editor/$name');
        preloadedImages.add(data.buffer.asUint8List());
      } catch (e) {
        print("Error loading asset '$name': $e");
      }
    }
    _isImagesLoading.value = false;
  }

  Future<void> _loadEditedImages() async {
    final List<dynamic>? storedImagesDynamic = _storage.read<List<dynamic>>(_editedImagesKey);
    if (storedImagesDynamic != null) {
      final List<String> storedImages = storedImagesDynamic.cast<String>().toList();
      editedImages.value = storedImages.map((base64String) => base64Decode(base64String)).toList();
    }
  }

  Future<void> _saveEditedImages() async {
    final List<String> base64Images = editedImages.map((image) => base64Encode(image)).toList();
    await _storage.write(_editedImagesKey, base64Images);
  }

  Future<void> _openImageEditor(Uint8List? imageBytes) async {
    if (imageBytes != null) {
      final Uint8List? editedImage = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ImageEditor(
            image: imageBytes,
          ),
        ),
      );

      if (editedImage != null) {
        editedImages.add(editedImage);
        await _saveEditedImages();
        _tabController.animateTo(1); // Switch to the Edited tab
        print("Edited image received (${editedImage.length} bytes)");
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select an image first.")),
      );
    }
  }

  Future<void> _pickImageFromGallery() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      _openImageEditor(bytes);
    }
  }

  Future<void> _navigateToPreview(int index, Uint8List imageBytes) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ImagePreviewScreen(
          imageBytes: imageBytes,
          onDelete: () => _deleteEditedImage(index),
        ),
      ),
    );
  }

  Future<void> _deleteEditedImage(int index) async {
    editedImages.removeAt(index);
    await _saveEditedImages();
    Get.back(); // Pop the preview screen
  }

  final AppThemeSwitchController themeController = Get.find<AppThemeSwitchController>();

  Widget _buildImageGrid(List<Uint8List?> images) {
    bool isDarkMode = themeController.isDarkMode.value;
    return GridView.builder(
      shrinkWrap: true,
      physics: const AlwaysScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
        childAspectRatio: 1.0,
      ),
      itemCount: images.length,
      itemBuilder: (context, index) {
        final imageBytes = images[index];
        return InkWell(
          onTap: () => _openImageEditor(imageBytes),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10.r),
            child: Container(
              decoration: BoxDecoration(
                color: isDarkMode ? AppColors.grey : AppColors.grey.shade200,
              ),
              child: SizedBox(
                width: _consistentImageSize,
                height: _consistentImageSize,
                child: imageBytes != null
                    ? Image.memory(
                  imageBytes,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                )
                    : const Center(child: CircularProgressIndicator()),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildImageGridShimmer() {
    bool isDarkMode = themeController.isDarkMode.value;
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
        childAspectRatio: 1.0,
      ),
      itemCount: 20, // Same as the initial number of preloaded images
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: themeController.isDarkMode.value
              ? AppColors.black.withOpacity(0.2)
              : AppColors.black.withOpacity(0.2),
          highlightColor: themeController.isDarkMode.value
              ? AppColors.grey.withOpacity(0.1)
              : AppColors.grey.withOpacity(0.2),
          child: Container(
            margin: EdgeInsets.all(4.0),
            decoration: BoxDecoration(
              color: AppColors.grey,
              borderRadius: BorderRadius.circular(10.r),
            ),
            width: _consistentImageSize,
            height: _consistentImageSize,
          ),
        );
      },
    );
  }

  Widget _buildEditedImageGrid() {
    bool isDarkMode = themeController.isDarkMode.value;
    return Padding(
      padding: EdgeInsets.only(left: 10.w, right: 10.w),
      child: Obx(() => GridView.builder(
        shrinkWrap: true,
        physics: const AlwaysScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
          childAspectRatio: 1.0,
        ),
        itemCount: editedImages.length,
        itemBuilder: (context, index) {
          final editedImage = editedImages[index];
          return InkWell(
            onTap: () => _navigateToPreview(index, editedImage),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10.r),
              child: Container(
                color: AppColors.grey.withOpacity(0.2),
                width: _definedEditedImageWidth,
                height: _definedEditedImageHeight,
                child: Center(
                  child: Image.memory(
                    editedImage,
                    fit: BoxFit.contain,
                    width: double.infinity,
                    // height: double.infinity,
                  ),
                ),
              ),
            ),
          );
        },
      )),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = themeController.isDarkMode.value;

    return Scaffold(
      backgroundColor: isDarkMode ? AppColors.black : AppColors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: isDarkMode ? AppColors.black : AppColors.white,
        surfaceTintColor: AppColors.transparent,
        foregroundColor: AppColors.transparent,
        title: CustomText(
          firstText: "Design",
          secondText: " Studio",
          fontSize: 18.sp,
          firstTextColor: isDarkMode ? AppColors.white : AppColors.black,
          secondTextColor: AppColors.primary,
        ),
        centerTitle: false,
        leading: InkWell(
          onTap: () {
            Get.back();
          },
          child: Icon(
            Icons.west,
            color: themeController.isDarkMode.value ? AppColors.white : AppColors.black,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(left: 10.w, right: 10.w),
        child: Column(
          children: [
            TabBar(
              controller: _tabController,
              dividerColor: Colors.transparent,
              indicatorSize: TabBarIndicatorSize.tab,
              indicatorColor: AppColors.primary,
              labelColor: isDarkMode ? AppColors.white : AppColors.black,
              unselectedLabelColor: isDarkMode ? AppColors.white : AppColors.black,
              labelStyle: GoogleFonts.quicksand(fontSize: 14.sp),
              indicator: BoxDecoration(
                border: Border.all(color: AppColors.primary, width: 1),
                borderRadius: BorderRadius.circular(50.r),
              ),
              tabs: [
                Tab(
                  child: CustomText(
                    title: "Images",
                    fontSize: 16.sp,
                    textColor: isDarkMode ? AppColors.white : AppColors.black,
                  ),
                ),
                Tab(
                  child: CustomText(
                    title: "Edited",
                    fontSize: 16.sp,
                    textColor: isDarkMode ? AppColors.white : AppColors.black,
                  ),
                ),
              ],
            ),
            AppSizedBox.space10h,
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  Obx(() => _isImagesLoading.value ? _buildImageGridShimmer() : _buildImageGrid(preloadedImages)),
                  _buildEditedImageGrid(),
                ],
              ),
            )
          ],
        ),
      ),
      floatingActionButton: _tabController.index == 0
          ? FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: _pickImageFromGallery,
        child: Icon(LineIcons.plus, color: AppColors.white),
      )
          : null,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}

class ImagePreviewScreen extends StatefulWidget {
  final Uint8List imageBytes;
  final VoidCallback onDelete;

  const ImagePreviewScreen({
    super.key,
    required this.imageBytes,
    required this.onDelete,
  });

  @override
  State<ImagePreviewScreen> createState() => _ImagePreviewScreenState();
}

class _ImagePreviewScreenState extends State<ImagePreviewScreen> {
  TextEditingController headerController =
  TextEditingController(text: "Designed in Noor-e-Quran App");

  Future<void> _shareImageWithHeader() async {
    final imageBytes = widget.imageBytes;
    final headerText = headerController.text.trim();

    try {
      final tempDir = await getTemporaryDirectory();
      final file =
      await File('${tempDir.path}/shared_image.png').writeAsBytes(imageBytes);
      await Share.shareXFiles(
        [XFile(file.path)],
        text: headerText.isNotEmpty ? headerText : null,
      );
    } catch (e) {
      print('Error sharing image: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to share image.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppThemeSwitchController themeController = Get.find<AppThemeSwitchController>();
    bool isDarkMode = themeController.isDarkMode.value;

    return Scaffold(
      backgroundColor: isDarkMode ? AppColors.black : AppColors.white,
      appBar: AppBar(
        backgroundColor: isDarkMode ? AppColors.black : AppColors.white,
        foregroundColor: isDarkMode ? AppColors.white : AppColors.black,
        title: CustomText(
          firstText: "Preview ",
          secondText: "& Share",
          fontSize: 18.sp,
          firstTextColor: isDarkMode ? AppColors.white : AppColors.black,
          secondTextColor: AppColors.primary,
        ),
        centerTitle: false,
        leading: InkWell(
          onTap: () {
            Get.back();
          },
          child: Icon(
            Icons.west,
            color:
            themeController.isDarkMode.value ? AppColors.white : AppColors.black,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.delete, color: AppColors.red),
            onPressed: widget.onDelete,
          ),
          IconButton(
            icon: Icon(Icons.share,
                size: 15.h,
                color: themeController.isDarkMode.value
                    ? AppColors.white
                    : AppColors.black),
            onPressed: _shareImageWithHeader,
          ),
          AppSizedBox.space10w,
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15.r),
              child: Image.memory(widget.imageBytes, fit: BoxFit.fitWidth),
            ),
          ],
        ),
      ),
    );
  }
}