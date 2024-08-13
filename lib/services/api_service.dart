// lib/services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:zomerfestival/models/artist.dart';
import 'package:zomerfestival/models/stage.dart';
import 'package:zomerfestival/models/lineup.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:3000';

  Future<List<Artist>> getArtists() async {
    final response = await http.get(Uri.parse('$baseUrl/artists'));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((artist) => Artist.fromJson(artist)).toList();
    } else {
      throw Exception('Failed to load artists');
    }
  }

  Future<List<Stage>> getStages() async {
    final response = await http.get(Uri.parse('$baseUrl/stages'));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((stage) => Stage.fromJson(stage)).toList();
    } else {
      throw Exception('Failed to load stages');
    }
  }

  Future<List<Lineup>> getLineup() async {
    final response = await http.get(Uri.parse('$baseUrl/lineup'));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((lineup) => Lineup.fromJson(lineup)).toList();
    } else {
      throw Exception('Failed to load lineup');
    }
  }
}
