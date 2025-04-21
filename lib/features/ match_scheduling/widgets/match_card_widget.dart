import 'package:flutter/material.dart';
import 'package:soccer_app/features/%20match_scheduling/models/match_model.dart';

class MatchCardWidget extends StatelessWidget {
  final MatchModel match;
  final String matchTime;
  final EdgeInsetsGeometry? margin;

  const MatchCardWidget({
    super.key,
    required this.match,
    required this.matchTime,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .1),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: ListTile(
        dense: true,
        title: Text(
          match.title,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onPrimaryContainer,
          ),
        ),
        subtitle: Text(
          matchTime,
          style: TextStyle(
            color: Theme.of(context)
                .colorScheme
                .onPrimaryContainer
                .withValues(alpha: .7),
          ),
        ),
        trailing: const Icon(Icons.drag_handle, size: 20),
      ),
    );
  }
}