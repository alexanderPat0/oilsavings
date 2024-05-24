import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:oilsavings/models/GasStationModel.dart';
import 'package:oilsavings/screens/user/main_screen.dart';

class GasStationList extends StatefulWidget {
  final double latitude;
  final double longitude;
  final int radius;

  const GasStationList({
    super.key,
    required this.latitude,
    required this.longitude,
    required this.radius,
  });

  @override
  _GasStationListState createState() => _GasStationListState();
}

class _GasStationListState extends State<GasStationList> {
  List<GasStationData> _stations = [];

  @override
  void initState() {
    super.initState();
    _fetchGasStations();
  }

  Future<void> _fetchGasStations() async {
    const apiKey =
        'AIzaSyAYANPUfV6P03R5Nfbt8NiMqhJ5MCyt3rU'; // Asegúrate de usar una clave API válida aquí
    final url = 'https://maps.googleapis.com/maps/api/place/nea-rbysearch/json'
        '?location=${widget.latitude},${widget.longitude}'
        '&radius=${widget.radius}'
        '&type=gas_station'
        '&key=$apiKey';

    try {
      final response = await http.get(Uri.parse(url));
      print("Response body: ${response.body}");
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> results = data['results'];
        setState(() {
          _stations =
              results.map((json) => GasStationData.fromJson(json)).toList();
        });
        print("Gas stations loaded: ${_stations.length}");
      } else {
        throw Exception('Failed to load gas stations');
      }
    } catch (error) {
      print('Error fetching gas stations: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nearby Gas Stations'),
      ),
      body: _stations.isEmpty
          ? const Center(child: Text('No gas stations found.'))
          : ListView.builder(
              itemCount: _stations.length,
              itemBuilder: (context, index) {
                final station = _stations[index];
                String img;
                if (station.name!.toLowerCase().contains('repsol')) {
                  img = "imgs/gas_station_img/repsol_icon.png";
                } else if (station.name!.toLowerCase().contains('cepsa')) {
                  img = "imgs/gas_station_img/cepsa_icon.png";
                } else if (station.name!.toLowerCase().contains('bp')) {
                  img = "imgs/gas_station_img/bp_icon.png";
                } else if (station.name!.toLowerCase().contains('shell')) {
                  img = "imgs/gas_station_img/shell_icon.png";
                } else {
                  img = "imgs/gas_station_img/default_station.png";
                }
                return Card(
                  child: ExpansionTile(
                    leading: Image.asset(img, width: 50, height: 50),
                    title: Text(station.name ?? 'Name not available'),
                    subtitle: Text(station.vicinity ?? 'No address available'),
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            _buildOpenStatus(station.openNow),
                            Text(
                                'Rating: ${station.rating} (${station.userRatingsTotal} reviews)'),
                            const SizedBox(height: 20),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: OutlinedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const MainScreen(),
                                    ),
                                  );
                                },
                                child: const Text('More Info'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }

  Widget _buildOpenStatus(bool? isOpen) {
    if (isOpen == null) {
      return const Text('Open status: Unknown',
          style: TextStyle(color: Colors.grey));
    } else {
      return Text('Open Now: ${isOpen ? "Yes" : "No"}',
          style: TextStyle(color: isOpen ? Colors.green : Colors.red));
    }
  }
}
