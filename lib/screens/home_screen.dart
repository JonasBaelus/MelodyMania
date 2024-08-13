// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:zomerfestival/screens/artist_screen.dart';
import 'package:zomerfestival/screens/stage_screen.dart';
import 'package:zomerfestival/screens/lineup_screen.dart';
import 'package:zomerfestival/screens/timetable_screen.dart';
import 'package:zomerfestival/screens/map_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: Text('Zomerfestival'),
        backgroundColor: Colors.deepPurple, // Change app bar color
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    'assets/images/festival_bg.jpg'), // Background image
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(vertical: 20.0),
                  child: Text(
                    'Melody Mania 2024',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          blurRadius: 10.0,
                          color: Colors.black,
                          offset: Offset(5.0, 5.0),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                  child: Text(
                    '23-25 Augustus, 2024',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      shadows: [
                        Shadow(
                          blurRadius: 10.0,
                          color: Colors.black,
                          offset: Offset(5.0, 5.0),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 20.0),
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => ArtistScreen()),
                      );
                    },
                    icon: Icon(Icons.music_note),
                    label: Text('Artiesten'),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.deepPurple, // Button color
                      onPrimary: Colors.white, // Text color
                      padding:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      textStyle:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => StageScreen()),
                      );
                    },
                    icon: Icon(
                        Icons.stadium_outlined), // Changed to a suitable icon
                    label: Text('Stages'),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.deepPurple, // Button color
                      onPrimary: Colors.white, // Text color
                      padding:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      textStyle:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => LineupScreen()),
                      );
                    },
                    icon: Icon(Icons.list),
                    label: Text('Line-up'),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.deepPurple, // Button color
                      onPrimary: Colors.white, // Text color
                      padding:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      textStyle:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => TimetableScreen()),
                      );
                    },
                    icon: Icon(Icons.timer_rounded),
                    label: Text('Timetable'),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.deepPurple, // Button color
                      onPrimary: Colors.white, // Text color
                      padding:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      textStyle:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => MapScreen()),
                      );
                    },
                    icon:
                        Icon(Icons.map_outlined), // Changed to a suitable icon
                    label: Text('Map'),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.deepPurple, // Button color
                      onPrimary: Colors.white, // Text color
                      padding:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      textStyle:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
