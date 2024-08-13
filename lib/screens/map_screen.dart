import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:zomerfestival/providers/stage_provider.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final LatLng _center = LatLng(51.2820, 4.8401); // Default center location

  @override
  void initState() {
    super.initState();
    Provider.of<StageProvider>(context, listen: false).fetchStages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Map'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Consumer<StageProvider>(
        builder: (ctx, stageProvider, _) {
          if (stageProvider.isLoading) {
            return Center(child: CircularProgressIndicator());
          } else {
            List<Map<String, dynamic>> markers =
                List<Map<String, dynamic>>.from(
                    stageProvider.stages.map((stage) {
              return {
                'id': 'stage_${stage.id}',
                'position': _getStagePosition(stage.id),
                'title': stage.name,
                'color': _getColorById(stage.id),
              };
            }).toList());

            // Add a static marker for the entrance with a custom icon
            markers.add({
              'id': 'ingang',
              'position':
                  LatLng(51.2816, 4.8381),
              'title': ' Ingang',
              'icon': 'assets/images/entrance_icon.png', // Custom icon path
            });

            return Column(
              children: [
                Expanded(
                  child: FlutterMap(
                    options: MapOptions(
                      center: _center,
                      zoom: 17.0,
                    ),
                    children: [
                      TileLayer(
                        urlTemplate:
                            'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                        subdomains: ['a', 'b', 'c'],
                      ),
                      MarkerLayer(
                        markers: markers.map((marker) {
                          if (marker['id'] == 'ingang') {
                            // Use custom icon for entrance
                            return Marker(
                              width: 30.0, // Smaller width
                              height: 30.0, // Smaller height
                              point: marker['position'],
                              builder: (ctx) => Container(
                                child: Image.asset(
                                  marker['icon'],
                                  width: 20.0, // Adjusted width
                                  height: 20.0, // Adjusted height
                                ),
                              ),
                            );
                          } else {
                            // Use default icon for stages
                            return Marker(
                              width: 80.0,
                              height: 80.0,
                              point: marker['position'],
                              builder: (ctx) => Container(
                                child: Icon(
                                  Icons.place,
                                  color: marker['color'],
                                  size: 40.0,
                                ),
                              ),
                            );
                          }
                        }).toList(),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(16),
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: markers.map((marker) {
                      return Row(
                        children: [
                          marker['id'] == 'ingang'
                              ? Image.asset(
                                  marker['icon'],
                                  width: 20.0, // Adjusted width for legend
                                  height: 20.0, // Adjusted height for legend
                                )
                              : Icon(
                                  Icons.place,
                                  color: marker['color'],
                                ),
                          SizedBox(width: 8),
                          Text(
                            '${marker['title']}',
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  LatLng _getStagePosition(int stageId) {
    switch (stageId) {
      case 1:
        return LatLng(51.2823, 4.8388);
      case 2:
        return LatLng(51.2817, 4.8401);
      case 3:
        return LatLng(51.2822, 4.8398);
      default:
        return LatLng(51.2820, 4.8401); // Default position
    }
  }

  Color _getColorById(int id) {
    switch (id) {
      case 1:
        return Colors.red;
      case 2:
        return Colors.green;
      case 3:
        return Colors.blue;
      default:
        return Colors.black;
    }
  }
}
