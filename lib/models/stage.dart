// lib/models/stage.dart
class Stage {
  final int id;
  final String name;

  Stage({required this.id, required this.name});

  factory Stage.fromJson(Map<String, dynamic> json) {
    return Stage(
      id: json['id'] is int ? json['id'] : int.parse(json['id']),
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
