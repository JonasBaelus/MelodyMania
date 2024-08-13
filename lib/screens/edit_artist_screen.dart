// lib/screens/edit_artist_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zomerfestival/models/artist.dart';
import 'package:zomerfestival/providers/artist_provider.dart';

class EditArtistScreen extends StatefulWidget {
  final Artist artist;

  EditArtistScreen({required this.artist});

  @override
  _EditArtistScreenState createState() => _EditArtistScreenState();
}

class _EditArtistScreenState extends State<EditArtistScreen> {
  late TextEditingController _nameController;
  late TextEditingController _genreController;

  @override
  void initState() {
    _nameController = TextEditingController(text: widget.artist.name);
    _genreController = TextEditingController(text: widget.artist.genre);
    super.initState();
  }

  void _saveForm() {
    final name = _nameController.text;
    final genre = _genreController.text;

    if (name.isNotEmpty && genre.isNotEmpty) {
      Provider.of<ArtistProvider>(context, listen: false)
          .updateArtist(widget.artist.id, name, genre, widget.artist.imagePath);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bewerk Artiest'),
        backgroundColor: Colors.deepPurple,
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveForm,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Naam',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _genreController,
                decoration: InputDecoration(
                  labelText: 'Genre',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveForm,
                child: Text('Opslaan'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.deepPurple,
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  textStyle: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
