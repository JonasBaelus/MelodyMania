class Artist {
  final int id;
  final String name;
  final String genre;
  final String imagePath;

  Artist({
    required this.id,
    required this.name,
    required this.genre,
    required this.imagePath,
  }) {
    if (name.isEmpty) {
      throw ArgumentError('Name cannot be empty');
    }
    if (genre.isEmpty) {
      throw ArgumentError('Genre cannot be empty');
    }
    if (!imagePath.endsWith('.png') && !imagePath.endsWith('.jpg')) {
      throw ArgumentError('Invalid image path');
    }
  }

  factory Artist.fromJson(Map<String, dynamic> json) {
    try {
      return Artist(
        id: json['id'] is int ? json['id'] : int.parse(json['id']),
        name: json['name'],
        genre: json['genre'],
        imagePath: json['imagePath'],
      );
    } catch (e) {
      throw FormatException('Error parsing JSON: $e');
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'genre': genre,
      'imagePath': imagePath,
    };
  }
}
