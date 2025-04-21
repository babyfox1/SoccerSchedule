import 'package:flutter/material.dart';
import 'package:soccer_app/features/%20match_scheduling/services/time_converter_service.dart';

import '../models/match_model.dart';

class MatchSchedulerService {
  final List<MatchModel> matches;
  final Map<String, List<TimeOfDay>> preferences;
  final int matchDuration;

  MatchSchedulerService({
    required this.matches,
    required this.preferences,
    this.matchDuration = 70,
  });

bool hasConsecutiveMatches(List<MatchModel> matchesList) {
  for (int i = 0; i < matchesList.length - 1; i++) {
    final current = matchesList[i];
    final next = matchesList[i + 1];

    if (current.teamA == next.teamA ||
        current.teamA == next.teamB ||
        current.teamB == next.teamA ||
        current.teamB == next.teamB) {
      return true;
    }
  }
  return false;
}


  String? findConsecutiveTeam(List<MatchModel> matchesList) {
    for (int i = 0; i < matchesList.length - 1; i++) {
      final current = matchesList[i];
      final next = matchesList[i + 1];
      
      if (current.teamA == next.teamA) return current.teamA;
      if (current.teamA == next.teamB) return current.teamA;
      if (current.teamB == next.teamA) return current.teamB;
      if (current.teamB == next.teamB) return current.teamB;
    }
    return null;
  }

  Map<String, int> calculateDeviations(DateTime startTime) {
    final deviations = <String, int>{};

    for (int i = 0; i < matches.length; i++) {
      final matchStart = startTime.add(Duration(minutes: matchDuration * i));
      final matchEnd = matchStart.add(Duration(minutes: matchDuration));
      final match = matches[i];

      for (final team in [match.teamA, match.teamB]) {
        final pref = preferences[team];
        if (pref == null) continue;

        deviations[team] = (deviations[team] ?? 0) + 
          _calculateDeviation(matchStart, matchEnd, pref);
      }
    }

    return deviations;
  }

  int _calculateDeviation(DateTime start, DateTime end, List<TimeOfDay> pref) {
    final prefStart = TimeConverterService.toDateTime(pref[0]);
    final prefEnd = TimeConverterService.toDateTime(pref[1]);

    int deviation = 0;

    if (start.isBefore(prefStart)) {
      deviation += prefStart.difference(start).inMinutes;
    }
    if (end.isAfter(prefEnd)) {
      deviation += end.difference(prefEnd).inMinutes;
    }

    return deviation;
  }

  int getTotalDeviation(Map<String, int> deviations) {
    return deviations.values.fold(0, (sum, deviation) => sum + deviation);
  }
}