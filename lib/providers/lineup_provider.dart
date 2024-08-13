import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:zomerfestival/models/artist.dart';
import 'package:zomerfestival/models/lineup.dart';
import 'package:zomerfestival/models/stage.dart';

class LineupProvider with ChangeNotifier {
  List<Lineup> _lineup = [];
  List<Artist> _artists = [];
  List<Stage> _stages = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Lineup> get lineup => _lineup;
  List<Artist> get artists => _artists;
  List<Stage> get stages => _stages;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchLineup() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      final response =
          await http.get(Uri.parse('http://localhost:3000/lineup'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body) as List;
        _lineup = data.map((item) => Lineup.fromJson(item)).toList();
      } else {
        _errorMessage = 'Failed to load lineup';
      }
    } catch (error) {
      _errorMessage = 'An error occurred: $error';
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchArtistsAndStages() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      final artistsResponse =
          await http.get(Uri.parse('http://localhost:3000/artists'));
      final stagesResponse =
          await http.get(Uri.parse('http://localhost:3000/stages'));
      if (artistsResponse.statusCode == 200 &&
          stagesResponse.statusCode == 200) {
        final artistsData = json.decode(artistsResponse.body) as List;
        final stagesData = json.decode(stagesResponse.body) as List;
        _artists = artistsData.map((item) => Artist.fromJson(item)).toList();
        _stages = stagesData.map((item) => Stage.fromJson(item)).toList();
      } else {
        _errorMessage = 'Failed to load artists or stages';
      }
    } catch (error) {
      _errorMessage = 'An error occurred: $error';
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> addLineup(int artistId, int stageId, DateTime time) async {
    final id = _lineup.isNotEmpty
        ? _lineup
                .map((lineup) => lineup.id)
                .reduce((value, element) => value > element ? value : element) +
            1
        : 1;
    final newLineup =
        Lineup(id: id, artistId: artistId, stageId: stageId, time: time);
    try {
      final response = await http.post(
        Uri.parse('http://localhost:3000/lineup'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(newLineup.toJson()),
      );
      if (response.statusCode == 201) {
        _lineup.add(Lineup.fromJson(json.decode(response.body)));
      } else {
        throw 'Failed to add lineup';
      }
    } catch (error) {
      _errorMessage = 'An error occurred: $error';
    }
    notifyListeners();
  }

  Future<void> updateLineup(
      int id, int artistId, int stageId, DateTime time) async {
    final lineupIndex = _lineup.indexWhere((lineup) => lineup.id == id);
    if (lineupIndex >= 0) {
      final updatedLineup =
          Lineup(id: id, artistId: artistId, stageId: stageId, time: time);
      try {
        final response = await http.put(
          Uri.parse('http://localhost:3000/lineup/$id'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(updatedLineup.toJson()),
        );
        if (response.statusCode == 200) {
          _lineup[lineupIndex] = updatedLineup;
        } else {
          throw 'Failed to update lineup';
        }
      } catch (error) {
        _errorMessage = 'An error occurred: $error';
      }
      notifyListeners();
    }
  }

  Future<void> deleteLineup(int id) async {
    try {
      final response =
          await http.delete(Uri.parse('http://localhost:3000/lineup/$id'));
      if (response.statusCode == 200) {
        _lineup.removeWhere((lineup) => lineup.id == id);
      } else {
        throw 'Failed to delete lineup';
      }
    } catch (error) {
      _errorMessage = 'An error occurred: $error';
    }
    notifyListeners();
  }
}
