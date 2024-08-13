import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:zomerfestival/models/stage.dart';

class HttpException implements Exception {
  final String message;
  final int statusCode;

  HttpException(this.message, this.statusCode);

  @override
  String toString() {
    return 'HttpException: $message (Status code: $statusCode)';
  }
}

class StageProvider with ChangeNotifier {
  List<Stage> _stages = [];
  bool _isLoading = false;

  List<Stage> get stages => _stages;
  bool get isLoading => _isLoading;

  Future<void> fetchStages() async {
    _isLoading = true;
    notifyListeners();

    final url = 'http://localhost:3000/stages';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body) as List;
        _stages = data.map((json) => Stage.fromJson(json)).toList();
      } else {
        throw HttpException('Failed to load stages', response.statusCode);
      }
    } catch (error) {
      print('Error fetching stages: $error');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addStage(String name) async {
    if (name.isEmpty) {
      throw ArgumentError('Stage name cannot be empty');
    }

    final url = 'http://localhost:3000/stages';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body) as List;
        final stages = data.map((json) => Stage.fromJson(json)).toList();
        final int maxId = stages.isNotEmpty
            ? stages.map((stage) => stage.id).reduce((a, b) => a > b ? a : b)
            : 0;

        final newStage = {
          'id': (maxId + 1).toString(),
          'name': name,
        };

        final postResponse = await http.post(
          Uri.parse(url),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(newStage),
        );

        if (postResponse.statusCode == 201) {
          await fetchStages();
        } else {
          throw HttpException('Failed to add stage', postResponse.statusCode);
        }
      } else {
        throw HttpException('Failed to load stages', response.statusCode);
      }
    } catch (error) {
      print('Error adding stage: $error');
    }
  }

  Future<void> updateStage(int id, String name) async {
    if (name.isEmpty) {
      throw ArgumentError('Stage name cannot be empty');
    }

    final url = 'http://localhost:3000/stages/$id';
    final updatedStage = {
      'id': id,
      'name': name,
    };

    try {
      final response = await http.put(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(updatedStage),
      );

      if (response.statusCode == 200) {
        await fetchStages();
      } else {
        throw HttpException('Failed to update stage', response.statusCode);
      }
    } catch (error) {
      print('Error updating stage: $error');
    }
  }

  Future<void> deleteStage(int id) async {
    final url = 'http://localhost:3000/stages/$id';

    try {
      final response = await http.delete(Uri.parse(url));

      if (response.statusCode == 200) {
        _stages.removeWhere((stage) => stage.id == id);
        notifyListeners();
      } else {
        throw HttpException('Failed to delete stage', response.statusCode);
      }
    } catch (error) {
      print('Error deleting stage: $error');
    }
  }
}
