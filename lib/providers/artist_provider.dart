import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:zomerfestival/models/artist.dart';

// Custom HttpException class
class HttpException implements Exception {
  final String message;
  final int statusCode;

  HttpException(this.message, this.statusCode);

  @override
  String toString() {
    return 'HttpException: $message (Status code: $statusCode)';
  }
}

class ArtistProvider with ChangeNotifier {
  List<Artist> _artists = [];
  bool _isLoading = false;

  List<Artist> get artists => _artists;
  bool get isLoading => _isLoading;

  Future<void> fetchArtists() async {
    _isLoading = true;
    notifyListeners();

    final url = 'http://localhost:3000/artists';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body) as List;
        _artists = data.map((json) => Artist.fromJson(json)).toList();
      } else {
        throw HttpException('Failed to load artists', response.statusCode);
      }
    } catch (error) {
      print('Error fetching artists: $error');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addArtist(String name, String genre) async {
    final url = 'http://localhost:3000/artists';

    try {
      if (name.isEmpty || genre.isEmpty) {
        throw ArgumentError('Name and genre cannot be empty');
      }

      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body) as List;
        final artists = data.map((json) => Artist.fromJson(json)).toList();
        final int maxId = artists.isNotEmpty
            ? artists.map((artist) => artist.id).reduce((a, b) => a > b ? a : b)
            : 0;

        final newArtist = {
          'id': (maxId + 1).toString(),
          'name': name,
          'genre': genre,
          'imagePath': 'assets/images/default-image.png'
        };

        final postResponse = await http.post(
          Uri.parse(url),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(newArtist),
        );

        if (postResponse.statusCode == 201) {
          await fetchArtists();
        } else {
          throw HttpException('Failed to add artist', postResponse.statusCode);
        }
      } else {
        throw HttpException('Failed to load artists', response.statusCode);
      }
    } catch (error) {
      print('Error adding artist: $error');
    }
  }

  Future<void> updateArtist(
      int id, String name, String genre, String imagePath) async {
    final url = 'http://localhost:3000/artists/$id';
    final updatedArtist = {
      'id': id,
      'name': name,
      'genre': genre,
      'imagePath': imagePath,
    };

    try {
      if (name.isEmpty || genre.isEmpty) {
        throw ArgumentError('Name and genre cannot be empty');
      }
      if (!imagePath.endsWith('.png') && !imagePath.endsWith('.jpg')) {
        throw ArgumentError('Invalid image path');
      }

      final response = await http.put(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(updatedArtist),
      );

      if (response.statusCode == 200) {
        await fetchArtists();
      } else {
        throw HttpException('Failed to update artist', response.statusCode);
      }
    } catch (error) {
      print('Error updating artist: $error');
    }
  }

  Future<void> deleteArtist(int id) async {
    final url = 'http://localhost:3000/artists/$id';

    try {
      final response = await http.delete(Uri.parse(url));

      if (response.statusCode == 200) {
        _artists.removeWhere((artist) => artist.id == id);
        notifyListeners();
      } else {
        throw HttpException('Failed to delete artist', response.statusCode);
      }
    } catch (error) {
      print('Error deleting artist: $error');
    }
  }
}
