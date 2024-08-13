import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zomerfestival/providers/stage_provider.dart';
import 'package:zomerfestival/screens/edit_stage_screen.dart';

class StageScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stages'),
        backgroundColor: Colors.deepPurple,
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) => EditStageScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future:
            Provider.of<StageProvider>(context, listen: false).fetchStages(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error loading stages: ${snapshot.error}',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey,
                ),
              ),
            );
          } else {
            return Consumer<StageProvider>(
              builder: (ctx, stageProvider, _) {
                if (stageProvider.stages.isEmpty) {
                  return Center(
                    child: Text(
                      'Geen stages gevonden.',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey,
                      ),
                    ),
                  );
                } else {
                  return ListView.builder(
                    padding: EdgeInsets.all(16.0),
                    itemCount: stageProvider.stages.length,
                    itemBuilder: (ctx, i) {
                      final stage = stageProvider.stages[i];
                      return Card(
                        margin: EdgeInsets.symmetric(vertical: 8.0),
                        child: ListTile(
                          title: Text(
                            stage.name,
                            style: TextStyle(fontSize: 18),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon:
                                    Icon(Icons.edit, color: Colors.deepPurple),
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (ctx) =>
                                          EditStageScreen(stage: stage),
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
                                          'Weet je zeker dat je deze stage wilt verwijderen?'),
                                      actions: [
                                        TextButton(
                                          child: Text('Nee'),
                                          onPressed: () {
                                            Navigator.of(ctx).pop();
                                          },
                                        ),
                                        TextButton(
                                          child: Text('Ja'),
                                          onPressed: () async {
                                            Navigator.of(ctx).pop();
                                            try {
                                              await stageProvider
                                                  .deleteStage(stage.id);
                                            } catch (error) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                      'Error deleting stage: $error'),
                                                  backgroundColor:
                                                      Theme.of(context)
                                                          .errorColor,
                                                ),
                                              );
                                            }
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
                  );
                }
              },
            );
          }
        },
      ),
    );
  }
}
