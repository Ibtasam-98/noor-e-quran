import 'package:flutter/cupertino.dart';

import '../../config/prayer_enum.dart';
import 'grid_item_model.dart';

final List<GridItem> SalahCategoryenu = [
  GridItem(
    title: "Opligatory",
    subtitle: "Prayers",
    destination: SizedBox(),
  ),
  GridItem(
    title: "Sunnah",
    subtitle: "Nafl Prayers",
    destination: SizedBox(),
  ),
  GridItem(
    title: "Friday",
    subtitle: "Jumma Prayer",
    destination: SizedBox(),
  ),
  GridItem(
    title: "Eid",
    subtitle: "Prayers",
    destination: SizedBox(),
  ),
  GridItem(
    title: "Taraweeh",
    subtitle: "Qiyam-ul-Layl",
    destination: SizedBox(),
  ),
  GridItem(
    title: "Funeral",
    subtitle: "Prayer",
    destination: SizedBox(),
  ),
  GridItem(
    title: "Salatul",
    subtitle: "Istikhara",
    destination: SizedBox(),
  ),
  GridItem(
    title: "Salatul",
    subtitle: "Hajat",
    destination: SizedBox(),
  ),
  GridItem(
    title: "Prayer",
    subtitle: "Tracker",
    destination: SizedBox(),
  ),
  GridItem(
    title: "Prayer",
    subtitle: "Guide",
    destination: SizedBox(),
  ),
];



class PrayerCategory {
  final String title;
  final String subtitle;
  final PrayerType type;

  PrayerCategory({
    required this.title,
    required this.subtitle,
    required this.type,
  });
}
