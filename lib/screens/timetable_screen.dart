import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zomerfestival/providers/lineup_provider.dart';
import 'package:zomerfestival/models/lineup.dart';
import 'package:intl/intl.dart';

class TimetableScreen extends StatefulWidget {
  @override
  _TimetableScreenState createState() => _TimetableScreenState();
}

class _TimetableScreenState extends State<TimetableScreen> {
  String _selectedDate = '2024-08-23'; // Default selected date

  @override
  void initState() {
    super.initState();
    Provider.of<LineupProvider>(context, listen: false).fetchLineup();
    Provider.of<LineupProvider>(context, listen: false).fetchArtistsAndStages();
  }

  String formatTime(DateTime dateTime) {
    // Format the DateTime object to show only time
    final DateFormat formatter = DateFormat('HH:mm');
    return formatter.format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Timetable'),
        backgroundColor: Colors.deepPurple,
        actions: [
          DropdownButtonHideUnderline(
            child: Container(
              margin: EdgeInsets.only(right: 16),
              child: DropdownButton<String>(
                value: _selectedDate,
                dropdownColor: Colors.deepPurple,
                style: TextStyle(color: Colors.white),
                items: [
                  DropdownMenuItem(
                    child: Text('23/08/2024',
                        style: TextStyle(color: Colors.white)),
                    value: '2024-08-23',
                  ),
                  DropdownMenuItem(
                    child: Text('24/08/2024',
                        style: TextStyle(color: Colors.white)),
                    value: '2024-08-24',
                  ),
                  DropdownMenuItem(
                    child: Text('25/08/2024',
                        style: TextStyle(color: Colors.white)),
                    value: '2024-08-25',
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedDate = value!;
                  });
                },
                selectedItemBuilder: (BuildContext context) {
                  return ['2024-08-23', '2024-08-24', '2024-08-25']
                      .map((String value) {
                    return Container(
                      alignment: Alignment.center,
                      child: Text(
                        DateFormat('dd/MM/yyyy').format(DateTime.parse(value)),
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  }).toList();
                },
              ),
            ),
          ),
        ],
      ),
      body: Consumer<LineupProvider>(
        builder: (ctx, lineupProvider, _) {
          if (lineupProvider.isLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (lineupProvider.lineup.isEmpty) {
            return Center(
              child: Text(
                'No lineup found.',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey,
                ),
              ),
            );
          } else {
            // Filter lineup based on selected date
            DateTime selectedDate = DateTime.parse(_selectedDate);
            List<Lineup> filteredLineup = lineupProvider.lineup.where((lineup) {
              return lineup.time.year == selectedDate.year &&
                  lineup.time.month == selectedDate.month &&
                  lineup.time.day == selectedDate.day;
            }).toList();

            // Group lineup by stage
            Map<String, List<Lineup>> lineupByStage = {};
            for (var lineup in filteredLineup) {
              final stageName = lineupProvider.stages
                  .firstWhere((stage) => stage.id == lineup.stageId)
                  .name;
              if (lineupByStage[stageName] == null) {
                lineupByStage[stageName] = [];
              }
              lineupByStage[stageName]!.add(lineup);
            }

            // Sort stages alphabetically
            List<String> sortedStageNames = lineupByStage.keys.toList()
              ..sort((a, b) => a.compareTo(b));

            // Sort each stage's lineups by datetime
            for (var stage in sortedStageNames) {
              lineupByStage[stage]!.sort((a, b) => a.time.compareTo(b.time));
            }

            return ListView.builder(
              itemCount: sortedStageNames.length,
              itemBuilder: (context, index) {
                String stage = sortedStageNames[index];
                List<Lineup> stageLineup = lineupByStage[stage]!;

                return Card(
                  margin: EdgeInsets.all(10),
                  child: ExpansionTile(
                    title: Text(
                      stage,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    children: stageLineup.map((lineup) {
                      final artist = lineupProvider.artists
                          .firstWhere((artist) => artist.id == lineup.artistId);
                      final time = formatTime(lineup.time); // Show only time

                      return ListTile(
                        leading: Image.asset(
                          artist.imagePath,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                        title: Text(artist.name),
                        subtitle: Text(time),
                      );
                    }).toList(),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
