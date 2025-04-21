import 'package:flutter/material.dart';

class DeviationListWidget extends StatelessWidget {
  final Map<String, int> deviations;
  final int totalDeviation;
  final TextStyle textStyle;

  const DeviationListWidget({
    super.key,
    required this.deviations,
    required this.totalDeviation,
    required this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    final sorted = deviations.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...sorted.map((entry) {
          final deviation = entry.value;
          final color = _getDeviationColor(deviation);

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    entry.key,
                    style: textStyle.copyWith(color: color),
                  ),
                ),
                Text(
                  '$deviation мин',
                  style: textStyle.copyWith(color: color),
                ),
              ],
            ),
          );
        }),
        const SizedBox(height: 6),
        Text(
          'Общее отклонение: $totalDeviation мин',
          style: textStyle.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Color _getDeviationColor(int deviation) {
    if (deviation > 30) return Colors.red;
    if (deviation > 0) return Colors.orange;
    return Colors.green;
  }
}