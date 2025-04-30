import 'package:flutter/material.dart';


class GridItem {
  final String title;
  final String subtitle;
  final Widget destination;

  GridItem({
    required this.title,
    required this.subtitle,
    required this.destination, // Optional now
  });
}