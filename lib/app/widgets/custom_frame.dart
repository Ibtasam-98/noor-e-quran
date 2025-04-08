

import 'package:flutter/material.dart';

class CustomFrame extends StatelessWidget {
  final String leftImageAsset;
  final String rightImageAsset;
  final double imageHeight;
  final double imageWidth;

  // Constructor to pass the required parameters
  const CustomFrame({super.key,
    required this.leftImageAsset,
    required this.rightImageAsset,
    required this.imageHeight,
    required this.imageWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Image(
          image: AssetImage(leftImageAsset),
          height: imageHeight,
          width: imageWidth,
        ),
        Image(
          image: AssetImage(rightImageAsset),
          height: imageHeight,
          width: imageWidth,
        ),
      ],
    );
  }
}
