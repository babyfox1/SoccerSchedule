import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:soccer_app/features/%20match_scheduling/services/text_input_formatter_service.dart';

class TimeInputWidget extends StatelessWidget {
  final TextEditingController controller;
  final String? errorText;
  final String labelText;
  final VoidCallback onApply;
  final double buttonTextSize;

  const TimeInputWidget({
    super.key,
    required this.controller,
    required this.onApply,
    this.errorText,
    this.labelText = 'Начало соревнований (HH:mm)',
    this.buttonTextSize = 14,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 3,
          child: TextFormField(
            controller: controller,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(4),
              TextInputFormatterService(),
            ],
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: labelText,
              errorText: errorText,
              border: const OutlineInputBorder(),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          flex: 1,
          child: SizedBox(
            height: 48,
            child: ElevatedButton(
              onPressed: onApply,
              child: Text(
                'Ок',
                style: TextStyle(fontSize: buttonTextSize),
              ),
            ),
          ),
        ),
      ],
    );
  }
}