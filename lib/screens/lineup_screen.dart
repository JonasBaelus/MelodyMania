import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zomerfestival/models/lineup.dart';
import 'package:zomerfestival/providers/lineup_provider.dart';
import 'package:zomerfestival/screens/edit_lineup_screen.dart';
import 'package:zomerfestival/screens/add_lineup_screen.dart';
import 'package:intl/intl.dart'; // Import the intl package for formatting

class LineupScreen extends StatefulWidget {
  @override
  _LineupScreenState createState() => _LineupScreenState();
}

class _LineupScreenState extends State<LineupScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<LineupProvider>(context, listen: false).fetchLineup();
    Provider.of<LineupProvider>(context, listen: false).fetchArtistsAndStages();
  }

  String formatDateTime(DateTime dateTime) {
    // Format the DateTime object
    final DateFormat formatter = DateFormat('HH:mm dd-MM-yyyy');
    return formatter.format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Line-up'),
        backgroundColor: Colors.deepPurple,
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) => AddLineupScreen(),
                ),
              );
            },
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
                'Geen line-up gevonden.',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey,
                ),
              ),
            );
          } else {
            // Create a list of Lineups sorted by stage name and time
            final sortedLineup = lineupProvider.lineup.toList()
              ..sort((a, b) {
                final stageA = lineupProvider.stages
                    .firstWhere((stage) => stage.id == a.stageId)
                    .name;
                final stageB = lineupProvider.stages
                    .firstWhere((stage) => stage.id == b.stageId)
                    .name;

                // Compare stage names
                int stageComparison = stageA.compareTo(stageB);

                // If stage names are the same, sort by time
                if (stageComparison == 0) {
                  return a.time.compareTo(b.time);
                } else {
                  return stageComparison;
                }
              });

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          columnSpacing: 16,
                          columns: [
                            DataColumn(
                              label: Text(
                                'Artiest',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Stage',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Tijd',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Text(''),
                            ),
                          ],
                          rows: sortedLineup.map(
                            (lineup) {
                              final artist = lineupProvider.artists.firstWhere(
                                  (artist) => artist.id == lineup.artistId);
                              final stage = lineupProvider.stages.firstWhere(
                                  (stage) => stage.id == lineup.stageId);

                              return DataRow(
                                cells: [
                                  DataCell(Text(artist.name)),
                                  DataCell(Text(stage.name)),
                                  DataCell(Text(formatDateTime(lineup.time))),
                                  DataCell(
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        IconButton(
                                          icon: Icon(Icons.edit,
                                              color: Colors.deepPurple),
                                          onPressed: () {
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (ctx) =>
                                                    EditLineupScreen(
                                                        lineup: lineup),
                                              ),
                                            );
                                          },
                                        ),
                                        IconButton(
                                          icon: Icon(Icons.delete,
                                              color: Colors.red),
                                          onPressed: () {
                                            showDialog(
                                              context: context,
                                              builder: (ctx) => AlertDialog(
                                                title: Text(
                                                    'Bevestig Verwijdering'),
                                                content: Text(
                                                    'Weet je zeker dat je deze line-up wilt verwijderen?'),
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
                                                      Provider.of<LineupProvider>(
                                                              context,
                                                              listen: false)
                                                          .deleteLineup(
                                                              lineup.id);
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
                                ],
                              );
                            },
                          ).toList(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
