import 'package:soccer_app/features/%20match_scheduling/services/time_converter_service.dart';

class TimeValidatorService {
  static String? validate(String input, DateTime minTime, DateTime maxTime) {
    final parts = input.split(':');

    if (parts.length != 2 ||
        parts[0].length != 2 ||
        parts[1].length != 2 ||
        int.tryParse(parts[0]) == null ||
        int.tryParse(parts[1]) == null) {
      return 'Введите корректное время в формате HH:mm';
    }

    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);

    if (hour < 0 || hour > 23 || minute < 0 || minute > 59) {
      return 'Введите корректное время';
    }

    final parsed = DateTime(2023, 1, 1, hour, minute);

    if (parsed.isBefore(minTime)) {
      return 'Время должно быть не ранее ${TimeConverterService.formatTime(minTime)}';
    }

    if (parsed.isAfter(maxTime)) {
      return 'Время должно быть не позднее ${TimeConverterService.formatTime(maxTime)}';
    }

    return null;
  }
}