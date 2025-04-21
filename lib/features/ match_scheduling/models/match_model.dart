class MatchModel {
  final String teamA;
  final String teamB;

  MatchModel({required this.teamA, required this.teamB});

  String get title => '$teamA vs $teamB';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MatchModel &&
          runtimeType == other.runtimeType &&
          teamA == other.teamA &&
          teamB == other.teamB;

  @override
  int get hashCode => teamA.hashCode ^ teamB.hashCode;
}