import 'package:flutter/material.dart';

import 'package:soccer_app/features/%20match_scheduling/models/match_model.dart';
import 'package:soccer_app/features/%20match_scheduling/services/match_scheduler_service.dart';
import 'package:soccer_app/features/%20match_scheduling/services/time_converter_service.dart';
import 'package:soccer_app/features/%20match_scheduling/services/time_validator_service.dart';
import 'package:soccer_app/features/%20match_scheduling/widgets/deviation_list_widget.dart';
import 'package:soccer_app/features/%20match_scheduling/widgets/match_card_widget.dart';
import 'package:soccer_app/features/%20match_scheduling/widgets/time_input_widget.dart';

class DragCardsPage extends StatefulWidget {
  const DragCardsPage({super.key});

  @override
  DragCardsPageState createState() => DragCardsPageState();
}

class DragCardsPageState extends State<DragCardsPage> {
  static const int matchDuration = 70;
  static const TimeOfDay minTimeMatches = TimeOfDay(hour: 13, minute: 0);
  static const TimeOfDay maxTimeMatches = TimeOfDay(hour: 21, minute: 0);

  final TextEditingController startTimeController =
      TextEditingController(text: '13:00');
  String? errorText;
  DateTime startTime = DateTime(2023, 1, 1, 13, 0);

  final List<MatchModel> matches = [
    MatchModel(teamA: 'Team B', teamB: 'Team E'),
    MatchModel(teamA: 'Team C', teamB: 'Team D'),
    MatchModel(teamA: 'Team A', teamB: 'Team B'),
    MatchModel(teamA: 'Team E', teamB: 'Team F'),
    MatchModel(teamA: 'Team A', teamB: 'Team C'),
    MatchModel(teamA: 'Team D', teamB: 'Team F'),
  ];

  final Map<String, List<TimeOfDay>> preferences = {
    'Team A': [TimeOfDay(hour: 14, minute: 0), TimeOfDay(hour: 18, minute: 0)],
    'Team B': [TimeOfDay(hour: 13, minute: 0), TimeOfDay(hour: 16, minute: 0)],
    'Team C': [TimeOfDay(hour: 15, minute: 0), TimeOfDay(hour: 20, minute: 0)],
    'Team D': [TimeOfDay(hour: 14, minute: 0), TimeOfDay(hour: 19, minute: 0)],
    'Team E': [TimeOfDay(hour: 13, minute: 30), TimeOfDay(hour: 17, minute: 30)],
    'Team F': [TimeOfDay(hour: 16, minute: 0), TimeOfDay(hour: 21, minute: 0)],
  };

  late final MatchSchedulerService scheduler;

  @override
  void initState() {
    super.initState();
    scheduler = MatchSchedulerService(
      matches: matches,
      preferences: preferences,
      matchDuration: matchDuration,
    );
    _updateStartTime();
  }

  void _updateStartTime() {
    final input = startTimeController.text;
    final minTime = TimeConverterService.toDateTime(minTimeMatches);
    final maxTime = TimeConverterService.toDateTime(maxTimeMatches).subtract(
      Duration(minutes: matchDuration * (matches.length - 1)),
    );

    setState(() {
      errorText = TimeValidatorService.validate(input, minTime, maxTime);
      if (errorText == null) {
        final parts = input.split(':');
        startTime = DateTime(
          2023, 1, 1, 
          int.parse(parts[0]), 
          int.parse(parts[1]),
        );
      }
    });
  }

  void _onReorder(int oldIndex, int newIndex) async {
    List<MatchModel> newMatches = List.from(matches);
    
    if (newIndex > oldIndex) newIndex -= 1;
    final item = newMatches.removeAt(oldIndex);
    newMatches.insert(newIndex, item);
    
    if (scheduler.hasConsecutiveMatches(newMatches)) {
      final team = scheduler.findConsecutiveTeam(newMatches);
      if (team != null) {
        await _showConsecutiveMatchesDialog(team);
        return;
      }
    }
    
    setState(() {
      matches
        ..clear()
        ..addAll(newMatches);
    });
  }

  Future<void> _showConsecutiveMatchesDialog(String team) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Ошибка расписания'),
          content: Text('Команда "$team" не может играть два матча подряд'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  String _getMatchTime(int index) {
    final start = startTime.add(Duration(minutes: matchDuration * index));
    final end = start.add(Duration(minutes: matchDuration));
    return TimeConverterService.formatMatchTime(start, end);
  }

  @override
  Widget build(BuildContext context) {
    final deviations = scheduler.calculateDeviations(startTime);
    final totalDeviation = scheduler.getTotalDeviation(deviations);
    final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text('Real Madrid'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              physics: isPortrait ? const NeverScrollableScrollPhysics() : null,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: TimeInputWidget(
                        controller: startTimeController,
                        errorText: errorText,
                        onApply: () {
                          FocusScope.of(context).unfocus();
                          _updateStartTime();
                        },
                      ),
                    ),
                    Flexible(
                      fit: FlexFit.loose,
                      child: SizedBox(
                        height: isPortrait ? null : constraints.maxHeight * 0.5,
                        child: ReorderableListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: matches.length,
                          onReorder: _onReorder,
                          itemBuilder: (context, index) {
                            return MatchCardWidget(
                              key: ValueKey(matches[index]),
                              match: matches[index],
                              matchTime: _getMatchTime(index),
                              margin: const EdgeInsets.symmetric(vertical: 4),
                            );
                          },
                        ),
                      ),
                    ),
                    const Divider(height: 1),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: DeviationListWidget(
                        deviations: deviations,
                        totalDeviation: totalDeviation,
                        textStyle: const TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}