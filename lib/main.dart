// lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zomerfestival/providers/artist_provider.dart';
import 'package:zomerfestival/providers/stage_provider.dart';
import 'package:zomerfestival/providers/lineup_provider.dart';
import 'package:zomerfestival/screens/home_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => ArtistProvider()),
        ChangeNotifierProvider(create: (ctx) => StageProvider()),
        ChangeNotifierProvider(create: (ctx) => LineupProvider()),
      ],
      child: MaterialApp(
        title: 'Melody Mania',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch(
            primarySwatch: Colors.blue,
          ).copyWith(
            secondary: Colors.orange,
          ),
          textTheme: TextTheme(
            headline1: TextStyle(
                fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
            bodyText1: TextStyle(fontSize: 18, color: Colors.black87),
            bodyText2: TextStyle(fontSize: 16, color: Colors.black54),
          ),
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.blueAccent,
            titleTextStyle: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              primary: Colors.orange,
              onPrimary: Colors.white,
              textStyle: TextStyle(fontSize: 18),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            ),
          ),
        ),
        home: HomeScreen(),
      ),
    );
  }
}
