import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zomerfestival/providers/lineup_provider.dart';

class AddLineupScreen extends StatefulWidget {
  @override
  _AddLineupScreenState createState() => _AddLineupScreenState();
}

class _AddLineupScreenState extends State<AddLineupScreen> {
  int? _selectedArtist;
  int? _selectedStage;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  @override
  void initState() {
    super.initState();
    Provider.of<LineupProvider>(context, listen: false).fetchArtistsAndStages();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  void _submit() async {
    if (_selectedArtist == null ||
        _selectedStage == null ||
        _selectedDate == null ||
        _selectedTime == null) {
      // Show error if any field is null
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Vul alle velden in')),
      );
      return;
    }

    final selectedDateTime = DateTime(
      _selectedDate!.year,
      _selectedDate!.month,
      _selectedDate!.day,
      _selectedTime!.hour,
      _selectedTime!.minute,
    );

    try {
      await Provider.of<LineupProvider>(context, listen: false)
          .addLineup(_selectedArtist!, _selectedStage!, selectedDateTime);
      Navigator.of(context).pop();
    } catch (error) {
      // Handle errors from addLineup
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Fout bij het toevoegen van de line-up: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nieuwe Line-up'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Consumer<LineupProvider>(
          builder: (ctx, lineupProvider, _) {
            if (lineupProvider.isLoading) {
              return Center(child: CircularProgressIndicator());
            } else {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  DropdownButtonFormField<int>(
                    hint: Text('Selecteer artiest'),
                    value: _selectedArtist,
                    onChanged: (int? newValue) {
                      setState(() {
                        _selectedArtist = newValue;
                      });
                    },
                    items: lineupProvider.artists.map((artist) {
                      return DropdownMenuItem<int>(
                        value: artist.id,
                        child: Text(artist.name),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 16),
                  DropdownButtonFormField<int>(
                    hint: Text('Selecteer stage'),
                    value: _selectedStage,
                    onChanged: (int? newValue) {
                      setState(() {
                        _selectedStage = newValue;
                      });
                    },
                    items: lineupProvider.stages.map((stage) {
                      return DropdownMenuItem<int>(
                        value: stage.id,
                        child: Text(stage.name),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 16),
                  ListTile(
                    title: Text(_selectedDate == null
                        ? 'Selecteer Datum'
                        : 'Geselecteerde Datum: ${_selectedDate!.toLocal()}'
                            .split(' ')[0]),
                    trailing: Icon(Icons.calendar_today),
                    onTap: () => _selectDate(context),
                  ),
                  ListTile(
                    title: Text(_selectedTime == null
                        ? 'Selecteer Tijd'
                        : 'Geselecteerde Tijd: ${_selectedTime!.format(context)}'),
                    trailing: Icon(Icons.access_time),
                    onTap: () => _selectTime(context),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.deepPurple, // Button color
                      onPrimary: Colors.white, // Text color
                    ),
                    onPressed: _submit,
                    child: Text('Toevoegen'),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
