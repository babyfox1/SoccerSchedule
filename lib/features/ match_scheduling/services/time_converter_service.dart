import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class TimeConverterService {
  static DateTime toDateTime(TimeOfDay time) {
    return DateTime(2023, 1, 1, time.hour, time.minute);
  }

  static String formatMatchTime(DateTime start, DateTime end) {
    final format = DateFormat('HH:mm');
    return '${format.format(start)} - ${format.format(end)}';
  }

  static String formatTime(DateTime time) {
    return DateFormat('HH:mm').format(time);
  }
}