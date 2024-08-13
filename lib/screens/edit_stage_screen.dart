import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zomerfestival/models/stage.dart';
import 'package:zomerfestival/providers/stage_provider.dart';

class EditStageScreen extends StatefulWidget {
  final Stage? stage;

  EditStageScreen({this.stage});

  @override
  _EditStageScreenState createState() => _EditStageScreenState();
}

class _EditStageScreenState extends State<EditStageScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  bool _isLoading = false;

  @override
  void initState() {
    _nameController = TextEditingController(
      text: widget.stage != null ? widget.stage!.name : '',
    );
    super.initState();
  }

  void _saveForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        if (widget.stage == null) {
          await Provider.of<StageProvider>(context, listen: false)
              .addStage(_nameController.text);
        } else {
          await Provider.of<StageProvider>(context, listen: false).updateStage(
            widget.stage!.id,
            _nameController.text,
          );
        }
        Navigator.of(context).pop();
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving stage: $error'),
            backgroundColor: Theme.of(context).errorColor,
          ),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.stage == null ? 'Voeg Stage toe' : 'Bewerk Stage'),
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
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Naam',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Voer een naam in.';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              _isLoading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _saveForm,
                      child: Text('Opslaan'),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.deepPurple,
                        padding:
                            EdgeInsets.symmetric(horizontal: 50, vertical: 15),
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
