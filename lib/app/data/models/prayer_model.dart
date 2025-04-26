import '../../config/prayer_enum.dart';

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
