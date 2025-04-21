import 'package:flutter/material.dart';

class TeamPreferenceModel {
  final String teamName;
  final List<TimeOfDay> preferredTimes;

  TeamPreferenceModel({required this.teamName, required this.preferredTimes});
}