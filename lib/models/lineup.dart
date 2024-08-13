// lib/models/lineup.dart
class Lineup {
  final int id;
  final int artistId;
  final int stageId;
  final DateTime time;

  Lineup(
      {required this.id,
      required this.artistId,
      required this.stageId,
      required this.time});

  factory Lineup.fromJson(Map<String, dynamic> json) {
    return Lineup(
      id: json['id'] is int ? json['id'] : int.parse(json['id']),
      artistId: json['artistId'] is int
          ? json['artistId']
          : int.parse(json['artistId']),
      stageId:
          json['stageId'] is int ? json['stageId'] : int.parse(json['stageId']),
      time: DateTime.parse(json['time']), // Convert string to DateTime
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id.toString(),
      'artistId': artistId,
      'stageId': stageId,
      'time': time.toIso8601String(), // Convert DateTime to string
    };
  }
}
