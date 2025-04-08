import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'dart:ui' as ui;


String formatTime(String timeStr, bool is24HourFormat) {
  try {
    DateTime prayerTime = DateFormat("HH:mm").parse(timeStr);
    return is24HourFormat
        ? DateFormat("HH:mm").format(prayerTime) // 24-hour format
        : DateFormat("h:mm a").format(prayerTime); // 12-hour format
  } catch (e) {
    print('Error formatting time: $e');
    return timeStr; // Fallback to original string
  }
}

String formatDuration(Duration duration) {
  String twoDigits(int n) => n.toString().padLeft(2, '0');
  final minutes = twoDigits(duration.inMinutes.remainder(60));
  final seconds = twoDigits(duration.inSeconds.remainder(60));
  return '$minutes:$seconds';
}

String truncateString(String text, int maxLines, TextStyle style, BuildContext context) {
  final TextPainter textPainter = TextPainter(
    text: TextSpan(text: text, style: style),
    maxLines: 3,
    textDirection: ui.TextDirection.ltr,
  )..layout(maxWidth: MediaQuery.of(context).size.width);

  if (textPainter.didExceedMaxLines) {
    final lastVisibleLineEnd = textPainter.getPositionForOffset(Offset(textPainter.size.width, textPainter.size.height)).offset;
    return text.substring(0, lastVisibleLineEnd) + '...';
  } else {
    return text;
  }
}