import 'dart:js_interop';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:oilsavings/models/GasStationModel.dart';
import 'package:oilsavings/screens/user/main_screen.dart';
import 'dart:convert';

import 'package:web_scraper/web_scraper.dart';

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
  final webScraper = WebScraper('https://www.dieselogasolina.com');
  Map<String, Map<String, double>> prices = {};
  String _selectedFuelType = 'Sin Plomo 95';
  final apiKey = 'AIzaSyBmaXLlR-Pfgm1sfn-8oALHvu9Zf1fWT7k';

  @override
  void initState() {
    super.initState();
    _fetchGasStations();
    _fetchPrices();
  }
    Future<void> _refresh() async {
    _fetchGasStations();
    _fetchPrices();
    }
  void _fetchPrices() async {
    if (await webScraper.loadWebPage('/')) {
      final tableRows = webScraper.getElement('table tbody tr', ['td']);
      for (var row in tableRows) {
        var cells = row['attributes']['td'];
        String fuelType = cells[0]['title'];
        for (int i = 1; i < cells.length; i++) {
          String brand = getBrandName(i);
          double price = double.tryParse(cells[i]['title'].replaceAll('€/l', '').replaceAll(',', '.')) ?? 0.0;
          if (!prices.containsKey(brand)) {
            prices[brand] = {};
          }
          prices[brand]![fuelType] = price;
        }
      }
      setState(() {});
    }
  }

  String getBrandName(int index) {
    switch (index) {
      case 1:
        return 'Repsol';
      case 2:
        return 'Cepsa';
      case 3:
        return 'BP';
      case 4:
        return 'Shell';
      case 5:
        return 'Galp';
      case 6:
        return 'Alcampo';
      case 7:
        return 'Carrefour';
      case 8:
        return 'E.Leclerc';
      default:
        return 'Unknown';
    }
  }

  Future<void> _fetchGasStations() async {
    final url = 'https://maps.googleapis.com/maps/api/place/nearbysearch/json'
        '?location=${widget.latitude},${widget.longitude}'
        '&radius=${widget.radius}'
        '&type=gas_station'
        '&key=$apiKey';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> results = data['results'];
        setState(() {
          _stations =
              results.map((json) => GasStationData.fromJson(json)).toList();
        });
      } else {
        throw Exception('Failed to load gas stations');
      }
    } catch (error) {
      print('Error fetching gas stations: $error');
    }
  }

  List<GasStationData> _getFilteredStations() {
    return _stations.where((station) {
      String brand = getBrandFromName(station.name);
      return prices.containsKey(brand) &&
          prices[brand]!.containsKey(_selectedFuelType);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nearby Gas Stations'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButton<String>(
              value: _selectedFuelType,
              items: <String>[
                'Sin Plomo 95',
                'Sin Plomo 98',
                'Gasóleo A',
                'Gasóleo A+',
                'GLP'
              ].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  _selectedFuelType = newValue!;
                  // _refresh();
                });
              },
            ),
          ),
          Expanded(
            child: _stations.isEmpty
                ? const Center(child: Text('No gas stations found.'))
                : ListView.builder(
                    itemCount: _getFilteredStations().length,
                    itemBuilder: (context, index) {
                      final station = _getFilteredStations()[index];
                      String img;
                      String brand = getBrandFromName(station.name);
                      Map<String, double>? fuelPrices = prices[brand];

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
                                  fuelPrices != null
                                      ? Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: fuelPrices.entries
                                              .map((entry) => Text(
                                                  '${entry.key}: ${entry.value.toStringAsFixed(3)} €/l'))
                                              .toList(),
                                        )
                                      : const Text('Fuel prices not available'),
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
          ),
        ],
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

  String getBrandFromName(String? name) {
    if (name == null) return 'Unknown';
    name = name.toLowerCase();
    if (name.toLowerCase().contains('repsol')) return 'Repsol';
    if (name.toLowerCase().contains('cepsa')) return 'Cepsa';
    if (name.toLowerCase().contains('bp')) return 'BP';
    if (name.toLowerCase().contains('shell')) return 'Shell';
    if (name.toLowerCase().contains('galp')) return 'Galp';
    if (name.toLowerCase().contains('alcampo')) return 'Alcampo';
    if (name.toLowerCase().contains('carrefour')) return 'Carrefour';
    if (name.toLowerCase().contains('e.leclerc')) return 'E.Leclerc';
    return 'Unknown';
  }
}