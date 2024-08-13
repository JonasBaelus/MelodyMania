// lib/screens/artist_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zomerfestival/providers/artist_provider.dart';
import 'package:zomerfestival/screens/add_artist_screen.dart';
import 'package:zomerfestival/screens/edit_artist_screen.dart';

class ArtistScreen extends StatefulWidget {
  @override
  _ArtistScreenState createState() => _ArtistScreenState();
}

class _ArtistScreenState extends State<ArtistScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<ArtistProvider>(context, listen: false).fetchArtists();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Artiesten'),
        backgroundColor: Colors.deepPurple, // Change app bar color
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => AddArtistScreen()),
              );
            },
          ),
        ],
      ),
      body: Consumer<ArtistProvider>(
        builder: (ctx, artistProvider, _) {
          if (artistProvider.isLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (artistProvider.artists.isEmpty) {
            return Center(
              child: Text(
                'Geen artiesten gevonden.',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey,
                ),
              ),
            );
          } else {
            // Sort the artists alphabetically by name
            artistProvider.artists.sort((a, b) => a.name.compareTo(b.name));

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView.builder(
                itemCount: artistProvider.artists.length,
                itemBuilder: (ctx, i) {
                  final artist = artistProvider.artists[i];
                  return Card(
                    elevation: 5,
                    margin: EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: AssetImage(artist
                            .imagePath), // Use AssetImage for local images
                        radius: 30,
                      ),
                      title: Text(
                        artist.name,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        artist.genre,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit, color: Colors.deepPurple),
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      EditArtistScreen(artist: artist),
                                ),
                              );
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  title: Text('Bevestig Verwijdering'),
                                  content: Text(
                                      'Weet je zeker dat je deze artiest wilt verwijderen?'),
                                  actions: [
                                    TextButton(
                                      child: Text('Nee'),
                                      onPressed: () {
                                        Navigator.of(ctx).pop();
                                      },
                                    ),
                                    TextButton(
                                      child: Text('Ja'),
                                      onPressed: () {
                                        Provider.of<ArtistProvider>(context,
                                                listen: false)
                                            .deleteArtist(artist.id);
                                        Navigator.of(ctx).pop();
                                      },
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }
}
